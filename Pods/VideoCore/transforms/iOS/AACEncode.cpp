/*
 
 Video Core
 Copyright (c) 2014 James G. Hurley
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 
 */
#include <videocore/transforms/iOS/AACEncode.h>
#include <sstream>

namespace videocore { namespace iOS {
 
    struct UserData {
        uint8_t* data;
        int size;
        int packetSize;
        AudioStreamPacketDescription * pd ;
        
    } ;
    
    static const int kSamplesPerFrame = 1024;
    
    AACEncode::AACEncode( int frequencyInHz, int channelCount )
    : m_sentConfig(false)
    {

        AudioStreamBasicDescription in = {0}, out = {0};
        
        in.mSampleRate = frequencyInHz;
        in.mChannelsPerFrame = channelCount;
        in.mBitsPerChannel = 16;
        in.mFormatFlags = kAudioFormatFlagsCanonical;
        in.mFormatID = kAudioFormatLinearPCM;
        in.mFramesPerPacket = 1;
        in.mBytesPerFrame = in.mBitsPerChannel * in.mChannelsPerFrame / 8;
        in.mBytesPerPacket = in.mFramesPerPacket*in.mBytesPerFrame;
        
        out.mFormatID = kAudioFormatMPEG4AAC;
        out.mFormatFlags = 0;
        out.mFramesPerPacket = kSamplesPerFrame;
        out.mSampleRate = frequencyInHz;
        out.mChannelsPerFrame = channelCount;
        
        bool canResume = true;
        UInt32 outputBitrate = 128000; // 128 kbps
        UInt32 propSize = sizeof(outputBitrate);
        UInt32 outputPacketSize = 0;
        
        AudioClassDescription requestedCodecs[1] = {
            {
                kAudioEncoderComponentType,
                kAudioFormatMPEG4AAC,
                kAppleSoftwareAudioCodecManufacturer
            }
        };
        
        AudioConverterNewSpecific(&in, &out, 1, requestedCodecs, &m_audioConverter);
        
        AudioConverterSetProperty(m_audioConverter, kAudioConverterEncodeBitRate, propSize, &outputBitrate);
        
        AudioConverterSetProperty(m_audioConverter, kAudioConverterPropertyCanResumeFromInterruption, sizeof(canResume), &canResume);
        
        AudioConverterGetProperty(m_audioConverter, kAudioConverterPropertyMaximumOutputPacketSize, &propSize, &outputPacketSize);
        
        
        m_outputPacketMaxSize = outputPacketSize;
        
        m_bytesPerSample = 2 * channelCount;
        
        makeAsc((frequencyInHz == 44100) ? 4 : 3, channelCount);
        
    }
    AACEncode::~AACEncode() {
        AudioConverterDispose(m_audioConverter);
    }
    void
    AACEncode::makeAsc(char sampleRateIndex, char channelCount)
    {
        // http://wiki.multimedia.cx/index.php?title=MPEG-4_Audio#Audio_Specific_Config
        m_asc[0] = 0x10 | ((sampleRateIndex>>1) & 0x3);
        m_asc[1] = ((sampleRateIndex & 0x1)<<7) | ((channelCount & 0xF) << 3);
    }
    OSStatus
    AACEncode::ioProc(AudioConverterRef audioConverter, UInt32 *ioNumDataPackets, AudioBufferList* ioData, AudioStreamPacketDescription** ioPacketDesc, void* inUserData )
    {
        UserData* ud = static_cast<UserData*>(inUserData);
        
        UInt32 maxPackets = ud->size / ud->packetSize;
        
        *ioNumDataPackets = std::min(maxPackets, *ioNumDataPackets);
        
        ioData->mBuffers[0].mData = ud->data;
        ioData->mBuffers[0].mDataByteSize = ud->size;
        ioData->mBuffers[0].mNumberChannels = 1;
        
        return noErr;
    }
    void
    AACEncode::pushBuffer(const uint8_t* const data, size_t size, IMetadata& metadata)
    {
        const size_t sampleCount = size / m_bytesPerSample;
        const size_t aac_packet_count = sampleCount / kSamplesPerFrame;
        const size_t required_bytes = aac_packet_count * m_outputPacketMaxSize;
        
        if(m_outputBuffer.total() < (required_bytes)) {
            m_outputBuffer.resize(required_bytes);
        }
        uint8_t* p = m_outputBuffer();
        uint8_t* p_out = (uint8_t*)data;

        for ( size_t i = 0 ; i < aac_packet_count ; ++i ) {
            UInt32 num_packets = 1;

            AudioBufferList l;
            l.mNumberBuffers=1;
            l.mBuffers[0].mDataByteSize = m_outputPacketMaxSize * num_packets;
            l.mBuffers[0].mData = p;
            
            std::unique_ptr<UserData> ud(new UserData());
            ud->size = static_cast<int>(kSamplesPerFrame * m_bytesPerSample);
            ud->data = const_cast<uint8_t*>(p_out);
            ud->packetSize = static_cast<int>(m_bytesPerSample);
            
            AudioStreamPacketDescription output_packet_desc[num_packets];
            
            AudioConverterFillComplexBuffer(m_audioConverter, AACEncode::ioProc, ud.get(), &num_packets, &l, output_packet_desc);
            
            p += output_packet_desc[0].mDataByteSize;
            p_out += kSamplesPerFrame * m_bytesPerSample;
        }
        const size_t totalBytes = p - m_outputBuffer();

        
        auto output = m_output.lock();
        if(output && totalBytes) {
            if(!m_sentConfig) {
                output->pushBuffer((const uint8_t*)m_asc, sizeof(m_asc), metadata);
                m_sentConfig = true;
            }
            
            output->pushBuffer(m_outputBuffer(), totalBytes, metadata);
        }
    }
}
}

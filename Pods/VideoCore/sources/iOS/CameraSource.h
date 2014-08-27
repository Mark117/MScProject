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
#ifndef __videocore__CameraSource__
#define __videocore__CameraSource__

#include <iostream>
#include <videocore/sources/ISource.hpp>
#include <videocore/transforms/IOutput.hpp>
#include <CoreVideo/CoreVideo.h>
#include <glm/glm.hpp>


namespace videocore { namespace iOS {
    
    /*!
     *  Capture video from the device's cameras.
     */
    class CameraSource : public ISource, public std::enable_shared_from_this<CameraSource>
    {
    public:
        
        /*!
         *  Deprecated. Please see videocore::AspectTransform
         */
        enum AspectMode
        {
            kAspectFit,  /*!< An aspect mode which shrinks the incoming video to fit in the supplied boundaries. */
            kAspectFill  /*!< An aspect mode which scales the video to fill the supplied boundaries and maintain aspect ratio. */
        } __attribute__ ((deprecated));
        
    public:
        
        /*!
         *  Constructor. Deprecated. Replaced by videocore::PositionTransform and videocore::AspectTransform.
         * 
         *  \param x the x position of the source output in the video
         *  \param y the y position of the source output in the video
         *  \param w the width of the source output
         *  \param h the height of the source output
         *  \param videow the width of the video
         *  \param videoh the height of the video
         *  \param aspect Unused.
         */
        CameraSource(float x,
                     float y,
                     float w,
                     float h,
                     float videow,
                     float videoh,
                     float aspect) __attribute__ ((deprecated));
        
        /*! Constructor */
        CameraSource();
        
        /*! Destructor */
        ~CameraSource();
        
        /*! ISource::setOutput */
        void setOutput(std::shared_ptr<IOutput> output);
        
        /*! 
         *  Get the AVCaptureVideoPreviewLayer associated with the camera output.
         *
         *  \param outAVCaputreVideoPreviewLayer a pointer to an AVCaptureVideoPreviewLayer pointer.
         */
        void getPreviewLayer(void** outAVCaptureVideoPreviewLayer);

        /*!
         *  Setup camera properties
         *
         *  \param fps      Optional parameter to set the output frames per second.
         *  \param useFront Start with the front-facing camera
         *  \param useInterfaceOrientation whether to use interface or device orientation as reference for video capture orientation
         */
        void setupCamera(int fps = 15, bool useFront = true, bool useInterfaceOrientation = false);
        /*!
         * Set the aspect mode. The default is kAspectFit. Deprecated. Use the AspectTransform instead.
         *
         * \param aspectMode Set the aspect mode to use.
         *
         */
        void setAspectMode( AspectMode aspectMode ) __attribute__ ((deprecated));
        
        /*!
         *  Toggle the camera between front and back-facing cameras.
         */
        void toggleCamera();
        
        /*!
         *  Attempt to turn the torch mode on or off.
         *
         *  \param torchOn  Bool indicating whether the torch should be on or off.
         *  
         *  \return the actual state of the torch.
         */
        bool setTorch(bool torchOn);
        
        /*!
         *  Attempt to set the POI for focus.
         *  (0,0) represents top left, (1,1) represents bottom right.
         *
         *  \return Success. `false` is returned if the device doesn't support a POI.
         */
        bool setFocusPointOfInterest(float x, float y);
        
        void setContinuousAutofocus(bool wantsContinuous);
        
        bool setExposurePointOfInterest(float x, float y);
        
        void setContinuousExposure(bool wantsContinuous);
        
        
    public:
        /*! Used by Objective-C Capture Session */
        void bufferCaptured(CVPixelBufferRef pixelBufferRef);
        
        /*! Used by Objective-C Device/Interface Orientation Notifications */
        void reorientCamera();
        
    private:
        
        /*! 
         * Get a camera with a specified position
         *
         * \param position The position to search for.
         * 
         * \return the camera device, if found.
         */
        void* cameraWithPosition(int position);
        
    private:
        
        glm::mat4 m_matrix;
        struct { float x, y, w, h, vw, vh, a; } m_size, m_targetSize;
        
        std::weak_ptr<IOutput> m_output;
        
        void* m_captureSession;
        void* m_captureDevice;
        void* m_callbackSession;
        void* m_previewLayer;
        
        AspectMode m_aspectMode;
        int  m_fps;
        bool m_isFirst;
        bool m_usingDeprecatedMethods;
        bool m_torchOn;
        bool m_useInterfaceOrientation;

    };
    
}
}
#endif /* defined(__videocore__CameraSource__) */

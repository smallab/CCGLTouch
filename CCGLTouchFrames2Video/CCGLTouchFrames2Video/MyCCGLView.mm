//
//  MyCCGLView.mm
//  CCGLTouchFrames2Video example
//
//  Created by Matthieu Savary on 06/06/12.
//  Copyright (c) 2012 SMALLAB.ORG. All rights reserved.
//
//  More info on the CCGLTouch project >> http://cocoacid.org/ios/
//  License & disclaimer >> see license.txt file included in the distribution package
//
//  Latest revision on 10/06/12.
//

#import "MyCCGLView.h"

@implementation MyCCGLView

/**
 *	The superclass setup method
 */

- (void)setup
{
    [super setup];
    
	// setup our camera
	CameraPersp cam;
	cam.setEyePoint( Vec3f(-100.0f, 10.0f, 10.0f) );
	cam.setCenterOfInterestPoint( Vec3f(0.0f, 0.0f, 0.0f) );
	cam.setPerspective( 60.0f, [self getWindowAspectRatio], 1.0f, 1000.0f );
	mMayaCam.setCurrentCam( cam );
	
    // init value
    mCaptureFlag = NO;
}



/**
 *  The superclass draw method
 */

- (void)draw {
	// this pair of lines is the standard way to clear the screen in OpenGL
	gl::clear( Color( 1.0f, frameCount/100.0f, 0.75f ), true );
	glClear( GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT );
    
    // use the camera
    gl::setMatrices( mMayaCam.getCamera() );
    
    // draw a rotating cube
	glPushMatrix();
    glRotatef(5 * frameCount, 0.0f, 1.0f, 0.0f);
	gl::drawColorCube( Vec3f(0,-20.0f,0.0f), Vec3f(10.0f, 10.0f, 10.0f) );
	gl::drawColorCube( Vec3f::zero(), Vec3f(20.0f, 20.0f, 20.0f) );
	glPopMatrix();
    
    // frame capture
    if (mCaptureFlag) {
        [self captureFrame2Video];
    }
}



/**
 *  incoming from controller
 */

- (void)captureFrames:(BOOL)flag
{
    mCaptureFlag = flag;
    if (flag) {
        [self initVideoWriterSession];
        mFrameStart = frameCount;
        console() << "starting recording" << endl;
    } else {
        [self closeVideoWriterSession];
        [self saveMovieToLibrary];
        console() << "stoping recording" << endl;
    }
}



/**
 *  OpenGL capturing to video methods
 */

-(void)captureFrame2Video
{
    // writing image to video
    [self writeImageinVideo:(int)(frameCount-mFrameStart) fps:30];
}

- (void)initVideoWriterSession
{
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/movie.mov"]];
    
    // removing temp file from home dir
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:path error:NULL];
    
    NSError *error = nil; 
    videoWriter = [[AVAssetWriter alloc] initWithURL:[NSURL fileURLWithPath:path]  
                                            fileType:AVFileTypeQuickTimeMovie /*AVFileTypeMPEG4*/
                                               error:&error]; 
    NSParameterAssert(videoWriter); 
    
    NSDictionary *videoSettings = [NSDictionary dictionaryWithObjectsAndKeys: 
                                   /*AVVideoCodecH264*/AVVideoCodecJPEG
                                   , AVVideoCodecKey, 
                                   [NSNumber numberWithInt:[self getWindowWidth]], AVVideoWidthKey, 
                                   [NSNumber numberWithInt:[self getWindowHeight]], AVVideoHeightKey, 
                                   nil];
    
    writerInput = [[AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeVideo outputSettings:videoSettings] retain];
    writerInput.expectsMediaDataInRealTime = YES;
    
    NSDictionary *sourcePixelBufferAttributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys: [NSNumber numberWithInt:kCVPixelFormatType_32BGRA], kCVPixelBufferPixelFormatTypeKey,
                                                           [NSNumber numberWithInt:[self getWindowWidth]], kCVPixelBufferWidthKey,
                                                           [NSNumber numberWithInt:[self getWindowHeight]], kCVPixelBufferHeightKey,
                                                           nil];
    
    adaptor = [AVAssetWriterInputPixelBufferAdaptor assetWriterInputPixelBufferAdaptorWithAssetWriterInput:writerInput sourcePixelBufferAttributes:sourcePixelBufferAttributesDictionary];
    [adaptor retain];
    NSParameterAssert(writerInput); 
    NSParameterAssert([videoWriter canAddInput:writerInput]); 
    [videoWriter addInput:writerInput]; 
    [videoWriter retain];
    
    // Mirror the video to comply with OpenGL's upside-down rendering
    writerInput.transform = CGAffineTransformMakeScale(1, -1);
    
    // Start a session
    [videoWriter startWriting]; 
    [videoWriter startSessionAtSourceTime:kCMTimeZero]; 
    
    // write first image
    [self writeImageinVideo:0 fps:10];
}

- (void)closeVideoWriterSession
{
    if (writerInput.readyForMoreMediaData) {
        // Finish the session
        [writerInput markAsFinished];
        [videoWriter finishWriting];                
        CVPixelBufferPoolRelease(adaptor.pixelBufferPool);
        [videoWriter release];
        [writerInput release];
        NSLog (@"Done writing opengl as movie");
    }
}

-(void)writeImageinVideo:(int)fid fps:(int)fps  
{ 
    if (writerInput.readyForMoreMediaData) {
        
        CMTime currentTime = CMTimeMake(fid, fps);
        
        CVPixelBufferRef pixel_buffer = NULL;
        CVReturn status = CVPixelBufferPoolCreatePixelBuffer (NULL, adaptor.pixelBufferPool, &pixel_buffer);
        if ((pixel_buffer == NULL) || (status != kCVReturnSuccess))
            return;
        else {
            CVPixelBufferLockBaseAddress(pixel_buffer, 0);
            GLubyte *pixelBufferData = (GLubyte *)CVPixelBufferGetBaseAddress(pixel_buffer);
            glReadPixels(0, 0, [self getWindowWidth], [self getWindowHeight], GL_BGRA, GL_UNSIGNED_BYTE, pixelBufferData);
        }
        
        if(![adaptor appendPixelBuffer:pixel_buffer withPresentationTime:currentTime]) 
        {
            NSLog(@"Problem appending pixel buffer at time: %lld", currentTime.value);
        } 
        else 
        {
            NSLog(@"Recorded pixel buffer at time: %lld", currentTime.value);
        }
        CVPixelBufferUnlockBaseAddress(pixel_buffer, 0);
        CVPixelBufferRelease(pixel_buffer);
        
    }
} 

- (void)saveMovieToLibrary 
{ 
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/movie.mov"]];
    
    // moving file to photo lib
    [self downloadVideo:path];
}

-(void)downloadVideo:(NSString *)sampleMoviePath
{
    if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(sampleMoviePath))
        UISaveVideoAtPathToSavedPhotosAlbum(sampleMoviePath, self, @selector(video:didFinishSavingWithError: contextInfo:), sampleMoviePath);
}

-(void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    NSLog(@"Finished with error: %@", error);
}



/**
 *  Superclass events
 */

- (void)mouseDown:(ci::app::MouseEvent)event
{
    mMayaCam.mouseDown( event.getPos() );
}

- (void)mouseDrag:(ci::app::MouseEvent)event
{
    mMayaCam.mouseDrag( event.getPos(), event.isLeftDown(), event.isMiddleDown(), event.isRightDown() );
}

@end

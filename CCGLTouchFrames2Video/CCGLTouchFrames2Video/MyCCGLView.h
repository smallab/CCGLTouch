//
//  MyCCGLView.h
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

#import <AVFoundation/AVAsset.h>
#import <AVFoundation/AVAssetTrack.h>
#import <AVFoundation/AVAssetReader.h>
#import <AVFoundation/AVAssetReaderOutput.h>
#import <AVFoundation/AVAssetWriter.h>
#import <AVFoundation/AVAssetWriterInput.h>
#import <AVFoundation/AVMediaFormat.h>
#import <AVFoundation/AVAudioSettings.h>
#import <AVFoundation/AVVideoSettings.h>
#import <AVFoundation/AVAssetImageGenerator.h>
#import <AVFoundation/AVTime.h>
#import <CoreMedia/CMSampleBuffer.h>

#include "cinder/MayaCamUI.h"

#import "CCGLTouchView.h"

@interface MyCCGLView : CCGLTouchView {
	MayaCamUI mMayaCam;

    // video vars
    BOOL mCaptureFlag;
    int mFrameStart;
    AVAssetWriter *videoWriter;
    AVAssetWriterInput* writerInput;
    AVAssetWriterInputPixelBufferAdaptor *adaptor;
}

/**
 *  incoming from controller
 */

- (void)captureFrames:(BOOL)flag;

/**
 *  OpenGL capture methods
 */

-(void)captureFrame2Video;

/**
 *  Video from UIImages methods
 */

- (void)initVideoWriterSession;
- (void)closeVideoWriterSession;
-(void)writeImageinVideo:(int)fid fps:(int)fps;
- (void)saveMovieToLibrary;
-(void)downloadVideo:(NSString *)sampleMoviePath;
-(void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;

@end

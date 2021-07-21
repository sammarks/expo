//
//  ABI40_0_0EXFaceDetectorManager.h
//  Exponent
//
//  Created by Stanisław Chmiela on 22.11.2017.
//  Copyright © 2017 650 Industries. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <ABI40_0_0UMFaceDetectorInterface/ABI40_0_0UMFaceDetectorManager.h>

@interface ABI40_0_0EXFaceDetectorManager : NSObject <ABI40_0_0UMFaceDetectorManager>

- (void)setOnFacesDetected:(void (^)(NSArray<NSDictionary *> *))onFacesDetected;

- (void)setIsEnabled:(BOOL)enabled;
- (void)updateSettings:(NSDictionary *)settings;

- (void)maybeStartFaceDetectionOnSession:(AVCaptureSession *)session
                        withPreviewLayer:(AVCaptureVideoPreviewLayer *)previewLayer;
- (void)maybeStartFaceDetectionOnSession:(AVCaptureSession *)session
                        withPreviewLayer:(AVCaptureVideoPreviewLayer *)previewLayer mirrored:(BOOL)mirrored;
- (void)stopFaceDetection;

@end

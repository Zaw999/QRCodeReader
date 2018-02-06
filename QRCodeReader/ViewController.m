//
//  ViewController.m
//  QRCodeReader
//
//  Created by ZawYeNaing on 2/1/18.
//  Copyright © 2018 Zaw Ye Naing. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _isReading = NO;
    
    _captureSession = nil;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)startStopReading:(id)sender {
    
    if(!_isReading) {
        if([self startReading]) {
            [_btnStart setTitle: @"Stop" forState: UIControlStateNormal];
        }
    } else {
        [self stopReading];
        [_btnStart setTitle: @"Start" forState: UIControlStateNormal];
    }
    
    _isReading = !_isReading;
}

-(BOOL)startReading {
    NSError *error;
    
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType: AVMediaTypeVideo];
    AVCaptureDeviceInput *input    = [AVCaptureDeviceInput deviceInputWithDevice: captureDevice error: &error];
    
    if(!input) {
        NSLog(@"%@", [error localizedDescription]);
        return NO;
    }
    
    _captureSession = [[AVCaptureSession alloc] init];
    [_captureSession addInput: input];
    
    AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    [_captureSession addOutput: captureMetadataOutput];
    
    dispatch_queue_t dispatchQueue;
    dispatchQueue = dispatch_queue_create("myQueue", NULL);
    [captureMetadataOutput setMetadataObjectsDelegate: self queue: dispatchQueue];
    [captureMetadataOutput setMetadataObjectTypes: [NSArray arrayWithObjects:AVMetadataObjectTypeQRCode, nil]];
    
    _videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession: _captureSession];
    [_videoPreviewLayer setVideoGravity: AVLayerVideoGravityResizeAspectFill];
    [_videoPreviewLayer setFrame:_viewPreview.layer.bounds];
    [_viewPreview.layer addSublayer:_videoPreviewLayer];
    
    [_captureSession startRunning];
    
    return YES;
    
}

-(void)captureOutput:(AVCaptureOutput *)output didOutputMetadataObjects:(NSArray<__kindof AVMetadataObject *> *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    
    if(metadataObjects != NULL && [metadataObjects count] > 0) {
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex: 0];
        if([[metadataObj type] isEqualToString: AVMetadataObjectTypeQRCode]) {
            
            [_lblStatus performSelectorOnMainThread:@selector(setText:) withObject: [metadataObj stringValue] waitUntilDone: NO];
             
            [self performSelectorOnMainThread:@selector(stopReading) withObject: nil waitUntilDone: NO];
            [_btnStart performSelectorOnMainThread:@selector(setTitle:) withObject:@"Start!" waitUntilDone: NO];
        }
    }
}

-(void)stopReading {
    [_captureSession stopRunning];
    _captureSession = nil;
    
    [_videoPreviewLayer removeFromSuperlayer];
}

@end

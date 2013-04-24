//
//  ViewController.m
//  faceDetection
//
//  Created by abdus on 2/22/13.
//  Copyright (c) 2013 www.abdus.me All rights reserved.
//

#import "ViewController.h"
#import <CoreImage/CoreImage.h>
#import <CoreImage/CoreImage.h>
#import <QuartzCore/QuartzCore.h>

#pragma mark private Interface
@interface ViewController ()
{
    UIImageView *imageView;
}

@end

@implementation ViewController


#pragma mark
#pragma mark VC Delegate

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImage *image = [UIImage imageNamed:@"abdus.jpg"];
    imageView = [[UIImageView alloc] initWithImage:image];
    [imageView setFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    
    [self.view addSubview:imageView];
    
    [self startForFaceDetectionForImage:image];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark
#pragma mark FaceDetection
-(void)startForFaceDetectionForImage:(UIImage *)image
{
    //[self performSelectorInBackground:@selector(markFacesForUIImage:) withObject:image];
    
    [self detectForFacesInUIImage:image];
}

-(void)detectForFacesInUIImage:(UIImage *)facePicture
{
    CIImage* image = [CIImage imageWithCGImage:facePicture.CGImage];
    
    CIDetector* detector = [CIDetector detectorOfType:CIDetectorTypeFace
                                              context:nil options:[NSDictionary dictionaryWithObject:CIDetectorAccuracyLow forKey:CIDetectorAccuracy]];
    
    NSArray* features = [detector featuresInImage:image];
    
    for(CIFaceFeature* faceObject in features)
    {
        CGRect modifiedFaceBounds = faceObject.bounds;
        modifiedFaceBounds.origin.y = facePicture.size.height-faceObject.bounds.size.height-faceObject.bounds.origin.y;
        
        [self addSubViewWithFrame:modifiedFaceBounds];
        
        if(faceObject.hasLeftEyePosition)
        {
            
            CGRect leftEye = CGRectMake(faceObject.leftEyePosition.x,(facePicture.size.height-faceObject.leftEyePosition.y), 10, 10);
            [self addSubViewWithFrame:leftEye];
        }
        
        if(faceObject.hasRightEyePosition)
        {
            
            CGRect rightEye = CGRectMake(faceObject.rightEyePosition.x, (facePicture.size.height-faceObject.rightEyePosition.y), 10, 10);
            [self addSubViewWithFrame:rightEye];
            
        }
        if(faceObject.hasMouthPosition)
        {
           CGRect  mouth = CGRectMake(faceObject.mouthPosition.x,facePicture.size.height-faceObject.mouthPosition.y,10, 10);
            [self addSubViewWithFrame:mouth];
        }
    }
}

-(void)addSubViewWithFrame:(CGRect)frame
{
    UIView* highlitView = [[UIView alloc] initWithFrame:frame];
    highlitView.layer.borderWidth = 1;
    highlitView.layer.borderColor = [[UIColor whiteColor] CGColor];
    [imageView addSubview:highlitView];
}
@end

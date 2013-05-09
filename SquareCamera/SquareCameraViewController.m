//
//  SquareCameraViewController.m
//  square-camera
//
//  Created by Brian Tang on 5/9/13.
//  Copyright (c) 2013 Brian Tang. All rights reserved.
//

#import "SquareCameraViewController.h"

@interface SquareCameraViewController ()
{
    int _dimension;
    BOOL _showCamera;
}

- (UIImage*)resizeImage:(UIImage*)image;

@end

@implementation SquareCameraViewController

@synthesize delegate = _delegate;

static inline double radians (double degrees) {return degrees * M_PI/180;}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithImageDimension:(int)dimension
{
    self = [super init];
    if (self)
    {
        _dimension = dimension;
        _showCamera = true;
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    // We don't want to show the camera again in cases where we dismiss the camera view and such
    if (!_showCamera)
    {
        return;
    }
    
    UIImagePickerController *picker	= [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    picker.wantsFullScreenLayout = YES;
    picker.showsCameraControls = YES;
    
    // Overlay to only reveal a square image capture area
    NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:@"SquareCameraOverlay" owner:self options:nil];
    UIView *overlay = [nibArray objectAtIndex:0];
    picker.cameraOverlayView = overlay;
    
    [self presentViewController:picker animated:YES completion:nil];
}

// Crops to square then resizes
- (UIImage*)resizeImage:(UIImage*)image
{
    if (nil == image) {
        NSLog(@"Nothing to resize");
        return nil;
    }
    
    CGSize size = [image size];
    
    // Only crop if height != width
    UIImage* newImage;
    if (size.height != size.width) {
        // Create rectangle that represents a square-cropped image.
        // This assumes height > width (portrait mode photo)
        CGRect rect = CGRectMake((size.height - size.width)/2, 0,
                                 size.width, size.width);
        
        // Create bitmap image from original image data,
        // using rectangle to specify desired crop area
        CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], rect);
        newImage = [UIImage imageWithCGImage:imageRef];
        CGImageRelease(imageRef);
    }
    
    // Resize to dimension
    CGFloat targetWidth;
    CGFloat targetHeight;
    targetWidth = targetHeight = _dimension;
    
    CGImageRef imageRef = [newImage CGImage];
    CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(imageRef);
    CGColorSpaceRef colorSpaceInfo = CGImageGetColorSpace(imageRef);
    
    if (bitmapInfo == kCGImageAlphaNone) {
        bitmapInfo = kCGImageAlphaNoneSkipLast;
    }
    
    // Rotation correction
    CGContextRef bitmap;
    if (newImage.imageOrientation == UIImageOrientationUp || newImage.imageOrientation == UIImageOrientationDown) {
        bitmap = CGBitmapContextCreate(NULL, targetWidth, targetHeight, CGImageGetBitsPerComponent(imageRef), CGImageGetBytesPerRow(imageRef), colorSpaceInfo, bitmapInfo);
        
    } else {
        bitmap = CGBitmapContextCreate(NULL, targetHeight, targetWidth, CGImageGetBitsPerComponent(imageRef), CGImageGetBytesPerRow(imageRef), colorSpaceInfo, bitmapInfo);
        
    }
    
    if (newImage.imageOrientation == UIImageOrientationLeft) {
        CGContextRotateCTM (bitmap, radians(90));
        CGContextTranslateCTM (bitmap, 0, -targetHeight);
        
    } else if (newImage.imageOrientation == UIImageOrientationRight) {
        CGContextRotateCTM (bitmap, radians(-90));
        CGContextTranslateCTM (bitmap, -targetWidth, 0);
        
    } else if (newImage.imageOrientation == UIImageOrientationUp) {
        CGContextRotateCTM (bitmap, radians(-90));
        CGContextTranslateCTM (bitmap, -targetWidth, 0);
    } else if (newImage.imageOrientation == UIImageOrientationDown) {
        CGContextTranslateCTM (bitmap, targetWidth, targetHeight);
        CGContextRotateCTM (bitmap, radians(-180.));
    }
    
    CGContextDrawImage(bitmap, CGRectMake(0, 0, targetWidth, targetHeight), imageRef);
    CGImageRef ref = CGBitmapContextCreateImage(bitmap);
    newImage = [UIImage imageWithCGImage:ref];
    
    CGContextRelease(bitmap);
    CGImageRelease(ref);
    
    return newImage;
}


#pragma mark -
#pragma mark UIImagePickerControllerDelegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    _showCamera = NO;
    
    if (_delegate)
    {
        [_delegate squareCameraDidCancel];
    }
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    _showCamera = NO;
    
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    image = [self resizeImage:image];
    
    if (_delegate)
    {
        [_delegate squareCameraDidSelectImage:image];
    }
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
}

#pragma mark -
#pragma mark UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
}

#pragma mark -

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

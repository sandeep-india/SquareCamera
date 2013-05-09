//
//  SquareCameraViewController.h
//  square-camera
//
//  Created by Brian Tang on 5/9/13.
//  Copyright (c) 2013 Brian Tang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SquareCameraDelegate
@required
- (void)squareCameraDidSelectImage:(UIImage *)image;
- (void)squareCameraDidCancel;
@end

@interface SquareCameraViewController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

- (id)initWithImageDimension:(int)dimension;

@property (nonatomic, weak) id<SquareCameraDelegate> delegate;

@end

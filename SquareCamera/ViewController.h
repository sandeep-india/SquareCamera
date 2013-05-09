//
//  ViewController.h
//  square-camera
//
//  Created by Brian Tang on 5/8/13.
//  Copyright (c) 2013 Brian Tang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SquareCameraViewController.h"

@interface ViewController : UIViewController<SquareCameraDelegate>

- (IBAction)showCamera:(id)sender;

@property (nonatomic, weak) IBOutlet UIImageView *image;

@end

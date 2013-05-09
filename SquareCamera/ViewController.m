//
//  ViewController.m
//  square-camera
//
//  Created by Brian Tang on 5/8/13.
//  Copyright (c) 2013 Brian Tang. All rights reserved.
//

#import "ViewController.h"
#import "SquareCameraViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize image = _image;

- (IBAction)showCamera:(id)sender
{
    SquareCameraViewController *squareCamera = [[SquareCameraViewController alloc] initWithImageDimension:240];
    squareCamera.delegate = self;
    [self presentViewController:squareCamera animated:NO completion:nil];
}

- (void)squareCameraDidSelectImage:(UIImage *)image
{
    [_image setImage:image];
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)squareCameraDidCancel
{
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

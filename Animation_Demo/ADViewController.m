//
//  ADViewController.m
//  Animation_Demo
//
//  Created by Bill Gestrich on 11/25/13.
//  Copyright (c) 2013 William Gestrich. All rights reserved.
//

#import "ADViewController.h"

@interface ADViewController ()

@property BOOL viewAppeared;

@end

@implementation ADViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
}   

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

    //[self changeAlpha];
    //[self rotateIn3D];
    //[self translateIn3D];
    //[self rotateWithSpring];
    //[self combineAnimations];

}





















-(void)changeAlpha{
    self.planeImage.alpha = 0.0;
    [UIView animateWithDuration:5.0 animations:^{
        self.planeImage.alpha = 1.0;
    }];
}





















-(void)rotateIn3D{
    
    [UIView animateWithDuration:3.0 animations:^{
        CATransform3D transform = CATransform3DMakeRotation(M_PI, 0.0, 1.0, 0.0);
        self.ringImage.layer.transform = transform;
    }];
    
}
























-(void)translateIn3D{


    CATransform3D transform = self.planeImage.layer.transform;
    transform.m34 = 1.0/350;
    
    CATransform3D finalTransform = CATransform3DTranslate(transform, 50, 0.0, 1000);
    [UIView animateWithDuration:2.0 delay:0.0 options:UIViewAnimationOptionRepeat|UIViewAnimationOptionAutoreverse animations:^{
        [self.planeImage.layer setTransform:finalTransform];
    } completion:^(BOOL finished) {
        CATransform3D finalTransform = CATransform3DTranslate(transform, 0.0, 0.0, 0.0);
        [UIView animateWithDuration:2.0f animations:^{
            [self.planeImage.layer setTransform:finalTransform];
        } completion:^(BOOL finished) {
            
        }];
    }];
}

















-(void)rotateWithSpring{
    
    //ios only
    [UIView animateWithDuration:5.0 delay:0.0 usingSpringWithDamping:0.5 initialSpringVelocity:2.0 options:UIViewAnimationOptionTransitionNone animations:^{
        self.ringImage.transform = CGAffineTransformRotate(self.ringImage.transform,-M_PI_4*.65);
    } completion:nil];
    
}












-(void)combineAnimations{
    
    
    [UIView animateWithDuration:2.0 delay:0.25 options:UIViewAnimationOptionAllowAnimatedContent|UIViewAnimationOptionCurveEaseInOut    animations:^{
        self.ringImage.transform = CGAffineTransformRotate(self.ringImage.transform,-M_PI_4*.65);
     } completion:nil
     ];
    
    self.planeImage.alpha = 0.1;
    [UIView animateWithDuration:2.0 animations:^{
        CGRect frame = self.planeImage.frame;
        frame.size.height *=1.5;
        frame.size.width *=1.5;
        self.planeImage.frame = frame;
        self.planeImage.alpha = 1.0;
    }];
    
}














- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

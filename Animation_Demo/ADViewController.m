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
    

    //[self rotateIn3D];
    //[self addFallAnimationForLayer:self.ringImage.layer];
    //[self translateIn3D];
    if(!self.viewAppeared){
        [self rotateIn2D];
    }
    
    self.viewAppeared = YES;
    
    
}


-(void)rotateIn3D{
    [UIView animateWithDuration:10.0 animations:^{
        
        /*
        [UIView animateWithDuration:3.0 animations:^{
            
            //CATransform3D transform = CATransform3DMakeRotation(-M_PI, 0.0, 1.0, 0.9);
            //CATransform3D transform = CATransform3DMakeAffineTransform(CGAffineTransformMakeRotation(M_PI/2));
            //testView.layer.transform = transform;
            //testView.backgroundColor = [UIColor yellowColor];
            
        }];
        */
        
        /*
         
         [UIView animateWithDuration:10.0 animations:^{
         CATransform3D transform = CATransform3DMakeScale(1.0, 1.0, 10.0);
         self.ringImage.layer.transform = transform;
         }];
         */
        
        CATransform3D transform = CATransform3DMakeRotation(M_PI, 0.0, 1.0, 0.0);
        //CATransform3D transform = CATransform3DMakeAffineTransform(CGAffineTransformMakeRotation(M_PI/2));
        self.ringImage.layer.transform = transform;
        
    }];
}

-(void)translateIn3D{
    //CATransform3D translation = CATransform3DMakeTranslation(0.0, -50.0, 0.0);
    //translation.m34 = 1.0 / -500.0f;


    CATransform3D transform = self.planeImage.layer.transform;
    transform.m34 = 1.0/350;
    CATransform3D finalTransform = CATransform3DRotate(transform, M_PI_4, 1.0, 0.0, 0.0);
    [UIView animateWithDuration:2.0f animations:^{
        [self.planeImage.layer setTransform:finalTransform];
    } completion:^(BOOL finished) {
        /*CATransform3D flyAway = CATransform3DMakeTranslation(0., 0., -10000);
        [UIView animateWithDuration:3.0f animations:^{
            NSLog(@"done");
            [self.ringImage.layer setTransform:flyAway];
        } completion:^(BOOL finished) {
            NSLog(@"done and done");
        }];
         */
    }];
}




-(void)rotateIn2D{
    
    
    //ios 7
    /*
     [UIView animateWithDuration:4.0 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:5.0 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
     self.planeImage.transform = CGAffineTransformRotate(self.planeImage.transform,3.14/2);
     } completion:nil];
     */
    
    //ios 7
    
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
        //self.planeImage.center = center;
        self.planeImage.alpha = 1.0;
//        self.planeImage.frame
    }];
    
}

-(void)changeBounds{
    //Change bounds
    [UIView animateWithDuration:1.0 delay:0.0 options:UIViewAnimationOptionAutoreverse|UIViewAnimationOptionRepeat animations:^{
        self.ringImage.layer.needsDisplayOnBoundsChange = YES;
        [UIView animateWithDuration:4.0 animations:^{
            
            CGRect frame = self.ringImage.bounds;
            frame.size.width *=1.5;
            frame.size.height *=1.5;
            self.ringImage.bounds = frame;
        } ];
    } completion:^(BOOL finished) {
    }];
}


- (void)addFallAnimationForLayer:(CALayer *)layer{
    
    // The keyPath to animate
    NSString *keyPath = @"transform.translation.y";
    
    // Allocate a CAKeyFrameAnimation for the specified keyPath.
    CAKeyframeAnimation *translation = [CAKeyframeAnimation animationWithKeyPath:keyPath];
    
    // Set animation duration and repeat
    translation.duration = 1.5f;
    translation.repeatCount = HUGE_VAL;
    
    // Allocate array to hold the values to interpolate
    NSMutableArray *values = [[NSMutableArray alloc] init];
    
    // Add the start value
    // The animation starts at a y offset of 0.0
    [values addObject:[NSNumber numberWithFloat:0.0f]];
    
    // Add the end value
    // The animation finishes when the ball would contact the bottom of the screen
    // This point is calculated by finding the height of the applicationFrame
    // and subtracting the height of the ball.
    CGFloat height = [[UIScreen mainScreen] applicationFrame].size.height - layer.frame.size.height;
    [values addObject:[NSNumber numberWithFloat:height]];
    
    // Set the values that should be interpolated during the animation
    translation.values = values;
    
    [layer addAnimation:translation forKey:keyPath];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

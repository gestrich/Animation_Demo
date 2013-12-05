//
//  ADFlyMenuViewController.m
//  Animation_Demo
//
//  Created by Bill Gestrich on 12/1/13.
//  Copyright (c) 2013 William Gestrich. All rights reserved.
//

#import "ADFlyMenuViewController.h"

@interface ADFlyMenuViewController ()

@property (strong, nonatomic) NSMutableArray *flyViews;

@property BOOL viewAppeared;


@end

@implementation ADFlyMenuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    //1. Adding images
    self.flyViews = [NSMutableArray arrayWithCapacity:10];
    
    self.scrollView.delegate = self;
    CGSize size = self.scrollView.frame.size;
    size.height *=10;
    self.scrollView.contentSize = size;
    
    NSArray *images = @[
                        [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"image1.png"]],
                        [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"image2.png"]],
                        [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"image3.png"]],
                        [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"image4.png"]]];
    
    for(int x=0; x<[images count]; x++){
        
        
        //Make images
        UIImageView *placeholderView = images[x];
        CGRect newFrame = self.scrollView.frame;
        newFrame.size.width = self.scrollView.frame.size.width;
        placeholderView.frame = newFrame;
        
        UIView *closeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, newFrame.size.width, 20.0)];
        closeView.backgroundColor = [UIColor redColor];
        
        placeholderView.image = [ADFlyMenuViewController addHeaderToView:placeholderView.image];
        
        
        
        
        
        
        //2. Set anchor point and initial angle
        CGFloat yOffset = [[self.flyViews lastObject] frame].origin.y
        + [[self.flyViews lastObject] frame].size.height/2 ;
        
        placeholderView.layer.anchorPoint = CGPointMake(0.5, 0.0);
        placeholderView.layer.position = CGPointMake(placeholderView.layer.bounds.size.width/2, yOffset);
        placeholderView.contentMode = UIViewContentModeScaleAspectFit;
        
        //Set on angle initially
        CATransform3D transform = CATransform3DIdentity;
        transform.m34 = 1.0/300;
        transform = CATransform3DRotate(transform, M_PI_4/2, 1.0, 0.0, 0.0);
        placeholderView.layer.transform = transform;
        
        
        
        
        
        
        //3. Add animation
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.x"];
        animation.fromValue = @(M_PI_4/8);
        animation.toValue = @(M_PI_4/2) ;
        
        animation.duration = 1.0; // For convenience when using timeOffset to control the animation
        [placeholderView.layer addAnimation:animation forKey:nil];
        placeholderView.layer.speed = 0.0;
        
        
        
        
        
        //Add to view
        [self.flyViews addObject:placeholderView];
        [self.scrollView addSubview:placeholderView];

        //4. Enforce z order
        placeholderView.layer.zPosition = -([self.flyViews count] - x);
    }


}


+(UIImage*) addHeaderToView:(UIImage*)thumb
{
    CGSize size = thumb.size;
    UIGraphicsBeginImageContext(size);
    
    CGPoint thumbPoint = CGPointMake(0, 0);
    [thumb drawAtPoint:thumbPoint];
    
    UIImage* starred = [UIImage imageNamed:@"close.png"];
    
    CGPoint starredPoint = CGPointMake(0, 0);
    [starred drawAtPoint:starredPoint];
    
    UIImage* result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return result;



}

-(void)viewDidAppear:(BOOL)animated{
    if(!self.viewAppeared){
        [self.flyViews enumerateObjectsUsingBlock:^(UIView * obj, NSUInteger idx, BOOL *stop) {
            [self updateAngles:obj.layer];
        }];
    }
    
    self.viewAppeared = YES;
    
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.flyViews enumerateObjectsUsingBlock:^(UIView * obj, NSUInteger idx, BOOL *stop) {
        [self updateAngles:obj.layer];
        obj.layer.zPosition = -([self.flyViews count] - idx);
    }];
}

-(void)updateAngles:(CALayer *)layer{
    
    //5. Calculate where in the "timeOffset" we should be
    //based on position of layer
    CGFloat imageTop = layer.bounds.origin.y;
    CGFloat contentTop = self.scrollView.contentOffset.y;
    CGFloat distanceToTop = imageTop - contentTop;
    
    distanceToTop = abs(distanceToTop);
    CGFloat percent =distanceToTop / self.scrollView.frame.size.height;
    
    layer.timeOffset = percent;
    
}


@end

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
        
        UIImageView *mapView = images[x];
        CGRect newFrame = self.scrollView.frame;
        newFrame.size.width = self.scrollView.frame.size.width;
        mapView.frame = newFrame;
        
        UIView *closeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, newFrame.size.width, 20.0)];
        closeView.backgroundColor = [UIColor redColor];
        
        mapView.image = [ADFlyMenuViewController addHeaderToView:mapView.image];
        
        //2. Set position and anchor point
        CGFloat yOffset = [[self.flyViews lastObject] frame].origin.y
        + [[self.flyViews lastObject] frame].size.height/2 ;
        
        mapView.layer.anchorPoint = CGPointMake(0.5, 0.0);
        mapView.layer.position = CGPointMake(mapView.layer.bounds.size.width/2, yOffset);
        mapView.contentMode = UIViewContentModeScaleAspectFit;
        
        //Set on angle initially
        CATransform3D transform = CATransform3DIdentity;
        transform.m34 = 1.0/200;
        transform = CATransform3DRotate(transform, M_PI_4/2, 1.0, 0.0, 0.0);
        mapView.layer.transform = transform;
        
        //Add animation
        [mapView.layer addAnimation:[self customAnimation] forKey:nil];
        mapView.layer.speed = 0.0;
        
        //Add to view
        [self.flyViews addObject:mapView];
        [self.scrollView addSubview:mapView];

        //Enforce z order
        mapView.layer.zPosition = -([self.flyViews count] - x);
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
            [self set3d:obj.layer];
        }];
    }
    
    self.viewAppeared = YES;
    
}

/**
 This is the animation that is controlled using timeOffset when the user scrolls
 */
- (CAAnimation *)customAnimation
{
    
    CABasicAnimation *move = [CABasicAnimation animationWithKeyPath:@"transform.rotation.x"];
    move.fromValue = @(M_PI_4/4);
    move.toValue = @(M_PI_4/2) ;
 
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.duration = 1.0; // For convenience when using timeOffset to control the animation
    group.animations = @[move];

    return group;
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.flyViews enumerateObjectsUsingBlock:^(UIView * obj, NSUInteger idx, BOOL *stop) {
        [self set3d:obj.layer];
        obj.layer.zPosition = -([self.flyViews count] - idx);
    }];
}

-(void)set3d:(CALayer *)layer{
    
    CGFloat imageTop = layer.position.y;
    CGFloat contentTop = self.scrollView.contentOffset.y;
    CGFloat distanceToTop = imageTop - contentTop;
    
    distanceToTop = abs(distanceToTop);
    CGFloat percent =distanceToTop / self.scrollView.frame.size.height;
    NSLog(@"percent = %f", percent);
    NSLog(@"imageTop = %f", imageTop);
    NSLog(@"contentTop = %f", contentTop);
    layer.timeOffset = percent;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

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
        [self addView:mapView];
        mapView.layer.zPosition = -([self.flyViews count] - x);
    }

	// Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated{
    [self.flyViews enumerateObjectsUsingBlock:^(UIView * obj, NSUInteger idx, BOOL *stop) {
        [self set3d:obj.layer];
    }];
    
}


-(void)addView:(UIView *)mapView{
    CGFloat yOffset = [[self.flyViews lastObject] frame].origin.y + [[self.flyViews lastObject] frame].size.height ;
    mapView.frame = CGRectMake(20.0, yOffset, self.scrollView.frame.size.width -40, mapView.frame.size.height);
    mapView.contentMode = UIViewContentModeScaleAspectFit;
    
    CATransform3D transform = mapView.layer.transform;
    transform.m34 = 1.0/250;
    transform = CATransform3DRotate(transform, M_PI_4/4, 1.0, 0.0, 0.0);
    mapView.layer.transform = transform;
    
    
    [mapView.layer addAnimation:[self pullDownAnimation] forKey:nil];
    mapView.layer.speed = 0.0;
    
    [self.flyViews addObject:mapView];
    
    [self.scrollView addSubview:mapView];
    
}


/**
 This is the animation that is controlled using timeOffset when the user scrolls
 */
- (CAAnimation *)pullDownAnimation
{
    /*
    CABasicAnimation *move = [CABasicAnimation animationWithKeyPath:@"transform.rotation.x"];
    move.fromValue = @0;
    move.toValue = @M_PI_2;
 */
    
    CABasicAnimation *loc = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    loc.fromValue = @1.0;
    loc.toValue = @-0.5;
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.duration = 1.0; // For convenience when using timeOffset to control the animation
    group.animations = @[loc];
    
    return group;
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.flyViews enumerateObjectsUsingBlock:^(UIView * obj, NSUInteger idx, BOOL *stop) {
        [self set3d:obj.layer];
        obj.layer.zPosition = -([self.flyViews count] - idx);
    }];
}

-(void)set3d:(CALayer *)layer{
    
    CGFloat distanceToCenter = (layer.frame.origin.y + (layer.frame.size.height/2)) -
    (self.scrollView.contentOffset.y + (self.scrollView.frame.size.height/2));
    distanceToCenter = abs(distanceToCenter);
    CGFloat percent =distanceToCenter / self.scrollView.frame.size.height/2;
    NSLog(@"percent = %f", percent);
    layer.timeOffset = percent;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

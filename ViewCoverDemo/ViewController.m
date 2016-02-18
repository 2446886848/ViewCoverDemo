//
//  ViewController.m
//  ViewCoverDemo
//
//  Created by 吴志和 on 15/12/3.
//  Copyright © 2015年 wuzhihe. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIImage *meiziImage = [UIImage imageNamed:@"meizi.jpg"];
    self.view.layer.contents = (__bridge id)meiziImage.CGImage;
    
    [self showRectWithCenterPoint3:self.view.center];
}

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    CGPoint point = [[touches anyObject] locationInView:self.view];
//    
//    [self showRectWithCenterPoint:point];
//}

/**
 *  第一种使用view覆盖的方式来显示选中
 *
 *  @param centerPoint 鼠标点击的中心点
 */
- (void)showRectWithCenterPoint:(CGPoint)centerPoint
{
    [self.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    UIView *blackView = [[UIView alloc] initWithFrame:self.view.bounds];
    blackView.userInteractionEnabled = NO;
    blackView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    [self.view addSubview:blackView];
    
    CGFloat lightW = 100.0;
    CGFloat lightH = 100.0;
    UIView *lightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, lightW, lightH)];
    lightView.userInteractionEnabled = NO;
    lightView.center = centerPoint;
    lightView.layer.contents = self.view.layer.contents;
    lightView.layer.contentsRect = CGRectMake(lightView.frame.origin.x / blackView.bounds.size.width, lightView.frame.origin.y / blackView.bounds.size.height, lightView.frame.size.width / blackView.bounds.size.width, lightView.frame.size.height / blackView.bounds.size.height);
    
    [blackView addSubview:lightView];
}

/**
 *  第二种使用layer.mask的方式来显示选中
 *
 *  @param centerPoint 鼠标点击的中心点
 *  处理起来稍微有点麻烦，因为默认控制器的view.layer带有两个sublayer
 */
- (void)showRectWithCenterPoint2:(CGPoint)centerPoint
{
    //移除新添加的layer
    static CALayer *oldLayer = nil;
    [oldLayer removeFromSuperlayer];
    oldLayer = nil;
    
    CALayer *blackLayer = [CALayer layer];
    blackLayer.frame = self.view.layer.bounds;
    blackLayer.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5].CGColor;
    [self.view.layer addSublayer:blackLayer];
    oldLayer = blackLayer;
    
    CALayer *bgLayer = [CALayer layer];
    bgLayer.contents = self.view.layer.contents;
    bgLayer.frame = self.view.layer.bounds;
    [blackLayer addSublayer:bgLayer];
    
    CALayer *maskLayer = [[CALayer alloc] init];
    maskLayer.frame = self.view.layer.bounds;
    maskLayer.backgroundColor = [UIColor clearColor].CGColor;

    CALayer *rectLayer= [[CALayer alloc] init];
    rectLayer.frame = CGRectMake(0, 0, 100, 100);
    rectLayer.cornerRadius = 5.0;
    rectLayer.position = centerPoint;
    rectLayer.backgroundColor = [UIColor redColor].CGColor;
    [maskLayer addSublayer:rectLayer];
    bgLayer.mask = maskLayer;
}

/**
 * 第三种使用layer遮盖的方式来显示选中
 *
 *  @param centerPoint 选中的中心坐标
 */
- (void)showRectWithCenterPoint3:(CGPoint)centerPoint
{
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = self.view.bounds;
    maskLayer.fillColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6].CGColor;
    maskLayer.fillRule = kCAFillRuleEvenOdd;
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithArcCenter:centerPoint radius:100 startAngle:0 endAngle:M_PI * 2 clockwise:NO];
    [bezierPath appendPath:[UIBezierPath bezierPathWithRect:maskLayer.frame]];
    maskLayer.path = bezierPath.CGPath;
    bezierPath.usesEvenOddFillRule = YES;
    [self.view.layer addSublayer:maskLayer];
}

@end

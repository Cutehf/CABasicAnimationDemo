//
//  ViewController.m
//  弹出视图添加动画
//
//  Created by 黄飞 on 16/7/13.
//  Copyright © 2016年 黄飞. All rights reserved.
//

#import "ViewController.h"
#import <QuartzCore/CALayer.h>

@interface ViewController ()

/**弹出视图View*/
@property (nonatomic,strong) UIView *popView;
@property (nonatomic,assign) BOOL isShow;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.view.backgroundColor = [UIColor greenColor];
    
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    [btn setTitle:@"点击" forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor redColor];
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
}


//创建视图
-(void)createUI{
    
    //添加视图
    self.popView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 130, 130)];
    self.popView.backgroundColor = [UIColor redColor];
    self.popView.center = self.view.center;
    [self.view addSubview:self.popView];
    self.popView.hidden = true;
    
    //取消按钮
    UIButton *cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(self.popView.frame)-30, self.popView.frame.size.width/2, 30)];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelButtonMethod) forControlEvents:UIControlEventTouchUpInside];
    [self.popView addSubview:cancelBtn];
    
    //确定按钮
    UIButton *okBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.popView.frame.size.width/2, CGRectGetHeight(self.popView.frame)-30, self.popView.frame.size.width/2, 30)];
    [self.popView addSubview:okBtn];
    [okBtn setTitle:@"确定" forState:UIControlStateNormal];
    [okBtn addTarget:self action:@selector(okButtonMethod) forControlEvents:UIControlEventTouchUpInside];

    
}


-(void)btnClick{
    if (self.popView==nil) {
        [self createUI];
    }
    
    self.isShow = YES;
    
    CABasicAnimation *basicAnimation = [CABasicAnimation animation];
    basicAnimation.delegate = self;
    basicAnimation.keyPath = @"transform.scale";
    //动画的时长
    basicAnimation.duration = 0.3f;
    //所改变属性的起始值
    basicAnimation.fromValue = [NSNumber numberWithFloat:0];
    //所改变属性的结束时的值
    basicAnimation.toValue = [NSNumber numberWithFloat:1.0];
    
    //如果是一个动画CAAnimation,则需要将其removedOnCompletion设置为NO,要不然fillMode不起作用
    basicAnimation.removedOnCompletion = NO;
    //动画执行完成后会停留在完成的位置
    /**
     
     kCAFillModeRemoved 这个是默认值,也就是说当动画开始前和动画结束后,动画对layer都没有影响,动画结束后,layer会恢复到之前的状态
     kCAFillModeForwards 当动画结束后,layer会一直保持着动画最后的状态
     kCAFillModeBackwards 这个和kCAFillModeForwards是相对的,就是在动画开始前,你只要将动画加入了一个layer,layer便立即进入动画的初始状态并等待动画开始.你可以这样设定测试代码,将一个动画加入一个layer的时候延迟5秒执行.然后就会发现在动画没有开始的时候,只要动画被加入了layer,layer便处于动画初始状态
     kCAFillModeBoth 理解了上面两个,这个就很好理解了,这个其实就是上面两个的合成.动画加入后开始之前,layer便处于动画初始状态,动画结束后layer保持动画最后的状态.
     
     */
    basicAnimation.fillMode = kCAFillModeForwards;
    
    //设置动画的速度变化
    /**
     
     1.kCAMediaTimingFunctionLinear（线性）：匀速，给你一个相对静态的感觉
     2.kCAMediaTimingFunctionEaseIn（渐进）：动画缓慢进入，然后加速离开
     3.kCAMediaTimingFunctionEaseOut（渐出）：动画全速进入，然后减速的到达目的地
     4.kCAMediaTimingFunctionEaseInEaseOut（渐进渐出）：动画缓慢的进入，中间加速，然后减速的到达目的地。这个是默认的动画行为。
     */
    basicAnimation.timingFunction = [CAMediaTimingFunction functionWithName:@"easeIn"];
    
    
    [self.popView.layer addAnimation:basicAnimation forKey:basicAnimation.keyPath];
}


//动画代理开始方法
-(void)animationDidStart:(CAAnimation *)anim{
    NSLog(@"开始了动画");
    self.popView.hidden = false;
}

//动画结束代理方法
-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    NSLog(@"结束了动画");
    
    if (!self.isShow) {
        
        [self.popView.layer removeAllAnimations];
        [self.popView removeFromSuperview];
        self.popView = nil;
    }
    
}

//取消按钮方法
-(void)cancelButtonMethod{
    NSLog(@"取消按钮点击");
    self.isShow = NO;
    [self hideAnimation];
}

//确定按钮方法
-(void)okButtonMethod{
    NSLog(@"确定按钮点击");
    
}


//隐藏时的动画
-(void)hideAnimation{
    
    //消失变小动画
    CABasicAnimation *basic = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    basic.delegate = self;
    basic.duration = 0.2;
    basic.fromValue = [NSNumber numberWithFloat:1.0];
    basic.toValue = [NSNumber numberWithFloat:0];
    basic.removedOnCompletion = NO;
    basic.fillMode = kCAFillModeForwards;
    
    //创建自己的 easing 函数。通过传递 cubic Bézier 曲线的两个控制点的 x 和 y 坐标
//    CAMediaTimingFunction *timingFunction = [CAMediaTimingFunction functionWithControlPoints: 0.389 : 0.000 : 0.200 : 1.000];
//    [basic setTimingFunction:timingFunction];
    
    basic.timingFunction = [CAMediaTimingFunction functionWithName:@"easeOut"];
    
    [self.popView.layer addAnimation:basic forKey:basic.keyPath];
    
    //添加渐渐消失效果
    CABasicAnimation *alphaAnima = [CABasicAnimation animationWithKeyPath:@"opacity"];
    alphaAnima.delegate = self;
    alphaAnima.duration = 0.2;
    alphaAnima.fromValue = [NSNumber numberWithFloat:1.0];
    alphaAnima.toValue = [NSNumber numberWithFloat:0];
    alphaAnima.removedOnCompletion = NO;
    alphaAnima.fillMode = kCAFillModeForwards;

    [self.popView.layer addAnimation:alphaAnima forKey:alphaAnima.keyPath];

    
}

@end

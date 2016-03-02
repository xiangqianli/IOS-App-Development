//
//  ViewController.h
//  paulproject1
//
//  Created by lxq on 16/2/29.
//  Copyright (c) 2016年 lxq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
-(IBAction)enter:(UIButton *)sender;
-(void)performTwoOperation:(double(^)(double,double))operation;
- (IBAction)operate:(UIButton *)sender;

@end


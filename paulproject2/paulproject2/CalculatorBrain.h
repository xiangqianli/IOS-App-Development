//
//  CalculatorBrain.h
//  paulproject2
//
//  Created by lxq on 16/3/8.
//  Copyright (c) 2016年 lxq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorBrain : NSObject

-(void)pushOperand:(double)operand;
-(double)popOperand;
-(double)performOperation:(NSString *)operand;
-(void)cleanAll;

@end
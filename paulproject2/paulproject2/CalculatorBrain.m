//
//  CalculatorBrain.m
//  paulproject2
//
//  Created by lxq on 16/3/8.
//  Copyright (c) 2016年 lxq. All rights reserved.
//

#import "CalculatorBrain.h"
typedef NS_ENUM(NSInteger,OperationStyle){
    NumberStyle,
    OneOperationStyle,
    TwoOperationStyle
};
@interface CalculatorBrain()
@property(strong,nonatomic)NSMutableArray *operandStack;
@end
@implementation CalculatorBrain
@synthesize operandStack=_operandStack;
NSString *operationString=@"+ - × ÷ √ sin cos";
-(instancetype)init{
    self.operandStack=[[NSMutableArray alloc]init];
    return self;
}
-(NSString *)pushOperand:(NSString*)operand{
    NSLog(@"%@",self.operandStack);
    NSNumber *tempresult=nil;
    tempresult=[self performOperation:operand];
    if (tempresult!=nil)
        [self.operandStack addObject:tempresult];
    NSLog(@"%@",self.operandStack);
    return [NSString stringWithFormat:@"%@",tempresult];
}
-(double)popOperand{
    double arrayCount=self.operandStack.count;
    NSNumber *number;
    if (arrayCount>0) {
        number=[self.operandStack objectAtIndex:arrayCount-1];
        [self.operandStack removeLastObject];
    }else
        NSLog(@"no more operand");
    return [number doubleValue];
}
-(OperationStyle)judgeType:(NSString *)operand{
    NSRange range=[operationString rangeOfString:operand];
    if (range.location==NSNotFound)
        return NumberStyle;
    else if (range.location<7)
        return TwoOperationStyle;
    else if(range.location>7)
        return OneOperationStyle;
    return 0;
}

-(NSNumber *)performOperation:(NSString *)operand{
    OperationStyle typeNumber=[self judgeType:operand];
    NSNumber *tresult=nil;
        if (typeNumber==TwoOperationStyle&&self.operandStack.count>1) {
            double lastValue=[self popOperand];
            double firstValue=[self popOperand];
            if ([operand isEqualToString:@"+"])
                tresult=[NSNumber numberWithDouble:lastValue+firstValue];
            else if ([operand isEqualToString:@"-"])
                tresult=[NSNumber numberWithDouble:firstValue-lastValue];
            else if ([operand isEqualToString:@"*"])
                tresult=[NSNumber numberWithDouble:firstValue*lastValue];
            else if ([operand isEqualToString:@"÷"])
                tresult=[NSNumber numberWithDouble:firstValue/lastValue];
        }else if(typeNumber==OneOperationStyle&&self.operandStack.count>0){
            double value=[self popOperand];
            if ([operand isEqualToString:@"√"])
                tresult=[NSNumber numberWithDouble:sqrt(value)];
            else if ([operand isEqualToString:@"sin"])
                tresult= [NSNumber numberWithDouble:sin(value*M_PI/180)];
            else if([operand isEqualToString:@"cos"])
                tresult= [NSNumber numberWithDouble:cos(value*M_PI/180)];
        }
        else if(typeNumber==NumberStyle)
            tresult= [NSNumber numberWithDouble:[operand doubleValue]];
    return tresult;
}

-(void)cleanAll{
    [self.operandStack removeAllObjects];
}

@end
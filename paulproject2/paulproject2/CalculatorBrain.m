//
//  CalculatorBrain.m
//  paulproject2
//
//  Created by lxq on 16/3/8.
//  Copyright (c) 2016年 lxq. All rights reserved.
//

#import "CalculatorBrain.h"
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
-(void)pushOperand:(double)operand{
    [_operandStack addObject:[NSNumber numberWithDouble:operand]];
}
-(double)popOperand{
    double arrayCount=_operandStack.count;
    NSNumber *number;
    if (arrayCount>0) {
        number=[_operandStack objectAtIndex:arrayCount-1];
        [_operandStack removeLastObject];
    }else
        NSLog(@"no more operand");
    return [number doubleValue];
}
-(double)performOperation:(NSString *)operand{
    NSRange range=[operationString rangeOfString:operand];
    if (range.location!=NSNotFound) {
        if (range.location<7) {
            double lastValue=[self popOperand];
            double firstValue=[self popOperand];
            if ([operand isEqualToString:@"+"])
                return lastValue+firstValue;
            else if ([operand isEqualToString:@"-"])
                return firstValue-lastValue;
            else if ([operand isEqualToString:@"*"])
                return firstValue*lastValue;
            else if ([operand isEqualToString:@"÷"])
                return firstValue/lastValue;
        }else{
            double value=[self popOperand];
            if ([operand isEqualToString:@"√"])
                return sqrt(value);
            else if ([operand isEqualToString:@"sin"])
                return sin(value*M_PI/180);
            else if([operand isEqualToString:@"cos"])
                return cos(value*M_PI/180);
        }
    }else
        return [operand doubleValue];
    return 0;
}
-(void)cleanAll{
    [self.operandStack removeAllObjects];
}
@end
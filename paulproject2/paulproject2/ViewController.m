//
//  ViewController.m
//  paulproject1
//  Calculator:输入时即按照后缀表达式的形式输入，如计算3+5：3 5 +
//  Created by lxq on 16/2/29.
//  Copyright (c) 2016年 lxq. All rights reserved.
//

#import "ViewController.h"
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *display;
@property (weak, nonatomic) IBOutlet UILabel *rightNowDisplay;
@property (strong,nonatomic) CalculatorBrain*brain;
@end

@implementation ViewController
@synthesize brain=_brain;
BOOL notFirstEnteredNumber=false;
BOOL notFirstEnteredDot=false;
NSString *operateString=@"+ - × ÷ √ sin cos";


- (int)countElements:(NSString *)str{
    return [[NSString stringWithFormat:@"%lu",(unsigned long)str.length] intValue];
}
- (void)dropLast{
    if (![self.display.text isEqual:@""]&&notFirstEnteredNumber==true) {//只有在自己输入数字时才能更新
        self.display.text=[self.display.text substringToIndex:(self.display.text.length-1)];
    }else
        notFirstEnteredNumber=false;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.rightNowDisplay.text=@" ";
    self.brain=[[CalculatorBrain alloc]init];
}
- (IBAction)appendDigit:(UIButton *)sender {//输入数字
    NSString *number=sender.currentTitle;
    if ([number isEqualToString:@"π"]) {
        if (notFirstEnteredNumber==true)
            [self enter:nil];
        [self.brain pushOperand:[NSString stringWithFormat:@"%f",M_PI]];
    }
    if (notFirstEnteredNumber==false) {
        self.display.text=number;
        if (![number isEqualToString:@"π"])
            notFirstEnteredNumber=true;
    }else
        self.display.text=[self.display.text stringByAppendingString:number];
}
- (IBAction)appendDot:(UIButton *)sender {//输入小数点
    if (notFirstEnteredNumber==false) {
        self.display.text=@"0.";
        notFirstEnteredNumber=true;
    }else if(notFirstEnteredDot==false)
        self.display.text=[self.display.text stringByAppendingString:@"."];
    notFirstEnteredDot=true;
}
- (IBAction)clearAll:(UIButton *)sender {//重新输入
    [self.brain cleanAll];
    self.display.text=@" ";
    self.rightNowDisplay.text=@" ";
    notFirstEnteredNumber=false;
}
- (IBAction)backSpace:(UIButton *)sender {
    if ([self countElements:self.rightNowDisplay.text]>0)
        [self dropLast];
}
- (IBAction)enter:(UIButton *)sender {//一串数字输入完毕
    NSString *stringNumber=[self.displayValue stringValue];
    if (![self.display.text isEqualToString:@"π"]&&notFirstEnteredNumber==true){
        [self.brain pushOperand:stringNumber];
        self.rightNowDisplay.text=[self.rightNowDisplay.text stringByAppendingString:[NSString stringWithFormat:@" %@",stringNumber]];
        notFirstEnteredNumber=false;
        notFirstEnteredDot=false;
    }
}
- (IBAction)operate:(UIButton *)sender {
    NSString *operation=sender.currentTitle;
    self.rightNowDisplay.text=[self.rightNowDisplay.text stringByAppendingString:[NSString stringWithFormat:@" %@",operation]];
    if (notFirstEnteredNumber==true)
        [self enter:nil];
    self.displayValue=[self.brain pushOperand:operation];
}
- (NSNumber* _Nullable)getDisplayValue{
    if ([[NSScanner scannerWithString:_display.text]scanDouble:nil])
        return [NSNumber numberWithDouble:[_display.text doubleValue]];
    else
        return nil;
}
- (void)setDisplayValue:(NSString *)displayValue{
    if (![[NSScanner scannerWithString:displayValue]scanDouble:nil])
        self.display.text=@"Error!";
    else
        self.display.text=displayValue;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

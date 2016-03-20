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
    NSArray *listString=[self.rightNowDisplay.text componentsSeparatedByString:@" "];
    unsigned long listCount=[listString count];
    NSString *listLast=[listString objectAtIndex:listCount-1];
    NSRange range=[operateString rangeOfString:listLast];
    if ([self.display.text isEqual:@""]||range.location!=NSNotFound) {//上一次输入的是符号或display一直被删删完了
        [self.brain popOperand];
        if ([listLast isEqualToString:@"+"]||[listLast isEqualToString:@"-"]||[listLast isEqualToString:@"÷"]||[listLast isEqualToString:@"×"]) {
            [self.brain pushOperand:[listString objectAtIndex:listCount-3]];
            [self.brain pushOperand:[listString objectAtIndex:listCount-2]];
        }else if ([listLast isEqualToString:@"√"]||[listLast isEqualToString:@"sin"]||[listLast isEqualToString:@"cos"]){
            [self.brain pushOperand:[listString objectAtIndex:listCount-2]];
        }
        NSMutableArray *listDeleteString=[NSMutableArray arrayWithArray:listString];
        [listDeleteString removeLastObject];
        listString=[NSArray arrayWithArray:listDeleteString];
        self.rightNowDisplay.text=[listString componentsJoinedByString:@" "];
    }else{
        self.display.text=[self.display.text substringToIndex:(self.display.text.length-1)];
        self.rightNowDisplay.text=[self.rightNowDisplay.text substringToIndex:(self.rightNowDisplay.text.length-1)];
    }
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
        self.rightNowDisplay.text=[self.rightNowDisplay.text stringByAppendingString:@" "];
        self.display.text=number;
        if (![number isEqualToString:@"π"])
            notFirstEnteredNumber=true;
    }else
        self.display.text=[self.display.text stringByAppendingString:number];
    self.rightNowDisplay.text=[self.rightNowDisplay.text stringByAppendingString:number];
}
- (IBAction)appendDot:(UIButton *)sender {//输入小数点
    if (notFirstEnteredNumber==false) {
        self.display.text=@"0.";
        self.rightNowDisplay.text=[self.rightNowDisplay.text stringByAppendingString:@"0."];
        notFirstEnteredNumber=true;
    }else if(notFirstEnteredDot==false){
        self.display.text=[self.display.text stringByAppendingString:@"."];
        self.rightNowDisplay.text=[self.rightNowDisplay.text stringByAppendingString:@"."];
    }
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
    if (![self.display.text isEqualToString:@"π"]&&notFirstEnteredNumber==true){
        [self.brain pushOperand:[self.displayValue stringValue]];
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
    if ([displayValue isEqual:nil]){
        self.display.text=@"Error!";
        [self dropLast];
    }
    else
        self.display.text=displayValue;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

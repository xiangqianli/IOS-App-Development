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
@end

@implementation ViewController

BOOL notFirstEnteredNumber=false;
BOOL notFirstEnteredDot=false;
NSString *operateString=@"+ - × ÷ √ sin cos";


-(int)countElements:(NSString *)str{
    return [[NSString stringWithFormat:@"%lu",(unsigned long)str.length] intValue];
}

-(void)dropLast{
    NSArray *listString=[self.rightNowDisplay.text componentsSeparatedByString:@" "];
    unsigned long listCount=[listString count];
    NSString *listLast=[listString objectAtIndex:listCount-1];
    NSRange range=[operateString rangeOfString:listLast];
    if ([self.display.text isEqual:@""]||range.location!=NSNotFound) {//上一次输入的是符号或display一直被删删完了
        [self.brain popOperand];
        if ([listLast isEqualToString:@"+"]||[listLast isEqualToString:@"-"]||[listLast isEqualToString:@"÷"]||[listLast isEqualToString:@"×"]) {
            [self.brain pushOperand:[[listString objectAtIndex:listCount-3] doubleValue]];
            [self.brain pushOperand:[[listString objectAtIndex:listCount-2] doubleValue]];
        }else if ([listLast isEqualToString:@"√"]||[listLast isEqualToString:@"sin"]||[listLast isEqualToString:@"cos"]){
            [self.brain pushOperand:[[listString objectAtIndex:listCount-2] doubleValue]];
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
    if (notFirstEnteredNumber==false) {
        self.rightNowDisplay.text=[self.rightNowDisplay.text stringByAppendingString:@" "];
        self.display.text=number;
        notFirstEnteredNumber=true;
    }else{
        self.display.text=[self.display.text stringByAppendingString:number];
    }
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
- (IBAction)appendPi:(UIButton *)sender {//输入PI
    [self enter:nil];
    [self.brain pushOperand:M_PI];
    self.display.text=[NSString stringWithFormat:@"%f",M_PI];
    self.rightNowDisplay.text=[self.rightNowDisplay.text stringByAppendingString:[NSString stringWithFormat:@" %f",M_PI]];
}
- (IBAction)clearAll:(UIButton *)sender {//重新输入
    [self.brain cleanAll];
    self.display.text=@"0";
    self.rightNowDisplay.text=@"0";
    notFirstEnteredNumber=false;
}
- (IBAction)backSpace:(UIButton *)sender {
    if ([self countElements:self.rightNowDisplay.text]>0 ) {
        [self dropLast];
    }
}

- (IBAction)enter:(UIButton *)sender {//一串数字输入完毕
    notFirstEnteredNumber=false;
    notFirstEnteredDot=false;
    [self.brain pushOperand:[self.displayValue doubleValue]];
}


- (IBAction)operate:(UIButton *)sender {
    NSString *operation=sender.currentTitle;
    self.rightNowDisplay.text=[self.rightNowDisplay.text stringByAppendingString:[NSString stringWithFormat:@" %@",operation]];
    if (notFirstEnteredNumber==true)
        [self enter:nil];
    double result=[self.brain performOperation:operation];
    self.displayValue=[NSNumber numberWithDouble:result];
}
-(NSNumber*)getDisplayValue{
    return [NSNumber numberWithDouble:[_display.text doubleValue]];
}
-(void)setDisplayValue:(NSNumber *)displayValue{
    self.display.text=[displayValue stringValue];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

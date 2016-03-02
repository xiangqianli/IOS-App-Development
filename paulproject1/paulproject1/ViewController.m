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
@property (retain,nonatomic) NSMutableArray *operandStack;
@end

@implementation ViewController
BOOL notFirstEnteredNumber=false;
BOOL notFirstEnteredDot=false;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.operandStack =[[NSMutableArray alloc]initWithCapacity:NSNumberFormatterNoStyle];
    self.rightNowDisplay.text=@"";
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
    self.rightNowDisplay.text=[self.rightNowDisplay.text stringByAppendingString:@" "];
    [self.operandStack addObject:[NSNumber numberWithDouble:M_PI]];
    self.display.text=[NSString stringWithFormat:@"%f",M_PI];
    self.rightNowDisplay.text=[self.rightNowDisplay.text stringByAppendingString:[NSString stringWithFormat:@"%f",M_PI]];
    NSLog(@"%@",self.operandStack);
}
- (IBAction)clearAll:(UIButton *)sender {//重新输入
    [self.operandStack removeAllObjects];
    self.display.text=@"0";
    self.rightNowDisplay.text=@"";
    notFirstEnteredNumber=false;
}

- (IBAction)enter:(UIButton *)sender {//一串数字输入完毕
    notFirstEnteredNumber=false;
    notFirstEnteredDot=false;
    double doubleDisplay=[_display.text doubleValue];
    [self.operandStack addObject:[NSNumber numberWithDouble:doubleDisplay]];
    NSLog(@"%@",self.operandStack);
}

-(void)performTwoOperation:(double(^)(double,double))operationTwo{//二元运算
    double arrayCount=self.operandStack.count;
    double tempresult;
    NSNumber* tempnumber;
    if(arrayCount>=2){
        tempresult=operationTwo([[self.operandStack objectAtIndex:arrayCount-1]doubleValue],[[self.operandStack objectAtIndex:arrayCount-2]doubleValue]);
        [self.operandStack removeLastObject];
        tempnumber=@(tempresult);
        _display.text=[tempnumber stringValue];
        [self.operandStack removeLastObject];
        [self enter:nil];
    }
}
-(void)performOneOperation:(double(^)(double))operationOne{//一元运算
    double arrayCount=self.operandStack.count;
    double tempresult;
    NSNumber* tempnumber;
    if(arrayCount>=1){
        tempresult=operationOne([[self.operandStack objectAtIndex:arrayCount-1]doubleValue]);
        [self.operandStack removeLastObject];
        tempnumber=@(tempresult);
        self.display.text=[tempnumber stringValue];
        [self enter:nil];
    }
}

- (IBAction)operate:(UIButton *)sender {
    if (notFirstEnteredNumber==true)
        [self enter:nil];
    NSString *operate=sender.currentTitle;
    self.rightNowDisplay.text=[self.rightNowDisplay.text stringByAppendingString:[NSString stringWithFormat:@" %@",operate]];
    double (^mutiply)(double,double)=^(double op1,double op2){//乘法
        [self.operandStack removeLastObject];
        return  op1*op2;
    };
    double (^devided)(double,double)=^(double op1,double op2){//除法
        [self.operandStack removeLastObject];
        return  op2/op1;
    };
    double (^plus)(double,double)=^(double op1,double op2){//加法
        [self.operandStack removeLastObject];
        return  op1+op2;
    };
    double (^minus)(double,double)=^(double op1,double op2){//减法
        [self.operandStack removeLastObject];
        return  op2-op1;
    };
    double (^square)(double)=^(double op1){//开方
        return  sqrt(op1);
    };
    double (^getsin)(double)=^(double op1){//正弦函数
        return sin(op1*M_PI/180);
    };
    double (^getcos)(double)=^(double op1){//余弦函数
        return cos(op1*M_PI/180);
    };
    if ([operate isEqualToString:@"✕"]) {
        [self performTwoOperation:mutiply];
    }else if ([operate isEqualToString:@"÷"]){
        [self performTwoOperation:devided];
    }else if ([operate isEqualToString:@"+"]){
        [self performTwoOperation:plus];
    }else if ([operate isEqualToString:@"−"]){
        [self performTwoOperation:minus];
    }else if ([operate isEqualToString:@"√"]){
        [self performOneOperation:square];
    }else if ([operate isEqualToString:@"sin"]){
        [self performOneOperation:getsin];
    }else if ([operate isEqualToString:@"cos"]){
        [self performOneOperation:getcos];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

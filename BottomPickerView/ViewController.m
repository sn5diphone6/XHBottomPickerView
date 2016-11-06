//
//  ViewController.m
//  BottomPickerView
//
//  Created by 姚冬元 on 16/8/4.
//  Copyright © 2016年 X1aoHey. All rights reserved.
//

#import "ViewController.h"
#import "XHBottomPickerView.h"


#define kSCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define kSCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define Color(r, g, b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]

@interface ViewController ()<BottomPickerViewDelegete>

@property (nonatomic, strong) XHBottomPickerView *date;
@property (nonatomic, strong) XHBottomPickerView *date2;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *btn = [[UIButton alloc] init];
    btn.frame = CGRectMake(50, 100, 100, 30);
    [btn setTitle:@"单列滚轮" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(tap) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btn];
    
    UIButton *btn2 = [[UIButton alloc] init];
    btn2.frame = CGRectMake(180, 100, 130, 30);
    [btn2 setTitle:@"二级联动滚轮" forState:UIControlStateNormal];
    [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(tapTwo) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btn2];
    
    UIButton *btn3 = [[UIButton alloc] init];
    btn3.frame = CGRectMake(50, 150, 100, 30);
    [btn3 setTitle:@"时间选择" forState:UIControlStateNormal];
    [btn3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn3 addTarget:self action:@selector(tapThree) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btn3];
    
    UIButton *btn4 = [[UIButton alloc] init];
    btn4.frame = CGRectMake(180, 150, 100, 30);
    [btn4 setTitle:@"时间选择2" forState:UIControlStateNormal];
    [btn4 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn4 addTarget:self action:@selector(tapFour) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btn4];
}

- (void)tap {
    
    XHBottomPickerView *pickerView = [[XHBottomPickerView alloc] initWithFrame:CGRectMake(0, kSCREEN_HEIGHT - 260, kSCREEN_WIDTH, 260)
                                                                         Array:@[@"大乐透", @"排列3", @"排列5", @"7星彩", @"双色球", @"福彩3D"]];
    pickerView.delegate = self;
    [pickerView show];
    
}

- (void)tapTwo {
    
    NSDictionary *dic = [[NSDictionary alloc] init];
    dic = @{
            @"体彩":@[@"大乐透", @"排列3", @"排列5", @"7星彩"],
            @"福彩":@[@"双色球", @"福彩3D"],
            };
    
    XHBottomPickerView *pickerView = [[XHBottomPickerView alloc] initWithFrame:CGRectMake(0, kSCREEN_HEIGHT - 260, kSCREEN_WIDTH, 260)
                                                                         Array:@[@"体彩", @"福彩"]
                                                                    Dictionary:dic];
    pickerView.delegate = self;
    [pickerView show];
}

- (void)tapThree {
    
    _date = [[XHBottomPickerView alloc] initDatePicker:CGRectMake(0, kSCREEN_HEIGHT - 260, kSCREEN_WIDTH, 260)
                                                  Mode:UIDatePickerModeDate];
    _date.dateFormat = @"YYYY-MM-DD hh:mm:ss";
    _date.delegate = self;
    [_date show];
}

- (void)tapFour {
    
    _date2 = [[XHBottomPickerView alloc] initDatePicker:CGRectMake(0, kSCREEN_HEIGHT - 260, kSCREEN_WIDTH, 260)
                                                   Mode:UIDatePickerModeDate];
    _date2.dateFormat = @"YYYY-MM";
    _date2.delegate = self;
    [_date2 show];
}


#pragma mark BottomPickerViewDelegete

- (void)picker:(UIPickerView *)pickerView selectTitle:(NSString *)title row:(NSInteger)row {
    
    NSLog(@"title = %@, row = %ld", title, (long)row);
}

- (void)picker:(UIPickerView *)pickerView selectTitle:(NSString *)title firstRow:(NSInteger)firstRow secondRow:(NSInteger)secondRow {
    
    NSLog(@"title = %@, row = %ld-%ld", title, (long)firstRow, (long)secondRow);
}

- (void)datePicker:(UIDatePicker *)datePicker selectData:(NSString *)dateString {
    
    if (datePicker == _date.datePicker) {
        
        NSLog(@"%@", dateString);
    }
    
    else if (datePicker == _date2.datePicker) {
        
        NSLog(@"----%@", dateString);
    }
}

@end

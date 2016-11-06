//
//  XHBottomPickerView.m
//  BottomPickerView
//
//  Created by 姚冬元 on 16/8/4.
//  Copyright © 2016年 X1aoHey. All rights reserved.
//

#import "XHBottomPickerView.h"

#define kSCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define kSCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define Color(r, g, b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]

@implementation XHBottomPickerView
{
    UIView *view;
    
    NSArray *type1;         // 大分类
    NSDictionary *type2;    // 小分类
    
    NSInteger _pickerRow;
    NSInteger _pickerComponent;
}

@synthesize cancelBtn, doneBtn, picker, datePicker;

- (instancetype)initWithFrame:(CGRect)frame Array:(NSArray *)array Dictionary:(NSDictionary *)dic
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        _rect = frame;
        
        picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 40, CGRectGetWidth(frame), CGRectGetHeight(frame)-60)];
        picker.delegate  = self;
        picker.dataSource = self;
        picker.showsSelectionIndicator = YES;
        [self addSubview:picker];
        
        [self initOherUI];
        
        // 分类1
        type1 = array;
        
        // 分类2
        type2 = dic;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame Array:(NSArray *)array {
    
    return [self initWithFrame:frame Array:array Dictionary:nil];
}

- (instancetype)initDatePicker:(CGRect)frame Mode:(UIDatePickerMode)dateMode {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        _rect = frame;
        
        datePicker = [[UIDatePicker alloc] init];
        datePicker.frame = CGRectMake(0, 40, CGRectGetWidth(frame), CGRectGetHeight(frame)-60); // 设置显示的位置和大小
        datePicker.date = [NSDate date]; // 设置初始时间
        datePicker.timeZone = [NSTimeZone timeZoneWithName:@"GTM+8"]; // 设置时区，中国在东八区
        datePicker.datePickerMode = dateMode; // 设置样式
        [self addSubview:datePicker];
        
        [self initOherUI];
    }
    return self;
}

- (void)initOherUI {
    
    self.backgroundColor = [UIColor whiteColor];
    self.userInteractionEnabled = YES;
    self.layer.borderColor = [UIColor clearColor].CGColor;
    self.layer.borderWidth =  1;
    [self.layer setMasksToBounds:YES];
    
    cancelBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [cancelBtn addTarget:self action:@selector(selectbtn:) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setTitle:@"取消" forState:0];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    cancelBtn.tag = 1;
    [cancelBtn.layer setMasksToBounds:YES];
    [self addSubview:cancelBtn];
    
    doneBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [doneBtn addTarget:self action:@selector(selectbtn:) forControlEvents:UIControlEventTouchUpInside];
    [doneBtn setTitle:@"完成" forState:0];
    doneBtn.tag = 2;
    doneBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:doneBtn];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = Color(229, 229, 229);
    [self addSubview:lineView];
    
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(5);
        make.top.offset(0);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(50);
    }];
    
    [doneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-5);
        make.top.offset(0);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(50);
    }];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.top.equalTo(doneBtn.mas_bottom).with.offset(0);
        make.height.mas_equalTo(0.8);
        make.width.mas_equalTo(kSCREEN_WIDTH);
    }];
}

- (void)setBtnColor:(UIColor *)btnColor {
    
    [cancelBtn setTitleColor:btnColor forState:UIControlStateNormal];
    [doneBtn setTitleColor:btnColor forState:UIControlStateNormal];
}

- (void)setDateFormat:(NSString *)dateFormat {
    
    _dateFormat = dateFormat;
}

- (void)selectbtn:(UIButton *)sender {
    
    if (sender == cancelBtn) {
        
        [self dismiss];
        return;
    }
    
    if (datePicker) {
        
//        if (sender == doneBtn) {
        
            NSDate *select = [datePicker date]; // 获取被选中的时间
            NSDateFormatter *selectDateFormatter = [[NSDateFormatter alloc] init];
            selectDateFormatter.dateFormat = _dateFormat; // 设置时间和日期的格式
            NSString *dateString = [selectDateFormatter stringFromDate:select]; // 把date类型转为设置好格式的string类型
            
            [self.delegate datePicker:datePicker selectData:dateString];
//        }
    }
    else {
//        if (sender == doneBtn) {
        
            if(type2 == nil) {
                
                NSInteger row = _pickerRow ;
                
                NSString *selTitle = type1[row];
                
                if (self.delegate) {

                    [self.delegate picker:picker selectTitle:selTitle row:row];
                }
            }
            else {
                
                if (_pickerComponent == 0) {
                    
                    [picker reloadComponent:1];
                }
                
                NSInteger rowOne = [picker selectedRowInComponent:0];
                NSInteger rowTow = [picker selectedRowInComponent:1];
                
                NSString *component1Name = type1[rowOne];
                NSString *component2Name = type2[component1Name] [rowTow];
                
                if ([component2Name isEqualToString:@""] || component2Name == nil) {
                    
                    return;
                }
                
                if (self.delegate) {

                    NSString *selTitle = [component1Name stringByAppendingString:component2Name];
                    
                    [self.delegate picker:picker selectTitle:selTitle firstRow:rowOne secondRow:rowTow];
                }
            }
//        }
    }
    
    [self dismiss];
}

#pragma mark - 该方法的返回值决定该控件包含多少列
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView
{
    if (type2 == nil) {
        return 1;
    }
    return 2;
}

#pragma mark - 该方法的返回值决定该控件指定列包含多少个列表项
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    if (type2 == nil) {
        return type1.count;
    }
    else {
        if (component == 0) {
            
            return type1.count;
        }
        
        else  {
            
            NSInteger rowType1 = [pickerView selectedRowInComponent:0];
            NSString *type1Name = type1[rowType1];
            NSArray *type2Name = type2[type1Name];
            return type2Name.count;
        }
    }
}

#pragma mark - 该方法返回的NSString将作为UIPickerView中指定列和列表项的标题文本
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    if (type2 == nil) {
        
        return type1[row];
    }
    else {
        if (component == 0) {
            
            return type1[row];
        }
        else {
            NSInteger rowType1 = [pickerView selectedRowInComponent:0];
            NSString *type1Name = type1[rowType1];
            NSArray *type2Name = type2[type1Name];
            return type2Name[row];
        }
    }
}

#pragma mark - 当用户选中UIPickerViewDataSource中指定列和列表项时激发该方法
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (type2 == nil) {
        _pickerRow = row;
        _pickerComponent = component;
    }
    else {
        if(component == 0 || component == 1){
            
            if (component == 0) {
                [picker reloadComponent:1];
                [picker selectRow:0 inComponent:1 animated:YES];
            }
            
            //当第一个滚轮发生变化时,刷新第二个滚轮的数据
            [picker reloadComponent:1];
        }
        _pickerRow = row;
        _pickerComponent = component;
    }
}

//出现
- (void)show
{
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    view = [[UIView alloc] initWithFrame:keyWindow.bounds];
    view.alpha = 0.2;
    view.backgroundColor = [UIColor blackColor];
    [keyWindow addSubview:view];
    
    self.frame = CGRectMake(0, kSCREEN_HEIGHT, kSCREEN_WIDTH, 260);
    [keyWindow addSubview:self];
    
    
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^
     {
         CGRect rect = self.frame;
         rect = _rect;
         self.frame = rect;
     }
                     completion:^(BOOL finished)
     {
         [keyWindow bringSubviewToFront:self];
         // 点击灰色蒙版  pickerView 消失
         UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
         tapGestureRecognizer.cancelsTouchesInView = NO;
         [view addGestureRecognizer:tapGestureRecognizer];
     }];
}

//消失
- (void)dismiss
{
    [UIView animateWithDuration:0.25
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^
     {
         CGRect rect = self.frame;
         rect = CGRectMake(0, kSCREEN_HEIGHT, kSCREEN_WIDTH, 260);
         self.frame = rect;
         
         view.alpha = 0;
     }
                     completion:^(BOOL finished)
     {
         [view removeFromSuperview];
         [self removeFromSuperview];
         
         view = nil;
     }];
}
@end

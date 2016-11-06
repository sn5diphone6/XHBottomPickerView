//
//  XHBottomPickerView.h
//  BottomPickerView
//
//  Created by 姚冬元 on 16/8/4.
//  Copyright © 2016年 X1aoHey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Masonry.h"

@protocol BottomPickerViewDelegete <NSObject>

// 单列滚轮
- (void)picker:(UIPickerView *)pickerView selectTitle:(NSString *)title row:(NSInteger)row;

// 时间滚轮
- (void)datePicker:(UIDatePicker *)datePicker selectData:(NSString *)dateString;

// 二级联动滚轮
- (void)picker:(UIPickerView *)pickerView selectTitle:(NSString *)title firstRow:(NSInteger)firstRow secondRow:(NSInteger)secondRow;

@end

@interface XHBottomPickerView : UIView <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, retain) UIButton *cancelBtn;

@property (nonatomic, retain) UIButton *doneBtn;

@property (nonatomic, retain) UIPickerView *picker;

@property (nonatomic, retain) UIDatePicker *datePicker;

@property (nonatomic, assign) CGRect rect;

@property (nonatomic, strong) UIColor *btnColor;  // 确定/取消 按钮的按钮颜色

@property (nonatomic, copy) NSString *dateFormat; // 类似@"YYYY-MM-DD"

@property (nonatomic, retain) id<BottomPickerViewDelegete> delegate;

/* 创建二级联动pickerView */
- (instancetype)initWithFrame:(CGRect)frame Array:(NSArray *)array Dictionary:(NSDictionary *)dic;

/* 创建单列pickerView */
- (instancetype)initWithFrame:(CGRect)frame Array:(NSArray *)array;

/* 创建时间选择器 */
- (instancetype)initDatePicker:(CGRect)frame Mode:(UIDatePickerMode)dateMode;

/* 显示 */
- (void)show;

/* 消失 */
- (void)dismiss;

@end
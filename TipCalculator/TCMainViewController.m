//
//  ViewController.m
//  TipCalculator
//
//  Created by asu on 2015-09-04.
//  Copyright (c) 2015 asu. All rights reserved.
//

#import "TCMainViewController.h"

@interface TCMainViewController () <UIPickerViewDelegate, UIPickerViewDataSource>
@property (weak, nonatomic) IBOutlet UITextField *billAmountTextField;
@property (weak, nonatomic) IBOutlet UIPickerView *tipPercentPicker;
@property (weak, nonatomic) IBOutlet UILabel *suggestedTipTextField;
@property (weak, nonatomic) IBOutlet UILabel *suggestedTotalTextField;

@end

@implementation TCMainViewController

static int const MinTip = 0;
static int const MaxTip = 40;
static int const DefaultTip = 15;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    [self.billAmountTextField addTarget:self
                                 action:@selector(billAmountDidChange:)
                       forControlEvents:UIControlEventEditingChanged];
    
    self.tipPercentPicker.dataSource = self;
    self.tipPercentPicker.delegate = self;
    [self.tipPercentPicker reloadAllComponents];
    [self.tipPercentPicker selectRow:DefaultTip inComponent:0 animated:YES];
  
    [self recalculateValues];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - touch events

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

#pragma mark - <UITextFieldDelegate>

- (void)billAmountDidChange:(UITextField *)sender{
    [self recalculateValues];
}



#pragma mark - <UIPickerViewDataSource>

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{

    return MaxTip - MinTip + 1;

}

#pragma mark - <UIPickerViewDelegate>
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [NSString stringWithFormat:@"%d %%", (int)row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    [self recalculateValues];
}

#pragma mark - private
-(void)recalculateValues{
    
    float percentage = (float)[self.tipPercentPicker selectedRowInComponent:0] / 100.0f;
    
    float billAmount = [self floatFromText:self.billAmountTextField.text];
    
    float tip = percentage * billAmount;
    float total = tip + billAmount;
    
    self.suggestedTipTextField.text = [NSString stringWithFormat:@"Tip: %.2f", tip];
    self.suggestedTotalTextField.text = [NSString stringWithFormat:@"Total: %.2f", total];
    

}

-(float)floatFromText:(NSString*)text{
    NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
    NSNumber *convertedNumber = [numberFormatter numberFromString:text];
    return [convertedNumber floatValue];
}

@end

//
//  VWWAmplitudeParametersTableViewController.m
//  Synthesizer
//
//  Created by Zakk Hoyt on 2/19/14.
//  Copyright (c) 2014 Zakk Hoyt. All rights reserved.
//

#import "VWWAmplitudeParametersTableViewController.h"
#import "VWWSynthesizerGroup.h" 
#import "VWWSynthesizersController.h"

@interface VWWAmplitudeParametersTableViewController ()
@property (weak, nonatomic) IBOutlet UISlider *xAmplitudeSlider;
@property (weak, nonatomic) IBOutlet UISlider *yAmplitudeSlider;
@property (weak, nonatomic) IBOutlet UISlider *zAmplitudeSlider;

@property (weak, nonatomic) IBOutlet UITextField *xAmplitudeTextField;
@property (weak, nonatomic) IBOutlet UITextField *yAmplitudeTextField;
@property (weak, nonatomic) IBOutlet UITextField *zAmplitudeTextField;
@end

@implementation VWWAmplitudeParametersTableViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self updateControls];
    

}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[VWWSynthesizersController sharedInstance] writeSettings];
}


#pragma mark Private methods
-(void)updateControls{
    
    
    // Slider minimum values
    self.xAmplitudeSlider.minimumValue = 0.0;
    self.yAmplitudeSlider.minimumValue = 0.0;
    self.zAmplitudeSlider.minimumValue = 0.0;
    
    // Slider maximum values
    self.xAmplitudeSlider.maximumValue = 1.0;
    self.yAmplitudeSlider.maximumValue = 1.0;
    self.zAmplitudeSlider.maximumValue = 1.0;
    
    // Slider value
    self.xAmplitudeSlider.value = self.synthesizerGroup.xSynthesizer.amplitude;
    self.yAmplitudeSlider.value = self.synthesizerGroup.ySynthesizer.amplitude;
    self.zAmplitudeSlider.value = self.synthesizerGroup.zSynthesizer.amplitude;
    
    // Text boxes
    self.xAmplitudeTextField.text = [NSString stringWithFormat:@"%ld%%", (long)[self percentFromFloat:self.synthesizerGroup.xSynthesizer.amplitude]];
    self.yAmplitudeTextField.text = [NSString stringWithFormat:@"%ld%%", (long)[self percentFromFloat:self.synthesizerGroup.ySynthesizer.amplitude]];
    self.zAmplitudeTextField.text = [NSString stringWithFormat:@"%ld%%", (long)[self percentFromFloat:self.synthesizerGroup.zSynthesizer.amplitude]];
    
    


}


-(NSInteger)percentFromFloat:(float)amplitude{
    return (NSInteger)(amplitude * 100);
}


-(float)floatValueFromTextField:(UITextField*)textField{
    float value = textField.text.floatValue;
    value = value / (float)100;
    value = MAX(value, 0.0);
    value = MIN(value, 1.0);
    return value;
}




#pragma mark IBActions
- (IBAction)doneButtonAction:(id)sender {
    [[VWWSynthesizersController sharedInstance] writeSettings];
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (IBAction)xAmplitudeSliderValueChanged:(UISlider*)sender {
    self.synthesizerGroup.xSynthesizer.amplitude = sender.value;
    [self updateControls];
}
- (IBAction)yAmplitudeSliderValueChanged:(UISlider*)sender {
    self.synthesizerGroup.ySynthesizer.amplitude = sender.value;
    [self updateControls];
}
- (IBAction)zAmplitudeSliderValueChanged:(UISlider*)sender {
    self.synthesizerGroup.zSynthesizer.amplitude = sender.value;
    [self updateControls];
}


#pragma mark UITextFieldDelegate


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    
    if(textField == self.xAmplitudeTextField) {
        self.synthesizerGroup.xSynthesizer.amplitude = [self floatValueFromTextField:textField];
    } else if(textField == self.yAmplitudeTextField){
        self.synthesizerGroup.ySynthesizer.amplitude = [self floatValueFromTextField:textField];
    } else if(textField == self.zAmplitudeTextField){
        self.synthesizerGroup.zSynthesizer.amplitude = [self floatValueFromTextField:textField];
    }
    
    [self updateControls];
    return YES;
}



#pragma mark UITableViewDataSource

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if([self.synthesizerGroup.groupType isEqualToString:VWWSynthesizerGroupTouchScreen] ||
       [self.synthesizerGroup.groupType isEqualToString:VWWSynthesizerGroupMotion]){
        switch (section) {
            case VWWAxisTypeX:
                return @"X-Axis";
            case VWWAxisTypeY:
                return @"Y-Axis";
            case VWWAxisTypeZ:
                return @"Z-Axis";
            default:
                break;
        }
    } else if([self.synthesizerGroup.groupType isEqualToString:VWWSynthesizerGroupCamera]){
        switch (section) {
            case VWWAxisTypeX:
                return @"Red";
            case VWWAxisTypeY:
                return @"Green";
            case VWWAxisTypeZ:
                return @"Blue";
            default:
                break;
        }
        
    }
    return @"";
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        cell.backgroundColor = [UIColor clearColor];
    }
}

@end

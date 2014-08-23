//
//  VWWSensitivityParameterTableViewController.m
//  Synthesizer
//
//  Created by Zakk Hoyt on 2/19/14.
//  Copyright (c) 2014 Zakk Hoyt. All rights reserved.
//

#import "VWWSensitivityParameterTableViewController.h"
#import "VWWSynthesizerGroup.h" 
#import "VWWSynthesizersController.h"


@interface VWWSensitivityParameterTableViewController ()
@property (weak, nonatomic) IBOutlet UISlider *xSensitivitySlider;
@property (weak, nonatomic) IBOutlet UISlider *ySensitivitySlider;
@property (weak, nonatomic) IBOutlet UISlider *zSensitivitySlider;

@end

@implementation VWWSensitivityParameterTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        self.tableView.backgroundColor = nil;
        self.tableView.backgroundColor = [UIColor darkGrayColor];
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[VWWSynthesizersController sharedInstance] writeSettings];
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        NSInteger sectionCount = [self.tableView numberOfSections];
        for(NSUInteger sectionIndex = 0; sectionIndex < sectionCount; sectionIndex++){
            NSInteger cellCount = [self.tableView numberOfRowsInSection:sectionIndex];
            for(NSUInteger cellIndex = 0; cellIndex < cellCount; cellIndex++){
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:cellIndex inSection:sectionIndex];
                UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
                cell.backgroundColor = [UIColor clearColor];
            }
        }
    }
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self updateControls];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark Private methods
-(void)updateControls{
    
    
    // Slider minimum values
    self.xSensitivitySlider.minimumValue = 0.0;
    self.ySensitivitySlider.minimumValue = 0.0;
    self.zSensitivitySlider.minimumValue = 0.0;
    
    // Slider maximum values
    self.xSensitivitySlider.maximumValue = 1.0;
    self.ySensitivitySlider.maximumValue = 1.0;
    self.zSensitivitySlider.maximumValue = 1.0;
    
//    // Slider value
//    self.xSensitivitySlider.value = self.synthesizerGroup.xSynthesizer.sensitivity;
//    self.ySensitivitySlider.value = self.synthesizerGroup.ySynthesizer.sensitivity;
//    self.zSensitivitySlider.value = self.synthesizerGroup.zSynthesizer.sensitivity;
    self.xSensitivitySlider.value = 1.0;
    self.ySensitivitySlider.value = 1.0;
    self.zSensitivitySlider.value = 1.0;
    
}


#pragma mark IBActions
- (IBAction)doneButtonAction:(id)sender {
    [[VWWSynthesizersController sharedInstance] writeSettings];
    [self.navigationController popToRootViewControllerAnimated:YES];
}


#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    [self updateControls];
    return YES;
}



#pragma mark UITableViewDataSource

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
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
    return @"";
}
@end

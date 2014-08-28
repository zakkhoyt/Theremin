//
//  VWWSynthesizerSettingsTableViewController.m
//  Synthesizer
//
//  Created by Zakk Hoyt on 2/14/14.
//  Copyright (c) 2014 Zakk Hoyt. All rights reserved.
//

#import "VWWSynthesizerAxesSettingsTableViewController.h"
//#import "VWWSynthesizerSettingsTableViewController.h"
#import "VWWSynthesizerAxisSettingsTableViewController.h"
#import "VWWSynthesizersController.h"


static NSString *VWWSegueAxesToGroupConfig = @"VWWSegueAxesToGroupConfig";
const NSInteger VWWSynthesizerTouchScreenSection = 0;
const NSInteger VWWSynthesizerAccelerometerSection = 1;
const NSInteger VWWSynthesizerGyroscopeSection = 2;
const NSInteger VWWSynthesizerMagnetometerSection = 3;
const NSInteger VWWSynthesizerCameraSection = 4;

const NSInteger VWWSynthesizerConfigureRow = 0;
const NSInteger VWWSynthesizerXAxisRow = 1;
const NSInteger VWWSynthesizerYAxisRow = 2;
const NSInteger VWWSynthesizerZAxisRow = 3;

@interface VWWSynthesizerAxesSettingsTableViewController ()
@property (nonatomic, strong) VWWSynthesizersController *synthesizersController;
@property (weak, nonatomic) IBOutlet UISwitch *touchscreenXAxisSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *touchscreenYAxisSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *accelerometersXAxisSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *accelerometersYAxisSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *accelerometersZAxisSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *gyroscopesXAxisSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *gyroscopesYAxisSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *gyroscopesZAxisSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *magnetometersXAxisSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *magnetometersYAxisSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *magnetometersZAxisSwitch;

@property (weak, nonatomic) IBOutlet UISwitch *camerRedSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *cameraGreenSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *cameraBlueSwitch;







@end

@implementation VWWSynthesizerAxesSettingsTableViewController

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

    self.synthesizersController = [VWWSynthesizersController sharedInstance];
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        self.tableView.backgroundView = nil;
        self.tableView.backgroundColor = [UIColor darkGrayColor];
    }

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self updateControls];
    self.navigationController.navigationBarHidden = NO;
    
    
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

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[VWWSynthesizersController sharedInstance] writeSettings];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:VWWSegueAxesToGroupConfig]){
        VWWSynthesizerAxisSettingsTableViewController *vc = segue.destinationViewController;
        vc.synthesizerGroup = sender;
    }
}


#pragma mark Private methods
-(void)updateControls{
    // Touchscreen
    self.touchscreenXAxisSwitch.on = !self.synthesizersController.touchscreenGroup.xSynthesizer.muted;
    self.touchscreenYAxisSwitch.on = !self.synthesizersController.touchscreenGroup.ySynthesizer.muted;

    // Accelerometers
    self.accelerometersXAxisSwitch.on = !self.synthesizersController.accelerometersGroup.xSynthesizer.muted;
    self.accelerometersYAxisSwitch.on = !self.synthesizersController.accelerometersGroup.ySynthesizer.muted;
    self.accelerometersZAxisSwitch.on = !self.synthesizersController.accelerometersGroup.zSynthesizer.muted;
    
    // Gyroscopes
    self.gyroscopesXAxisSwitch.on = !self.synthesizersController.gyroscopesGroup.xSynthesizer.muted;
    self.gyroscopesYAxisSwitch.on = !self.synthesizersController.gyroscopesGroup.ySynthesizer.muted;
    self.gyroscopesZAxisSwitch.on = !self.synthesizersController.gyroscopesGroup.zSynthesizer.muted;
    
    // Magnetometers
    self.magnetometersXAxisSwitch.on = !self.synthesizersController.magnetometersGroup.xSynthesizer.muted;
    self.magnetometersYAxisSwitch.on = !self.synthesizersController.magnetometersGroup.ySynthesizer.muted;
    self.magnetometersZAxisSwitch.on = !self.synthesizersController.magnetometersGroup.zSynthesizer.muted;
    
    // Cameras
    self.camerRedSwitch.on = !self.synthesizersController.cameraGroup.xSynthesizer.muted;
    self.cameraGreenSwitch.on = !self.synthesizersController.cameraGroup.ySynthesizer.muted;
    self.cameraBlueSwitch.on = !self.synthesizersController.cameraGroup.zSynthesizer.muted;
}

#pragma mark IBActions
- (IBAction)doneButtonAction:(id)sender {
    [[VWWSynthesizersController sharedInstance] writeSettings];
    [self.navigationController popToRootViewControllerAnimated:YES];
}


- (IBAction)touchscreenXAxisSwitchValueChanged:(UISwitch*)sender {
    self.synthesizersController.touchscreenGroup.xSynthesizer.muted = !sender.on;
}
- (IBAction)touchscreenYAxisSwitchValueChanged:(UISwitch*)sender {
    self.synthesizersController.touchscreenGroup.ySynthesizer.muted = !sender.on;
}


- (IBAction)accelerometersXAxisSwitchValueChanged:(UISwitch*)sender {
    self.synthesizersController.accelerometersGroup.xSynthesizer.muted = !sender.on;
}
- (IBAction)accelerometersYAxisSwitchValueChanged:(UISwitch*)sender {
    self.synthesizersController.accelerometersGroup.ySynthesizer.muted = !sender.on;
}
- (IBAction)accelerometersZAxisSwitchValueChanged:(UISwitch*)sender {
    self.synthesizersController.accelerometersGroup.zSynthesizer.muted = !sender.on;
}

- (IBAction)gyroscopesXAxisSwitchValueChanged:(UISwitch*)sender {
    self.synthesizersController.gyroscopesGroup.xSynthesizer.muted = !sender.on;
}
- (IBAction)gyroscopesYAxisSwitchValueChanged:(UISwitch*)sender {
    self.synthesizersController.gyroscopesGroup.ySynthesizer.muted = !sender.on;
}
- (IBAction)gyroscopesZAxisSwitchValueChanged:(UISwitch*)sender {
    self.synthesizersController.gyroscopesGroup.zSynthesizer.muted = !sender.on;
}

- (IBAction)magnetometersXAxisSwitchValueChanged:(UISwitch*)sender {
    self.synthesizersController.magnetometersGroup.xSynthesizer.muted = !sender.on;
}
- (IBAction)magnetometersYAxisSwitchValueChanged:(UISwitch*)sender {
    self.synthesizersController.magnetometersGroup.ySynthesizer.muted = !sender.on;
}
- (IBAction)magnetometersZAxisSwitchValueChanged:(UISwitch*)sender {
    self.synthesizersController.magnetometersGroup.zSynthesizer.muted = !sender.on;
}

- (IBAction)cameraRedSwitchValueChanged:(UISwitch *)sender {
    self.synthesizersController.cameraGroup.xSynthesizer.muted = !sender.on;
}
- (IBAction)cameraGreenSwitchValueChanged:(UISwitch *)sender {
    self.synthesizersController.cameraGroup.ySynthesizer.muted = !sender.on;
}
- (IBAction)cameraBlueSwitchValueChanged:(UISwitch *)sender {
    self.synthesizersController.cameraGroup.zSynthesizer.muted = !sender.on;
}



#pragma mark UITableViewDataSource

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    const CGFloat kHeight = 20;
//    const CGFloat kYBorder = 4;
//    
//    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, kHeight)];
//    headerView.backgroundColor = [UIColor yellowColor];
//
//    UILabel *labelHeader = [[UILabel alloc] initWithFrame:CGRectMake (10, kYBorder ,tableView.bounds.size.width,kHeight - 2*kYBorder)];
//    labelHeader.backgroundColor = [UIColor redColor];
//    labelHeader.textColor = [UIColor whiteColor];
//    labelHeader.text = [NSString stringWithFormat:@"Testing %ld", (long)section];
//    [headerView addSubview:labelHeader];
//    return headerView;
//}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return @"Touch Screen";
        case 1:
            return @"Accelerometers";
        case 2:
            return @"Gyroscopes";
        case 3:
            return @"Magnetometers";
        case 4:
            return @"Camera";
        default:
            break;
    }
    return @"";
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    VWWSynthesizerGroup *synthesizerGroup;
    if(indexPath.section == VWWSynthesizerTouchScreenSection){
        synthesizerGroup = self.synthesizersController.touchscreenGroup;
    } else if(indexPath.section == VWWSynthesizerAccelerometerSection){
        synthesizerGroup = self.synthesizersController.accelerometersGroup;
    } else if(indexPath.section == VWWSynthesizerGyroscopeSection){
        synthesizerGroup = self.synthesizersController.gyroscopesGroup;
    } else if(indexPath.section == VWWSynthesizerMagnetometerSection){
        synthesizerGroup = self.synthesizersController.magnetometersGroup;
    } else if(indexPath.section == VWWSynthesizerCameraSection){
        synthesizerGroup = self.synthesizersController.cameraGroup;
    }
    
    if(indexPath.row == VWWSynthesizerConfigureRow){
        [self performSegueWithIdentifier:VWWSegueAxesToGroupConfig sender:synthesizerGroup];
    }
}



@end

//
//  VWWStatisticsMotionSensorsTableViewController.m
//  Synthesizer
//
//  Created by Zakk Hoyt on 2/19/14.
//  Copyright (c) 2014 Zakk Hoyt. All rights reserved.
//

#import "VWWStatisticsMotionSensorsTableViewController.h"
#import "VWWSynthesizersController.h"
#import "VWWSensorGraphViewController.h"
#import "VWWInAppPurchaseIdentifier.h"

static NSString *VWWSegueSensorsToGraph = @"VWWSegueSensorsToGraph";

@interface VWWStatisticsMotionSensorsTableViewController ()
@property (nonatomic, strong) VWWSynthesizersController *synthesizersController;
@property (weak, nonatomic) IBOutlet UILabel *accelerometersLabel;
@property (weak, nonatomic) IBOutlet UILabel *gyroscopesLabel;
@property (weak, nonatomic) IBOutlet UILabel *magnetometersLabel;
@property (weak, nonatomic) IBOutlet UILabel *cameraLabel;

@property (weak, nonatomic) IBOutlet UITableViewCell *accelerometersCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *gyroscopesCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *magnetometersCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *cameraCell;

@end

@implementation VWWStatisticsMotionSensorsTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        self.tableView.backgroundColor = nil;
        self.tableView.backgroundColor = [UIColor darkGrayColor];
    }
    
    CADisplayLink *link = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateControls)];
    [link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];

    self.cameraCell.hidden = YES;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.synthesizersController = [VWWSynthesizersController sharedInstance];
    
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
    
    
    // Update disclosuer indicators
    if([[VWWInAppPurchaseIdentifier sharedInstance] productPurchased:VWWInAppPurchaseGraphSensorsKey]){
        [self.accelerometersCell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        [self.gyroscopesCell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        [self.magnetometersCell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        [self.cameraCell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    } else {
        [self.accelerometersCell setAccessoryType:UITableViewCellAccessoryNone];
        [self.gyroscopesCell setAccessoryType:UITableViewCellAccessoryNone];
        [self.magnetometersCell setAccessoryType:UITableViewCellAccessoryNone];
        [self.cameraCell setAccessoryType:UITableViewCellAccessoryNone];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:VWWSegueSensorsToGraph]){
        VWWSensorGraphViewController *vc = segue.destinationViewController;
        NSIndexPath *indexPath = (NSIndexPath*)sender;
        VWWInputType sensorType =  (VWWInputType)(indexPath.section + 2);
        vc.sensorType = sensorType;
    }
}



#pragma mark Private methods
-(void)updateControls{
    self.accelerometersLabel.text = self.synthesizersController.accelerometersStatisticsString;
    self.gyroscopesLabel.text = self.synthesizersController.gyroscopesStatisticsString;
    self.magnetometersLabel.text = self.synthesizersController.magnetometersStatisticsString;
    self.cameraLabel.text = self.synthesizersController.cameraStatisticsString;
}



#pragma mark UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 4){
        return [[VWWInAppPurchaseIdentifier sharedInstance]productPurchased:VWWInAppPurchaseCameraDeviceKey] ? [super tableView:tableView heightForHeaderInSection:section] : 0;
    } else {
        return [super tableView:tableView heightForHeaderInSection:section];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 4){
        return [[VWWInAppPurchaseIdentifier sharedInstance]productPurchased:VWWInAppPurchaseCameraDeviceKey] ? [super tableView:tableView heightForRowAtIndexPath:indexPath] : 0;
    } else {
        return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    }
}

#pragma mark UITableViewDataSource

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return @"Accelerometers";
        case 1:
            return @"Gyroscopes";
        case 2:
            return @"Magnetometers";
        case 3:
            return [[VWWInAppPurchaseIdentifier sharedInstance]productPurchased:VWWInAppPurchaseCameraDeviceKey] ? @"Camera" : @"";
        default:
            break;
    }
    return @"";
}



#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if([[VWWInAppPurchaseIdentifier sharedInstance] productPurchased:VWWInAppPurchaseGraphSensorsKey]){
        [self performSegueWithIdentifier:VWWSegueSensorsToGraph sender:indexPath];
    }
}
#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        cell.backgroundColor = [UIColor clearColor];
    }
}

@end

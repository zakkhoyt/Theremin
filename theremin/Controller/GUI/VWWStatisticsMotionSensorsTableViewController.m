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

static NSString *VWWSegueSensorsToGraph = @"VWWSegueSensorsToGraph";

@interface VWWStatisticsMotionSensorsTableViewController ()
@property (nonatomic, strong) VWWSynthesizersController *synthesizersController;
@property (weak, nonatomic) IBOutlet UILabel *accelerometersLabel;
@property (weak, nonatomic) IBOutlet UILabel *gyroscopesLabel;
@property (weak, nonatomic) IBOutlet UILabel *magnetometersLabel;
@property (weak, nonatomic) IBOutlet UILabel *cameraLabel;

@end

@implementation VWWStatisticsMotionSensorsTableViewController

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
    
    CADisplayLink *link = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateControls)];
    [link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];

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

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return @"Accelerometers";
        case 1:
            return @"Gyroscopes";
        case 2:
            return @"Magnetometers";
        case 3:
            return @"Camera";
        default:
            break;
    }
    return @"";
}



#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:VWWSegueSensorsToGraph sender:indexPath];
}
@end

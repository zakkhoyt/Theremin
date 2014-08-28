//
//  VWWStatisticsMotionSensorsTableViewController.m
//  Synthesizer
//
//  Created by Zakk Hoyt on 2/19/14.
//  Copyright (c) 2014 Zakk Hoyt. All rights reserved.
//

#import "VWWStatisticsMotionSensorsTableViewController.h"
#import "VWWSynthesizersController.h"

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
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.synthesizersController = [VWWSynthesizersController sharedInstance];
    [self updateControls];
    [self addKeyValueObservers];
    
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

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self removeKeyValueObservers];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark Private methods (KVO)


-(void)addKeyValueObservers{
    [self.synthesizersController addObserver:self forKeyPath:VWWSynthesizersControllerAccelerometersStatisticsString options:NSKeyValueObservingOptionNew context:NULL];
    [self.synthesizersController addObserver:self forKeyPath:VWWSynthesizersControllerGyroscopesStatisticsString options:NSKeyValueObservingOptionNew context:NULL];
    [self.synthesizersController addObserver:self forKeyPath:VWWSynthesizersControllerMagnetoometersStatisticsString options:NSKeyValueObservingOptionNew context:NULL];
    [self.synthesizersController addObserver:self forKeyPath:VWWSynthesizersControllerCameraStatisticsString options:NSKeyValueObservingOptionNew context:NULL];
}

-(void)removeKeyValueObservers{
    [self.synthesizersController removeObserver:self forKeyPath:VWWSynthesizersControllerAccelerometersStatisticsString];
    [self.synthesizersController removeObserver:self forKeyPath:VWWSynthesizersControllerGyroscopesStatisticsString];
    [self.synthesizersController removeObserver:self forKeyPath:VWWSynthesizersControllerMagnetoometersStatisticsString];
    [self.synthesizersController removeObserver:self forKeyPath:VWWSynthesizersControllerCameraStatisticsString];

}


-(void)observeValueForKeyPath:(NSString *)keyPath
                     ofObject:(id)object
                       change:(NSDictionary *)change
                      context:(void *)context{
    dispatch_async(dispatch_get_main_queue(), ^{
        // Rather than passing the parameters though KVO, they are already available as public properties.
        // Easier to use that, just using KVO as a trigger.
        if([keyPath isEqualToString:VWWSynthesizersControllerAccelerometersStatisticsString]){
            self.accelerometersLabel.text = self.synthesizersController.accelerometersStatisticsString;
        } else if([keyPath isEqualToString:VWWSynthesizersControllerGyroscopesStatisticsString]) {
            self.gyroscopesLabel.text = self.synthesizersController.gyroscopesStatisticsString;
        } else if([keyPath isEqualToString:VWWSynthesizersControllerMagnetoometersStatisticsString]) {
            self.magnetometersLabel.text = self.synthesizersController.magnetometersStatisticsString;
        } else if([keyPath isEqualToString:VWWSynthesizersControllerCameraStatisticsString]){
            self.cameraLabel.text = self.synthesizersController.cameraStatisticsString;
        }
    });
}


#pragma mark Private methods
-(void)updateControls{
    VWW_LOG_TODO_TASK(@"Use KVO to update these labels");
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
@end

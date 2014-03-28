//
//  VWWEffectParametersTableViewController.m
//  Synthesizer
//
//  Created by Zakk Hoyt on 2/19/14.
//  Copyright (c) 2014 Zakk Hoyt. All rights reserved.
//

#import "VWWEffectParametersTableViewController.h"
#import "VWWSynthesizerGroup.h"
#import "VWWEffectTableViewCell.h"
#import "VWWSynthesizersController.h"
#import "VWWAutotuneKeysTableViewControllers.h"

static NSString *VWWSegueEffectParametersToKeys = @"VWWSegueEffectParametersToKeys";

@interface VWWEffectParametersTableViewController () <VWWEffectTableViewCellDelegate>

@end

@implementation VWWEffectParametersTableViewController

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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:VWWSegueEffectParametersToKeys]){
//        VWWAutotuneKeysTableViewControllers *vc = segue.destinationViewController;
        
    }
}


#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    VWWEffectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VWWEffectTableViewCell"];
    cell.effectType = (VWWEffectType)indexPath.row;
    cell.delegate = self;
    if(indexPath.section == VWWAxisTypeX){
        if(indexPath.row == (NSInteger)self.synthesizerGroup.xSynthesizer.effectType){
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    } else if(indexPath.section == VWWAxisTypeY){
        if(indexPath.row == (NSInteger)self.synthesizerGroup.ySynthesizer.effectType){
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    } else if(indexPath.section == VWWAxisTypeZ){
        if(indexPath.row == (NSInteger)self.synthesizerGroup.zSynthesizer.effectType){
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    
    cell.backgroundColor = [UIColor clearColor];

    return cell;
}

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




#pragma mark UITableViewDelegate


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // Update checkmark
    for(NSInteger index = 0; index < 2; index++){
        NSIndexPath *ip = [NSIndexPath indexPathForRow:index inSection:indexPath.section];
        VWWEffectTableViewCell *cell = (VWWEffectTableViewCell*)[tableView cellForRowAtIndexPath:ip];
        if(index == indexPath.row){
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    
    // Set wavetype
    if(indexPath.section == VWWAxisTypeX) {
        self.synthesizerGroup.xSynthesizer.effectType = (VWWEffectType)indexPath.row;
    } else if(indexPath.section == VWWAxisTypeY) {
        self.synthesizerGroup.ySynthesizer.effectType = (VWWEffectType)indexPath.row;
    } else if(indexPath.section == VWWAxisTypeZ) {
        self.synthesizerGroup.zSynthesizer.effectType = (VWWEffectType)indexPath.row;
    }
    
}

#pragma mark VWWEffectTableViewCellDelegate
-(void)effectTableViewCellEffectConfigButtonTouchUpInside:(VWWEffectTableViewCell*)sender{
    [self performSegueWithIdentifier:VWWSegueEffectParametersToKeys sender:self];
}

@end

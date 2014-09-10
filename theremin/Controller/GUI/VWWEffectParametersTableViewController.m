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
#import "VWWInAppPurchaseIdentifier.h"

static NSString *VWWSegueEffectParametersToKeys = @"VWWSegueEffectParametersToKeys";

@interface VWWEffectParametersTableViewController ()

@end

@implementation VWWEffectParametersTableViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
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
    if([segue.identifier isEqualToString:VWWSegueEffectParametersToKeys]){
        VWWAutotuneKeysTableViewControllers *vc = segue.destinationViewController;
        vc.synthesizer = sender;
    }
}

#pragma mark IBActions
- (IBAction)doneButtonAction:(id)sender {
    [[VWWSynthesizersController sharedInstance] writeSettings];
    [self.navigationController popToRootViewControllerAnimated:YES];
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
    if(indexPath.section == VWWAxisTypeX){
        if(indexPath.row == (NSInteger)self.synthesizerGroup.xSynthesizer.effectType){
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        cell.keyType = self.synthesizerGroup.xSynthesizer.keyType;
    } else if(indexPath.section == VWWAxisTypeY){
        if(indexPath.row == (NSInteger)self.synthesizerGroup.ySynthesizer.effectType){
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        cell.keyType = self.synthesizerGroup.ySynthesizer.keyType;
    } else if(indexPath.section == VWWAxisTypeZ){
        if(indexPath.row == (NSInteger)self.synthesizerGroup.zSynthesizer.effectType){
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        cell.keyType = self.synthesizerGroup.zSynthesizer.keyType;
    }
    
    cell.effectType = (VWWEffectType)indexPath.row;
    cell.backgroundColor = [UIColor clearColor];

    return cell;
}


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
    
    // Set effect type
    if(indexPath.section == VWWAxisTypeX) {
        self.synthesizerGroup.xSynthesizer.effectType = (VWWEffectType)indexPath.row;
    } else if(indexPath.section == VWWAxisTypeY) {
        self.synthesizerGroup.ySynthesizer.effectType = (VWWEffectType)indexPath.row;
    } else if(indexPath.section == VWWAxisTypeZ) {
        self.synthesizerGroup.zSynthesizer.effectType = (VWWEffectType)indexPath.row;
    }
    
    if([[VWWInAppPurchaseIdentifier sharedInstance] productPurchased:VWWInAppPurchaseAutotuneKeysKey]){
        if(indexPath.row == VWWEffectTypeAutoTune){
            
            VWWNormalizedSynthesizer *synthesizer = nil;
            if(indexPath.section == VWWAxisTypeX) {
                synthesizer = self.synthesizerGroup.xSynthesizer;
            } else if(indexPath.section == VWWAxisTypeY) {
                synthesizer = self.synthesizerGroup.ySynthesizer;
            } else if(indexPath.section == VWWAxisTypeZ) {
                synthesizer = self.synthesizerGroup.zSynthesizer;
            }
            [self performSegueWithIdentifier:VWWSegueEffectParametersToKeys sender:synthesizer];
        }
    }
    
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        cell.backgroundColor = [UIColor clearColor];
    }
}



@end

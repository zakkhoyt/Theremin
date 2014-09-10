//
//  VWWAutotuneKeysTableViewControllers.m
//  theremin
//
//  Created by Zakk Hoyt on 2/21/14.
//  Copyright (c) 2014 Zakk Hoyt. All rights reserved.
//

#import "VWWAutotuneKeysTableViewControllers.h"
#import "VWWNormalizedSynthesizer.h"
#import "VWWSynthesizersController.h"

@interface VWWAutotuneKeysTableViewControllers ()

@end

@implementation VWWAutotuneKeysTableViewControllers

- (void)viewDidLoad{
    [super viewDidLoad];
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        self.tableView.backgroundColor = nil;
        self.tableView.backgroundColor = [UIColor darkGrayColor];
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[VWWSynthesizersController sharedInstance] writeSettings];
}


- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];

}



#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 15;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KeyCell"];
    if(indexPath.row == self.synthesizer.keyType){
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        cell.selected = YES;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selected = NO;
    }
    NSString *keyString = [VWWSynthesizerTypes stringFromKey:(VWWAutoTuneType)indexPath.row];
    cell.textLabel.text = keyString;
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}




#pragma mark UITableViewDelegate


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    for(NSUInteger index = 0; index < 15; index++){
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
        if(indexPath.row == index){
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    
    VWWAutoTuneType keyType = (VWWAutoTuneType)indexPath.row;
    NSLog(@"Setting key type: %ld", (long)keyType);
    self.synthesizer.keyType = keyType;
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        cell.backgroundColor = [UIColor clearColor];
    }
}



@end

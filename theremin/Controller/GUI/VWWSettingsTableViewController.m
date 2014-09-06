//
//  VWWSettingsTableViewController.m
//  Synthesizer
//
//  Created by Zakk Hoyt on 2/14/14.
//  Copyright (c) 2014 Zakk Hoyt. All rights reserved.
//

#import "VWWSettingsTableViewController.h"
#import <MediaPlayer/MediaPlayer.h>

@interface VWWSettingsTableViewController ()
@property (weak, nonatomic) IBOutlet UITableViewCell *airPlayTableViewCell;

@end

@implementation VWWSettingsTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ){
        self.tableView.backgroundColor = nil;
        self.tableView.backgroundColor = [UIColor darkGrayColor];
    }
    
    [self addAirPlayVolumeControl];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

- (BOOL)prefersStatusBarHidden {
    return NO	;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)addAirPlayVolumeControl{
//    CGRect frame = CGRectMake(self.airPlayTableViewCell.bounds.size.width - self.airPlayTableViewCell.bounds.size.height,
//                              self.airPlayTableViewCell.bounds.size.height,
//                              self.airPlayTableViewCell.bounds.size.height,
//                              self.airPlayTableViewCell.bounds.size.height);
    CGRect frame = CGRectMake(12,
                              12 + 44,
                              self.airPlayTableViewCell.bounds.size.width - 24,
                              44);

    MPVolumeView *volumeView = [[MPVolumeView alloc] initWithFrame:frame];
    [volumeView setShowsVolumeSlider:YES];
    [self.airPlayTableViewCell addSubview:volumeView];
}


#pragma mark IBActions`



@end

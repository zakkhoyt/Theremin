//
//  VWWSettingsTableViewController.m
//  Synthesizer
//
//  Created by Zakk Hoyt on 2/14/14.
//  Copyright (c) 2014 Zakk Hoyt. All rights reserved.
//

#import "VWWSettingsTableViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import <iAd/iAd.h>

@interface VWWSettingsTableViewController () <ADBannerViewDelegate>
@property (weak, nonatomic) IBOutlet UITableViewCell *airPlayTableViewCell;
@property (weak, nonatomic) IBOutlet ADBannerView *adBannerView;
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
    self.adBannerView.delegate = self;
    self.adBannerView.alpha = 0.0;
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


#pragma mark AdBannerDelegate

- (void)bannerViewDidLoadAd:(ADBannerView *)banner{
    [UIView animateWithDuration:0.3 animations:^{
        self.adBannerView.alpha = 1.0;
    }];
}


@end

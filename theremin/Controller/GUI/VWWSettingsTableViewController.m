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
    
    self.adBannerView.delegate = self;
    self.adBannerView.alpha = 0.0;
    [self addAirPlayVolumeControl];
    self.preferredContentSize = CGSizeMake(320, 1000);

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
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

- (BOOL)prefersStatusBarHidden {
    return NO	;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)addAirPlayVolumeControl{
    CGRect frame = CGRectMake(8,
                              8 + 44,
                              self.view.bounds.size.width - 16,
                              44);

    MPVolumeView *volumeView = [[MPVolumeView alloc] initWithFrame:frame];
    [volumeView setShowsVolumeSlider:YES];
    [self.airPlayTableViewCell addSubview:volumeView];
}


#pragma mark IBActions`


//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell *cell = [super.tableView cellForRowAtIndexPath:indexPath];
//    cell.backgroundColor = [UIColor clearColor];
//    return cell;
//}

#pragma mark AdBannerDelegate

- (void)bannerViewDidLoadAd:(ADBannerView *)banner{
    [UIView animateWithDuration:0.3 animations:^{
        self.adBannerView.alpha = 1.0;
    }];
}


#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        cell.backgroundColor = [UIColor clearColor];
    }
}

@end

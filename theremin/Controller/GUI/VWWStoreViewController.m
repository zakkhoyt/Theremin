//
//  VWWStoreViewController.m
//  theremin
//
//  Created by Zakk Hoyt on 8/23/14.
//  Copyright (c) 2014 Zakk Hoyt. All rights reserved.
//

#import "VWWStoreViewController.h"
#import "VWWStoreTableViewCell.h"
@interface VWWStoreViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *storeItems;
@end

@implementation VWWStoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.storeItems = @[@"Autotune Keys"];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.storeItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
 
    VWWStoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VWWStoreTableViewCell"];
    cell.title = self.storeItems[indexPath.row];
    return cell;
}





#pragma mark UITableViewDelegate


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}

@end

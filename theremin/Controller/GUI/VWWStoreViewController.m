//
//  VWWStoreViewController.m
//  theremin
//
//  Created by Zakk Hoyt on 8/23/14.
//  Copyright (c) 2014 Zakk Hoyt. All rights reserved.
//

#import "VWWStoreViewController.h"
#import "VWWStoreTableViewCell.h"
#import "VWWInAppPurchaseIdentifier.h"
#import "MBProgressHUD.h"

@interface VWWStoreViewController () <VWWStoreTableViewCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *products;
@property (nonatomic, strong) MBProgressHUD *hud;
@end

@implementation VWWStoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        self.tableView.backgroundView = nil;
        self.tableView.backgroundColor = [UIColor darkGrayColor];
    }

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    if(self.hud == nil)[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchased:) name:VWWInAppPurchaseProductPurchasedNotification object:nil];
    
    // Get Apple product IDs
    [[VWWInAppPurchaseIdentifier sharedInstance] requestProductsWithCompletionHandler:^(BOOL success, NSArray *products) {
        self.products = products;
        [self.tableView reloadData];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];

}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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

#pragma mark IBActions
- (IBAction)restoreButtonAction:(id)sender {
    [[[UIAlertView alloc]initWithTitle:@"Restore Purchases?"
                               message:@"This will restore any features that you have previously purchased with your iTunes Store account"
                              delegate:self cancelButtonTitle:@"Not Now"
                     otherButtonTitles:@"Restore", nil]show];
}

#pragma mark Private methods
- (void)productPurchased:(NSNotification *)notification {
    NSString * productIdentifier = notification.object;
    [_products enumerateObjectsUsingBlock:^(SKProduct * product, NSUInteger idx, BOOL *stop) {
        if ([product.productIdentifier isEqualToString:productIdentifier]) {
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:idx inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
            *stop = YES;
        }
    }];
    @synchronized(self){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.hud = nil;
    }
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.products.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
 
    VWWStoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VWWStoreTableViewCell"];
    cell.delegate = self;
    SKProduct *product = self.products[indexPath.row];
    cell.product = product;
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44 * 3;
}


#pragma mark UITableViewDelegate


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        cell.backgroundColor = [UIColor clearColor];
    }
}

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 1){
        if(self.hud == nil)[MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [[VWWInAppPurchase sharedInstance] restoreCompletedTransactions];
    }
}


#pragma mark VWWStoreTableViewCellDelegate
-(void)storeTableViewCellBuyButtonAction:(VWWStoreTableViewCell*)sender{
    if(self.hud == nil)[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    SKProduct *product = self.products[indexPath.row];
    [[VWWInAppPurchaseIdentifier sharedInstance] buyProduct:product];
    
}
-(void)storeTableViewCellVideoButtonAction:(VWWStoreTableViewCell*)sender{
    
}


@end

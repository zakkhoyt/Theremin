//
//  VWWAppDelegate.m
//  Synthesizer
//
//  Created by Zakk Hoyt on 1/9/14.
//  Copyright (c) 2014 Zakk Hoyt. All rights reserved.
//

#import "VWWAppDelegate.h"
#import "UIFont+VWW.h"

@implementation VWWAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

    [self setupDefaults];
    [self setupAppearance];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


-(void)setupDefaults{
    
}

-(void)setupAppearance{
//    [[UINavigationBar appearance] setBarTintColor:[UIColor darkGrayColor]];
//    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor greenColor]}];
//    [[UIToolbar appearance] setBarTintColor:[UIColor darkGrayColor]];r
    
    UIColor *color = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.2];
    [[UINavigationBar appearance] setBarTintColor:color];
    [[UIToolbar appearance] setBarTintColor:color];
    
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor greenColor]}];
    
    
    NSDictionary *attributes = @{NSForegroundColorAttributeName : [UIColor greenColor],
                                 NSFontAttributeName : [UIFont fontForVWWWithSize:18]};
    [[UINavigationBar appearance] setTitleTextAttributes:attributes];
    [[UIBarButtonItem appearance] setTitleTextAttributes:attributes forState:UIControlStateNormal];
    

}

-(void)printFonts{
    VWW_LOG_DEBUG(@"\nListing fonts installed on this device:\n");
    for (NSString* family in [UIFont familyNames])
    {
        NSLog(@"family:\t%@", family);
        
        for (NSString* name in [UIFont fontNamesForFamilyName: family])
        {
            NSLog(@"name:\t\t%@", name);
        }
    }
}


@end

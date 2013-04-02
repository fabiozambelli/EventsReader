//
//  AppDelegate.m
//  EventsReader
//
//  Created by Fabio Zambelli on 03/04/12.
//  Copyright (c) 2012 Fabio Zambelli. All rights reserved.
//


#import "AppDelegate.h"

#import "Reachability.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize dm = _dm;
@synthesize eventManager = _eventManager;
@synthesize eventList = _eventList;
@synthesize internetAvailable = _internetAvailable;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{    
    
    NSLog(@"AppDelegate.didFinishLaunchingWithOptions");
    
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(reachabilityChanged:) name: kReachabilityChangedNotification object: nil];
    
    
    
    // Override point for customization after application launch.
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        UISplitViewController *splitViewController = (UISplitViewController *)self.window.rootViewController;
        UINavigationController *navigationController = [splitViewController.viewControllers lastObject];
        splitViewController.delegate = (id)navigationController.topViewController;
    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    NSLog(@"AppDelegate.applicationWillResignActive");
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    NSLog(@"AppDelegate.applicationDidEnterBackground");
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    NSLog(@"AppDelegate.applicationWillEnterForeground");
    
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    NSLog(@"AppDelegate.applicationDidBecomeActive");
    
    // Observe the kNetworkReachabilityChangedNotification. When that notification is posted, the
    // method "reachabilityChanged" will be called. 
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(reachabilityChanged:) name: kReachabilityChangedNotification object: nil];
    
    //Change the host name here to change the server your monitoring
	//hostReach = [Reachability reachabilityWithHostName: @"www.apple.com"];
	//[hostReach startNotifier];
    //NSLog(@"hostReach:%@",[hostReach connectionRequired]);
    
	
    internetReach = [Reachability reachabilityForInternetConnection] ;
	[internetReach startNotifier];
    NetworkStatus netStatus = [internetReach currentReachabilityStatus];
    
    switch (netStatus)
    {
        case ReachableViaWWAN:
        {
            NSLog(@"ReachableViaWWAN");
            self.internetAvailable = YES;
            break;
        }
        case ReachableViaWiFi:
        {
            NSLog(@"ReachableViaWiFi");
            self.internetAvailable = YES;
            break;
        }
        case NotReachable:
        {
            NSLog(@"NotReachable");
            self.internetAvailable = NO;
            break;
        }
            
    }        
    
    self.dm = [[DownloadManager alloc] init];
    
    [self.dm initDataFeed]; // set default data in cache
    
    if (self.internetAvailable)
        [self.dm downloadDataFeed];
    
    self.eventManager = [[EventManager alloc] init];
    
    self.eventList = [NSMutableArray array];
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    NSLog(@"AppDelegate.applicationWillTerminate");
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}


//Called by Reachability whenever status changes.
- (void) reachabilityChanged: (NSNotification* )note
{
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    switch (netStatus)
    {
        case ReachableViaWWAN:
        {
            NSLog(@"reachabilityChanged:ReachableViaWWAN");
            self.internetAvailable = YES;
            break;
        }
        case ReachableViaWiFi:
        {
            NSLog(@"reachabilityChanged:ReachableViaWiFi");
            self.internetAvailable = YES;
            break;
        }
        case NotReachable:
        {
            NSLog(@"reachabilityChanged:NotReachable");
            self.internetAvailable = NO;
            break;
        }
    }
}

@end

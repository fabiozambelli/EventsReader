//
//  AppDelegate.h
//  EventsReader
//
//  Created by Fabio Zambelli on 03/04/12.
//  Copyright (c) 2012 Fabio Zambelli. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DownloadManager.h"

#import "EventManager.h"

@class Reachability;

@interface AppDelegate : UIResponder <UIApplicationDelegate> {
    Reachability* hostReach;
    Reachability* internetReach;
    Reachability* wifiReach;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) DownloadManager *dm;
@property (strong, nonatomic) NSMutableArray* eventList;
@property (strong, nonatomic) EventManager* eventManager;
@property (nonatomic, assign) BOOL internetAvailable;

@end

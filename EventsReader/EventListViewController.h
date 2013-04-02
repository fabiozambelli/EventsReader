//
//  MasterViewController.h
//  EventsReader
//
//  Created by Fabio Zambelli on 03/04/12.
//  Copyright (c) 2012 Fabio Zambelli. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "EventManager.h"

@class EventDetailViewController;

@interface EventListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    
    NSMutableArray* eventList;
    
    IBOutlet UITableView *tableView;
    
    IBOutlet UIBarButtonItem *filterButton;   
    
    EventManager *em;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;

@property (strong, nonatomic) EventDetailViewController *detailViewController;

@property (strong, nonatomic) NSMutableArray *eventList;

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *filterButton;

@property (strong, nonatomic) EventManager *em;

@end
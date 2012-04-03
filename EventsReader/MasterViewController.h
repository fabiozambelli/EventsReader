//
//  MasterViewController.h
//  EventsReader
//
//  Created by Fabio Zambelli on 03/04/12.
//  Copyright (c) 2012 Fabio Zambelli. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailViewController;

@interface MasterViewController : UITableViewController

@property (strong, nonatomic) DetailViewController *detailViewController;

@end

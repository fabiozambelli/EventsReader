//
//  FilterViewController.h
//  EventsReader
//
//  Created by Fabio Zambelli on 30/04/12.
//  Copyright (c) 2012 Fabio Zambelli. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FilterViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {

    NSMutableDictionary *categories;
    
    IBOutlet UITableView *tableView;
    
    IBOutlet UIBarButtonItem *btnDone;
}

- (void)setCategories:(NSMutableDictionary *)_categories;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *btnDone;

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

//
//  DetailViewController.h
//  EventsReader
//
//  Created by Fabio Zambelli on 03/04/12.
//  Copyright (c) 2012 Fabio Zambelli. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AppDelegate.h"

#import "Event.h"

#import "EventManager.h"

@interface EventDetailViewController : UIViewController {
    
    Event *detailItem;
    
    UILabel *eventTitle;
    
    UIImageView *eventPicture;
    
    UITextView *eventDescription;
    
    UIToolbar *toolBar;
    
    EventManager *em;
}

//-(void)updateImage:(NSNotification *)notification;

@property (strong, nonatomic) Event *detailItem;

@property (strong, nonatomic) IBOutlet UILabel *eventTitle;

@property (strong, nonatomic) IBOutlet UIImageView *eventPicture;

@property (strong, nonatomic) IBOutlet UITextView *eventDescription;

@property (strong, nonatomic) IBOutlet UIToolbar *toolBar;

@property (strong, nonatomic) EventManager *em;

@end
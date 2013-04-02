//
//  MediaGalleryViewController.h
//  EventsReader
//
//  Created by Fabio Zambelli on 16/04/12.
//  Copyright (c) 2012 Fabio Zambelli. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Event.h"
#import "AppDelegate.h"


@interface EventMediaGalleryViewController : UIViewController <UIScrollViewDelegate> {
    
    Event * detailItem;
    
    UIScrollView *scrollView;
    
    UIPageControl *pageControl;
}

@property (weak, nonatomic) Event * detailItem;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;

@end
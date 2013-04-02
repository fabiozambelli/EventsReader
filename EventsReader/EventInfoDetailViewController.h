//
//  InfoDetailViewController.h
//  EventsReader
//
//  Created by Fabio Zambelli on 23/04/12.
//  Copyright (c) 2012 Fabio Zambelli. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <MapKit/MapKit.h>

#import "Event.h"

#define METERS_PER_MILE 1609.344

@interface EventInfoDetailViewController : UIViewController {

    Event * detailItem;
    
    IBOutlet MKMapView *mapView;
    
    IBOutlet UIWebView *webcontent;
}

@property (weak, nonatomic) Event * detailItem;

@property (strong, nonatomic) IBOutlet MKMapView *mapView;

@property (strong, nonatomic) IBOutlet UIWebView *webcontent;

@end

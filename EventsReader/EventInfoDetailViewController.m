//
//  InfoDetailViewController.m
//  EventsReader
//
//  Created by Fabio Zambelli on 23/04/12.
//  Copyright (c) 2012 Fabio Zambelli. All rights reserved.
//

#import "EventInfoDetailViewController.h"

#import "EntityInfo.h"

@implementation EventInfoDetailViewController

@synthesize detailItem = _detailItem;

@synthesize mapView = _mapView;;

@synthesize webcontent = _webcontent;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)setDetailItem:(id)newDetailItem
{
    NSLog(@"setDetailItem");
    
    _detailItem = newDetailItem;
            
}

- (void)viewWillAppear:(BOOL)animated {  

    CLLocationCoordinate2D zoomLocation = _detailItem.info.annotation.coordinate;

    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 0.25*METERS_PER_MILE, 0.25*METERS_PER_MILE);

    MKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:viewRegion];    
    
    [self.mapView addAnnotation:_detailItem.info.annotation];

    [self.mapView setRegion:adjustedRegion animated:YES];   
    
    [self.webcontent loadHTMLString:_detailItem.info.description baseURL:nil];
    
    self.title = @"More informations";
    
}


/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    [super viewDidLoad];
    
    NSLog(@"info:%@",_detailItem.info.website);
    NSLog(@"info:%@",_detailItem.info.lon);
    NSLog(@"info:%@",_detailItem.info.lat);
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
}
*/


- (void)viewDidUnload
{
    [self setMapView:nil];
    [self setWebcontent:nil];
    [self setDetailItem:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end

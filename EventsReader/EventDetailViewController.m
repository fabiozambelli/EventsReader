//
//  DetailViewController.m
//  EventsReader
//
//  Created by Fabio Zambelli on 03/04/12.
//  Copyright (c) 2012 Fabio Zambelli. All rights reserved.
//

#import "EventDetailViewController.h"

#import "EventMediaGalleryViewController.h"

#import "EventInfoDetailViewController.h"

@interface EventDetailViewController ()

- (void)configureView;

@end

@implementation EventDetailViewController

@synthesize detailItem = _detailItem;

@synthesize eventTitle = _eventTitle;

@synthesize eventPicture = _eventPicture;

@synthesize eventDescription = _eventDescription;

@synthesize toolBar = _toolBar;

@synthesize em = _em;

- (void)setDetailItem:(id)newDetailItem
{
    _detailItem = newDetailItem;
    
}

- (void)configureView
{
    // Update the user interface for the detail item.
    
    if (self.detailItem) {
        self.eventTitle.text = self.detailItem.title;
        self.eventDescription.text = self.detailItem.description;
        self.eventPicture.image = [UIImage imageWithContentsOfFile:self.detailItem.picture];
        
    }
    NSLog(@"DetailViewController.configureView");
    
    int counter = 0;
    NSArray *tmpArray = [self.detailItem.mediaGallery allValues];
    NSLog(@"DetailViewController.configureView-tmpArray:%@",tmpArray);
    for (NSString *tmpString in tmpArray)
    {
        if (![@"" isEqualToString:tmpString])
            counter++;
    }
    
    NSLog(@"DetailViewController.configureView-counter:%d",counter);
    if (counter == 0)
    {
        [ [self.toolBar.items  objectAtIndex: 0] setEnabled:(NO) ];
    } else {
        
        [ [self.toolBar.items  objectAtIndex: 0] setEnabled:(YES) ];
    }
    
    if ( (self.detailItem.info.annotation.coordinate.latitude == 0) ||  (self.detailItem.info.annotation.coordinate.longitude == 0)) {
        [ [self.toolBar.items  objectAtIndex: 1] setEnabled:(NO) ];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

/*
 -(void)updatePicture:(NSNotification *)notification{
 NSLog(@"DetailViewController.updatePicture");
 if ([[notification name] isEqualToString:@"entitypicture"])
 NSLog (@"Successfully received the test notification!");
 self.eventPicture.image =  [UIImage imageWithContentsOfFile:self.detailItem.picture];
 }
 */

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"DetailViewController.viewDidLoad");
    
    __weak AppDelegate *sharedApp = [[UIApplication sharedApplication] delegate];
    
    
    self.em = [sharedApp eventManager];        
    
    [self.em prepareEventGallery:self.detailItem];
    
    // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatePicture:) name:@"entitypicture" object:nil];    
    
	// Do any additional setup after loading the view, typically from a nib.
    self.title = @"Event Detail";
    
    [self configureView];
}

- (void)viewDidUnload
{
    NSLog(@"DetailViewController.viewDidUnload");
    [self setEventTitle:nil];
    [self setEventPicture:nil];
    [self setEventDescription:nil];
    [self setToolBar:nil];
    [self setDetailItem:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"DetailViewController.viewWillAppear");
    [super viewWillAppear:animated];
    self.eventPicture.image = [UIImage imageWithContentsOfFile:self.detailItem.picture];
}

- (void)viewDidAppear:(BOOL)animated
{
    NSLog(@"DetailViewController.viewDidAppear");
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    NSLog(@"DetailViewController.viewWillDisappear");
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    NSLog(@"DetailViewController.viewDidDisappear");
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([[segue identifier] isEqualToString:@"toMediaGallery"])
    {
        EventMediaGalleryViewController *mediaGalleryController =segue.destinationViewController;
        
        mediaGalleryController.detailItem = self.detailItem;
    } 
    else if ([[segue identifier] isEqualToString:@"toInfoDetail"])     
    {
        EventInfoDetailViewController *infoDetailViewContrller =segue.destinationViewController;
        
        infoDetailViewContrller.detailItem = self.detailItem; 
    }
}

@end

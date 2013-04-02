//
//  MasterViewController.m
//  EventsReader
//
//  Created by Fabio Zambelli on 03/04/12.
//  Copyright (c) 2012 Fabio Zambelli. All rights reserved.
//

#import "EventListViewController.h"

#import "EventDetailViewController.h"

#import "FilterViewController.h"

#import "Event.h"

#import "EntityManager.h"

#import "AppDelegate.h"

@implementation EventListViewController

@synthesize eventList = _eventList;

@synthesize tableView = _tableView;

@synthesize filterButton = _filterButton;

@synthesize em = _em;

@synthesize detailViewController = _detailViewController;

- (void)awakeFromNib
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        //self.clearsSelectionOnViewWillAppear = NO;
        self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
    }
    [super awakeFromNib];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];  
    __weak AppDelegate *sharedApp = [[UIApplication sharedApplication] delegate];
    
    NSLog(@"MasterViewController.viewDidLoad");
    
    
    self.em = [sharedApp eventManager];
    
    //NSLog(@"appdelagte.eventList:%@",[sharedApp eventList]);
    if ([[sharedApp eventList] count]==0)
    {      
        [self.em  prepareEvents:[sharedApp eventList]];                  
        
    }        
    [self setEventList:[sharedApp eventList]];
    //NSLog(@"eventList:%@",[self eventList]);
    
    
    [self.em printIndexedEvent];
    
	// Do any additional setup after loading the view, typically from a nib.
    self.detailViewController = (EventDetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionMiddle];
    }
    
    self.title = @"Events";
    
}

- (void)viewDidUnload
{
    NSLog(@"MasterViewController.viewDidUnload");
    [self setTableView:nil];
    [self setFilterButton:nil];
    [self setEventList:nil];
    [self setEm:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"MasterViewController.viewWillAppear");
    [super viewWillAppear:animated];
    
    __weak AppDelegate *sharedApp = [[UIApplication sharedApplication] delegate];
    self.em = [sharedApp eventManager];
    
    if ([[sharedApp eventList] count]==0)
    {    
        [self.em  prepareEvents:[sharedApp eventList]];            
    }
    
    [self setEventList:[sharedApp eventList]]; //DA VERIFICARE ESISTE GIA' A LIVELLO DI APPDELEGATE UN OGGETTO EVENTLIST CHE VIENE RICHIAMATO GLOBALMENTE
    
    [self.em  applyFilter:[sharedApp eventList] ];
    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    NSLog(@"MasterViewController.viewDidAppear");
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    NSLog(@"MasterViewController.viewWillDisappear");
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    NSLog(@"MasterViewController.viewDidDisappear");
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.eventList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [self.tableView
                             dequeueReusableCellWithIdentifier:@"assetItem"];
    
    Event *eventItem = [self.eventList objectAtIndex:indexPath.row];
    
    cell.textLabel.text = eventItem.title;
    
    cell.imageView.image = [UIImage imageWithContentsOfFile:eventItem.thumb];
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    __weak AppDelegate *sharedApp = [[UIApplication sharedApplication] delegate];    
    
    if ([[segue identifier] isEqualToString:@"toDetail"])
    {
        NSLog(@"MasterViewController.toDetail");
        
        EventDetailViewController *detailController =segue.destinationViewController;
        
        Event *eventDetail = [[sharedApp eventList]objectAtIndex:self.tableView.indexPathForSelectedRow.row];
        
        detailController.detailItem = eventDetail;    
        
    } else if ([[segue identifier] isEqualToString:@"toFilter"]) {
        
        
        NSLog(@"MasterViewController.toFilter");
        
        FilterViewController *detailController =segue.destinationViewController;                
        
        [detailController setCategories:[sharedApp eventManager].selectedEvents];
        
    }
    
}



@end

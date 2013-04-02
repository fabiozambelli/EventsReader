//
//  MediaGalleryViewController.m
//  EventsReader
//
//  Created by Fabio Zambelli on 16/04/12.
//  Copyright (c) 2012 Fabio Zambelli. All rights reserved.
//

#import "EventMediaGalleryViewController.h"

#import "Constants.h"


@interface EventMediaGalleryViewController()

@property (nonatomic, strong) NSMutableArray *pageImages;

@property (nonatomic, strong) NSMutableArray *pageViews;

- (void)loadVisiblePages;

- (void)loadPage:(NSInteger)page;

- (void)purgePage:(NSInteger)page;

- (void)configureView;

@end

@implementation EventMediaGalleryViewController

@synthesize detailItem = _detailItem;

@synthesize scrollView = _scrollView;

@synthesize pageControl = _pageControl;

@synthesize pageImages = _pageImages;

@synthesize pageViews = _pageViews;


- (void)loadVisiblePages {
    
    NSLog(@"loadVisiblePages");
    
    // First, determine which page is currently visible
    CGFloat pageWidth = self.scrollView.frame.size.width;
    NSInteger page = (NSInteger)floor((self.scrollView.contentOffset.x * 2.0f + pageWidth) / (pageWidth * 2.0f));
    
    // Update the page control
    self.pageControl.currentPage = page;
    
    //NSLog(@"loadVisiblePages.currentPage:%d",page);
    
    // Work out which pages you want to load
    NSInteger firstPage = page - 1;
    NSInteger lastPage = page + 1;
    //NSLog(@"loadVisiblePages.firstPage:%d",firstPage);
    //NSLog(@"loadVisiblePages.lastPage:%d",lastPage);
    
    // Purge anything before the first page
    for (NSInteger i=0; i<firstPage; i++) {
        [self purgePage:i];
    }
    
	// Load pages in our range
    for (NSInteger i=firstPage; i<=lastPage; i++) {
        [self loadPage:i];
    }
    
	// Purge anything after the last page
    for (NSInteger i=lastPage+1; i<self.pageImages.count; i++) {
        [self purgePage:i];
    }
}

- (void)loadPage:(NSInteger)page {
    
    NSLog(@"loadPage:%d",page);
    
    if (page < 0 || page >= self.pageImages.count) {
        // If it's outside the range of what you have to display, then do nothing
        //NSLog(@"loadPage.outside the range");
        return;
    }
    
    UIView *pageView = [self.pageViews objectAtIndex:page];
    if ((NSNull*)pageView == [NSNull null]) {
        
        CGRect frame = self.scrollView.bounds;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0.0f;
        
        UIImageView *newPageView = [[UIImageView alloc] initWithImage:[self.pageImages objectAtIndex:page]];
        newPageView.contentMode = UIViewContentModeScaleAspectFit;
        newPageView.frame = frame;
        //NSLog(@"loadPage:%@",newPageView);
        [self.scrollView addSubview:newPageView];        
        [self.pageViews replaceObjectAtIndex:page withObject:newPageView];
    }
}

- (void)purgePage:(NSInteger)page {
    
    NSLog(@"purgePage:%d",page);
    
    if (page < 0 || page >= self.pageImages.count) {
        //NSLog(@"purgePage.outside the range");
        // If it's outside the range of what you have to display, then do nothing
        return;
    }
    
    // Remove a page from the scroll view and reset the container array
    UIView *pageView = [self.pageViews objectAtIndex:page];
    if ((NSNull*)pageView != [NSNull null]) {
        //NSLog(@"purgePage:%@",pageView);
        [pageView removeFromSuperview];
        [self.pageViews replaceObjectAtIndex:page withObject:[NSNull null]];
    }
}


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


- (void)configureView
{
    NSLog(@"MediaGallery.configureView");
    
    self.title = @"Related Contents";
    
    //NSLog(@"MediaGalleryViewController.viewDidLoad%@",self.detailItem.mediaGallery);
    
    self.pageImages = [[NSMutableArray alloc] init];
    
    for (NSString *key in [self.detailItem.mediaGallery allKeys])
    {
        //NSLog(@"MediaGallery.configureView.key:%@",key);
        NSString *value = [self.detailItem.mediaGallery objectForKey:key];
        //NSLog(@"MediaGallery.configureView.value:%@",value);
        
        if (![@"" isEqualToString:value]) {
            //NSLog(@"exists");
            [self.pageImages addObject:[UIImage imageWithContentsOfFile:value]];
        }
        
    }
    
    
    NSInteger pageCount = self.pageImages.count;
    //NSLog(@"MediaGalleryViewController.pageCount%d",pageCount);
    
    self.pageControl.currentPage = 0;
    
    self.pageControl.numberOfPages = pageCount;
    
    self.pageViews = [[NSMutableArray alloc] init];
    
    for (NSInteger i = 0; i < pageCount; ++i) {
        
        [self.pageViews addObject:[NSNull null]];
        
    }
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    NSLog(@"viewDidLoad");
    
    [super viewDidLoad];
    
    [self configureView];
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    NSLog(@"viewWillAppear");
    
    [super viewWillAppear:animated];
    
    CGSize pagesScrollViewSize = self.scrollView.frame.size;
    
    self.scrollView.contentSize = CGSizeMake(pagesScrollViewSize.width * self.pageImages.count, pagesScrollViewSize.height);
    
    
    [self loadVisiblePages];
    
}


- (void)viewDidUnload
{
    [self setPageImages:nil];
    [self setPageViews:nil];
    [self setScrollView:nil];
    [self setPageControl:nil];
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    NSLog(@"scrollViewDidScroll");
    
    // Load the pages that are now on screen
    [self loadVisiblePages];
}

@end

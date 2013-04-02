//
//  FilterViewController.m
//  EventsReader
//
//  Created by Fabio Zambelli on 30/04/12.
//  Copyright (c) 2012 Fabio Zambelli. All rights reserved.
//

#import "FilterViewController.h"

@implementation FilterViewController

@synthesize tableView = _tableView;

@synthesize btnDone = _btnDone;

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

- (void)setCategories:(NSMutableDictionary *)_categories
{
    categories = _categories;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [categories count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //NSLog(@"FilterViewController.tableView");
    UITableViewCell *cell = [self.tableView
                             dequeueReusableCellWithIdentifier:@"itemCategory"];
    
    NSString *category = [[categories allKeys] objectAtIndex:indexPath.row];
    //NSLog(@"category:%@",category);
    cell.textLabel.text = category;
    
    BOOL checked = [[categories objectForKey:category] boolValue];        
	UIImage *image = (checked) ? [UIImage imageNamed:@"checked.png"] : [UIImage imageNamed:@"unchecked.png"];
	
	UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
	CGRect frame = CGRectMake(0.0, 0.0, image.size.width, image.size.height);
	button.frame = frame;	// match the button's size with the image size
    
	[button setBackgroundImage:image forState:UIControlStateNormal];
	
	// set the button's target to this table view controller so we can interpret touch events and map that to a NSIndexSet
	[button addTarget:self action:@selector(checkButtonTapped:event:) forControlEvents:UIControlEventTouchUpInside];
    
	cell.backgroundColor = [UIColor clearColor];
    
	cell.accessoryView = button;        
    
    return cell;
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        [tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionMiddle];
    }
    self.title = @"Categories";
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"FilterViewController.didSelectRowAtIndexPath");
    
    NSString *category = [[categories allKeys] objectAtIndex:indexPath.row];
    BOOL checked = [[categories objectForKey:category] boolValue];
    
    if (checked) {
        [categories setValue:[NSNumber numberWithBool:NO] forKey:category];
        
    } else {
        [categories setValue:[NSNumber numberWithBool:YES] forKey:category];
    }
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];        
    UIButton *button = (UIButton *)cell.accessoryView;	
    UIImage *newImage = (checked) ? [UIImage imageNamed:@"unchecked.png"] : [UIImage imageNamed:@"checked.png"];    
    [button setBackgroundImage:newImage forState:UIControlStateNormal];
    
    
	[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)checkButtonTapped:(id)sender event:(id)event
{
    NSLog(@"FilterViewController.checkButtonTapped");
	NSSet *touches = [event allTouches];
    
	UITouch *touch = [touches anyObject];
    
	CGPoint currentTouchPosition = [touch locationInView:tableView];
    
	NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint: currentTouchPosition];
	if (indexPath != nil)
	{
        
        /* accessoryButtonTappedForRowWithIndexPath */
        NSString *category = [[categories allKeys] objectAtIndex:indexPath.row];
        BOOL checked = [[categories objectForKey:category] boolValue];
        
        if (checked) {
            [categories setValue:[NSNumber numberWithBool:NO] forKey:category];
            
        } else {
            [categories setValue:[NSNumber numberWithBool:YES] forKey:category];
        }
        
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];        
        UIButton *button = (UIButton *)cell.accessoryView;	
        UIImage *newImage = (checked) ? [UIImage imageNamed:@"unchecked.png"] : [UIImage imageNamed:@"checked.png"];
        
        [button setBackgroundImage:newImage forState:UIControlStateNormal];
        
	}
}

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload
{
    [self setTableView:nil];
    [self setBtnDone:nil];
    [self setCategories:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)btnDone:(id)sender {
    NSLog(@"FilterViewController.btnDone");
    
    [self dismissModalViewControllerAnimated:YES];
}

@end

//
//  EventManager.m
//  EventsReader
//
//  Created by Fabio Zambelli on 18/04/12.
//  Copyright (c) 2012 Fabio Zambelli. All rights reserved.
//

#import "EventManager.h"

#import "Event.h"

#import "DownloadManager.h"

#import "EntityInfo.h"

#import "EntityAnnotation.h"

#import "AppDelegate.h"

#import "Constants.h"

@implementation EventManager

@synthesize indexedEvents = _indexedEvents;

@synthesize selectedEvents = _selectedEvents;

- (id) init
{
    NSLog(@"EventManager init");
    
    if( (self = [super init]) ) {  
        
        self.indexedEvents = [[NSMutableDictionary alloc] init];
        self.selectedEvents = [[NSMutableDictionary alloc] init];
        
    }
    return self;
    
}

- (void) applyFilter: (NSMutableArray *)allEventList
{
    
    NSLog(@"EventManager.applyFilter");
    
    if ([self.selectedEvents count]>0)
        [allEventList removeAllObjects];
    
    //NSMutableArray *allEventList = [NSMutableArray array];
    
    NSArray *allKeys = [self.selectedEvents allKeys];
    
    BOOL selected;
    
    NSMutableDictionary *tmp = [[NSMutableDictionary alloc] init];
    
    for (NSString* key in allKeys) {
        
        selected = [[self.selectedEvents objectForKey:key] boolValue];
        
        if (selected) 
        {
            NSMutableArray *eventsSelected = [self.indexedEvents objectForKey:key];
            
            for (Event *currentEvent in  eventsSelected) 
            {                                
                
                if ([tmp objectForKey:[currentEvent uid]] == nil)
                {
                    [tmp setValue:currentEvent forKey:[currentEvent uid]];
                    [allEventList addObject:currentEvent];
                }
                
            }
        }
    }
    
}


/** effettua il parsing del json eventi. crea un array di eventi. ogni elemnto dell'array contiene un evento. tutte le proprieta dell'evento sono varolizzare ad eccezione della mediagallery. le risorse remote vengono scaricate in modo asincrono **/

- (void) prepareEvents: (NSMutableArray *)allEventList
{
    
    NSLog(@"EventManager.prepareEvents");
    
    NSMutableArray *arrayOfData = [super getEntities:KEY_ENTITY_EVENT];
    
    NSError* error;
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init]; 
    
    [dateFormat setDateFormat:@"dd/MM/yyyy"];
    
    /** una il download manager ( scope application ) e lo configura per gli eventi **/
    __weak AppDelegate *sharedApp = [[UIApplication sharedApplication] delegate];
    __weak DownloadManager *dm = [sharedApp dm];
    [dm setEntityDataPath:CACHE_FOLDER_EVENT];
    
    
    
    for (NSData *data in arrayOfData) 
    {
        
        NSDictionary* json = [NSJSONSerialization 
                              JSONObjectWithData:data                           
                              options:kNilOptions 
                              error:&error];                
        
        NSArray* jsonEvents = [json objectForKey:@"events"];
        
        for (NSDictionary* event in jsonEvents) {
            
            /* mandatory fields */
            
            NSString *uid_ = [event objectForKey:@"uid"];
            
            NSLog(@"uid_: %@", uid_);
            
            NSString *title_ = [event objectForKey:@"title"];
            
            //NSLog(@"title_: %@", title_);
            
            NSDate *date_ = [dateFormat dateFromString:[event objectForKey:@"date"]];
            
            //NSLog(@"date_: %@", date_);
            
            NSString *description_ = [event objectForKey:@"description"];
            
            //NSLog(@"description_: %@", description_);
            
            if ( (uid_!=nil)&&(title_!=nil)&&(date_!=nil)&&(description_!=nil) ) 
            {
                Event *eventItem_ = [[Event alloc] init:uid_ :title_ :date_ :description_];        
                
                /* optional fields */
                
                NSString *urlThumb = [event objectForKey:@"thumb"];
                
                dispatch_async(dispatch_get_global_queue(0, 0), ^{ 
                    __block NSString *resourcePath = [dm cachedDownloadInFolder:[NSURL URLWithString:urlThumb] :uid_];
                    eventItem_.thumb = resourcePath;
                    
                });                
                
                NSString *urlPicture = [event objectForKey:@"picture"];
                
                dispatch_async(dispatch_get_global_queue(0, 0), ^{ 
                    __block NSString *resourcePath = [dm cachedDownloadInFolder:[NSURL URLWithString:urlPicture] :uid_];
                    eventItem_.picture = resourcePath;
                    // [[NSNotificationCenter defaultCenter] postNotificationName: @"entitypicture" object: self];
                    
                });
                
                NSArray *categories_ = (NSArray *)[event objectForKey:@"category"];
                
                for (NSString *category in categories_)  
                {
                    //NSLog(@"category:%@",category);
                    NSMutableArray *array;
                    array = [self.indexedEvents objectForKey:category];
                    if ( array == nil) {
                        array = [[NSMutableArray alloc ] init ];
                    } else {
                        [self.indexedEvents removeObjectForKey:category];
                    }
                    [array addObject:eventItem_];
                    [self.indexedEvents setObject:array forKey:category]; 
                }
                
                eventItem_.categories = categories_;
                
                categories_ = nil;
                
                
                /** default setting. will be replaced with path **/
                NSMutableDictionary *tmpDictionary = [[NSMutableDictionary alloc] init ];
                
                NSArray *tmpArray = [event objectForKey:@"media_gallery"];
                NSLog(@"tmpArray:%@",tmpArray);
                
                for (NSString *tmpString in tmpArray)
                {
                    NSLog(@"tmpString:%@",tmpString);
                    [tmpDictionary setObject:@"" forKey:tmpString];
                    
                }
                eventItem_.mediaGallery = tmpDictionary;
                
                //[self startAsyncDownload:uid_ urlArray:(NSArray *)[event objectForKey:@"media_gallery"] genericItem:eventItem_];
                
                
                EntityInfo *eventInfo = [[EntityInfo alloc] init];                
                
                
                NSArray *arrInfo = [event objectForKey:@"info"];
                
                for (NSDictionary* info in arrInfo) 
                {
                    NSString *description_ = [info objectForKey:@"description"];
                    eventInfo.description = description_;
                    
                    CLLocationCoordinate2D coordinate_;
                    coordinate_.latitude = [[info objectForKey:@"lat"] doubleValue];
                    coordinate_.longitude = [[info objectForKey:@"lon"] doubleValue];
                    
                    eventInfo.annotation = [[EntityAnnotation alloc] initWithCoordinate:title_ coordinate:coordinate_];
                    
                }
                
                eventItem_.info = eventInfo;
                
                eventInfo = nil;                            
                
                [allEventList addObject:(eventItem_)];                        
            }
            
        }
        
    }
    
    for (NSString *k in [self.indexedEvents allKeys]) 
    {
        [self.selectedEvents setObject:[NSNumber numberWithBool:YES] forKey:k];
    }
    
    //return allEventList;
}




- (void) prepareEventGallery: (Event *)eventItem
{
    
    NSLog(@"EventManager.prepareEventGallery");
    
    __weak AppDelegate *sharedApp = [[UIApplication sharedApplication] delegate];
    __weak DownloadManager *dm = [sharedApp dm];
    [dm setEntityDataPath:CACHE_FOLDER_EVENT];
    
    NSArray *tmpArray = [eventItem.mediaGallery allKeys];
    
    for (NSString *tmpString in tmpArray) {
        
        if ([@"" isEqualToString:[eventItem.mediaGallery objectForKey:tmpString]])
            
            dispatch_async(dispatch_get_global_queue(0, 0), ^{ 
                __block NSString *resourcePath = [dm cachedDownloadInFolder:[NSURL URLWithString:tmpString] :[NSString stringWithFormat:@"%@/%@", eventItem.uid, CACHE_FOLDER_GALLERY]] ;
                
                NSLog(@"EventManager.prepareEventGallery - resourcePath%@",resourcePath);
                
                [eventItem.mediaGallery setObject:resourcePath forKey:tmpString];
                
            });
        
    }
}


- (void) printIndexedEvent 
{
    //NSLog(@"IndexedEvent%@",self.indexedEvents);
}

- (void) printSelectedEvent 
{
    //NSLog(@"SelectedEvent%@",self.selectedEvents);
}

@end


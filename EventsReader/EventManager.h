//
//  EventManager.h
//  EventsReader
//
//  Created by Fabio Zambelli on 18/04/12.
//  Copyright (c) 2012 Fabio Zambelli. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "EntityManager.h"

@interface EventManager : EntityManager 

@property (strong) NSMutableDictionary *indexedEvents;

@property (strong) NSMutableDictionary *selectedEvents;

- (void) prepareEvents:(NSMutableArray *)allEventList;

- (void) prepareEventGallery: (Event *)eventItem;

- (void) applyFilter: (NSMutableArray *)allEventList;

- (void) printIndexedEvent;

- (void) printSelectedEvent;

@end

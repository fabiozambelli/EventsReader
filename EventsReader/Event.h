//
//  Event.h
//  EventsReader
//
//  Created by Fabio Zambelli on 03/04/12.
//  Copyright (c) 2012 Fabio Zambelli. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "EntityInfo.h"

@interface Event : NSObject

@property (strong) NSString *uid;
@property (strong) NSString *title;
@property (strong) NSArray *categories;
@property (strong) NSDate *date;
@property (strong) NSString *description;
@property (strong) NSString *picture;
@property (strong) NSString *thumb;
@property (strong) NSMutableDictionary *mediaGallery;
@property (strong) EntityInfo *info;

- (id)init:(NSString*)uid :(NSString*)title :(NSDate*)date :(NSString*)description; 

@end


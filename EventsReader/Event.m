//
//  Event.m
//  EventsReader
//
//  Created by Fabio Zambelli on 03/04/12.
//  Copyright (c) 2012 Fabio Zambelli. All rights reserved.
//

#import "Event.h"

@implementation Event

@synthesize uid = _uid;
@synthesize title = _title;
@synthesize categories = _categories;
@synthesize date = _date;
@synthesize description = _description;
@synthesize picture = _picture;
@synthesize thumb = _thumb;
@synthesize mediaGallery = _mediaGallery;
@synthesize info = _info;

- (id)init:(NSString*)uid :(NSString*)title :(NSDate*)date :(NSString*)description 
{
    if ((self = [super init])) {
        self.uid = uid;
        self.title = title;        
        self.date = date;
        self.description = description;
    }
    return self;
}

@end

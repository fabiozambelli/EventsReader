//
//  EventAnnotation.m
//  EventsReader
//
//  Created by Fabio Zambelli on 23/04/12.
//  Copyright (c) 2012 Fabio Zambelli. All rights reserved.
//

#import "EntityAnnotation.h"

@implementation EntityAnnotation

@synthesize coordinate = _coordinate;

@synthesize label = _label;

- (id)initWithCoordinate:(NSString *)newLabel coordinate:(CLLocationCoordinate2D)coordinate
{
    if ((self = [super init])) {
        self.label = newLabel;
        _coordinate = coordinate;
    }
    return self;
}

- (NSString *)title {
    if ([self.label isKindOfClass:[NSNull class]]) 
        return @"";
    else
        return self.label;
}

- (NSString *)subtitle {
    return @"";
}

@end

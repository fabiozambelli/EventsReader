//
//  EventInfo.h
//  EventsReader
//
//  Created by Fabio Zambelli on 18/04/12.
//  Copyright (c) 2012 Fabio Zambelli. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "EntityAnnotation.h"

@interface EntityInfo : NSObject 

@property (strong) EntityAnnotation *annotation;

@property (strong) NSString *description;

@end

//
//  EntityManager.h
//  EventsReader
//
//  Created by Fabio Zambelli on 18/04/12.
//  Copyright (c) 2012 Fabio Zambelli. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Event.h"

@interface EntityManager : NSObject

- (NSMutableArray *) getEntities:(NSString *)entityName;

@end

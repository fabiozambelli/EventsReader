//
//  Util.m
//  EventsReader
//
//  Created by Fabio Zambelli on 17/04/12.
//  Copyright (c) 2012 Fabio Zambelli. All rights reserved.
//

#import "Util.h"

@implementation Util

+ (NSInteger)parseTime:(NSString *)thetime 
{
    NSInteger _thetime = 0;
    
    NSString *key = [thetime substringWithRange:NSMakeRange(0, 1)];
    //NSLog(@"key: %@", key);
    NSInteger value = [[thetime substringFromIndex:1] doubleValue];
    //NSLog(@"value: %d", value);
    
    // day=86400 
    
    if ([key isEqualToString:@"h"]) 
    {
        _thetime = 3600.0 * value;
    } 
    else if ([key isEqualToString:@"d"]) 
    {
        _thetime = 86400.0 * value;
    }
    else if ([key isEqualToString:@"w"]) 
    {
        _thetime = 86400.0 * 7 * value;
    }
    
   //NSLog(@"_thetime: %d", _thetime);
    
    return _thetime;
}

@end

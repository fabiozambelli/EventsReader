//
//  EntityManager.m
//  EventsReader
//
//  Created by Fabio Zambelli on 18/04/12.
//  Copyright (c) 2012 Fabio Zambelli. All rights reserved.
//

#import "EntityManager.h"

#import "AppDelegate.h"

#import "DownloadManager.h"



#import "Constants.h"

@implementation EntityManager


- (NSMutableArray *) getEntities:(NSString *)entityName
{
    //NSLog(@"EntityManager.getEntity%@",entityName);
    
    NSMutableArray *arrayOfData = [NSMutableArray array];
    
    NSData *data = nil;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *dataPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"entities"];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"entities" ofType:@"plist"];    
    
    if (path) 
    {
        
        NSMutableDictionary *entityDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
        
        NSRange match;
        
        for (NSString *key in entityDictionary)                        
        {
            //NSLog(@"key: %@", key);
            
            //NSLog(@"entityName: %@", entityName);
            
            match = [key rangeOfString: entityName];
            
            if (match.location != NSNotFound)
            {
                
                NSString *value = [entityDictionary objectForKey:key];
                
                NSArray *chunks = [value componentsSeparatedByString: @";"];
                
                NSURL *url = [NSURL URLWithString:[chunks objectAtIndex:0]];
                
                NSString *fileName = [[url path] lastPathComponent];
                
                NSString *filePath = [dataPath stringByAppendingPathComponent:fileName];                                
                
                //NSLog(@"EntityManager.filePath%@",filePath);
                
                data = [NSData dataWithContentsOfFile:filePath];
                
                [arrayOfData addObject:data];
            }
            
        }
        
    }
    
    return arrayOfData;
}

@end


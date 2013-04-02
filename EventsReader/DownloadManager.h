//
//  DownloadManager.h
//  EventsReader
//
//  Created by Fabio Zambelli on 17/04/12.
//  Copyright (c) 2012 Fabio Zambelli. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DownloadManager : NSObject

- (void)downloadDataFeed;

- (void)initDataFeed;

- (id)cachedDownloadInFolder:(NSURL *)url :(NSString *)folderName;

-(void)debugFunction:(NSString *)logString;

@property (nonatomic, copy) NSString *dataPath;

@property (nonatomic, copy) NSString *filePath;

@property (nonatomic, copy) NSString *entityDataPath;

@end

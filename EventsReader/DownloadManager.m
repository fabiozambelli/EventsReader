//
//  DownloadManager.m
//  EventsReader
//
//  Created by Fabio Zambelli on 17/04/12.
//  Copyright (c) 2012 Fabio Zambelli. All rights reserved.
//

#import "DownloadManager.h"

#import "Util.h"

#import "Constants.h"

#import "ZipArchive/ZipArchive.h"

@interface NSObject (PrivateMethods)

- (void) initCache;
- (void) clearCache;
- (id) getFileModificationDate;
- (void) cachedDownload:(NSURL *)theURL :(NSInteger)cacheTime;
- (void) uncachedDownload:(NSURL *)theURL;

@end

@implementation DownloadManager

@synthesize dataPath;

@synthesize filePath;

@synthesize entityDataPath = _entityDataPath;

const double defaultCacheTime = 86400.0;

- (void)setEntityDataPath:(NSString *)folderName
{
    _entityDataPath = [NSString stringWithFormat:@"%@/%@", dataPath, folderName];
    
    /* create a new cache directory */
	if (![[NSFileManager defaultManager] createDirectoryAtPath:_entityDataPath
								   withIntermediateDirectories:NO
													attributes:nil
														 error:nil]) {
	}
    
}

- (void)initDataFeed
{
    NSLog(@"DownloadManager.initDataFeed");
    
    [self initCache];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    
    filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"entities.zip"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath])
    {
        
        NSLog(@"try to restore from backup");
        NSString *backupPath = [[NSBundle mainBundle] pathForResource:@"entities" ofType:@"zip"];
        
        [[NSFileManager defaultManager] moveItemAtPath:backupPath toPath:filePath error:nil];
        
        ZipArchive* za = [[ZipArchive alloc] init];
        
        if( [za UnzipOpenFile:filePath] ) {
            if( [za UnzipFileTo:[paths objectAtIndex:0] overWrite:YES] != NO ) {
                
                
                NSLog(@"backup restored");
            }
            
            [za UnzipCloseFile];
        }
        
    }
    
}

- (void)downloadDataFeed
{
    
    NSLog(@"DownloadManager.downloadDataFeed");
    
    /* read from plist which data have to download */
    NSString *entitiesPath = [[NSBundle mainBundle] pathForResource:PLIST_ENTITIES ofType:@"plist"];
    
    NSMutableDictionary *entityDictionary = nil;
    
    if (entitiesPath)
    {
        entityDictionary = [NSMutableDictionary dictionaryWithContentsOfFile:entitiesPath];
        
        //[[NSMutableDictionary alloc] initWithContentsOfFile:entitiesPath];
    }
    
    /* read from plist which data have to clean */
    NSString *updatesPath = [[NSBundle mainBundle] pathForResource:PLIST_UPDATES ofType:@"plist"];
    
    NSMutableDictionary *updatesDictionary = nil;
    
    if (updatesPath)
    {
        updatesDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:updatesPath];
    }
    
    
    /* force update of cheked items */
    
    if (updatesDictionary != nil)
    {
        
        for (id key in updatesDictionary)
        {
            NSString *value = [updatesDictionary objectForKey:key];
            
            NSURL *theURL = [NSURL URLWithString:value];
            
            NSData *data = nil;
            
            NSError *error = nil;
            
            NSLog(@"downloadDataFeed - do http :%@",theURL);
            
            /* downlaod and read which data have to clean */
            data = [NSData dataWithContentsOfURL:theURL options:NSDataReadingUncached error:&error];
            
            if(error || !data){
                //NSLog(@"errore download json");
                return;
            }
            
            
            NSDictionary* json = [NSJSONSerialization
                                  JSONObjectWithData:data
                                  options:kNilOptions
                                  error:&error];
            
            NSArray* updates = [json objectForKey:@"updates"];
            
            for (NSDictionary* updateItem in updates) {
                
                NSString *key_ = [[updateItem allKeys] objectAtIndex:0];
                
                NSLog(@"key_:%@",key_);
                
                NSString *value_ = [updateItem objectForKey:key_];
                
                NSLog(@"value_:%d",[value_ intValue]);
                
                NSString *dataFeedUrl = [entityDictionary objectForKey:[NSString stringWithFormat:@"%@.%@", key_, key]];
                
                NSArray *chunks = [dataFeedUrl componentsSeparatedByString: @";"];
                
                NSLog(@"value_:%d",[value_ intValue]);
                NSLog(@"chunks:%@",[chunks objectAtIndex:0]);
                NSLog(@"chunks:%@",[chunks objectAtIndex:1]);
                NSLog(@"chunks:%d",[[chunks objectAtIndex:2] intValue]);
                
                
                if ([value_ intValue]>[[chunks objectAtIndex:2] intValue])
                {
                    
                    [self uncachedDownload:[NSURL URLWithString:[chunks objectAtIndex:0]]];
                    
                    //NSLog(@"entityDictionary.value:%@",[NSString stringWithFormat:@"%@;%@;%@", [chunks objectAtIndex:0], [chunks objectAtIndex:1],value_]);
                    //NSLog(@"entityDictionary.key:%@",[NSString stringWithFormat:@"%@.%@", key_, key]);
                    
                    [entityDictionary setValue:[NSString stringWithFormat:@"%@;%@;%@", [chunks objectAtIndex:0], [chunks objectAtIndex:1],value_] forKey:[NSString stringWithFormat:@"%@.%@", key_, key]];
                    
                    [entityDictionary writeToFile:entitiesPath atomically:YES];
                    
                    NSLog(@"entityDictionary updated at %@",entitiesPath);
                    
                }
                
            }
            
            
        }
        
    }
    
    /* update as definied in cache timer */
    
    if (entityDictionary != nil)
    {
        
        for (id key in entityDictionary)
        {
            //NSLog(@"key: %@", key);
            NSString *value = [entityDictionary objectForKey:key];
            //NSLog(@"value: %@", value);
            NSArray *chunks = [value componentsSeparatedByString: @";"];
            
            [ self cachedDownload:[NSURL URLWithString:[chunks objectAtIndex:0]] :[Util parseTime:[chunks objectAtIndex:1]] ];
        }
        
    }
    
}



- (void) initCache
{
	/* create path to cache directory inside the application's Documents directory */
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    self.dataPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:CACHE_FOLDER_ROOT];
    
	/* check for existence of cache directory */
	if ([[NSFileManager defaultManager] fileExistsAtPath:dataPath]) {
		return;
	}
    
	/* create a new cache directory */
	if (![[NSFileManager defaultManager] createDirectoryAtPath:dataPath
								   withIntermediateDirectories:NO
													attributes:nil
														 error:nil]) {
        
        NSLog(@"create a new cache directory%@", dataPath);
        
		return;
	}
}


- (void) clearCache
{
	/* remove the cache directory and its contents */
	if (![[NSFileManager defaultManager] removeItemAtPath:dataPath error:nil]) {
        
		return;
	}
    
	/* create a new cache directory */
	if (![[NSFileManager defaultManager] createDirectoryAtPath:dataPath
								   withIntermediateDirectories:NO
													attributes:nil
														 error:nil]) {
		return;
	}
    
}


- (id) getFileModificationDate
{
    
    NSDate *fileDate;
    
	/* default date if file doesn't exist (not an error) */
	fileDate = [NSDate dateWithTimeIntervalSinceReferenceDate:0];
    
	if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
		/* retrieve file attributes */
		NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
		if (attributes != nil) {
			fileDate = [attributes fileModificationDate];
		}
    }
    
    return fileDate;
}


- (void) uncachedDownload:(NSURL *)theURL {
    
    NSLog(@"DownloadManager.uncachedDownload");
    
    NSData *data = nil;
    
    NSString *fileName = [[theURL path] lastPathComponent];
    
    filePath = [dataPath stringByAppendingPathComponent:fileName];
    
    //NSLog(@"cacheEngine.filePath: %@", filePath);
    
    NSLog(@"uncachedDownload - do http :%@",theURL);
    
    NSError *error;
    data = [NSData dataWithContentsOfURL:theURL options:NSDataReadingUncached error:&error];
    
    if(error || !data){
        //NSLog(@"errore download json");
        return;
    }
    
    [[NSFileManager defaultManager] createFileAtPath:filePath
                                            contents:data
                                          attributes:nil];
}

- (void) cachedDownload:(NSURL *)theURL :(NSInteger)cacheTime
{
    NSLog(@"DownloadManager.cachedDownload");
    
    NSData *data = nil;
    
    NSString *fileName = [[theURL path] lastPathComponent];
    
    filePath = [dataPath stringByAppendingPathComponent:fileName];
    
    //NSLog(@"cacheEngine.filePath: %@", filePath);
    
    NSDate *fileDate = [self getFileModificationDate];
    
    NSTimeInterval time = fabs([fileDate timeIntervalSinceNow]);
    
    if ( (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) || (time > cacheTime) )
    {
        
        // se il json non è in cache ...
        
        NSLog(@"cachedDownload - do http :%@",theURL);
        
        NSError *error;
        data = [NSData dataWithContentsOfURL:theURL options:NSDataReadingUncached error:&error];
        
        if(error || !data){
            //NSLog(@"errore download json");
            return;
        }
        
        [[NSFileManager defaultManager] createFileAtPath:filePath
												contents:data
											  attributes:nil];
    }
}

-(void)debugFunction:(NSString *)logString{
    NSLog(@"log ----------------------- %@",logString);
}

- (id)cachedDownloadInFolder:(NSURL *)url :(NSString *)folderName
{
    
    NSData *data = nil;
    
    [self initCache];
    
    
    NSString *fileName = [[url path] lastPathComponent];
    
    
    NSString *folderPath = [_entityDataPath stringByAppendingPathComponent:folderName];
    
    /* create a new cache directory */
	if (![[NSFileManager defaultManager] createDirectoryAtPath:folderPath
								   withIntermediateDirectories:NO
													attributes:nil
														 error:nil]) {
	}
    
    NSString *filePath__ = [folderPath stringByAppendingPathComponent:fileName];
    
    NSDate *fileDate = [self getFileModificationDate];
    
    NSTimeInterval time = fabs([fileDate timeIntervalSinceNow]);
    
    if ( (![[NSFileManager defaultManager] fileExistsAtPath:filePath__]) || (time > defaultCacheTime) )
    {
        
        // se il json non è in cache ...
        NSError *error;
        
        data = [NSData dataWithContentsOfURL:url options:NSDataReadingUncached error:&error];
        
        if(error || !data){
            return filePath__ = NULL;
        }
        
        
        [[NSFileManager defaultManager] createFileAtPath:filePath__
                                                contents:data
                                              attributes:nil];
        
    }
    
    
    NSLog(@"DownloadManager.cachedDownloadInFolder - thread:[%@,%@]fileName:%@,filePath:%@", folderName, url, fileName, filePath__);
    
    
    return filePath__;
}

@end
//
//  EventAnnotation.h
//  EventsReader
//
//  Created by Fabio Zambelli on 23/04/12.
//  Copyright (c) 2012 Fabio Zambelli. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <MapKit/MapKit.h>

@interface EntityAnnotation : NSObject <MKAnnotation> {
    
    NSString *label;
    
    CLLocationCoordinate2D _coordinate;
}

@property (nonatomic, weak) NSString *label;

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

- (id)initWithCoordinate:(NSString *)newLabel coordinate:(CLLocationCoordinate2D)coordinate;

@end

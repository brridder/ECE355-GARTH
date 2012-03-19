//
//  FloodSensorEvent.m
//  garth
//
//  Created by Pew on 12-03-19.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "FloodSensorEvent.h"

@implementation FloodSensorEvent

@synthesize waterHeight = waterHeight_, delta = delta_;

- (id)initWithDictionary:(NSDictionary *)dict {
    self = [super initWithDictionary:dict];
    if (self) {
        waterHeight_ = [[dict objectForKey:@"water_height"] intValue];
        delta_ = [[dict objectForKey:@"delta"] intValue];
    }
    
    return self;
}

@end

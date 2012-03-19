//
//  TempSensorEvent.m
//  garth
//
//  Created by Pew on 12-03-19.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "TempSensorEvent.h"

@implementation TempSensorEvent

@synthesize temperature = temperature_, delta = delta_;

- (id)initWithDictionary:(NSDictionary *)dict {
    self = [super initWithDictionary:dict];
    if (self) {
        temperature_ = [[dict objectForKey:@"temperature"] intValue];
        delta_ = [[dict objectForKey:@"delta"] intValue];
    }
    return self;
}

@end

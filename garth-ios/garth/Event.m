//
//  Event.m
//  garth
//
//  Created by Pew on 12-03-19.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Event.h"

@implementation Event

@synthesize timestamp = timestamp_, eventType = eventType_;

- (id)init {
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (id)initWithDictionary:(NSDictionary*)dict {    
    self = [super init];
    if (self) {
        eventType_ = [[dict objectForKey:@"event_type"] intValue];
        timestamp_ = [[NSDate dateWithTimeIntervalSince1970:[[dict objectForKey:@"timestamp"] doubleValue]] retain];
    }
    return self;
}

@end

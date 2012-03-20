//
//  Event.m
//  garth
//
//  Created by Pew on 12-03-19.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Event.h"

@implementation Event

@synthesize timestamp = timestamp_, eventType = eventType_, dateString = dateString_;

- (id)initWithDictionary:(NSDictionary*)dict {    
    self = [super init];
    if (self) {
        eventType_ = [[dict objectForKey:@"event_type"] intValue];
        timestamp_ = [[NSDate dateWithTimeIntervalSince1970:[[dict objectForKey:@"timestamp"] doubleValue]] retain];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"hh:mm a dd/mm/yyyy"];
        dateString_ = [[formatter stringFromDate:timestamp_] retain];
    }
    return self;
}

@end

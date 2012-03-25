//
//  MotionSensorEvent.m
//  garth
//
//  Created by Pew on 12-03-19.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "MotionSensorEvent.h"

@implementation MotionSensorEvent

@synthesize threshold = threshold_, startTime = startTime_, endTime = endTime_, duration = duration_;
@synthesize endTimeString = endTimeString_, startTimeString = startTimeString_;

- (id)initWithDictionary:(NSDictionary *)dict {
    self = [super initWithDictionary:dict];
    if (self) {
        threshold_ = [[dict objectForKey:@"current_threshold"] intValue];
        startTime_ = [NSDate dateWithTimeIntervalSince1970:[[dict objectForKey:@"start_time"] intValue]];
        endTime_ = [NSDate dateWithTimeIntervalSince1970:[[dict objectForKey:@"end_time"] intValue]];
        duration_ = [[dict objectForKey:@"duration"] intValue];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"hh:mm a dd/mm/yyyy"];
        startTimeString_ = [formatter stringFromDate:startTime_];
        endTimeString_ = [formatter stringFromDate:endTime_];
    }
    
    return self;
}

@end

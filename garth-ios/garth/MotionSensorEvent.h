//
//  MotionSensorEvent.h
//  garth
//
//  Created by Pew on 12-03-19.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "SensorEvent.h"

@interface MotionSensorEvent : SensorEvent {
    int threshold_;
    NSDate *startTime_;
    NSDate *endTime_;
    NSString *startTimeString_;
    NSString *endTimeString_;
    int duration_;
}

@property (nonatomic) int threshold;
@property (nonatomic, retain) NSDate *startTime;
@property (nonatomic, retain) NSDate *endTime;
@property (nonatomic, readonly) NSString *startTimeString;
@property (nonatomic, readonly) NSString *endTimeString;
@property (nonatomic) int duration;

@end

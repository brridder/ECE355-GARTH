//
//  Event.h
//  garth
//
//  Created by Pew on 12-03-19.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EventFactory.h"
typedef enum {
    EventTypeDoorSensorEvent = 1,
    EventTypeWindowSensorEvent = 2,
    EventTypeFloodSensorEvent = 3,
    EventTypeTempSensorEvent = 4,
    EventTypeAlarmEvent = 5,
    EventTypeKeyPadEvent = 6,
    EventTypeNFCEvent = 7,
    EventTypeMotionSensorEvent = 8
} EventType;

@interface Event : NSObject {
    NSDate *timestamp_;
    EventType eventType_;
}

@property (nonatomic, readonly) NSDate *timestamp;
@property (nonatomic)  EventType eventType;

- (id)initWithDictionary:(NSDictionary*)dict;
@end

//
//  EventFactory.h
//  garth
//
//  Created by Pew on 12-03-19.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

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

@interface EventFactory : NSObject

+ (id)createEventFromDictionary:(NSDictionary*)dict;

@end

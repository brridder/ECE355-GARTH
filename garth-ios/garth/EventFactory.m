//
//  EventFactory.m
//  garth
//
//  Created by Pew on 12-03-19.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "EventFactory.h"

#import "SensorEvent.h"
#import "DoorSensorEvent.h"
#import "TempSensorEvent.h"
#import "FloodSensorEvent.h"
#import "WindowSensorEvent.h"
#import "MotionSensorEvent.h"
#import "AlarmEvent.h"
#import "KeypadEvent.h"

@implementation EventFactory

+ (Event*)createEventFromDictionary:(NSDictionary*)dict {
    Event *e = nil;
    NSLog(@"%@", dict);
    EventType type = [[dict objectForKey:@"event_type"] intValue];
    
    NSLog(@"type: %d", type);
    switch (type) {
        case EventTypeDoorSensorEvent: {
            e = [[DoorSensorEvent alloc] initWithDictionary:dict];
            NSLog(@"%@", [(DoorSensorEvent*)e isOpened]);
            break;
        }
        case EventTypeWindowSensorEvent: {
            e = [[WindowSensorEvent alloc] initWithDictionary:dict];
            break;
        }
        case EventTypeTempSensorEvent: {
            e = [[TempSensorEvent alloc] initWithDictionary:dict];
            break;
        }
        case EventTypeFloodSensorEvent: {
            e = [[FloodSensorEvent alloc] initWithDictionary:dict];
            break;
        }
        case EventTypeMotionSensorEvent: {
            e = [[MotionSensorEvent alloc] initWithDictionary:dict];
            break;
        }
        case EventTypeAlarmEvent: {
            e = [[AlarmEvent alloc] initWithDictionary:dict];
            break;
        }
        case EventTypeKeyPadEvent: {
            e = [[KeypadEvent alloc] initWithDictionary:dict];
            break;
        }
        default:
            NSLog(@"DEAULTS, %@ ", type);
            break;
    }

    return e;
}

@end

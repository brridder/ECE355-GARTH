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


@implementation EventFactory

+ (Event*)createEventFromDictionary:(NSDictionary*)dict {
    Event *e = nil;
    NSLog(@"%@", dict);
    int type = [[dict objectForKey:@"event_type"] intValue];
    
    NSLog(@"type: %d", type);
    switch (type) {
        case EventTypeDoorSensorEvent: {
            e = [[DoorSensorEvent alloc] initWithDictionary:dict];
            NSLog(@"%@", [(DoorSensorEvent*)e isOpened]);
            break;
        }
        case EventTypeWindowSensorEvent: {
            break;
        }
        case EventTypeTempSensorEvent: {
            break;
        }
        case EventTypeFloodSensorEvent: {
            break;
        }
        case EventTypeMotionSensorEvent: {
            break;
        }
        case EventTypeAlarmEvent: {
            break;
        }
        case EventTypeKeyPadEvent: {
            break;
        }
        default:
            NSLog(@"DEAULTS, %@ ", type);
            break;
    }

    return e;
}

@end

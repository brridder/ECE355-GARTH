//
//  DoorSensorEvent.h
//  garth
//
//  Created by Pew on 12-03-19.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "SensorEvent.h"

@interface DoorSensorEvent : SensorEvent {
    int doorId_;
    BOOL isOpened_;
}

@property (nonatomic) int doorId;
@property (nonatomic) BOOL isOpened;

@end

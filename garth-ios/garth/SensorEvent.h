//
//  SensorEvent.h
//  garth
//
//  Created by Pew on 12-03-19.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Event.h"

@interface SensorEvent : Event {
    int sensorId_;
}

@property (nonatomic) int sensorId;

@end

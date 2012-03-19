//
//  FloodSensorEvent.h
//  garth
//
//  Created by Pew on 12-03-19.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "SensorEvent.h"

@interface FloodSensorEvent : SensorEvent {
    int waterHeight_;
    int delta_;
}

@property (nonatomic) int waterHeight;
@property (nonatomic) int delta;


@end

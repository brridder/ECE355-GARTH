//
//  TempSensorEvent.h
//  garth
//
//  Created by Pew on 12-03-19.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "SensorEvent.h"

@interface TempSensorEvent : SensorEvent {
    int temperature_;
    int delta_;
}

@property (nonatomic) int temperature;
@property (nonatomic) int delta;

@end

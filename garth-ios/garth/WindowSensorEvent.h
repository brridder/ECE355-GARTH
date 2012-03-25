//
//  WindowSensorEvent.h
//  garth
//
//  Created by Pew on 12-03-19.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "SensorEvent.h"

@interface WindowSensorEvent : SensorEvent {
    int windowId_;
    BOOL isOpened_;
}

@property (nonatomic) int windowId;
@property (nonatomic) BOOL isOpened;


@end

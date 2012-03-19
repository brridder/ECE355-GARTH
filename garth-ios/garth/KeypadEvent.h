//
//  KeypadEvent.h
//  garth
//
//  Created by Pew on 12-03-19.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Event.h"

@interface KeypadEvent : Event {
    int inputDeviceID_;
    NSString *inputChar_;
}

@property (nonatomic) int inputDeviceID;
@property (nonatomic, retain) NSString *inputChar;


@end

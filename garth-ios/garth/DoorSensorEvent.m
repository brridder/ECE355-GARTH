//
//  DoorSensorEvent.m
//  garth
//
//  Created by Pew on 12-03-19.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "DoorSensorEvent.h"

@implementation DoorSensorEvent


@synthesize doorId = doorId_, isOpened = isOpened_;

- (id)initWithDictionary:(NSDictionary *)dict {
    self = [super initWithDictionary:dict];
    if (self) {
        doorId_ = (int)[dict objectForKey:@"door_id"];
        isOpened_ = (int)[dict objectForKey:@"opened"] == 1;
    }
    return self;
}

@end

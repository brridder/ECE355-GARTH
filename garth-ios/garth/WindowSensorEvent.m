//
//  WindowSensorEvent.m
//  garth
//
//  Created by Pew on 12-03-19.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "WindowSensorEvent.h"

@implementation WindowSensorEvent

@synthesize windowId = windowId_, isOpened = isOpened_;

- (id)initWithDictionary:(NSDictionary *)dict {
    self = [super initWithDictionary:dict];
    if (self) {
        windowId_ = (int)[dict objectForKey:@"window_id"];
        isOpened_ = (int)[dict objectForKey:@"opened"] == 1;
    }
    return self;
}

@end

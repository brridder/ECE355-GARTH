//
//  KeypadEvent.m
//  garth
//
//  Created by Pew on 12-03-19.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "KeypadEvent.h"

@implementation KeypadEvent

@synthesize inputDeviceID = inputDeviceID_, inputChar = inputChar_;

- (id)initWithDictionary:(NSDictionary *)dict {
    self = [super initWithDictionary:dict];
    if (self) {
        inputDeviceID_ = [[dict objectForKey:@"input_device_id"] intValue];
        inputChar_ = [NSString stringWithString:[dict objectForKey:@"input_char"]];
    }
    
    return self;
}

@end

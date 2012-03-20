//
//  AlarmEvent.m
//  garth
//
//  Created by Pew on 12-03-19.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "AlarmEvent.h"

@implementation AlarmEvent

@synthesize severity = severity_, alarmDescription = alarmDescription_, speechMessage = speechMessage_;

- (id)initWithDictionary:(NSDictionary *)dict {
    self = [super initWithDictionary:dict];
    if (self) {
        severity_ = [[dict objectForKey:@"severity"] intValue];
        alarmDescription_ = [[NSString stringWithFormat:@"%@",[dict objectForKey:@"description"]] retain];
        speechMessage_ = [[NSString stringWithString:[dict objectForKey:@"speech_message"]] retain];
    }    
    return self;
}

- (void)dealloc {
    [super dealloc];
    [alarmDescription_ release];
    [speechMessage_ release];
}

@end

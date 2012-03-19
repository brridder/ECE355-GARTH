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
        alarmDescription_ = [NSString stringWithString:[dict objectForKey:@"description"]];
        speechMessage_ = [NSString stringWithString:[dict objectForKey:@"speech_message"]];
    }    
    return self;
}

- (NSString*)description {
    return [NSString stringWithFormat:@"AlarmEvent : %d, %@, %@", severity_, alarmDescription_, speechMessage_];
}

@end

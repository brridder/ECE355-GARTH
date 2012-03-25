//
//  AlarmEvent.h
//  garth
//
//  Created by Pew on 12-03-19.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Event.h"

enum AlarmSeverity {
    AlarmSeverityCriticalAlarm = 1,
    AlarmSeverityMajorAlarm = 2,
    AlarmSeverityMinorAlarm = 3
};

@interface AlarmEvent : Event {
    enum AlarmSeverity severity_;
    NSString *alarmDescription_;
    NSString *speechMessage_;
}

@property (nonatomic) enum AlarmSeverity severity;
@property (nonatomic, retain) NSString *alarmDescription;
@property (nonatomic, retain) NSString *speechMessage;

@end

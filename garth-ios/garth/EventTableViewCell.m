//
//  EventTableViewCell.m
//  garth
//
//  Created by Pew on 12-03-19.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "EventTableViewCell.h"
#import "garthAppDelegate.h"
#import "DoorSensorEvent.h"
#import "WindowSensorEvent.h"
#import "TempSensorEvent.h"
#import "FloodSensorEvent.h"
#import "MotionSensorEvent.h"
#import "AlarmEvent.h"
#import "KeypadEvent.h"

@implementation EventTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        timestamp_ = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
        timestamp_.font = [UIFont systemFontOfSize:12.0f];
        timestamp_.lineBreakMode = UILineBreakModeWordWrap;
        [self addSubview:timestamp_];
        
        
        deviceID_ = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
        deviceID_.font = [UIFont systemFontOfSize:14.0f];
        deviceID_.lineBreakMode = UILineBreakModeWordWrap;
        [self addSubview:deviceID_];
        
        state_ = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        state_.font = [UIFont systemFontOfSize:16.0f];
        state_.lineBreakMode = UILineBreakModeWordWrap;
        [self addSubview:state_];
        
        delta_ = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        delta_.font = [UIFont systemFontOfSize:16.0f];
        delta_.lineBreakMode = UILineBreakModeWordWrap;
        [self addSubview:delta_];
        
        eventType_ = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        eventType_.font = [UIFont systemFontOfSize:16.0f];
        eventType_.lineBreakMode = UILineBreakModeWordWrap;
        [self addSubview:eventType_];
        
        formatter_ = [[NSDateFormatter alloc] init];
        [formatter_ setDateFormat:@"hh:mm a dd/mm/yyyy"];
    }
    return self;
}

- (void)setEvent:(Event*)event {
    if (event_) {
        [event release];
        event = nil;
    }
    event_ = [event retain];
    
    NSString *timestring = [self formatDate:[event timestamp]];
    if (![timestring isEqualToString:@""]) {
        timestamp_.text = timestring;
    }
    switch (event.eventType) {
        case EventTypeDoorSensorEvent:
            deviceID_.text = [NSString stringWithFormat:@"%@ %@",[(DoorSensorEvent*)event sensorId], [(DoorSensorEvent*)event doorId]];
            state_.text = [(DoorSensorEvent*)event isOpened] ? @"Opened" : @"Closed";
            delta_.text = @"";
            eventType_.text = @"Door Event";
            break;
        case EventTypeWindowSensorEvent:
            deviceID_.text = [NSString stringWithFormat:@"%@ %@",[(WindowSensorEvent*)event sensorId], [(WindowSensorEvent*)event windowId]];
            state_.text = [(WindowSensorEvent*)event isOpened] ? @"Opened" : @"Closed";
            delta_.text = @"";
            eventType_.text = @"Window Event";
            break;
        case EventTypeTempSensorEvent:
            deviceID_.text = [NSString stringWithFormat:@"%@",[(TempSensorEvent*)event sensorId]];
            state_.text = [NSString stringWithFormat:@"Temperature: %@°",[(TempSensorEvent *)event temperature]];
            delta_.text = [NSString stringWithFormat:@"Temperature Delta: %@°",[(TempSensorEvent *)event delta]];
            eventType_.text = @"Temperature Event";
            break;
        case EventTypeFloodSensorEvent:
            deviceID_.text = [NSString stringWithFormat:@"%@",[(FloodSensorEvent*)event sensorId]];
            state_.text = [NSString stringWithFormat:@"Water Height: %@",[(FloodSensorEvent *)event waterHeight]];
            delta_.text = [NSString stringWithFormat:@"Height Delta: %@",[(FloodSensorEvent *)event delta]];
            eventType_.text = @"Flood Event";            
            break;
        case EventTypeMotionSensorEvent:
            deviceID_.text = [NSString stringWithFormat:@"%@",[(MotionSensorEvent*)event sensorId]];
            state_.text = [NSString stringWithFormat:@"Start Time: %@",[self formatDate:[(MotionSensorEvent *)event startTime]]];
            delta_.text = [NSString stringWithFormat:@"End Time: %@",[self formatDate:[(MotionSensorEvent *)event endTime]]];
            eventType_.text = @"Motion Sensor Event";                        
            break;
        case EventTypeKeyPadEvent:
            break;
        default:
            break;
    }

    [self setupFrames];
}


- (NSString *)formatDate:(NSDate*)date {
    return [formatter_ stringFromDate:date];
}


- (void)setupFrames {
    CGSize frameSize = self.frame.size;
    CGSize size = [timestamp_.text sizeWithFont:timestamp_.font constrainedToSize:frameSize lineBreakMode:UILineBreakModeWordWrap];
    timestamp_.frame = CGRectMake(10, 10, size.width, size.height);
    
    size = [deviceID_.text sizeWithFont:deviceID_.font constrainedToSize:frameSize lineBreakMode:UILineBreakModeWordWrap];
    deviceID_.frame = CGRectMake(timestamp_.frame.origin.x + timestamp_.frame.size.width + 10, 10, size.width, size.height);
    
    size = [state_.text sizeWithFont:state_.font constrainedToSize:frameSize lineBreakMode:UILineBreakModeWordWrap];
    state_.frame = CGRectMake(10, deviceID_.frame.origin.y + deviceID_.frame.size.height, size.width, size.height);
    
    size = [delta_.text sizeWithFont:delta_.font constrainedToSize:frameSize lineBreakMode:UILineBreakModeWordWrap];
    delta_.frame = CGRectMake(10 + state_.frame.origin.x + state_.frame.size.width, state_.frame.origin.y, size.width, size.height);
    
    size = [eventType_.text sizeWithFont:eventType_.font constrainedToSize:frameSize lineBreakMode:UILineBreakModeWordWrap];
    eventType_.frame = CGRectMake(10, delta_.frame.origin.y + delta_.frame.size.height, size.width, size.height);
}

- (void)dealloc {
    [super dealloc];
    [timestamp_ release];
    [deviceID_ release];
    [state_ release];
    [delta_ release];
    [eventType_ release];
    [event_ release];
}

@end

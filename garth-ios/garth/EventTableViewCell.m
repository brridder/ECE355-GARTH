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
        
        containerView_ = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 66.0f)];
        containerView_.backgroundColor = [UIColor colorWithRed:0.0f green:1.0f blue:0.0f alpha:0.15f];
        
        
        timestamp_ = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
        timestamp_.font = [UIFont systemFontOfSize:12.0f];
        timestamp_.lineBreakMode = UILineBreakModeWordWrap;
        timestamp_.backgroundColor = [UIColor clearColor];
        [containerView_ addSubview:timestamp_];
        
        
        deviceID_ = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
        deviceID_.font = [UIFont systemFontOfSize:12.0f];
        deviceID_.lineBreakMode = UILineBreakModeWordWrap;
        deviceID_.backgroundColor = [UIColor clearColor];
        [containerView_ addSubview:deviceID_];
        
        state_ = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        state_.font = [UIFont systemFontOfSize:14.0f];
        state_.lineBreakMode = UILineBreakModeWordWrap;
        state_.backgroundColor = [UIColor clearColor];
        [containerView_ addSubview:state_];
        
        delta_ = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        delta_.font = [UIFont systemFontOfSize:14.0f];
        delta_.lineBreakMode = UILineBreakModeWordWrap;
        delta_.backgroundColor = [UIColor clearColor];
        [containerView_ addSubview:delta_];
        
        eventType_ = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        eventType_.font = [UIFont systemFontOfSize:14.0f];
        eventType_.lineBreakMode = UILineBreakModeWordWrap;
        eventType_.backgroundColor = [UIColor clearColor];
        [containerView_ addSubview:eventType_];
        
        [self addSubview:containerView_];
    }
    return self;
}

- (void)setEvent:(Event*)event {
    [event_ autorelease];
    event_ = [event retain];
    
    timestamp_.text = [event_ dateString];
    
    switch (event.eventType) {
        case EventTypeDoorSensorEvent:
            deviceID_.text = [NSString stringWithFormat:@"Sensor ID: %@ Door ID: %@",[(DoorSensorEvent*)event sensorId], [(DoorSensorEvent*)event doorId]];
            state_.text = [(DoorSensorEvent*)event isOpened] ? @"Opened" : @"Closed";
            delta_.text = @"";
            eventType_.text = @"Door Event";
            break;
        case EventTypeWindowSensorEvent:
            deviceID_.text = [NSString stringWithFormat:@"Sensor ID: %@ Window ID: %@",[(WindowSensorEvent*)event sensorId], [(WindowSensorEvent*)event windowId]];
            state_.text = [(WindowSensorEvent*)event isOpened] ? @"Opened" : @"Closed";
            delta_.text = @"";
            eventType_.text = @"Window Event";
            break;
        case EventTypeTempSensorEvent:
            deviceID_.text = [NSString stringWithFormat:@"Sensor ID: %@",[(TempSensorEvent*)event sensorId]];
            NSLog(@"%d", [(TempSensorEvent *)event temperature]);
            state_.text = [NSString stringWithFormat:@"Temperature: %d°",[(TempSensorEvent *)event temperature]];
            delta_.text = [NSString stringWithFormat:@"Temperature Delta: %d°",[(TempSensorEvent *)event delta]];
            eventType_.text = @"Temperature Event";
            break;
        case EventTypeFloodSensorEvent:
            deviceID_.text = [NSString stringWithFormat:@"Sensor ID: %@",[(FloodSensorEvent*)event sensorId]];
            state_.text = [NSString stringWithFormat:@"Water Height: %d",[(FloodSensorEvent *)event waterHeight]];
            delta_.text = [NSString stringWithFormat:@"Height Delta: %d",[(FloodSensorEvent *)event delta]];
            eventType_.text = @"Flood Event";            
            break;
        case EventTypeMotionSensorEvent:
            deviceID_.text = [NSString stringWithFormat:@"Sensor ID: %@",[(MotionSensorEvent*)event sensorId]];
            state_.text = [NSString stringWithFormat:@"Start Time: %@",[(MotionSensorEvent *)event startTimeString]];
            delta_.text = [NSString stringWithFormat:@"End Time: %@",[(MotionSensorEvent *)event endTimeString]];
            eventType_.text = @"Motion Sensor Event";                        
            break;
        case EventTypeKeyPadEvent:
            break;
        default:
            break;
    }

    [self setupFrames];
}

- (void)setupFrames {
    CGSize frameSize = self.frame.size;
    CGSize size = [timestamp_.text sizeWithFont:timestamp_.font constrainedToSize:frameSize lineBreakMode:UILineBreakModeWordWrap];
    timestamp_.frame = CGRectMake(10, 5, size.width, size.height);
    
    size = [deviceID_.text sizeWithFont:deviceID_.font constrainedToSize:frameSize lineBreakMode:UILineBreakModeWordWrap];
    deviceID_.frame = CGRectMake(self.frame.size.width - size.width - 10, 5, size.width, size.height);
    
    size = [eventType_.text sizeWithFont:eventType_.font constrainedToSize:frameSize lineBreakMode:UILineBreakModeWordWrap];
    eventType_.frame = CGRectMake(10, deviceID_.frame.origin.y + deviceID_.frame.size.height, size.width, size.height);
    
    size = [state_.text sizeWithFont:state_.font constrainedToSize:frameSize lineBreakMode:UILineBreakModeWordWrap];
    state_.frame = CGRectMake(10, eventType_.frame.origin.y + eventType_.frame.size.height, size.width, size.height);    
    
    size = [delta_.text sizeWithFont:delta_.font constrainedToSize:frameSize lineBreakMode:UILineBreakModeWordWrap];
    delta_.frame = CGRectMake(10 + state_.frame.origin.x + state_.frame.size.width, state_.frame.origin.y, size.width, size.height);
}

- (void)dealloc {
    [super dealloc];
    [timestamp_ release];
    [deviceID_ release];
    [state_ release];
    [delta_ release];
    [eventType_ release];
    [event_ release];
    [containerView_ release];
}

@end

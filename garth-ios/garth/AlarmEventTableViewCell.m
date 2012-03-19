//
//  AlarmEventTableViewCell.m
//  garth
//
//  Created by Pew on 12-03-19.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "AlarmEventTableViewCell.h"

@implementation AlarmEventTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        timestampLabel_ = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        timestampLabel_.font = [UIFont systemFontOfSize:12.0f];
        [self addSubview:timestampLabel_];
        
        severityLabel_ = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        severityLabel_.font = [UIFont systemFontOfSize:16.0f];
        [self addSubview:severityLabel_];
        
        descriptionLabel_ = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        descriptionLabel_.font = [UIFont systemFontOfSize:16.0f];
        [self addSubview:descriptionLabel_];
        
        speechMessageLabel_ = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        speechMessageLabel_.font = [UIFont systemFontOfSize:16.0f];
        [self addSubview:speechMessageLabel_];
        
        formatter_ = [[NSDateFormatter alloc] init];
        [formatter_ setDateFormat:@"hh:mm a dd/mm/yyyy"];
    }
    return self;
}

- (void)setAlarmEvent:(AlarmEvent*)event {
    if (event_) {
        [event_ release];
        event_ = nil;
    }
    event_ = [event retain];
    
    timestampLabel_.text = [self formatDate:[event_ timestamp]];
    if ([event_ severity] == AlarmSeverityCriticalAlarm) {
        severityLabel_.text = @"CRITICAL";
    } else if ([event_ severity] == AlarmSeverityMajorAlarm) {
        severityLabel_.text = @"MAJOR";
    } else {
        severityLabel_.text = @"MINOR";
    }
    
    descriptionLabel_.text = [event_ description];
    speechMessageLabel_.text = [event_ speechMessage];
    [self setupFrames];
}


- (void)setupFrames {
    CGSize frameSize = self.frame.size;
    CGSize size = [timestampLabel_.text sizeWithFont:timestampLabel_.font constrainedToSize:frameSize lineBreakMode:UILineBreakModeWordWrap];
    timestampLabel_.frame = CGRectMake(10, 10, size.width, size.height);
    
    size = [severityLabel_.text sizeWithFont:severityLabel_.font constrainedToSize:frameSize lineBreakMode:UILineBreakModeWordWrap];
    severityLabel_.frame = CGRectMake(10, timestampLabel_.frame.origin.y + timestampLabel_.frame.size.height, size.width, size.height);
    
    size = [descriptionLabel_.text sizeWithFont:descriptionLabel_.font constrainedToSize:frameSize lineBreakMode:UILineBreakModeWordWrap];
    descriptionLabel_.frame = CGRectMake(10, severityLabel_.frame.origin.y + severityLabel_.frame.size.height, size.width, size.height);
    
    size = [speechMessageLabel_.text sizeWithFont:speechMessageLabel_.font constrainedToSize:frameSize lineBreakMode:UILineBreakModeWordWrap];
    speechMessageLabel_.frame = CGRectMake(10, descriptionLabel_.frame.origin.y + descriptionLabel_.frame.size.height, size.width, size.height);
    
}

- (NSString*)formatDate:(NSDate*)date {
    return [formatter_ stringFromDate:date];
}

- (void)dealloc {
    [super dealloc];
    [severityLabel_ release];
    [descriptionLabel_ release];
    [speechMessageLabel_ release];
}

@end

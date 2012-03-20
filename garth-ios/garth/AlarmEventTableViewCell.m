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
        containerView_ = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 66.0f)];
        
        containerView_.backgroundColor = [UIColor colorWithRed:1.0f green:0.0f blue:0.0f alpha:0.5f];
            
        timestampLabel_ = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        timestampLabel_.font = [UIFont systemFontOfSize:12.0f];
        timestampLabel_.backgroundColor = [UIColor clearColor];
        [containerView_ addSubview:timestampLabel_];
        
        
        severityLabel_ = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        severityLabel_.font = [UIFont systemFontOfSize:16.0f];
        severityLabel_.backgroundColor = [UIColor clearColor];
        [containerView_ addSubview:severityLabel_];
        
        descriptionLabel_ = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        descriptionLabel_.font = [UIFont systemFontOfSize:14.0f];
        descriptionLabel_.backgroundColor = [UIColor clearColor];
        [containerView_ addSubview:descriptionLabel_];
        
        speechMessageLabel_ = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        speechMessageLabel_.font = [UIFont systemFontOfSize:14.0f];
        speechMessageLabel_.backgroundColor = [UIColor clearColor];
        [containerView_ addSubview:speechMessageLabel_];
                
        [self addSubview:containerView_];
    }
    return self;
}

- (void)setAlarmEvent:(AlarmEvent*)event {
    if (event_) {
        [event_ release];
        event_ = nil;
    }
    event_ = [event retain];
    
    timestampLabel_.text = [event_ dateString];
    
    if ([event_ severity] == AlarmSeverityCriticalAlarm) {
        severityLabel_.text = @"CRITICAL ALARM";
    } else if ([event_ severity] == AlarmSeverityMajorAlarm) {
        severityLabel_.text = @"MAJOR ALARM";
    } else {
        severityLabel_.text = @"MINOR ALARM";
    }
    
    descriptionLabel_.text = [event_ alarmDescription];
    speechMessageLabel_.text = [event_ speechMessage];
    [self setupFrames];
}


- (void)setupFrames {

    CGSize frameSize = self.frame.size;
    CGSize size = [timestampLabel_.text sizeWithFont:timestampLabel_.font constrainedToSize:frameSize lineBreakMode:UILineBreakModeWordWrap];
    timestampLabel_.frame = CGRectMake(10, 5, size.width, size.height);
    
    size = [severityLabel_.text sizeWithFont:severityLabel_.font constrainedToSize:frameSize lineBreakMode:UILineBreakModeWordWrap];
    severityLabel_.frame = CGRectMake(10, timestampLabel_.frame.origin.y + timestampLabel_.frame.size.height, size.width, size.height);
    
    size = [descriptionLabel_.text sizeWithFont:descriptionLabel_.font constrainedToSize:frameSize lineBreakMode:UILineBreakModeWordWrap];
    descriptionLabel_.frame = CGRectMake(10, severityLabel_.frame.origin.y + severityLabel_.frame.size.height, size.width, size.height);
    
    size = [speechMessageLabel_.text sizeWithFont:speechMessageLabel_.font constrainedToSize:frameSize lineBreakMode:UILineBreakModeWordWrap];
    speechMessageLabel_.frame = CGRectMake(descriptionLabel_.frame.origin.x + descriptionLabel_.frame.size.width + 5, descriptionLabel_.frame.origin.y, size.width, size.height);
    
}


- (void)dealloc {
    [super dealloc];
    [severityLabel_ release];
    [descriptionLabel_ release];
    [speechMessageLabel_ release];
}

@end

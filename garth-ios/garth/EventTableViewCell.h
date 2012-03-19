//
//  EventTableViewCell.h
//  garth
//
//  Created by Pew on 12-03-19.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Event.h"

@interface EventTableViewCell : UITableViewCell {
    Event *event_;
    
    UILabel *timestamp_;
    UILabel *deviceID_;
    UILabel *state_;
    UILabel *delta_;
    UILabel *eventType_;
    
    NSDateFormatter *formatter_;
    
}

- (void)setupFrames;
- (void)setEvent:(Event*)event;
- (NSString *)formatDate:(NSDate*)date;
@end

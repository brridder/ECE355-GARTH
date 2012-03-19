//
//  AlarmEventTableViewCell.h
//  garth
//
//  Created by Pew on 12-03-19.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlarmEvent.h"

@interface AlarmEventTableViewCell : UITableViewCell {
    AlarmEvent *event_;
    UILabel *timestampLabel_;
    UILabel *severityLabel_;
    UILabel *descriptionLabel_;
    UILabel *speechMessageLabel_;
    
    NSDateFormatter *formatter_;
}

- (void)setAlarmEvent:(AlarmEvent*)event;
- (NSString*)formatDate:(NSDate*)date;
- (void)setupFrames;
@end

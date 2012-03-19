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
}

- (void)setEvent:(Event*)event;

@end

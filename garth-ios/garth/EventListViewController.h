//
//  HomeViewController.h
//  garth
//
//  Created by Pew on 12-03-19.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBJson.h"
@interface EventListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    UITableView *tableview_;
    
    NSMutableArray *eventList_;
    BOOL isGettingEvents_;
    SBJsonParser *parser_;

    NSTimer *timer_;
}

- (void)getEvents;
- (void)parseEventJSONString:(NSString*)jsonResultString;

@end

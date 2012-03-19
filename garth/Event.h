//
//  Event.h
//  garth
//
//  Created by Pew on 12-03-19.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EventFactory.h"

@interface Event : NSObject {
    NSDate *timestamp_;
    enum EventType *eventType_;
}

@property (nonatomic, readonly) NSDate *timestamp;
@property (nonatomic, readonly) enum EventType *eventType;


- (id)initWithDictionary:(NSDictionary*)dict;
@end

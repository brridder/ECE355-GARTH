//
//  garthAppDelegate.h
//  garth
//
//  Created by Pew on 12-03-19.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface garthAppDelegate : NSObject <UIApplicationDelegate> {
    NSString *serverIP_;
}


@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) NSString *serverIP;

@end

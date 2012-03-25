//
//  HomeViewController.m
//  garth
//
//  Created by Pew on 12-03-19.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "EventListViewController.h"
#import "garthAppDelegate.h"
#import "EventTableViewCell.h"
#import "AlarmEvent.h"
#import "AlarmEventTableViewCell.h"
#import "Event.h"
#import "AFJSONRequestOperation.h"
#import "EventFactory.h"

@implementation EventListViewController

#pragma mark - View lifecycle

- (void)loadView {
    [super loadView];
    tableview_ = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height -44) style:UITableViewStylePlain];
    tableview_.delegate = self;
    tableview_.dataSource = self;
    
    eventList_ = [[NSMutableArray alloc] init];
    
    parser_ = [[SBJsonParser alloc] init];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    tableview_.frame = self.view.bounds;
    [self.view addSubview:tableview_];
    [self getEvents];
    [self.navigationController setTitle:@"Events List"];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    tableview_.frame = self.view.bounds;
    
}

- (void)viewDidUnload {
    [super viewDidUnload];
    [tableview_ removeFromSuperview];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view stuff

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [eventList_ count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 66.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifer = nil;
    Event *event = [eventList_ objectAtIndex:indexPath.row];
    if ([event eventType] == EventTypeAlarmEvent) {
        identifer = @"alarm";
    } else {
        identifer = @"event";
    }
    
    UITableViewCell *cell = [tableview_ dequeueReusableCellWithIdentifier:identifer];
    if (cell == nil) {
        if ([event eventType] == EventTypeAlarmEvent) {
            cell = [[[AlarmEventTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer] autorelease];
        } else {
            cell = [[[EventTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer] autorelease];
        }
    }
    
    if ([event eventType] == EventTypeAlarmEvent) {
        [(AlarmEventTableViewCell*)cell setAlarmEvent:(AlarmEvent*)event];
    } else {
        [(EventTableViewCell*)cell setEvent:event];
    }

    return cell;
}

- (void)getEvents {
    if (isGettingEvents_) {
        return;
    }
    NSString *ip = [((garthAppDelegate *)[[UIApplication sharedApplication] delegate]) serverIP];
    if (ip == nil) {
        return;
    }
    NSString *urlString = [NSString stringWithFormat:@"http://%@:3000/", ip];
    
    NSLog(@"%@", urlString);
    NSURL *url = [NSURL URLWithString:urlString];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    NSString *rpcBody = @"{\"jsonrpc\" : \"2.0\", \"method\" : \"get_events\", \"params\" : [], \"id\" : 1223}";
    [request setHTTPBody:[rpcBody dataUsingEncoding:NSStringEncodingConversionAllowLossy]];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request 
    success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        isGettingEvents_ = NO;
        NSLog(@"JSON : %@", JSON);
        [self parseEventJSONString:[JSON objectForKey:@"result"]];
        
        return;
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        isGettingEvents_ = NO;
        NSLog(@"Failed, trying again");
        [self getEvents];
        return;
    }];
    
    [operation start];
    isGettingEvents_ = YES;
    if (timer_ == nil) {
        timer_ = [NSTimer scheduledTimerWithTimeInterval:10.0f target:self selector:@selector(getEvents) userInfo:nil repeats:YES];
    }
}

- (void)parseEventJSONString:(NSString*)jsonResultString {
    NSArray *eventDicts = [parser_ objectWithString:jsonResultString];
    
    [eventList_ removeAllObjects];
    Event *event = nil;
    for (NSDictionary *e in eventDicts) {
        event = [[EventFactory createEventFromDictionary:e] retain];
        if (event) {
            [eventList_ insertObject:event atIndex:0];
        }
    }
    NSLog(@"%@", eventList_);
    [tableview_ reloadData];
    
}



@end

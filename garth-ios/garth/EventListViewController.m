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
#import "Event.h"
#import "AFJSONRequestOperation.h"
#import "EventFactory.h"

@implementation EventListViewController

#pragma mark - View lifecycle

- (void)loadView {
    [super loadView];
    tableview_ = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStylePlain];
    tableview_.delegate = self;
    tableview_.dataSource = self;
    
    eventList_ = [[NSMutableArray alloc] init];
    
    parser_ = [[SBJsonParser alloc] init];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:tableview_];
    [self getEvents];
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifer = @"cell";
    
    UITableViewCell *cell = [tableview_ dequeueReusableCellWithIdentifier:identifer];
    if (cell == nil) {
        cell = [[[EventTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer] autorelease];
    }
    
    Event *event = [eventList_ objectAtIndex:indexPath.row];
    [(EventTableViewCell*)cell setEvent:event];
    return cell;
}

- (void)getEvents {
    NSString *ip = [((garthAppDelegate *)[[UIApplication sharedApplication] delegate]) serverIP];
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
}

- (void)parseEventJSONString:(NSString*)jsonResultString {
    NSArray *eventDicts = [parser_ objectWithString:jsonResultString];
    
    [eventList_ removeAllObjects];
    Event *event = nil;
    for (NSDictionary *e in eventDicts) {
        event = [EventFactory createEventFromDictionary:e];
        [eventList_ addObject:event];
    }
    
}

- (void)eventsRetreived:(NSArray*)events {
    
}

@end

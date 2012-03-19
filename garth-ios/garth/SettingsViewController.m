//
//  SettingsViewController.m
//  garth
//
//  Created by Pew on 12-03-19.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "SettingsViewController.h"
#import "EventListViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "garthAppDelegate.h"

@implementation SettingsViewController

- (void)loadView {
    [super loadView];
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    serverIPTextField_ = [[UITextField alloc] initWithFrame:CGRectMake(40, 50, 320 - 80, 30)];
    serverIPTextField_.backgroundColor = [UIColor colorWithRed:230.0f/255.0f green:230.0f/255.0f blue:230.0f/255.0f alpha:1.0f];
    serverIPTextField_.delegate = self;
    [serverIPTextField_.layer setCornerRadius:5.0f];
    [serverIPTextField_.layer setBorderColor:[[UIColor blackColor] CGColor]];
    [serverIPTextField_.layer setBorderWidth:1.0f];
    [serverIPTextField_ setTextAlignment:UITextAlignmentCenter];
    
    serverIPTextField_.placeholder = @"Enter server IP.";
    
    connectButton_ = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [connectButton_ addTarget:self action:@selector(connectButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    connectButton_.frame = CGRectMake(serverIPTextField_.frame.origin.x, serverIPTextField_.frame.size.height + serverIPTextField_.frame.origin.y + 10, serverIPTextField_.frame.size.width, 44);
    [connectButton_ setTitle:@"Connect" forState:UIControlStateNormal];
    
    [self.view addSubview:serverIPTextField_];
    [self.view addSubview:connectButton_];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    [serverIPTextField_ removeFromSuperview];
    [connectButton_ removeFromSuperview];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)connectButtonPressed:(UIButton*)button {
    NSString *ipString = serverIPTextField_.text;
    [((garthAppDelegate*)[[UIApplication sharedApplication] delegate]) setServerIP:ipString];
    
    EventListViewController *vc = [[EventListViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)dealloc {
    [super dealloc];
    [serverIPTextField_ release];
}

@end

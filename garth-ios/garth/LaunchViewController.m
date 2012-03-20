//
//  SettingsViewController.m
//  garth
//
//  Created by Pew on 12-03-19.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "LaunchViewController.h"
#import "EventListViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "garthAppDelegate.h"

@implementation LaunchViewController

- (void)loadView {
    [super loadView];
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(40, 50, 320 - 80, 40)];
    [backgroundView.layer setCornerRadius:5.0f];
    [backgroundView.layer setBorderColor:[[UIColor blackColor] CGColor]];
    [backgroundView.layer setBorderWidth:1.0f];
    backgroundView.backgroundColor = [UIColor colorWithRed:230.0f/255.0f green:230.0f/255.0f blue:230.0f/255.0f alpha:1.0f];    
    serverIPTextField_ = [[UITextField alloc] initWithFrame:CGRectMake(0,5, 320 - 90, 30)];
    serverIPTextField_.font = [UIFont systemFontOfSize:18.0f];
    serverIPTextField_.center = CGPointMake(115, 23.0f);
    serverIPTextField_.backgroundColor = [UIColor colorWithRed:230.0f/255.0f green:230.0f/255.0f blue:230.0f/255.0f alpha:1.0f];
    serverIPTextField_.delegate = self;
   
    [serverIPTextField_ setTextAlignment:UITextAlignmentCenter];
    
    serverIPTextField_.placeholder = @"Enter server IP";
    
    connectButton_ = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [connectButton_ addTarget:self action:@selector(connectButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    connectButton_.frame = CGRectMake(backgroundView.frame.origin.x, backgroundView.frame.size.height + backgroundView.frame.origin.y + 10, backgroundView.frame.size.width, 44);
    [connectButton_ setTitle:@"Connect" forState:UIControlStateNormal];
    
    [backgroundView addSubview:serverIPTextField_];
    [self.view addSubview:backgroundView];
    [self.view addSubview:connectButton_];
    
    [self.navigationController setTitle:@"GARTH"];
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

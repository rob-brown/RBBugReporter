//
//  RBReportEmailerVC.m
//  AboutOne
//
//  Created by Robert Brown on 8/6/11.
//  Copyright 2011 Robert Brown. All rights reserved.
//

#import "RBReportEmailerVC.h"
#import "RBEmailBuilder.h"
#import "RBAttachment.h"


@interface RBReportEmailerVC ()

@property (nonatomic, retain) id<RBEmailBuilder> emailBuilder;

@end


@implementation RBReportEmailerVC

@synthesize emailBuilder;

- (id)initWithEmailBuilder:(id<RBEmailBuilder>)builder {
    
    NSParameterAssert(builder);
    
    if ((self = [super init])) {
        [self setEmailBuilder:builder];
    }
    
    return self;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    id<RBEmailBuilder> builder = [self emailBuilder];
    
    // Sets up the mail composer.
    [self setMailComposeDelegate:self];
    [self setSubject:[builder subjectLine]];
    [self setToRecipients:[builder recipients]];
    [self setMessageBody:[builder emailMessage]
                  isHTML:[builder isHTML]];
    
    // Adds all of the attachments, if any. 
    NSArray * attachments = [builder attachments];
    
    for (id<RBAttachment> attachment in attachments) {
        [self addAttachmentData:[attachment data]
                       mimeType:[attachment MIMEType]
                       fileName:[attachment fileName]];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - MFMailComposeViewControllerDelegate methods

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
	[[self navigationController] dismissModalViewControllerAnimated:YES];
}


#pragma mark - Memory Management

- (void)dealloc {
    [self setEmailBuilder:nil];
    [super dealloc];
}

@end

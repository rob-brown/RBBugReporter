//
//  RBReportEmailerVC.m
//
//  Created by Robert Brown on 8/6/11.
//  Copyright 2011 Robert Brown. All rights reserved.
//

#import "RBReportEmailerVC.h"
#import "RBEmailBuilder.h"
#import "RBAttachment.h"


@implementation RBReportEmailerVC

- (id)initWithEmailBuilder:(id<RBEmailBuilder>)builder {
    
    NSParameterAssert(builder);
    
    if ((self = [super init])) {
        
        // Sets up the mail composer.
        [self setMailComposeDelegate:self];
        [self setDelegate:self];
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - MFMailComposeViewControllerDelegate methods

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    [self dismissModalViewControllerAnimated:YES];
}

@end

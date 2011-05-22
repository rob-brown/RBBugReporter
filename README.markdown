#RBBugReporter

##Summary
`RBBugReporter` is a class to make it easy to receive error reports, notify users of errors, and log errors. `RBBugReporter` also includes support for Flurry. 

##Dependencies
`RBBugReporter` relies on some of my categories. Be sure to also include my `UIWindow+RBExtras` and `UIViewController+RBExtras`. They can be found in my RBCategories repository.

Flurry is an optional feature. To use the Flurry features you must include the Flurry SDK which can be found at Flurry.com

##Receiving email reports
One of the standard ways for a user to report bugs is through email. `RBBugReporter` provides a template email composer. The email message is broken into several parts consisting of comments, errors, and device info. Each part has default values and can be modified through various accessors. 

There is also a standard alert view that can be presented which asks the user if they want to report a bug. Alternatively, you can present the mail composer in another way. The following gives an example of each. 

```objective-c
// Presents an alert that asks the user to report a bug. If they accept, then the email composer is presented.
RBBugReporter * reporter = [[RBBugReporter alloc] initWithError:error];
[reporter presentBugAlert];
[reporter release];

// Presents the email composer directly. This could be in response to the user pressing a bug report button or by some other means.
RBBugReporter * reporter = [[RBBugReporter alloc] initWithErrorMessage:@"Testing reporter"];
[reporter presentBugReportComposer];
[reporter release];
```

##User notifications
`RBBugReporter` includes a method for presenting simple messages to users. These messages are intended to present information or notify of errors where no immediate action is required. The following is an example:

```objective-c
[RBBugReporter presentAlertWithTitle:@"Testing" 
                             message:@"Testing simple message presentation."];
```

##Logging errors
Logging errors are made very easy. Just pass the error to RBBugReporter.

```objective-c
NSError * error = nil;

// Some code that might generate an error.

if (error) {
	[RBBugReporter logError:error];
}
```

##Flurry
In addition to standard reporting methods, `RBBugReporter` provides and optional wrapper around Flurry. Flurry reporting can also be disabled when debugging to prevent mixing debugging sessions with regular user sessions.

###Including Flurry
1. Include the Flurry SDK. See Flurry.com for details.
2. In the Xcode build settings, look for "Preprocessor Macros". Define the macro FLURRY for all build configurations.
3. (Optional) To disable Flurry reports when debugging, define the macro DEBUG for just the debug build configuration.

###Flurry reporting
There are several simple methods for Flurry. `RBBugReporter` can log errors, exceptions, and events. The following gives examples of each.

```objective-c
// Simple error reporting.
[RBBugReporter sendFlurryReportWithError:error];

// Customized error reporting.
[RBBugReporter sendFlurryReportWithTitle:@"Error"
                                 message:@"An error occurred"
                                   error:error];

// Customized exception reporting.
[RBBugReporter sendFlurryReportWithTitle:@"Error"
                                 message:@"An error occurred"
                               exception:exception];

// Simple event logging.
[RBBugReporter logFlurryEvent:anEventName];
```

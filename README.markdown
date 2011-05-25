#RBBugReporter

##Summary
`RBBugReporter` is a class to make it easy to receive error reports, notify users of errors, and log errors. `RBBugReporter` also includes support for [Flurry Analytics][1]. 

##Dependencies
`RBBugReporter` relies on some of my categories. Be sure to also include my `UIWindow+RBExtras`, `UIViewController+RBExtras`, and `NSString+RBExtras`. They can be found in my [RBCategories repository][2].

Flurry is an optional feature. To use the Flurry features you must include the Flurry SDK which can be found at [Flurry.com][1].

##Generating email reports
One of the standard ways for a user to report bugs is through email. The `RBEmailBuilder` protocol provides a standard interface for generating email content. `RBEmailBuilder` uses a simple builder pattern (see [Design Patterns: Elements of Reusable Object-Oriented Software][3]). `RBBaseEmailBuilder` provides a basic implementation of the `RBEmailBuilder` protocol which can be inherited by subclasses. 

##Receiving email reports
`RBBugReporter` provides a template email composer. It has two different ways it can be presented. There is a standard alert view that can be presented which asks the user if they want to report a bug. Alternatively, you can present the mail composer directly in response to whatever action you choose. The following gives an example of each. 

```objective-c
// Presents an alert that asks the user to report a bug. If they accept, then the email composer is presented.
RBBugReportEmailBuilder * builder [[RBBugReportEmailBuilder alloc] initWithError:error];
RBBugReporter * reporter = [[RBBugReporter alloc] init];
[reporter presentBugAlertWithBuilder:builder];
[builder release];
[reporter release];

// Presents the email composer directly. This could be in response to the user pressing a bug report button or by some other means.
RBBugReportEmailBuilder * builder [[RBBugReportEmailBuilder alloc] initWithErrorMessage:@"Testing reporter"];
RBBugReporter * reporter = [[RBBugReporter alloc] init];
[reporter presentBugReportComposerWithBuilder:builder];
[builder release];
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
In addition to standard reporting methods, `RBBugReporter` provides an optional wrapper around Flurry. Flurry reporting can also be disabled when debugging to prevent mixing debugging sessions with regular user sessions.

###Including Flurry
1. Include the Flurry SDK. See [Flurry.com][1] for details.
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

##License

`RBBugReporter` is licensed under the MIT license, which is reproduced in its entirety here:

>Copyright (c) 2011 Robert Brown
>
>Permission is hereby granted, free of charge, to any person obtaining a copy
>of this software and associated documentation files (the "Software"), to deal
>in the Software without restriction, including without limitation the rights
>to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
>copies of the Software, and to permit persons to whom the Software is
>furnished to do so, subject to the following conditions:
>
>The above copyright notice and this permission notice shall be included in
>all copies or substantial portions of the Software.
>
>THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
>IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
>FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
>AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
>LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
>OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
>THE SOFTWARE.

  [1]: http://www.flurry.com/
  [2]: https://github.com/rob-brown/RBCategories
  [3]: http://www.amazon.com/Design-Patterns-Elements-Reusable-Object-Oriented/dp/0201633612/ref=sr_1_1?ie=UTF8&qid=1306283437&sr=8-1

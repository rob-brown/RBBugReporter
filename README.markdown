#RBReporter

##Summary
`RBReporter` is a facade to make it easy to receive error reports, notify users of errors, and log errors. `RBReporter` also includes support for [Flurry Analytics][1]. You only need to interact with `RBReporter`; however, you can still use the underlying classes if necessary. 

##Dependencies
`RBReporter` relies on some of my categories. Be sure to also include my `UIWindow+RBExtras`, `UIViewController+RBExtras`, `NSString+RBExtras`, and `NSURL+RBExtras`. They can be found in my [RBCategories repository][2].

`RBReporter` also depends on `MessageUI.framework`.

Flurry is an optional feature. To use the Flurry features you must include the Flurry SDK which can be found at [Flurry.com][1].

`RBReporter` is written for iOS 4.0+ support. It can probably be modified for 3.0+ support by switching GCD with NSOperationQueue. `RBReporter` has not been written to work with the Mac platform. It would be nice if `RBReporter` is modified to be independent of iOS so it could be used in Mac software. 

##Email

###Generating email reports
One of the standard ways for a user to report bugs is through email. The `RBEmailBuilder` protocol provides a standard interface for generating email content. `RBEmailBuilder` uses a simple builder pattern (see [Design Patterns: Elements of Reusable Object-Oriented Software][3] or [Wikipedia][4]). `RBBaseEmailBuilder` provides a basic implementation of the `RBEmailBuilder` protocol which can be inherited by subclasses. 

###Receiving email reports
`RBReporter` provides a template email composer. It has two different ways it can be presented. There is a standard alert view that can be presented which asks the user if they want to report a bug. Alternatively, you can present the mail composer directly in response to whatever action you choose. The following gives an example of each. 

```objective-c
// Presents an alert that asks the user to report a bug. If they accept, then the email composer is presented.
RBBugReportEmailBuilder * builder [[RBBugReportEmailBuilder alloc] initWithError:error];
RBReporter * reporter = [[RBReporter alloc] init];
[reporter presentBugAlertWithBuilder:builder];
[builder release];
[reporter release];

// Presents the email composer directly. This could be in response to the user pressing a bug report button or by some other means.
RBBugReportEmailBuilder * builder [[RBBugReportEmailBuilder alloc] initWithErrorMessage:@"Testing reporter"];
RBReporter * reporter = [[RBReporter alloc] init];
[reporter presentBugReportComposerWithBuilder:builder];
[builder release];
[reporter release];
```

##User notifications
`RBReporter` includes a convenience method for presenting simple messages to users. These messages are intended to present information or notify of errors where no immediate action is required. The following is an example:

```objective-c
[RBReporter presentAlertWithTitle:@"Testing" 
                          message:@"Testing simple message presentation."];
```

##Data Logging

###Logging errors
Logging errors are made very easy. Just pass the error to `RBReporter`. Exceptions can be handled similarly.

```objective-c
NSError * error = nil;

// Some code that might generate an error.

if (error) {
	[RBReporter logError:error];
}
```

###RBLogger
There is a logger underneath `RBReporter`. `RBReporter` provides a facade to the logger; however, if you need to directly access the logger, you may. The logger is also designed to create a new log file every day. This keeps log files smaller and makes it easy to clean up old log files. 

###RBLogFile
`RBLogFile` provides an interface for the log files `RBLogger` uses. These files can direct their output to a file on the local file system or on a remote server. This also makes the format of the log file independent of the logger. `RBExtendedLogFile` is included for use as is or as a template for other log files. It uses a modification of the extended log file format. `RBBaseLogFile` provides a simple implementation and may be subclassed to define custom behavior.

###RBLogFileFactory
`RBLogger` is intended to only use one type of log file. `RBLogFileFactory` is responsible for creating log files so  `RBLogger` is doesn't need to know anything about your own implementations of `RBLogFile`. By changing `newLogFileWithPath:` you can change the file format of your log files.

##Flurry
In addition to standard reporting methods, `RBReporter` provides an optional facade to Flurry. Flurry reporting can also be disabled when debugging to prevent mixing debugging sessions with regular user sessions.

###Including Flurry
1. Include the Flurry SDK. See [Flurry.com][1] for details.
2. In the Xcode build settings, look for "Preprocessor Macros". Define the macro FLURRY for all build configurations.
3. (Optional) To disable Flurry reports when debugging, define the macro DEBUG for just the debug build configuration.

###Flurry reporting
There are several simple methods for Flurry. `RBReporter` can log errors, exceptions, and events. The following gives examples of each.

```objective-c
// Simple error reporting.
[RBReporter sendFlurryReportWithError:error];

// Customized error reporting.
[RBReporter sendFlurryReportWithTitle:@"Error"
                              message:@"An error occurred"
                                error:error];

// Customized exception reporting.
[RBReporter sendFlurryReportWithTitle:@"Error"
                              message:@"An error occurred"
                            exception:exception];

// Simple event logging.
[RBReporter logFlurryEvent:anEventName];
```

##License

`RBReporter` is licensed under the MIT license, which is reproduced in its entirety here:

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
  [4]: http://en.wikipedia.org/wiki/Builder_pattern

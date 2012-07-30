Getting Started With Your SMJobKit-based Application
====================================================

There are a few manual steps that you need to perform before you can build your application:

1. Add your service's binary (product) to the Copy Files build phase of your application (the phase
   for `Contents/Library/LaunchServices`).

2. Set up your application's target to link with `SMJobKit.framework`.

3. Set up your service's target to link with `libSMJService.a`.

Xcode templates can do a lot, but not everything!  Plus, they're not really documented.  If you
know how to accomplish any of the above steps via template configuration, let me know, please :)

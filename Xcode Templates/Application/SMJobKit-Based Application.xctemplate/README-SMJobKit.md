Getting Started With Your SMJobKit-based Application
====================================================

There are a few manual steps that you need to perform before you can build your application:

1. In your application's target, move the `Run Script` (Generic preprocessing) build phase to
   _before_ the `Compile Sources` build phase.

2. Add the SMJobKit Xcode project to your project or workspace.

3. Set up your application's target to link with SMJobKit.framework.

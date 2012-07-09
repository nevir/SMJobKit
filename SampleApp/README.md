SMJobKit Sample Application
===========================

While `SMJobKit` does its best to make setting up system agents/daemons, it's
still not an entirely straightforward process.


Configuring Your Project
------------------------

1. Pull SMJobKit into your workspace somewhere, so that XCode can reference it.

2. In your app's build phases, add `SMJobKit.framework` to be linked.

Creating The Job Service
------------------------

Unlike XPC services, system jobs are pure binaries (not bundles), which makes
our lives a bit less pleasant.

1. Create a new command line tool target (type `Foundation` is a good starting
   point).

2. Create an Info.plist for the service, [as per the sample](SampleService/SampleService-Info.plist):

  * Make sure that you set the Bundle identifier to a launchd-appropriate
    service name such as `com.example.AppName.ServiceName`.

  * **Make sure** that you update the authorized clients section to point to
    your app's bundle identifier, and that the certificate subject *exactly*
    matches your developer certificate!

3. Create a launchd.plist for the service, [as per the sample](SampleService/SampleService-Launchd.plist):

  * The label should match your service's bundle identifier.

  * Make sure to update the Mach services section with that identifier as well.

4. Configure the build settings [as per the sample](Configuration/SampleService.xcconfig):

  * The target name should be the same as the bundle identifier you gave it in
    its Info.plist.

  * Set up the other linker flags to set the two plists as TEXT nodes in the
    binary (since we can't build a bundle)

  * Make sure that you give a code signing identity to the target.

5. In your *app* target, add a new copy files build phase:

  * It should be set to the `Wrapper` destination with a subpath of
    `Contents/Library/LaunchServices`.

  * Add the service's product binary to be copied.

//
//  AppDelegate.m
//  RevealLauncher
//
//  Created by likid1412 on 10/21/14.
//  Copyright (c) 2014 Likid. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

-(void)bringToFrontApplicationWithBundleIdentifier:(NSString*)inBundleIdentifier
{
    // Try to bring the application to front
    NSArray* appsArray = [NSRunningApplication runningApplicationsWithBundleIdentifier:inBundleIdentifier];
    if([appsArray count] > 0)
    {
        [[appsArray objectAtIndex:0] activateWithOptions:NSApplicationActivateIgnoringOtherApps];
    }

    // Quit ourself
    [[NSApplication sharedApplication] terminate:self];
}

-(void)launchApplicationWithPath:(NSString*)inPath andBundleIdentifier:(NSString*)inBundleIdentifier
{
    if(inPath != nil)
    {
        // Run Calculator.app and inject our dynamic library
        NSString *dyldLibrary = [[NSBundle bundleForClass:[self class]] pathForResource:@"libHookReveal" ofType:@"dylib"];
        NSString *launcherString = [NSString stringWithFormat:@"DYLD_INSERT_LIBRARIES=\"%@\" \"%@\" &", dyldLibrary, inPath];
        system([launcherString UTF8String]);

        // Bring it to front after a delay
        [self performSelector:@selector(bringToFrontApplicationWithBundleIdentifier:) withObject:inBundleIdentifier afterDelay:1.0];
    }
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    NSString *calculatorPath = @"/Applications/Reveal.app/Contents/MacOS/Reveal";
    if([[NSFileManager defaultManager] fileExistsAtPath:calculatorPath])
        [self launchApplicationWithPath:calculatorPath andBundleIdentifier:@"com.ittybittyapps.Reveal"];
}

@end
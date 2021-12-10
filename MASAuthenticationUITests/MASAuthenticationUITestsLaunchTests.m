//
//  MASAuthenticationUITestsLaunchTests.m
//  MASAuthenticationUITests
//
//  Created by Pratap Reddy Guvvala on 10/12/21.
//  Copyright © 2021 CA Technologies. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface MASAuthenticationUITestsLaunchTests : XCTestCase

@end

@implementation MASAuthenticationUITestsLaunchTests

+ (BOOL)runsForEachTargetApplicationUIConfiguration {
    return YES;
}

- (void)setUp {
    self.continueAfterFailure = NO;
}

- (void)testLaunch {
    XCUIApplication *app = [[XCUIApplication alloc] init];
    [app launch];

    // Insert steps here to perform after app launch but before taking a screenshot,
    // such as logging into a test account or navigating somewhere in the app

    XCTAttachment *attachment = [XCTAttachment attachmentWithScreenshot:XCUIScreen.mainScreen.screenshot];
    attachment.name = @"Launch Screen";
    attachment.lifetime = XCTAttachmentLifetimeKeepAlways;
    [self addAttachment:attachment];
}

@end

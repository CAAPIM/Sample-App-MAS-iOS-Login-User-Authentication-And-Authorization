//
//  MASAuthenticationUITests.m
//  MASAuthenticationUITests
//
//  Created by Pratap Reddy Guvvala on 10/12/21.
//  Copyright © 2021 CA Technologies. All rights reserved.
//

#import <XCTest/XCTest.h>

#define USER_NAME                         @"admin"
#define PASSWORD                          @"7layer"
#define USER_TEXTFIELD                    @"Username"
#define PASSWORD_TEXTFIELD                @"Password"
#define OK_BUTTON                         @"OK"
#define SUCCESS_MESSAGE                   @"Login was successful"
#define Explicit_Login                    @"Explicit Login"
#define Authentication_SUCCESS            @"Authentication status: authenticated as admin"
#define SYSTEM_ALERT_HANDLER              @"SystemAlertHandler"
#define ALLOW_ONCE                        @"Allow Once"
#define TIME_INTERVAL                     5



@interface MASAuthenticationUITests : XCTestCase

@property(nonatomic,strong) XCUIApplication *app;
@end

@implementation MASAuthenticationUITests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.

    // In UI tests it is usually best to stop immediately when a failure occurs.
    self.continueAfterFailure = NO;

    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    
    _app = [[XCUIApplication alloc] init];

}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testExample {
    // UI tests must launch the application that they test.
    XCUIApplication *app = [[XCUIApplication alloc] init];
    [app launch];

    // Use recording to get started writing UI tests.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testLaunchPerformance {
    if (@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *)) {
        // This measures how long it takes to launch your application.
        [self measureWithMetrics:@[[[XCTApplicationLaunchMetric alloc] init]] block:^{
            [[[XCUIApplication alloc] init] launch];
        }];
    }
}

- (void)checkSystemAlerts {
    
    [self addUIInterruptionMonitorWithDescription:SYSTEM_ALERT_HANDLER handler:^BOOL(XCUIElement * _Nonnull interruptingElement) {
        NSString * allowOnce = ALLOW_ONCE;
        XCUIElementQuery * buttons = interruptingElement.buttons;
        if ([buttons[allowOnce] exists]) {
            [buttons[allowOnce] tap];
            return YES;
        }
        return NO;
    }];
}

- (void)test_ExplicitLogIn {
    
    [_app launch];
    [self checkSystemAlerts];

    XCUIElement *alertRegisterGW = _app.alerts.buttons[OK_BUTTON];
    if([alertRegisterGW exists]){
        [alertRegisterGW tap];
    }

    [_app.staticTexts[Explicit_Login] tap];
    
    XCUIElement *userElement = _app.alerts.textFields[USER_TEXTFIELD];
    XCUIElement *passwordElement = _app.alerts.secureTextFields[PASSWORD_TEXTFIELD];
    
    [userElement tap];
    [userElement typeText:USER_NAME];
    
    [passwordElement tap];
    [passwordElement typeText:PASSWORD];
    
    XCUIElement *okButton = _app.alerts.buttons[OK_BUTTON];
    if([okButton exists]){
        [okButton tap];
    }
    
    BOOL okButtonLoginSuccess = [_app.alerts.buttons[OK_BUTTON] waitForExistenceWithTimeout:TIME_INTERVAL];
    XCTAssert(okButtonLoginSuccess);
    
    if(okButtonLoginSuccess) {
        XCTAssert([_app.alerts.staticTexts[SUCCESS_MESSAGE] exists]);
        XCUIElement *loginSuccessAlert = _app.alerts.buttons[OK_BUTTON];
        if([loginSuccessAlert exists]){
            [loginSuccessAlert tap];
        }
    }

    BOOL checkLoginSuccess = [_app.staticTexts[Authentication_SUCCESS] waitForExistenceWithTimeout:TIME_INTERVAL];
    XCTAssert(checkLoginSuccess);
}

@end

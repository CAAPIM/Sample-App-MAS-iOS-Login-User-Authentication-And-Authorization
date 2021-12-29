//
//  MASAuthenticationUITests.m
//  MASAuthenticationUITests
//
//  Created by Pratap Reddy Guvvala on 10/12/21.
//  Copyright © 2021 CA Technologies. All rights reserved.
//

#import <XCTest/XCTest.h>

#define USER_NAME                         @"admin"
//#define USER_NAME                         @"pratap"
#define PASSWORD                          @"7layer"
#define USER_TEXTFIELD                    @"Username"
#define PASSWORD_TEXTFIELD                @"Password"
#define OK_BUTTON                         @"OK"
#define Explicit_Login                    @"Explicit Login"
#define INVOKE_API                        @"Invoke API"
#define DE_REGISTER_DEVICE                @"De-register device"
#define SUCCESS_MESSAGE                   @"Login was successful"
#define INVOKING_APISUCCESS_MESSAGE       @"Invoking API Successful"
#define Authentication_SUCCESS            @"Authentication status: authenticated as"
#define DE_REGISTER_DEVICE_MESSAGE        @"Authentication status: not authenticated"
#define SYSTEM_ALERT_HANDLER              @"SystemAlertHandler"
#define ALLOW_ONCE                        @"Allow Once"
#define TIME_INTERVAL                     10
#define MAS_UI_CANCEL                     @"masui-cancelBtn"
#define MAS_UI_LogIn                      @"Login"
#define MAS_UI_USER_TEXTFIELD             @"masui-usernameField"
#define MAS_UI_PASSWORD_FIELD             @"masui-passwordField"


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

- (void)checkUserLogIn {
    
    BOOL checkLoginAlert = [_app.alerts.textFields[USER_TEXTFIELD] waitForExistenceWithTimeout:TIME_INTERVAL];
    if(checkLoginAlert) {
        XCUIElement *userElement = _app.alerts.textFields[USER_TEXTFIELD];
        XCUIElement *passwordElement = _app.alerts.secureTextFields[PASSWORD_TEXTFIELD];
        
        [userElement tap];
        [userElement typeText:USER_NAME];
        
        [passwordElement tap];
        [passwordElement typeText:PASSWORD];
    }
}
-(NSString *)succeessUser {
    return [NSString stringWithFormat:@"%@ %@",Authentication_SUCCESS,USER_NAME];
}

- (void)test_ExplicitLogIn {
    
    [_app launch];
    [self checkSystemAlerts];
    
    XCUIElement *alertRegisterGW = _app.alerts.buttons[OK_BUTTON];
    if([alertRegisterGW exists]){
        [alertRegisterGW tap];
    }
    
    [_app.staticTexts[Explicit_Login] tap];
    
    [self checkUserLogIn];
    
    XCUIElement *okButton = _app.alerts.buttons[OK_BUTTON];
    if([okButton exists]){
        [okButton tap];
    }
    
    BOOL okButtonLoginSuccess = [_app.alerts.buttons[OK_BUTTON] waitForExistenceWithTimeout:TIME_INTERVAL];
    
    if(okButtonLoginSuccess) {

        XCUIElement *successMessage = _app.alerts.staticTexts[SUCCESS_MESSAGE];
        if ([successMessage exists]) {
            XCTAssert(successMessage);
        } else {
            XCTAssert(successMessage);
        }

        XCUIElement *loginSuccessAlert = _app.alerts.buttons[OK_BUTTON];
        if([loginSuccessAlert exists]){
            [loginSuccessAlert tap];
        }
    } else {
        XCTAssert(okButtonLoginSuccess);
    }
    
    BOOL checkLoginSuccess = [_app.staticTexts[[self succeessUser]] waitForExistenceWithTimeout:TIME_INTERVAL];
    XCTAssert(checkLoginSuccess);
}

- (void)test_InvokeAPILogIn {
    
    [_app launch];
    
    [self checkSystemAlerts];
    
    XCUIElement *alertRegisterGW = _app.alerts.buttons[OK_BUTTON];
    if([alertRegisterGW exists]) {
        [alertRegisterGW tap];
    }
    
    [_app.staticTexts[DE_REGISTER_DEVICE] tap];
    
    XCUIElement *deRegisterDevice = _app.staticTexts[DE_REGISTER_DEVICE_MESSAGE];
    
    NSPredicate *exists = [NSPredicate predicateWithFormat:@"exists == 1"];
    [self expectationForPredicate:exists evaluatedWithObject:deRegisterDevice handler:nil];
    [self waitForExpectationsWithTimeout:TIME_INTERVAL handler:nil];
    
    XCTAssert([deRegisterDevice exists]);
    
    [_app.staticTexts[INVOKE_API] tap];
    
    BOOL masuiCancelBtn = [_app.buttons[MAS_UI_CANCEL] waitForExistenceWithTimeout:TIME_INTERVAL];
    
    if(masuiCancelBtn) {
        
        XCUIElement *userElement = _app.textFields[MAS_UI_USER_TEXTFIELD];
        XCUIElement *passwordElement = _app.secureTextFields[MAS_UI_PASSWORD_FIELD];
        
        [userElement tap];
        [userElement typeText:USER_NAME];
        
        [passwordElement tap];
        [passwordElement typeText:PASSWORD];
        
        XCUIElement *logInElement = _app.staticTexts[MAS_UI_LogIn];
        [logInElement tap];
        
    } else {
        [self checkUserLogIn];
        
        XCUIElement *okButton = _app.alerts.buttons[OK_BUTTON];
        if([okButton exists]){
            [okButton tap];
        }
        
        BOOL okButtonLoginSuccess = [_app.alerts.buttons[OK_BUTTON] waitForExistenceWithTimeout:TIME_INTERVAL];
        
        if(okButtonLoginSuccess) {
            XCUIElement *successInvokeMessage = _app.alerts.staticTexts[INVOKING_APISUCCESS_MESSAGE];
            if ([successInvokeMessage exists]) {
                XCTAssert(successInvokeMessage);
            } else {
                XCTAssertFalse(successInvokeMessage);
            }
            
            XCUIElement *loginSuccessAlert = _app.alerts.buttons[OK_BUTTON];
            if([loginSuccessAlert exists]){
                [loginSuccessAlert tap];
            }
        } else {
            XCTAssert(okButtonLoginSuccess);
        }
    }
    BOOL checkLoginSuccess = [_app.staticTexts[[self succeessUser]] waitForExistenceWithTimeout:TIME_INTERVAL];
    XCTAssert(checkLoginSuccess);
}

- (void)test_DeRegisterDevice {
    [_app launch];
    
    [self checkSystemAlerts];
    
    XCUIElement *alertRegisterGW = _app.alerts.buttons[OK_BUTTON];
    if([alertRegisterGW exists]) {
        [alertRegisterGW tap];
    }
    
    [_app.staticTexts[DE_REGISTER_DEVICE] tap];
    
    XCUIElement *deRegisterDevice = _app.staticTexts[DE_REGISTER_DEVICE_MESSAGE];
    
    NSPredicate *exists = [NSPredicate predicateWithFormat:@"exists == 1"];
    [self expectationForPredicate:exists evaluatedWithObject:deRegisterDevice handler:nil];
    [self waitForExpectationsWithTimeout:TIME_INTERVAL handler:nil];
    
    XCTAssert([deRegisterDevice exists]);
}

@end

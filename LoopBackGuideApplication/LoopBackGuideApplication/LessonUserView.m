//
//  LessonOneView.m
//  LoopBackGuideApplication
//
//  Created by Stephen Hess on 1/8/14.
//  Copyright (c) 2014 StrongLoop. All rights reserved.
//

#import "LessonUserView.h"

#import <LoopBack/LoopBack.h>

#import "AppDelegate.h"

typedef enum _UserMode
{
    UM_CREATE = 0,
    UM_LOGIN,
    UM_LOGOUT
}UserMode;

@interface LessonUserView ()

@property (nonatomic, strong) LBUser* loggedInUser;

@property (nonatomic, strong) LBUserRepository* repository;

@end

/**
 * Implementation for Lesson Four: Users
 */
@implementation LessonUserView

// Simple delegate implementation to auto-dismiss UITextFields.
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

/**
 * Accessor for the respository.  The first time it is requested, it will
 * be created.  Each subsequent request will get the cached version.
 */
- (LBUserRepository*)repository
{
    if (_repository == nil)
    {
        // Grab the shared LBRESTAdapter instance.
        LBRESTAdapter *adapter = ((AppDelegate *)[[UIApplication sharedApplication] delegate]).adapter;
        
        //Create our repository once
        self.repository = (LBUserRepository *)[adapter repositoryWithClass:[LBUserRepository class]];
    }
    
    return _repository;
}

/**
 * Sends the appropriate request (create/login/logout) based on the current UI mode.
 */
- (IBAction)sendRequest:(id)sender {
    if (_modeSC.selectedSegmentIndex == UM_CREATE) {
        // 1. Create a new user given the email and password from the UI.
        LBUser *user = [self.repository createUserWithEmail:_emailTF.text
                                                   password:_passwordTF.text];
        
        // 2. Save!
        [user saveWithSuccess:^{
            NSLog(@"Successfully saved %@", user);
            _statusTV.text = [NSString stringWithFormat:@"Created user %@", _emailTF.text];
        } failure:^(NSError *error) {
            NSLog(@"Failed to save %@ with %@", user, error);
            _statusTV.text = [NSString stringWithFormat:@"Failed to create user with error: %@", [error localizedRecoverySuggestion]];
            [[[UIAlertView alloc] initWithTitle:@"Error"
                                        message:[error localizedDescription]
                                       delegate:nil
                              cancelButtonTitle:@"Dismiss"
                              otherButtonTitles:nil] show];
        }];
    }
    else if (_modeSC.selectedSegmentIndex == UM_LOGIN) {
        //Attempt to login with the given credentials.
        [self.repository userByLoginWithEmail:_emailTF.text password:_passwordTF.text success:^(LBUser* loggedInUser){
            NSLog(@"Successfully logged in %@", loggedInUser);
            _statusTV.text = [NSString stringWithFormat:@"Logged in user %@", _emailTF.text];
            self.loggedInUser = loggedInUser;
            [[[UIAlertView alloc] initWithTitle:@"Logged In!"
                                        message:nil
                                       delegate:nil
                              cancelButtonTitle:@"Dismiss"
                              otherButtonTitles:nil] show];
        } failure:^(NSError *error) {
            NSLog(@"Failed to log in %@", error);
            _statusTV.text = [NSString stringWithFormat:@"Failed to log in with error: %@", [error localizedRecoverySuggestion]];
            [[[UIAlertView alloc] initWithTitle:@"Error"
                                        message:[error localizedDescription]
                                       delegate:nil
                              cancelButtonTitle:@"Dismiss"
                              otherButtonTitles:nil] show];
        }];
    }
    else {
        //Attempt to log out
        [self.repository logoutWithSuccess:^{
            self.loggedInUser = nil;
            _statusTV.text = [NSString stringWithFormat:@"Logged out!"];
            [[[UIAlertView alloc] initWithTitle:@"Logged Out!"
                                        message:nil
                                       delegate:nil
                              cancelButtonTitle:@"Dismiss"
                              otherButtonTitles:nil] show];
        }failure:^(NSError *error) {
            NSLog(@"Failed to log out %@", error);
            _statusTV.text = [NSString stringWithFormat:@"Failed to log out with error: %@", [error localizedRecoverySuggestion]];
            [[[UIAlertView alloc] initWithTitle:@"Error"
                                        message:[error localizedDescription]
                                       delegate:nil
                              cancelButtonTitle:@"Dismiss"
                              otherButtonTitles:nil] show];
        }];
    }
}

@end

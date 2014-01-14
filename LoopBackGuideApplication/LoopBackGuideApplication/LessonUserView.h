//
//  LessonUserView.h
//  LoopBackGuideApplication
//
//  Created by Stephen Hess on 1/8/14.
//  Copyright (c) 2014 StrongLoop. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LessonUserView : UIView <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *emailTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UISegmentedControl *modeSC;
@property (weak, nonatomic) IBOutlet UITextView *statusTV;

- (IBAction)sendRequest:(id)sender;

@end

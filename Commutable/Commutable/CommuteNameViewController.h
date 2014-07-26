//
//  CommuteNameViewController.h
//  Commutable
//
//  Created by Edward Damisch on 7/26/14.
//  Copyright (c) 2014 Commutable. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommuteNameViewController : UIViewController <UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *commuteNameTextField;
@property (strong, nonatomic) NSString *commuteName;

@end

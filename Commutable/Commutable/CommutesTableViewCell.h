//
//  CommutesTableViewCell.h
//  Commutable
//
//  Created by Edward Damisch and Rick Wattras on 4/12/14.
//  Copyright (c) 2014 Commutable. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommutesTableViewCell : UITableViewCell
//Connects the label from table of commutes in the storyboard
@property (strong, nonatomic) IBOutlet UILabel *commuteName;

@end

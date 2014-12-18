//
//  UIBorderLabel.h
//  Commutable
//
//  Created by Rick Wattras on 12/17/14.
//  Copyright (c) 2014 Commutable. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIBorderLabel : UILabel
{
    CGFloat topInset;
    CGFloat leftInset;
    CGFloat bottomInset;
    CGFloat rightInset;
}

@property (nonatomic) CGFloat topInset;
@property (nonatomic) CGFloat leftInset;
@property (nonatomic) CGFloat bottomInset;
@property (nonatomic) CGFloat rightInset;

@end

//
//  UIBorderLabel.m
//  Commutable
//
//  Created by Rick Wattras on 12/17/14.
//  Copyright (c) 2014 Commutable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIBorderLabel.h"

@implementation UIBorderLabel

@synthesize topInset, leftInset, bottomInset, rightInset;

- (void)drawTextInRect:(CGRect)rect
{
    UIEdgeInsets insets = {self.topInset, self.leftInset,
        self.bottomInset, self.rightInset};
    
    return [super drawTextInRect:UIEdgeInsetsInsetRect(rect, insets)];
}

@end
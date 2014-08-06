//
//  CommutableFirstViewController.h
//  Commutable
//
//  Created by Edward Damisch and Rick Wattras on 4/12/14.
//  Copyright (c) 2014 Commutable. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>

@interface CommutableFirstViewController : UIViewController <UIScrollViewDelegate>

@property (strong, nonatomic) IBOutlet GMSMapView *mapView;


@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@property (nonatomic, strong) NSMutableArray *commuteArray;

@end

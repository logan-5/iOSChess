//
//  ViewController.h
//  Chess
//
//  Created by Logan Smith on 3/12/15.
//  Copyright (c) 2015 Logan Smith. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel* turnLabel;
- (IBAction)receiveTap:(id)sender;
- (void)eventAtLocationX:(int)x Y:(int)y;
@end

//
//  UIImage+UIImageTint.h
//  Chess
//  ______READ______:  Amazingly helpful code from https://coffeeshopped.com/2010/09/iphone-how-to-dynamically-color-a-uiimage
//  It would be unnecessary in iOS 7, which adds easy functionality for tinting an image.
//  However I am living in the stone age.
//
//  Copied from the Internet by Logan Smith on 3/18/15.
//  Copyright (c) 2015 Logan Smith. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (UIImageTint)

+ (UIImage*)imageNamed:(NSString*)name withColor:(UIColor*)color;

@end

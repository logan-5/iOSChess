//
//  UIImage+UIImageTint.m
//  Chess
//
//  ______READ______:  Amazingly helpful code from https://coffeeshopped.com/2010/09/iphone-how-to-dynamically-color-a-uiimage
//  It would be unnecessary in iOS 7, which adds easy functionality for tinting an image.
//  However I am living in the stone age.


//  Copied from the Internet by Logan Smith on 3/18/15.
//  Copyright (c) 2015 Logan Smith. All rights reserved.
//

#import "UIImage+UIImageTint.hh"

@implementation UIImage (UIImageTint)

+ (UIImage*)imageNamed:(NSString*)name withColor:(UIColor*)color {
    
    UIImage *img = [UIImage imageNamed:name];
    
    // begin a new image context, to draw our colored image onto
    UIGraphicsBeginImageContext(img.size);
    
    // get a reference to that context we created
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // set the fill color
    [color setFill];
    
    // translate/flip the graphics context (for transforming from CG* coords to UI* coords
    CGContextTranslateCTM(context, 0, img.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    // set the blend mode to color burn, and the original image
    CGContextSetBlendMode(context, kCGBlendModeDifference);
    CGRect rect = CGRectMake(0, 0, img.size.width, img.size.height);
    CGContextDrawImage(context, rect, img.CGImage);
    
    // set a mask that matches the shape of the image, then draw (color burn) a colored rectangle
    CGContextClipToMask(context, rect, img.CGImage);
    CGContextAddRect(context, rect);
    CGContextDrawPath(context,kCGPathFill);
    
    // generate a new UIImage from the graphics context we drew onto
    UIImage *coloredImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //return the color-burned image
    return coloredImg;
}

@end

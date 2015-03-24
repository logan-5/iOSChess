//
//  DrawableImageView.h
//  Chess
//
//  Created by Logan Smith on 3/16/15.
//  Copyright (c) 2015 Logan Smith. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Drawable.hh"
@class ViewController;

@interface DrawableImageView : UIImageView

@property (nonatomic, assign) Drawable* object;
@property (nonatomic, assign) BOOL tinted;

- (id)initWithFrame:(CGRect)frame object:(Drawable*)obj parent:(ViewController*)viewcontroller;
- (id)initWithObject:(Drawable*)obj parent:(ViewController*)viewcontroller;

@end

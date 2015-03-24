//
//  DrawableImageView.m
//  Chess
//
//  Created by Logan Smith on 3/16/15.
//  Copyright (c) 2015 Logan Smith. All rights reserved.
//

#import "DrawableImageView.hh"
#import "Piece.hh"
#import "ViewController.hh"

@interface DrawableImageView () {
    ViewController* _parent;
}
@end

@implementation DrawableImageView

- (id)initWithFrame:(CGRect)frame object:(Drawable*)obj parent:(ViewController*)viewcontroller
{
    self = [super initWithFrame:frame];
    if (self) {
        self.object = obj;
        self.tinted = NO;
        _parent = viewcontroller;
        
        if( self.object->drawableType() == Drawable::PIECE ) {
            UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
            [self addGestureRecognizer:pan];
        }
    }
    return self;
}

- (id)initWithObject:(Drawable*)obj parent:(ViewController*)viewcontroller
{
    self = [super init];
    if(self) {
        self.object = obj;
        self.tinted = NO;
        _parent = viewcontroller;
        if( self.object->drawableType() == Drawable::PIECE ) {
            UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
            [self addGestureRecognizer:pan];
        }
    }
    return self;
}

- (void)handlePan:(UIPanGestureRecognizer*)sender
{
    if(sender.state == UIGestureRecognizerStateBegan) {
        [_parent eventAtLocationX:self.center.x Y:self.center.y];
        //NSLog(@"began");
    }
    [self.superview bringSubviewToFront:self];
    CGPoint translation = [sender translationInView:self.superview];
    self.center = CGPointMake( self.center.x + translation.x, self.center.y + translation.y );
    [sender setTranslation:CGPointMake(0, 0) inView:self.superview];
    
    if(sender.state == UIGestureRecognizerStateEnded) {
        [_parent eventAtLocationX:self.center.x Y:self.center.y];
        //NSLog(@"ended");
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

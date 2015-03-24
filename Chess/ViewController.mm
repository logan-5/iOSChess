//
//  ViewController.m
//  Chess
//
//  Created by Logan Smith on 3/12/15.
//  Copyright (c) 2015 Logan Smith. All rights reserved.
//

#import "ViewController.hh"
#import "Game.hh"
#import "DrawableImageView.hh"
#import "UIImage+UIImageTint.hh"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *startNewGameButton;
- (IBAction)startNewGame:(id)sender;

@end

@implementation ViewController {
    Game* _game;
    int _screenSizeX, _screenSizeY;
    int _boardOffsetY; // how far down the screen the board is
    int _squareSize;
    int _capturedWhiteY, _capturedBlackY, _capturedSize;
    struct { int blackY = 1, whiteY = -1; } _capturedStackDirection; // which way the captured pieces will 'pile up'
    NSMutableArray *_boardImages, *_capturedWhiteImages, *_capturedBlackImages;
    
    /*
    BOOL _animating;
    int _animationSteps, _animationSpeed;
    NSMutableArray *_animatees;
    struct animObject { DrawableImageView* image; int stepX, stepY, destX, destY; };
    // if an object's coordinates are different from its onscreen coordinates, make an animObject of it and add it to _animatees.  calculate step sizes etc
    // set a timer to animate. reset _animationIndex at the end
    int _animationIndex;*/
    
    float _animationDuration, _animationDelay;
    UIViewAnimationOptions _animationOptions;
    
    float _promotionPanelX, _promotionPanelY;
    UIImageView *_promotionBackground, *_promotionPanel, *_promotionQueen, *_promotionRook, *_promotionKnight, *_promotionBishop;
}

- (void)rotatePieces
{
    double angle = _game->turn() == Piece::WHITE ? 0 : M_PI;
    [UIView animateWithDuration:0.4
                          delay:0.5
                        options:_animationOptions
                     animations:^{
                         for( DrawableImageView *d in _boardImages ) {
                             if( d.object->drawableType() == Drawable::PIECE ) {
                                 d.transform = CGAffineTransformMakeRotation(angle);
                             }
                         }
                     }
                     completion:^(BOOL finished){}];

}

- (void)refreshView
{
    NSMutableArray *imagesToRemoveFromBoard = [[NSMutableArray alloc] init];
    for ( DrawableImageView* d in _boardImages ) {
        if ( d.object->drawableType() == Drawable::PIECE ) {
            // remove captured pieces from this list
            Piece* p = static_cast<Piece*>( d.object );
            if( p->color() == _game->turn() ) {
                d.userInteractionEnabled = YES;
            } else {
                d.userInteractionEnabled = NO;
            }
            if( p->isCaptured() ) { 
                if( p->color() == Piece::BLACK ) {
                    [_capturedBlackImages addObject:d];
                } else {
                    [_capturedWhiteImages addObject:d];
                } // trying to kick my addiction to ternary operators, one if-else at a time
                [imagesToRemoveFromBoard addObject:d];
                continue;
            }
            // possibly tint the selected piece an ugly color
            if( _game->selectionIs( p ) ) {
                // set the image to a new tinted image
                NSString* fileName = [NSString stringWithUTF8String:d.object->fileName().c_str()];
                [d setImage:[UIImage imageNamed:fileName withColor:[UIColor colorWithRed:128 green:128 blue:0 alpha:0.5]]];
                d.tinted = YES;
            } else if ( d.tinted == YES ) {
                // reset the image to an untinted version
                NSString* fileName = [NSString stringWithUTF8String:d.object->fileName().c_str()];
                [d setImage:[UIImage imageNamed:fileName]];
                d.tinted = NO;
            }
        }
        //[d setFrame:CGRectMake( d.object->x() * _squareSize, d.object->y() * _squareSize + _boardOffsetY, _squareSize, _squareSize )];
    }
    // remove images that were flagged to be removed
    for ( DrawableImageView* d in imagesToRemoveFromBoard ) {
        [_boardImages removeObject:d];
    }
    
    [UIView animateWithDuration:_animationDuration
                          delay:_animationDelay
                        options:_animationOptions
                     animations:^{
                         for( DrawableImageView* d in _boardImages ) {
                             if( d.object->x() * _squareSize != d.frame.origin.x || d.object->y() * _squareSize + _boardOffsetY != d.frame.origin.y ) {
                                 CGRect destination = d.frame;
                                 destination.origin.x = d.object->x() * _squareSize;
                                 destination.origin.y = d.object->y() * _squareSize + _boardOffsetY;
                                 [d setFrame:destination];
                             }
                         }
                     }
                     completion:^(BOOL finished) {
                         // now draw the captured pieces off to the top and bottom sides of the screen
                         for( int i = 0; i < [_capturedWhiteImages count]; ++i ) {
                             [[_capturedWhiteImages objectAtIndex:i] setFrame:CGRectMake( i * _capturedSize, _capturedWhiteY, _capturedSize, _capturedSize ) ];
                         }
                         for( int i = 0; i < [_capturedBlackImages count]; ++i ) {
                             [[_capturedBlackImages objectAtIndex:i] setFrame:CGRectMake( i * _capturedSize, _capturedBlackY, _capturedSize, _capturedSize ) ];
                         }
                         
                         if( _game->checkMate() ) {
                             _turnLabel.text = @"CHEcKmAtE!";
                             self.startNewGameButton.hidden = NO;
                         } else if ( _game->staleMate() ) {
                             _turnLabel.text = @"stay lmate";
                             self.startNewGameButton.hidden = NO;
                         } else if( _game->check() ) {
                             _turnLabel.text = @"CHECK!!";
                         } else if( _game->turn() == Piece::WHITE ) {
                             _turnLabel.text = @"White's turn";
                         } else {
                             _turnLabel.text = @"Black's turn";
                         }
                         
                         [self rotatePieces];
                     }];
    
    if( _game->status() == Game::PROMOTED ) {
        _promotionBackground = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _screenSizeX, _screenSizeY)];
        _promotionBackground.image = [UIImage imageNamed:@"whitesquare.png"];
        _promotionBackground.alpha = 0;
        [self.view addSubview:_promotionBackground];
        
        float rightBoundary = _screenSizeX - 2 * _promotionPanelX;
        float padding = ( ( rightBoundary /*- _promotionPanelX*/ ) - ( 4 * _squareSize ) ) / 5;
        _promotionPanel = [[UIImageView alloc] initWithFrame:CGRectMake(_promotionPanelX, _promotionPanelY, rightBoundary, _screenSizeY - 2 * _promotionPanelY )];
        _promotionPanel.image = [UIImage imageNamed:@"blacksquare.png"];
        _promotionPanel.alpha = 0;
        [self.view addSubview:_promotionPanel];
        
        _promotionQueen = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _squareSize, _squareSize)];
        _promotionQueen.image = [UIImage imageNamed:(_game->turn() == Piece::WHITE ? @"whitequeen.png" : @"blackqueen.png")];
        _promotionQueen.center = CGPointMake(_promotionPanelX + padding + _squareSize * 1 / 2 , _screenSizeY / 2);
        _promotionQueen.alpha = 0;
        [self.view addSubview:_promotionQueen];
        
        _promotionRook = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _squareSize, _squareSize)];
        _promotionRook.image = [UIImage imageNamed:(_game->turn() == Piece::WHITE ? @"whiterook.png" : @"blackrook.png")];
        _promotionRook.center = CGPointMake(_promotionPanelX + 2 * padding + _squareSize * 3 / 2, _screenSizeY / 2);
        _promotionRook.alpha = 0;
        [self.view addSubview:_promotionRook];
        
        _promotionKnight = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _squareSize, _squareSize)];
        _promotionKnight.image = [UIImage imageNamed:(_game->turn() == Piece::WHITE ? @"whiteknight.png" : @"blackknight.png")];
        _promotionKnight.center = CGPointMake(_promotionPanelX + 3 * padding + _squareSize * 5 / 2, _screenSizeY / 2);
        _promotionKnight.alpha = 0;
        [self.view addSubview:_promotionKnight];
        
        _promotionBishop = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _squareSize, _squareSize)];
        _promotionBishop.image = [UIImage imageNamed:(_game->turn() == Piece::WHITE ? @"whitebishop.png" : @"blackbishop.png")];
        _promotionBishop.center = CGPointMake(_promotionPanelX + 4 * padding + _squareSize * 7 / 2, _screenSizeY / 2);
        _promotionBishop.alpha = 0;
        [self.view addSubview:_promotionBishop];
        
        [UIView animateWithDuration:0.2
                              delay:0.1
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             _promotionBackground.alpha = 0.5;
                             _promotionPanel.alpha = 0.7;
                             _promotionQueen.alpha = 1;
                             _promotionRook.alpha = 1;
                             _promotionKnight.alpha = 1;
                             _promotionBishop.alpha = 1;
                         }
                         completion:^(BOOL finished) {}];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    /*
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ) {
        _screenSizeX = 1024;
        _screenSizeY = 768;
    } else {
        _screenSizeX = 320;
        _screenSizeY = 460; // lucky guess
    }*/
    
    [self initGame];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)clearPromotedImages
{
    [UIView animateWithDuration:0.2
                          delay:.1 options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         _promotionBackground.alpha = 0;
                         _promotionPanel.alpha = 0;
                         _promotionQueen.alpha = 0;
                         _promotionRook.alpha = 0;
                         _promotionKnight.alpha = 0;
                         _promotionBishop.alpha = 0;
                     }
                     completion:^(BOOL finished) {
                         [_promotionBackground removeFromSuperview];
                         [_promotionPanel removeFromSuperview];
                         [_promotionQueen removeFromSuperview];
                         [_promotionRook removeFromSuperview];
                         [_promotionKnight removeFromSuperview];
                         [_promotionBishop removeFromSuperview];
                     }
     ];
}

- (void)promoteTo:(Game::promotion_e)piece
{
    DrawableImageView *newPiece = [[DrawableImageView alloc] initWithObject:_game->promotePieceTo( piece ) parent:self];
    [newPiece setFrame:CGRectMake(newPiece.object->x() * _squareSize, newPiece.object->y() * _squareSize + _boardOffsetY, _squareSize, _squareSize)];
    NSString* fileName = [NSString stringWithUTF8String:newPiece.object->fileName().c_str()];
    newPiece.image = [UIImage imageNamed:fileName];
    [_boardImages addObject:newPiece];
    NSMutableArray *removeList = [[NSMutableArray alloc] init];
    for( DrawableImageView* d in _boardImages ) {
        if( _game->promoteeIs( d.object ) ) {
            d.hidden = true;
            [removeList addObject:d];
        }
    }
    for( DrawableImageView *d in removeList ) {
        [_boardImages removeObject:d];
    }
    [self.view addSubview:newPiece];
    [self.view bringSubviewToFront:newPiece];
    [self clearPromotedImages];
    [self refreshView];
}

- (IBAction)receiveTap:(id)sender
{
    UITapGestureRecognizer* tap = (UITapGestureRecognizer*)sender;
    CGPoint location = [tap locationInView:self.view];
    if( _game->status() == Game::PROMOTED ) {
        // if a pawn was promoted, do out-of-the-ordinary stuff
        if( CGRectContainsPoint(_promotionQueen.frame, location) ) {
            [self promoteTo:Game::QUEEN];
        } else if( CGRectContainsPoint(_promotionRook.frame, location) ) {
            [self promoteTo:Game::ROOK];
        } else if( CGRectContainsPoint(_promotionKnight.frame, location) ) {
            [self promoteTo:Game::KNIGHT];
        } else if( CGRectContainsPoint(_promotionBishop.frame, location) ) {
            [self promoteTo:Game::BISHOP];
        }
    } else {
        [self eventAtLocationX:location.x Y:location.y];
    }
}

- (void)eventAtLocationX:(int)x Y:(int)y
{
    int squareX = x / _squareSize, squareY = ( y - _boardOffsetY ) / _squareSize;
    if( squareX >= 0 && squareX < 8 && squareY >= 0 && squareY < 8 ) {
        _game->eventOnSquare( squareX, squareY );
    }
    
    [self refreshView];
}

/*
- (void)moveImage:(DrawableImageView *)image duration:(NSTimeInterval)duration x:(CGFloat)x y:(CGFloat)y
{
    // Setup the animation
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:duration];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    // The transform matrix
    CGAffineTransform transform = CGAffineTransformMakeTranslation(x, y);
    image.transform = transform;
    
    // Commit the changes
    [UIView commitAnimations];
    
}*/

- (IBAction)startNewGame:(id)sender
{
    delete _game;
    self.startNewGameButton.hidden = YES;
    [[self.view subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self initGame];
}

- (void)initGame
{
    _screenSizeX = self.view.bounds.size.width;
    _screenSizeY = self.view.bounds.size.height;
    _squareSize = fmin( _screenSizeX, _screenSizeY ) / 8;
    _boardOffsetY = _screenSizeY / 2 - 4 * _squareSize;
    _capturedSize = _squareSize * 2 / 3;
    _capturedWhiteY = 0;
    _capturedBlackY = _screenSizeY - _capturedSize;
    _promotionPanelX = _screenSizeX * 1 / 6;
    _promotionPanelY = _screenSizeY * 5 / 12;
    _game = new Game( _squareSize ); // DO I NEED TO BE AFRAID OF THIS?
    _boardImages = [[NSMutableArray alloc] init];
    _capturedBlackImages = [[NSMutableArray alloc] init];
    _capturedWhiteImages = [[NSMutableArray alloc] init];
    
    /*
     _animating = NO;
     _animationSteps = 8;
     _animationSpeed = 10; // no idea
     _animationIndex = 0;*/
    _animationDuration = 0.2;
    _animationDelay = 0.0;
    _animationOptions = UIViewAnimationOptionCurveEaseInOut;
    
    std::vector<Drawable*> drawables = _game->getDrawables();
    for( auto it = drawables.begin(); it != drawables.end(); ++it ) {
        uint8_t x = ( *it )->x(), y = ( *it )->y();
        DrawableImageView* square = [[DrawableImageView alloc] initWithFrame:CGRectMake( x * _squareSize, y *_squareSize + _boardOffsetY, _squareSize, _squareSize) object:*it parent:self];
        
        NSString* fileName = [NSString stringWithUTF8String:( *it )->fileName().c_str()];
        square.image = [UIImage imageNamed:fileName];
        
        [self.view addSubview:square];
        if( ( *it )->drawableType() == Drawable::SQUARE ) {
            [self.view sendSubviewToBack:square]; // so squares appear behind pieces
        } else {
            Piece* p = static_cast<Piece*>( *it );
            if( p->color() == _game->turn() ) {
                square.userInteractionEnabled = YES;
            } else {
                square.userInteractionEnabled = NO;
            }
        }
        [_boardImages addObject:square];
    }
    
    if( _game->checkMate() ) {
        _turnLabel.text = @"CHEcKmAtE!";
        self.startNewGameButton.hidden = NO;
    } else if ( _game->staleMate() ) {
        _turnLabel.text = @"stay lmate";
        self.startNewGameButton.hidden = NO;
    } else if( _game->check() ) {
        _turnLabel.text = @"CHECK!!";
    } else if( _game->turn() == Piece::WHITE ) {
        _turnLabel.text = @"White's turn";
    } else {
        _turnLabel.text = @"Black's turn";
    }
}

@end

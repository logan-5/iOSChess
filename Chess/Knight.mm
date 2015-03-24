//
//  Knight.cpp
//  Chess
//
//  Created by Logan Smith on 3/13/15.
//  Copyright (c) 2015 Logan Smith. All rights reserved.
//

#include "Knight.hh"

Piece::squarelist_t Knight::getMoveOptions( bool testMove ) const {
    squarelist_t options;
    
    // up
    int y = _currentSquare->y() - 2, x;
    if( y >= 0 ) {
        x = _currentSquare->x();
        if( x - 1 >= 0 ) {
            Square* s = ( ( *_board )( x - 1, y ) );
            options.push_back( s );
            addToCaptureTargets( *s, testMove );
        }
        if( x + 1 < _board->sizeX() ) {
            Square* s = ( ( *_board )( x + 1, y ) );
            options.push_back( s );
            addToCaptureTargets( *s, testMove );
        }
    }
    
    // down
    y = _currentSquare->y() + 2;
    if( y < _board->sizeY() ) {
        x = _currentSquare->x();
        if( x - 1 >= 0 ) {
            Square* s = ( ( *_board )( x - 1, y ) );
            options.push_back( s );
            addToCaptureTargets( *s, testMove );
        }
        if( x + 1 < _board->sizeX() ) {
            Square* s = ( ( *_board )( x + 1, y ) );
            options.push_back( s );
            addToCaptureTargets( *s, testMove );
        }
    }
    
    // left
    x = _currentSquare->x() - 2;
    if( x >= 0 ) {
        y = _currentSquare->y();
        if( y - 1 >= 0 ) {
            Square* s = ( ( *_board )( x, y - 1 ) );
            options.push_back( s );
            addToCaptureTargets( *s, testMove );
        }
        if( y + 1 < _board->sizeY() ) {
            Square* s = ( ( *_board )( x, y + 1 ) );
            options.push_back( s );
            addToCaptureTargets( *s, testMove );
        }
    }
    
    // right
    x = _currentSquare->x() + 2;
    if( x < _board->sizeX() ) {
        y = _currentSquare->y();
        if( y - 1 >= 0 ) {
            Square* s = ( ( *_board )( x, y - 1 ) );
            options.push_back( s );
            addToCaptureTargets( *s, testMove );
        }
        if( y + 1 < _board->sizeX() ) {
            Square* s = ( ( *_board )( x, y + 1 ) );
            options.push_back( s );
            addToCaptureTargets( *s, testMove );
        }
    }    
    
    return options;
}
//
//  Bishop.cpp
//  Chess
//
//  Created by Logan Smith on 3/12/15.
//  Copyright (c) 2015 Logan Smith. All rights reserved.
//

#include "Bishop.hh"
#include <vector>

Piece::squarelist_t Bishop::getMoveOptions( bool testMove ) const {
    squarelist_t options;
    
    // up left
    int x = _currentSquare->x() - 1, y = _currentSquare->y() - 1;
    while( inBounds( x, _board->sizeX() ) && inBounds( y, _board->sizeY() ) && !isSameColorAs( ( *_board )( x, y )->occupier() ) ) {
        Square* s = ( ( *_board )( x--, y-- ) );
        options.push_back( s );
        addToCaptureTargets( *s, testMove );
        if( s->isOccupied() ) { break; }
    }
    
    // up right
    x = _currentSquare->x() + 1, y = _currentSquare->y() - 1;
    while( inBounds( x, _board->sizeX() ) && inBounds( y, _board->sizeY() ) && !isSameColorAs( ( *_board )( x, y )->occupier() ) ) {
        Square* s = ( ( *_board )( x++, y-- ) );
        options.push_back( s );
        addToCaptureTargets( *s, testMove );
        if( s->isOccupied() ) { break; }
    }
    
    // down left
    x = _currentSquare->x() - 1, y = _currentSquare->y() + 1;
    while( inBounds( x, _board->sizeX() ) && inBounds( y, _board->sizeY() ) && !isSameColorAs( ( *_board )( x, y )->occupier() ) ) {
        Square* s = ( ( *_board )( x--, y++ ) );
        options.push_back( s );
        addToCaptureTargets( *s, testMove );
        if( s->isOccupied() ) { break; }
    }
    
    // down right
    x = _currentSquare->x() + 1, y = _currentSquare->y() + 1;
    while( inBounds( x, _board->sizeX() ) && inBounds( y, _board->sizeY() ) && !isSameColorAs( ( *_board )( x, y )->occupier() ) ) {
        Square* s = ( ( *_board )( x++, y++ ) );
        options.push_back( s );
        addToCaptureTargets( *s, testMove );
        if( s->isOccupied() ) { break; }
    }
    
    return options;
}
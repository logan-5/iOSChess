//
//  Rook.cpp
//  Chess
//
//  Created by Logan Smith on 3/12/15.
//  Copyright (c) 2015 Logan Smith. All rights reserved.
//

#include "Rook.hh"
#include "Square.hh"

Piece::squarelist_t Rook::getMoveOptions( bool testMove ) const {
    squarelist_t options;
    
    // vertical up
    int y = _currentSquare->y() - 1;
    while( inBounds( y, _board->sizeY() ) && !isSameColorAs( ( *_board )( _currentSquare->x(), y )->occupier() ) ) {
        Square* s = ( *_board )( _currentSquare->x(), y-- );
        options.push_back( s );
        addToCaptureTargets( *s, testMove );
        if( s->isOccupied() ) { break; } // if we added this piece because there was an enemy piece in the square, stop here so we can't move 'past' the enemy piece
    }
    
    // vertical down
    y = _currentSquare->y() + 1;
    while( inBounds( y, _board->sizeY() ) && !isSameColorAs( ( *_board )( _currentSquare->x(), y )->occupier() ) ) {
        Square* s = ( *_board )( _currentSquare->x(), y++ );
        options.push_back( s );
        addToCaptureTargets( *s, testMove );
        if( s->isOccupied() ) { break; }
    }
    
    // horizontal left
    int x = _currentSquare->x() - 1;
    while( inBounds( x, _board->sizeX() ) && !isSameColorAs( ( *_board )( x, _currentSquare->y() )->occupier() ) ) {
        Square* s = ( *_board )( x--, _currentSquare->y() );
        options.push_back( s );
        addToCaptureTargets( *s, testMove );
        if( s->isOccupied() ) { break; }
    }
    
    // horizontal right
    x = _currentSquare->x() + 1;
    while( inBounds( x, _board->sizeX() )  && !isSameColorAs( ( *_board )( x, _currentSquare->y() )->occupier() ) ) {
        Square* s = ( *_board )( x++, _currentSquare->y() );
        options.push_back( s );
        addToCaptureTargets( *s, testMove );
        if( s->isOccupied() ) { break; }
    }
    
    return options;
}

void Rook::forceMoveTo( Square &s ) {
    _currentSquare->deoccupy();
    _currentSquare = &s;
    s.occupyWith( *this ); // kyle reference
}
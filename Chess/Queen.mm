//
//  Queen.cpp
//  Chess
//
//  Created by Logan Smith on 3/13/15.
//  Copyright (c) 2015 Logan Smith. All rights reserved.
//

#include "Queen.hh"

Piece::squarelist_t Queen::getMoveOptions( bool testMove ) const {
    squarelist_t options;
    
    { // vertical/horizontal
        // vertical up
        int y = _currentSquare->y() - 1;
        while( inBounds( y, _board->sizeY() ) && !isSameColorAs( ( *_board )( _currentSquare->x(), y )->occupier() ) ) {
            Square* s = ( *_board )( _currentSquare->x(), y-- );
            options.push_back( s );
            addToCaptureTargets( *s, testMove );
            if( s->isOccupied() ) { break; }
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
    }
    
    { // diagonal
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
    }
    
    return options;
}
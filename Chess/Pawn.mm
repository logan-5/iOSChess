//
//  Pawn.cpp
//  Chess
//
//  Created by Logan Smith on 3/13/15.
//  Copyright (c) 2015 Logan Smith. All rights reserved.
//

#include "Pawn.hh"

bool Pawn::moveToSquareIfPossible( Square &s ) {
        // if the x coordinate of the square is different, it must be a diagonal capture
        if( s.x() != this->x() ) {
            if( s._occupied ) { // normal capture
                s.occupier()->capture(); // o frik
            } else {            // en passant
                Square& s2 = *( *_board )( s.x(), this->y() );
                s2.occupier()->capture();
            }
        }
        _currentSquare->deoccupy();
        _currentSquare = &s;
        s.occupyWith( *this ); // kyle reference
        if ( !_hasMoved ) {
            _hasMoved = true;
            _movedOnce = true;
        } else if( _movedOnce ) {
            _movedOnce = false;
        }
        return true;
}

Piece::squarelist_t Pawn::getMoveOptions( bool testMove ) const {
    squarelist_t options;
    
    int moveDirection;
    if ( _color == Piece::BLACK ) {
        moveDirection = move_direction::BLACK;
    } else {
        moveDirection = move_direction::WHITE;
    }
    int exclusiveBounds = ( moveDirection == move_direction::WHITE ) ? -1 : _board->sizeY();
    
    int y = _currentSquare->y(), x = _currentSquare->x();
    if( y + moveDirection != exclusiveBounds &&
       !( *_board )( x, y + moveDirection )->isOccupied()) {
        options.push_back( ( *_board )( x, y + moveDirection ) );
    
        // double move if it's the first move (but only if the single move was possible too)
        if( !_hasMoved && y + ( moveDirection * 2 ) != exclusiveBounds &&
           !( *_board )( x, y + ( moveDirection * 2 ) )->isOccupied()) {
            options.push_back( ( *_board )( x, y + ( moveDirection * 2) ) );
        }
    }
    
    // en passant
    // 1. check if we're in the appropriate row for it to be possible
    // 2. check if there's a piece immediately to our right or left whose _movedOnce == true
    // 3. add the square to move options.  capture the piece in moveToSquareIfPossible( Square& s )
    if( ( _color == Piece::WHITE && _currentSquare->y() == 3 ) ||
       ( _color == Piece::BLACK && _currentSquare->y() == 4 ) ) {
        if( x - 1 > 0 && ( *_board )( x - 1, y )->isOccupied() ) {
            Pawn* other = dynamic_cast<Pawn*>( ( *_board )( x - 1, y )->occupier() );
            if( other != nullptr && other->movedOnce() ) {
                Square* s = ( ( *_board )( x - 1, y + moveDirection ) );
                options.push_back( s );
                //addToCaptureTargets( *s, testMove );
            }
        }
        if( x + 1 <= _board->sizeX() && ( *_board )( x + 1, y )->isOccupied() ) {
            Pawn* other = dynamic_cast<Pawn*>( ( *_board )( x + 1, y )->occupier() );
            if( other != nullptr && other->movedOnce() ) {
                Square* s = ( ( *_board )( x + 1, y + moveDirection ) );
                options.push_back( s );
                //addToCaptureTargets( *s, testMove );
            }
        }
    }
    
    // pawn capturing
    y = _currentSquare->y() + moveDirection;
    if( y != exclusiveBounds && x - 1 >= 0 && x - 1 < _board->sizeX() && ( *_board )( x - 1, y )->isOccupied()) {
        // there's a piece on our diagonal left!  we can move there if it's an enemy (that's checked later in Pawn::moveToSquareIfPossible( Square& s )
        Square* s = ( ( *_board )( x - 1, y ) );
        options.push_back( s );
        addToCaptureTargets( *s, testMove );
    }
    if( y != exclusiveBounds && x + 1 >= 0 && x + 1 < _board->sizeX() && ( *_board )( x + 1, y )->isOccupied()) {
        // there's a piece on our diagonal right!  we can move there if it's an enemy (that's checked later in Pawn::moveToSquareIfPossible( Square& s )
        Square* s = ( ( *_board )( x + 1, y ) );
        options.push_back( s );
        addToCaptureTargets( *s, testMove );
    }
    
    return options;
}
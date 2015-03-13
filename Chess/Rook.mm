//
//  Rook.cpp
//  Chess
//
//  Created by Logan Smith on 3/12/15.
//  Copyright (c) 2015 Logan Smith. All rights reserved.
//

#include "Rook.hh"

bool Rook::moveToSquareIfPossible( Square &s ) {
    bool success = Piece::moveToSquareIfPossible( s );
    if( success ) {
        _hasMoved = true;
    }
    return success;
}

std::vector<Square*> Rook::getMoveOptions() const {
    std::vector<Square*> options;
    
    // vertical up
    int y = _currentSquare->y();
    while( y >= 0 && !( *_board )( _currentSquare->x(), y ).isOccupied() ) {
        options.push_back( &( *_board )( _currentSquare->x(), y-- ) );
    }
    
    // vertical down
    y = _currentSquare->y();
    while( y < _board->sizeY() && !( *_board )( _currentSquare->x(), y ).isOccupied() ) {
        options.push_back( &( *_board )( _currentSquare->x(), y++ ) );
    }
    
    // horizontal left
    int x = _currentSquare->x();
    while( x >= 0 && !( *_board )( x, _currentSquare->y() ).isOccupied() ) {
        options.push_back( &( *_board )( x--, _currentSquare->y() ) );
    }
    
    // horizontal right
    x = _currentSquare->x();
    while( x < _board->sizeX() && !( *_board )( x, _currentSquare->y() ).isOccupied() ) {
        options.push_back( &( *_board )( x++, _currentSquare->y() ) );
    }
    
    return options;
}
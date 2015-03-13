//
//  Bishop.cpp
//  Chess
//
//  Created by Logan Smith on 3/12/15.
//  Copyright (c) 2015 Logan Smith. All rights reserved.
//

#include "Bishop.hh"
#include <vector>

std::vector<Square*> Bishop::getMoveOptions() const {
    std::vector<Square*> options;
    
    // up left
    int x = _currentSquare->x(), y = _currentSquare->y();
    while( y >= 0 && !( *_board )( x, y ).isOccupied() ) {
        options.push_back( &( *_board )( x--, y-- ) );
    }
    
    // up right
    x = _currentSquare->x(), y = _currentSquare->y();
    while( y < _board->sizeY() && !( *_board )( x, y ).isOccupied() ) {
        options.push_back( &( *_board )( x++, y-- ) );
    }
    
    // down left
    x = _currentSquare->x(), y = _currentSquare->y();
    while( x >= 0 && !( *_board )( x, y ).isOccupied() ) {
        options.push_back( &( *_board )( x--, y++ ) );
    }
    
    // down right
    x = _currentSquare->x(), y = _currentSquare->y();
    while( x < _board->sizeX() && !( *_board )( x, y ).isOccupied() ) {
        options.push_back( &( *_board )( x++, y++ ) );
    }
    
    return options;
}
//
//  Piece.cpp
//  Chess
//
//  Created by Logan Smith on 3/12/15.
//  Copyright (c) 2015 Logan Smith. All rights reserved.
//

#include "Piece.hh"

bool Piece::moveToSquareIfPossible( Square &s ) {
    if( s._occupied ) {
        // todo: capture pieces
        return false;
    } else {
        std::vector<Square*> possibleMoves = getMoveOptions();
        
        // if the desired square is in the list of possible move options, move to it.  otherwise, don't move and return false
        for( Square* move : possibleMoves ) {
            if( move == &s ) {
                _currentSquare = &s;
                s.occupyWith( *this ); // kyle reference
                return true;
            }
        }
        return false;
    }
}
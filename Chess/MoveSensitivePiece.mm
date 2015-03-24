//
//  MoveSensitivePiece.c
//  Chess
//
//  Created by Logan Smith on 3/14/15.
//  Copyright (c) 2015 Logan Smith. All rights reserved.
//

#include "MoveSensitivePiece.hh"

bool MoveSensitivePiece::moveToSquareIfPossible( Square &s ) {
    bool success = Piece::moveToSquareIfPossible( s );
    if( success ) {
        _hasMoved = true;
    }
    return success;
}
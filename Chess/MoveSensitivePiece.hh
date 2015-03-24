//
//  MoveSensitive.h
//  Chess
//
//  Created by Logan Smith on 3/13/15.
//  Copyright (c) 2015 Logan Smith. All rights reserved.
//

#pragma once
#ifndef Chess_MoveSensitive_h
#define Chess_MoveSensitive_h
#include "Piece.hh"

class MoveSensitivePiece : public Piece {
public:
    MoveSensitivePiece( Board* board, color_e color, Square* currentSquare, std::string fileName ) : Piece( board, color, currentSquare, fileName ), _hasMoved( false ) {}
    virtual ~MoveSensitivePiece() {}
    bool hasMoved() { return _hasMoved; }
    bool moveToSquareIfPossible( Square &s );
    virtual squarelist_t getMoveOptions( bool testMove = false ) const = 0;
    
protected:
    bool _hasMoved;
    struct move_direction { static const int WHITE = -1; static const int BLACK = 1; };
};

#endif

//
//  Rook.h
//  Chess
//
//  Created by Logan Smith on 3/12/15.
//  Copyright (c) 2015 Logan Smith. All rights reserved.
//

#pragma once
#ifndef __Chess__Rook__
#define __Chess__Rook__
#include "Piece.hh"
#include <vector>

class Rook : public Piece {
public:
    Rook( Board* board, color_e color, Square* currentSquare ) : Piece( board, color, currentSquare ), _hasMoved( false ) {}
    ~Rook() {}
    bool hasMoved() { return _hasMoved; }
    std::vector<Square*> getMoveOptions() const;
    bool moveToSquareIfPossible( Square& s );
    
private:
    bool _hasMoved; // keep track of whether this rook has moved, for castles
};

#endif /* defined(__Chess__Rook__) */

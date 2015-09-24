//
//  Pawn.h
//  Chess
//
//  Created by Logan Smith on 3/13/15.
//  Copyright (c) 2015 Logan Smith. All rights reserved.
//

#pragma once
#ifndef __Chess__Pawn__
#define __Chess__Pawn__
#include "MoveSensitivePiece.hh"

class Pawn : public MoveSensitivePiece { 
public:
    Pawn( Board* board, color_e color, Square* currentSquare ) : MoveSensitivePiece( board, color, currentSquare, color == color_e::BLACK ? "blackpawn.png" : "whitepawn.png" ), _movedOnce( false ) {}
    ~Pawn() {}
    bool movedOnce() { return _movedOnce; }
    squarelist_t getMoveOptions( bool testMove = false ) const override;
    bool moveToSquareIfPossible( Square& s ) override;
    void update() { if( _movedOnce ) { _movedOnce = false; } }
    
private:
    bool _movedOnce; // for en passant
};

#endif /* defined(__Chess__Pawn__) */

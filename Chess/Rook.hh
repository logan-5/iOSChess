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
#include "MoveSensitivePiece.hh"

class Rook : public MoveSensitivePiece {
public:
    Rook( Board* board, color_e color, Square* currentSquare ) : MoveSensitivePiece( board, color, currentSquare, color == color_e::BLACK ? "blackrook.png" : "whiterook.png" ) {}
    ~Rook() {}
    squarelist_t getMoveOptions( bool testMove = false ) const;
    void forceMoveTo( Square& s );
    
private:
};

#endif /* defined(__Chess__Rook__) */

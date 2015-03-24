//
//  Knight.h
//  Chess
//
//  Created by Logan Smith on 3/13/15.
//  Copyright (c) 2015 Logan Smith. All rights reserved.
//

#pragma once
#ifndef __Chess__Knight__
#define __Chess__Knight__
#include "Piece.hh"

class Knight : public Piece {
public:
    Knight( Board* board, color_e color, Square* currentSquare ) : Piece( board, color, currentSquare, color == color_e::BLACK ? "blackknight.png" : "whiteknight.png" ) {}
    ~Knight() {}
    squarelist_t getMoveOptions( bool testMove = false ) const;
    
private:
};

#endif /* defined(__Chess__Knight__) */

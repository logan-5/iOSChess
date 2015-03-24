//
//  Queen.h
//  Chess
//
//  Created by Logan Smith on 3/13/15.
//  Copyright (c) 2015 Logan Smith. All rights reserved.
//

#pragma once
#ifndef __Chess__Queen__
#define __Chess__Queen__

#include "Piece.hh"

class Queen : public Piece {
public:
    Queen( Board* board, color_e color, Square* currentSquare ) : Piece( board, color, currentSquare, color == color_e::BLACK ? "blackqueen.png" : "whitequeen.png" ) {}
    ~Queen() {}
    squarelist_t getMoveOptions( bool testMove = false ) const;
    
private:
};

#endif /* defined(__Chess__Queen__) */

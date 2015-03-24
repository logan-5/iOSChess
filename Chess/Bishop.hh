//
//  Bishop.h
//  Chess
//
//  Created by Logan Smith on 3/12/15.
//  Copyright (c) 2015 Logan Smith. All rights reserved.
//

#pragma once
#ifndef __Chess__Bishop__
#define __Chess__Bishop__

#include "Piece.hh"

class Bishop : public Piece {
public:
    Bishop( Board* board, color_e color, Square* currentSquare ) : Piece( board, color, currentSquare, color == color_e::BLACK ? "blackbishop.png" : "whitebishop.png" ) {}
    ~Bishop() {}
    squarelist_t getMoveOptions( bool testMove = false ) const;
    
private:
};

#endif /* defined(__Chess__Bishop__) */

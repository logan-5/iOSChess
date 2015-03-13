//
//  Piece.h
//  Chess
//
//  Created by Logan Smith on 3/12/15.
//  Copyright (c) 2015 Logan Smith. All rights reserved.
//

#pragma once
#ifndef __Chess__Piece__
#define __Chess__Piece__

#include "Square.hh"
#include "Board.hh"
#include <vector>

class Piece {
    friend class Square;
public:
    enum color_e { BLACK = 0, WHITE = 0 };
    Piece( Board* board, color_e color, Square* square ) : _board( board ), _color( color ), _currentSquare( square ) {}
    virtual ~Piece() {}
    color_e color() { return _color; }
    virtual std::vector<Square*> getMoveOptions() const = 0;
    virtual bool moveToSquareIfPossible( Square& s );
    
protected:
    Board* _board;
    Square* _currentSquare;
    color_e _color;
};

#endif /* defined(__Chess__Piece__) */

//
//  Board.h
//  Chess
//
//  Created by Logan Smith on 3/12/15.
//  Copyright (c) 2015 Logan Smith. All rights reserved.
//
#pragma once
#ifndef __Chess__Board__
#define __Chess__Board__
#include "Square.hh"
#include <stdint.h>
#include <vector>

class Board {
public:
    Board();
    ~Board() {}
    Square& operator() (uint8_t x, uint8_t y) { return _board[x][y]; }
    int sizeX() { return 8; }
    int sizeY() { return 8; }
    
private:
    std::vector<std::vector<Square>> _board;
};

#endif /* defined(__Chess__Board__) */

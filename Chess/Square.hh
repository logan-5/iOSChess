//
//  Square.h
//  Chess
//
//  Created by Logan Smith on 3/12/15.
//  Copyright (c) 2015 Logan Smith. All rights reserved.
//

#pragma once
#ifndef _SQUARE_H_
#define _SQUARE_H_
#include <stdint.h>

class Piece;

class Square {
    friend class Piece;
public:
    enum color_e { BLACK = 0, WHITE = 1 };
    Square( color_e color, uint8_t x, uint8_t y ) : _color( color ), _occupied( false ), _x( x ), _y( y ),  _occupier( nullptr ) {}
    ~Square() {}
    color_e color() { return _color; }
    uint8_t x() { return _x; }
    uint8_t y() { return _y; }
    bool isOccupied() { return _occupied; }
    bool occupyWith( Piece& p );
    void deoccupy();
    
private:
    color_e _color;
    bool _occupied;
    Piece* _occupier;
    uint8_t _x, _y;
};

#endif
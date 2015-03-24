//
//  Drawable.h
//  Chess
//
//  Created by Logan Smith on 3/14/15.
//  Copyright (c) 2015 Logan Smith. All rights reserved.
//

#pragma once
#ifndef Chess_Drawable_h
#define Chess_Drawable_h
#include <string>

struct Drawable {
public:
    enum type_e { SQUARE, PIECE };
    Drawable( std::string fileName, type_e type ) : _fileName( fileName ), _type( type ) {}
    virtual ~Drawable() {}
    std::string fileName() { return _fileName; }
    type_e drawableType() { return _type; }
    virtual uint8_t x() = 0; // x() and y() should return grid coordinates, not screen coordinates
    virtual uint8_t y() = 0;
    
private:
    std::string _fileName;
    type_e _type;
};

#endif

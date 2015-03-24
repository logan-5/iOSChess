//
//  Square.m
//  Chess
//
//  Created by Logan Smith on 3/12/15.
//  Copyright (c) 2015 Logan Smith. All rights reserved.
//

#include "Square.hh"

bool Square::occupyWith( Piece &p ) {
    if ( _occupied ) {
        return false;
    } else {
        _occupier = &p;
        _occupied = true;
        return true;
    }
}

void Square::deoccupy() {
    if( !_occupied ) {
        return;
    } else {
        _occupied = false;
        _occupier = nullptr;
    }
}
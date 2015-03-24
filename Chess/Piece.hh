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


#include "Board.hh"
#include "Drawable.hh"
#include <vector>

class Piece : public Drawable {
    friend class Square;
    friend class Piece;
    friend class Pawn;
    friend class King;
public:
    typedef std::vector<Square*> squarelist_t;
    enum color_e { BLACK = -1, WHITE = 1 };
    Piece( Board* board, color_e color, Square* square, std::string fileName ) : _board( board ), _color( color ), _currentSquare( square ), Drawable( fileName, Drawable::PIECE ), _captured( false ) {
        _currentSquare->occupyWith(*this);
    }
    virtual ~Piece() {}
    color_e color() { return _color; }
    Square* currentSquare() { return _currentSquare; }
    uint8_t x();
    uint8_t y();
    bool isCaptured() { return _captured; }
    virtual squarelist_t getMoveOptions( bool testMove = false ) const = 0;
    void setMoveOptions() { } // maybe use this so we can remember the options later
    virtual bool moveToSquareIfPossible( Square& s );
    
protected:
    Board* _board;
    Square* _currentSquare;
    color_e _color;
    bool _captured;
    
    bool isSameColorAs( Piece* p ) const;
    bool inBounds(uint8_t num, int upperBound) const { return num >= 0 && num < upperBound; }
    void addToCaptureTargets( Square& s, bool testMove ) const;
    
private:
    void capture() { _captured = true; _currentSquare->deoccupy(); }
};

#endif /* defined(__Chess__Piece__) */

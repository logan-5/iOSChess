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
#include <stdint.h>
#include <vector>
#include <list>
#include "Square.hh"

class Square;
class Game;

class Board {
    friend class Game;
public:
    Board( Game* game );
    ~Board() {}
    Square* operator() (uint8_t x, uint8_t y) { return _board[x][y].get(); }
    int sizeX() { return _sizeX; }
    int sizeY() { return _sizeY; }
    void addToWhiteTargets( Square& s ) { _allWhiteCaptureTargets.push_back( &s ); }
    void addToBlackTargets( Square& s ) { _allBlackCaptureTargets.push_back( &s ); }
    void addToTempTargets( Square& s ) { _tempTargets.push_back( &s ); }
    std::vector<Square*> getSquareList();
    
private:
    Game* _game;
    std::vector<std::vector<std::unique_ptr<Square>>> _board;
    int _sizeX = 8, _sizeY = 8; // wat if chese changes evenchelly
    
    // TOOD: don't be lazy, change the below to forward_list and change all push_back() calls to push_front()
    std::vector<Square*> _allWhiteCaptureTargets, _allBlackCaptureTargets, _tempTargets; // any square determined to be a possible move option by a piece should be added to these lists.  exceptions for pawns and castling kings/rooks.  they are emptied every turn.  this is used to test for check/checkmate/stalemate.  maybe these defs will need to be moved to the Board class.  NOTE: this means that all pieces' possible moves need to be known each turn, which is not the case now; possible moves are only figured out upon moving.  so at the begining of each turn, we need to call getMoveOptions( bool testMove = false ) for everybody.  this dovetails nicely with the thing above about moving and then unmoving for check tests.  I wonder if we should then store the results of getMoveOptions( bool testMove = false ) with each piece for the remainder of the turn so we don't have to call it again upon next move... no.  waste of memory and time, much less efficient than just calling getMoveOptions( bool testMove = false ) once more for the piece we actually try to move.
};

#endif /* defined(__Chess__Board__) */

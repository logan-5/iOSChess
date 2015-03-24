//
//  King.h
//  Chess
//
//  Created by Logan Smith on 3/13/15.
//  Copyright (c) 2015 Logan Smith. All rights reserved.
//

#pragma once
#ifndef __Chess__King__
#define __Chess__King__
#include "MoveSensitivePiece.hh"
#include "Rook.hh"
#include <array>
class Game;

class King : public MoveSensitivePiece {
public:
    enum movetype_e { NORMAL, CASTLE };
    King( Board* board, color_e color, Square* currentSquare, Game& game, std::initializer_list<Rook*> rooks ) : MoveSensitivePiece( board, color, currentSquare, color == color_e::BLACK ? "blackking.png" : "whiteking.png" ), _game( &game ), _rooks( rooks ) {}
    ~King() {}
    squarelist_t getMoveOptions( bool testMove = false ) const;
    movetype_e lastMoveType() { return _lastMove; }
    bool moveToSquareIfPossible( Square& s ) override;
    
private:
    Game* _game; // the king gets to know about the game, so it knows if a square will put it in check.  plus it's the king so it gets special honors and stuff like that
    std::vector<Rook*> _rooks; // the king gets to know about the rooks on his team, so he can figure out castling info.  plus it's the king so it gets special honors and stuff like that.
    movetype_e _lastMove;
};

#endif /* defined(__Chess__King__) */

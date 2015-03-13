//
//  Board.cpp
//  Chess
//
//  Created by Logan Smith on 3/12/15.
//  Copyright (c) 2015 Logan Smith. All rights reserved.
//

#include "Board.hh"

Board::Board() {
    Square::color_e nextSquareColor = Square::WHITE;
    for( int i = 0; i < 8; ++i ) {
        _board.push_back(std::vector<Square>());
        for( int j = 0; j < 8; ++j ) {
            _board[i].push_back(Square(nextSquareColor, i, j));
            nextSquareColor = (nextSquareColor == Square::WHITE) ? Square::BLACK : Square::WHITE;
        }
    }
}
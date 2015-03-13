//
//  Bishop.h
//  Chess
//
//  Created by Logan Smith on 3/12/15.
//  Copyright (c) 2015 Logan Smith. All rights reserved.
//

#ifndef __Chess__Bishop__
#define __Chess__Bishop__

#include "Piece.hh"

class Bishop : public Piece {
public:
    Bishop( Board* board, color_e color, Square* currentSquare ) : Piece( board, color, currentSquare ) {}
    ~Bishop() {}
    std::vector<Square*> getMoveOptions() const;
    bool moveToSquareIfPossible( Square& s );
    
private:
};

#endif /* defined(__Chess__Bishop__) */

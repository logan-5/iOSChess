//
//  Piece.cpp
//  Chess
//
//  Created by Logan Smith on 3/12/15.
//  Copyright (c) 2015 Logan Smith. All rights reserved.
//

#include "Piece.hh"
#include "Square.hh"

/*
// returns true or false in the first place, returns the move list in the second place.  otherwise a vector of size 0 in the second place
std::pair<bool, std::vector<Square*>> Piece::moveOptionsExist( const Square& s ) const {
    std::pair<bool, std::vector<Square*>> options;
    options.first = false;
    if(true );
}*/

uint8_t Piece::x() { return _currentSquare->x(); }
uint8_t Piece::y() { return _currentSquare->y(); }

bool Piece::isSameColorAs( Piece* p ) const {
    if ( p == nullptr ) {
        return false;
    }
    return p->color() == _color;
}

// moveToSquareIfPossible( Square& s ) is badly named because it doesn't check for anything.  move validity is now checked elsewhere
// bool return value is also pointless
// why don't I change it instead of writing this?  mehhhh
// pawns and kings (because castling ?? look up whether a king can capture a piece while castling) should completely override this method
bool Piece::moveToSquareIfPossible( Square &s ) {
    /*if( s._occupied && s.occupier()->color() == _color ) {
        return false;
    }
    std::vector<Square*> possibleMoves = getMoveOptions();

    // if the desired square is in the list of possible move options, move to it.  otherwise, don't move and return false
    for( Square* move : possibleMoves ) {
        if( move == &s ) {*/
            if( s._occupied ) {
                // capture
                s.occupier()->capture(); // o frik
            }
            _currentSquare->deoccupy();
            _currentSquare = &s;
            s.occupyWith( *this ); // kyle reference
            return true;
        //}
   // }
   // return false;
}

void Piece::addToCaptureTargets( Square &s, bool testMove ) const {
    if( testMove ) {
        _board->addToTempTargets( s );
    } else if( _color == WHITE ) {
        _board->addToWhiteTargets( s );
    } else {
        _board->addToBlackTargets( s );
    }
}

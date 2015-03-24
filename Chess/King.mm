//
//  King.cpp
//  Chess
//
//  Created by Logan Smith on 3/13/15.
//  Copyright (c) 2015 Logan Smith. All rights reserved.
//

#include "King.hh"
#include "Game.hh"

Piece::squarelist_t King::getMoveOptions( bool testMove ) const {
    squarelist_t options;
    
    // up one
    int y = _currentSquare->y(), x = _currentSquare->x();
    if( y - 1 >= 0 ) {
        Square* s = ( ( *_board )( x, y - 1 ) );
        if( !_game->squareIsInCheck( *s, this->_color ) ) {
            options.push_back( s );
            addToCaptureTargets( *s, testMove );
        }
    }
    
    // down one
    if( y + 1 < _board->sizeY() ) {
        Square* s = ( ( *_board )( x, y + 1 ) );
        if( !_game->squareIsInCheck( *s, this->_color ) ) {
            options.push_back( s );
            addToCaptureTargets( *s, testMove );
        }
    }
    
    // left one
    if( x - 1 >= 0 ) {
        Square* s = ( ( *_board )( x - 1, y ) );
        if( !_game->squareIsInCheck( *s, this->_color ) ) {
            options.push_back( s );
            addToCaptureTargets( *s, testMove );
        }    }
    
    // right one
    if( x + 1 < _board->sizeX() ) {
        Square* s = ( ( *_board )( x + 1, y ) );
        if( !_game->squareIsInCheck( *s, this->_color ) ) {
            options.push_back( s );
            addToCaptureTargets( *s, testMove );
        }
    }
    
    // up left
    if( y - 1 >= 0 && x - 1 >= 0 ) {
        Square* s = ( ( *_board )( x - 1, y - 1 ) );
        if( !_game->squareIsInCheck( *s, this->_color ) ) {
            options.push_back( s );
            addToCaptureTargets( *s, testMove );
        }
    }
    
    // down left
    if( y + 1 < _board->sizeY() && x - 1 >= 0 ) {
        Square* s = ( ( *_board )( x - 1, y + 1 ) );
        if( !_game->squareIsInCheck( *s, this->_color ) ) {
            options.push_back( s );
            addToCaptureTargets( *s, testMove );
        }
    }
    
    // up right
    if( x + 1 < _board->sizeX() && y - 1 >= 0 ) {
        Square* s = ( ( *_board )( x + 1, y - 1 ) );
        if( !_game->squareIsInCheck( *s, this->_color ) ) {
            options.push_back( s );
            addToCaptureTargets( *s, testMove );
        }
    }
    
    // down right
    if( x + 1 < _board->sizeX() && y + 1 < _board->sizeY() ) {
        Square* s = ( ( *_board )( x + 1, y + 1 ) );
        if( !_game->squareIsInCheck( *s, this->_color ) ) {
            options.push_back( s );
            addToCaptureTargets( *s, testMove );
        }
    }
    
    // castling
    // notes: 0) neither king nor respective rook can have moved yet, 1) can't castle out of check, 2) can't castle through check, 3) can't capture while castling, 4) the distances between rooks are asymmetrical, 5) king-side castle happens on opposite sides for white and black
    if( !_hasMoved && !_game->squareIsInCheck( *_currentSquare, this->_color ) ) {
        // 1. check if the space is totally clear between me and the rook
        // 2. make sure I'm not in check now, and check for check on each square along the path
        // 3. move 2 squares
        // 4. send the signal that the rook should be moved too?
        
        for( auto& rook : _rooks ) {
            if( rook->hasMoved() ) { continue; }
            bool canCastle = true;
            // check all the squares between the king and the rook for 1) emptiness and 2) non-check-ness
            // cast x values to signed int because right now they are unsigned, and they'll go negative in our for-loop iteration
            int rookX = static_cast<signed int>( rook->x() );
            int kingX = static_cast<signed int>( _currentSquare->x() );
            for( int i = _currentSquare->x() + ( rookX - kingX > 0 ? 1 : -1 ); i != rookX; i += ( rookX - kingX > 0 ? 1 : -1 ) ) {
                Square* s = ( ( *_board )( i, _currentSquare->y() ) );
                if( s->isOccupied() || _game->squareIsInCheck( *s, this->_color ) ) {
                    canCastle = false;
                }
            }
            
            if( canCastle ) {
                // figure out the x coordinate of our destination square and add it as an option
                int destX = ( rookX - kingX > 0 ? 1 : -1 ) * 2 + kingX;
                options.push_back( ( ( *_board )( destX, _currentSquare->y() ) ) );
            }
        }
    }
    
    return options;
}

bool King::moveToSquareIfPossible( Square &s ) {
    /*if( s._occupied && s.occupier()->color() == _color ) {
        return false;
    }
    std::vector<Square*> possibleMoves = getMoveOptions();
    
    // if the desired square is in the list of possible move options, move to it.  otherwise, don't move and return false
    for( Square* move : possibleMoves ) {
        if( move == &s ) {*/
            // if we moved more than 1 square horizontally, it must have been a castle
            if( abs( s.x() - _currentSquare->x() ) > 1 ) {
                _lastMove = CASTLE;
            } else {
                _lastMove = NORMAL;
            }
            if( s._occupied ) {
                // capture
                s.occupier()->capture(); // o frik
            }
            _currentSquare->deoccupy();
            _currentSquare = &s;
            s.occupyWith( *this ); // kyle reference
            _hasMoved = true;
            return true;
       // }
    //}
    //return false;
}

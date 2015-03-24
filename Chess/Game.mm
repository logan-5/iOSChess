//
//  Game.mm
//  Chess
//
//  Created by Logan Smith on 3/12/15.
//  Copyright (c) 2015 Logan Smith. All rights reserved.
//

#include "Game.hh"
#include "Rook.hh"
#include "Bishop.hh"
#include "Queen.hh"
#include "King.hh"
#include "Knight.hh"
#include "Pawn.hh"

std::vector<Drawable*> Game::getDrawables () {
    std::vector<Drawable*> drawables;
    for( auto& p : _activeWhite ) {
        drawables.push_back( p.get() );
    }
    
    for( auto& p : _activeBlack ) {
        drawables.push_back( p.get() );
    }
    
    for( auto& p : _board->getSquareList() ) {
        drawables.push_back( p );
    }
    
    return drawables;
}

Game::status_e Game::eventOnSquare( int squareX, int squareY ) {
    if( ( *_board )( squareX, squareY )->isOccupied() && _turn == ( *_board )( squareX, squareY )->occupier()->color() ) {
        select( ( *_board )( squareX, squareY )->occupier() );
        return _status = Game::SELECTED;
    } else if( _selection && !_selection->isCaptured() && _turn == _selection->color() ) {
        bool moved = moveSelectionTo( squareX, squareY );

        if( moved ) {
            if( _selection == ( _turn == Piece::WHITE ? _whiteKing : _blackKing ) ) {
                King* k = static_cast<King*>( _turn == Piece::WHITE ? _whiteKing : _blackKing );
                if( k->lastMoveType() == King::CASTLE ) {
                    moveRookForCastle();
                }
            }
            // check if any pieces were captured
            std::vector<piece_ptr> whiteCapturedList, blackCapturedList;
            for ( auto& a : _activeWhite ) {
                if( a->isCaptured() ) {
                    _capturedWhite.push_front( a );
                    whiteCapturedList.push_back( a );
                }
            }
            for ( auto& a : _activeBlack ) {
                if( a->isCaptured() ) {
                    _capturedBlack.push_front( a );
                    blackCapturedList.push_back( a );
                }
            }
            removeCapturedPiecesFromActiveLists( whiteCapturedList, blackCapturedList );
            
            Pawn* p = dynamic_cast<Pawn*>( _selection );
            if( p != nullptr && p->y() == ( p->color() == Piece::WHITE ? 0 : _board->sizeY() - 1 ) ) {
                //_promotee = std::move( piece_ptr( _selection ) );
                _promotee = _selection;
                return _status = Game::PROMOTED;
            } else {
                initTurn();
                return _status = Game::MOVED;
            }
        } else {
            // TODOOOOOOOO: remove duplicates from _allWhiteCaptureTargets and black
        }
    }
    return _status = Game::NONE;
}

// promote a piece to a queen, rook, bishop, or knight
Drawable* Game::promotePieceTo( promotion_e p ) {
    Piece* newPiece;
    Square* s = ( *_board )( _promotee->x(), _promotee->y() );
    s->deoccupy();
    switch( p ) {
        case QUEEN:
            newPiece = new Queen( _board.get(), _promotee->color(), s );
            break;
        case ROOK:
            newPiece = new Rook( _board.get(), _promotee->color(), s );
            break;
        case BISHOP:
            newPiece = new Bishop( _board.get(), _promotee->color(), s );
            break;
        case KNIGHT:
            newPiece = new Knight( _board.get(), _promotee->color(), s );
            break;
        default:
            break;
    }
    auto pieceList = &( _promotee->color() == Piece::WHITE ? _activeWhite : _activeBlack );
    piece_ptr remove;
    // find and remove the piece associated with the promotee from the active list
    for( auto& p : *pieceList ) {
        if( p.get() == _promotee ) {
            remove = p;
            break;
        }
    }
    pieceList->remove( remove );
    // the add the new piece
    pieceList->push_front( std::move( piece_ptr( newPiece ) ) );
    
    _status = NONE;
    initTurn();
    return newPiece;
}

bool Game::squareIsInCheck( Square &s, Piece::color_e color ) {
    if( color == Piece::WHITE ) {
        for( auto& square : _board->_allBlackCaptureTargets ) {
            if( &s == square ) {
                return true;
            }
        }
    } else {
        for( auto& square : _board->_allWhiteCaptureTargets ) {
            if( &s == square ) {
                return true;
            }
        }
    }
    return false;
}

void Game::initTurn() {
    if( _first ) {
        _first = false;
    } else {
        _turn = ( _turn == Piece::WHITE ) ? Piece::BLACK : Piece::WHITE;
    }
    //_turn = Piece::WHITE; // FOR DEBUGGING ONLY
    _selection = nullptr;
    _board->_allWhiteCaptureTargets.clear();
    _board->_allBlackCaptureTargets.clear();
    _allWhiteMoveOptions.clear();
    _allBlackMoveOptions.clear();
    
    // get all move options from all pieces
    for( auto& p : _activeWhite ) {
        auto moves = p->getMoveOptions();
        for( auto& s : moves ) {
            if( !moveIsInvalidOrPutsKingIntoCheck( move_t( *p, p->x(), p->y(), s->x(), s->y() ) ) ) {
                _allWhiteMoveOptions.push_front( std::make_shared<move_t>( *p, p->x(), p->y(), s->x(), s->y() ) );
            }
        }
        if ( _turn == Piece::WHITE ) {
            if( Pawn* pawn = dynamic_cast<Pawn*>( p.get() ) ) { pawn->update(); } // set all pawns' _movedOnce variable appropriately
        }
    }
    for( auto& p : _activeBlack ) {
        auto moves = p->getMoveOptions();
        for( auto& s : moves ) {
            if( !moveIsInvalidOrPutsKingIntoCheck( move_t( *p, p->x(), p->y(), s->x(), s->y() ) ) ) {
                _allBlackMoveOptions.push_front( std::make_shared<move_t>( *p, p->x(), p->y(), s->x(), s->y() ) );
            }
        }
        if ( _turn == Piece::BLACK ) {
            if( Pawn* pawn = dynamic_cast<Pawn*>( p.get() ) ) { pawn->update(); } // set all pawns' _movedOnce variable appropriately
        }
    }
    
    Piece* king = _turn == Piece::WHITE ? _whiteKing : _blackKing;
    _check = squareIsInCheck( *king->currentSquare(), king->color() );
    
    if( _check ) {
        // <--------- simulate all moves RIGHT HERE and remove non-viable ones!!!!!!
        std::forward_list<std::shared_ptr<move_t>> nonViableMoves;
        
        auto moveList = &( ( _turn == Piece::WHITE ) ? _allWhiteMoveOptions : _allBlackMoveOptions );
        for( auto& s : *moveList ) {
             if( !moveGetsOutOfCheck( *s.get() ) ) {
                nonViableMoves.push_front( s );
             }
        }
        for( auto& s: nonViableMoves ) {
            moveList->remove( s );
        }
    }
    
    if ( _turn == Piece::WHITE && _allWhiteMoveOptions.empty() ) {
        if ( _check ) {
            _checkmate = true;
        } else {
            _stalemate = true;
        }
    } else if( _turn == Piece::BLACK && _allBlackMoveOptions.empty() ) {
        if ( _check ) {
            _checkmate = true;
        } else {
            _stalemate = true;
        }
    }
}

bool Game::moveIsInvalidOrPutsKingIntoCheck( const move_t& move ) {
    Piece* occupier = ( *_board )( move.newX, move.newY )->occupier();
    if( occupier != nullptr && occupier->color() == move.piece.color() ) { return true; } // the move is blocked by other piece on my team.  invalid move
    
    _board->_tempTargets.clear();
    Piece* king = move.piece.color() == Piece::WHITE ? _whiteKing : _blackKing;
    
    ( *_board )( move.newX, move.newY )->deoccupy();
    ( *_board )( move.newX, move.newY )->occupyWith( move.piece );
    ( *_board )( move.prevX, move.prevY )->deoccupy();
    
    // get all capture targets
    auto pieceList = &( ( _turn == Piece::WHITE ) ? _activeBlack : _activeWhite );
    for( auto& s : *pieceList ) {
        if( s.get() == occupier ) { continue; }
        s->getMoveOptions( true ); // options are added to _board->_tempTargets because of false argument
        //NSLog([NSString stringWithFormat:@"after: %ld", _board->_tempTargets.size()]);
    }
    
    bool intoCheck = false;
    // check if king's square is in the list
    // note: if it's the king's move that is being tested, then the king's square is (move.newX, move.newY) rather than king->currentSquare()
    for( auto& s : _board->_tempTargets ) {
        if( ( &move.piece != king && s == king->currentSquare() ) ||
           ( &move.piece == king && s->x() == move.newX && s->y() == move.newY ) ) {            intoCheck = true;
        }
    }
    
    // 'move' the pieces back where they were
    ( *_board )( move.newX, move.newY )->deoccupy();
    if( occupier != nullptr ) {
        ( *_board )( move.newX, move.newY )->occupyWith( *occupier );
    }
    ( *_board )( move.prevX, move.prevY )->occupyWith( move.piece );
    
    return intoCheck;
}

// is this function getting called 1000 times?
bool Game::moveGetsOutOfCheck( const move_t& move ) {
    _board->_tempTargets.clear();
    //NSLog([NSString stringWithFormat:@"before: %ld", _board->_tempTargets.size()]);

    // move the piece to the new square
    // calculate all capture targets for other team (**EXCEPT** those of the new square's occupier, if any)
    // bool returnValue = king_is_still_in_check
    // undo move
    // return returnValue
    Piece* king = _turn == Piece::WHITE ? _whiteKing : _blackKing;
    Piece* occupier = ( *_board )( move.newX, move.newY )->occupier();
    //Square* ___square = ( *_board )( move.newX, move.newY ); // for debugging only
    //auto temp_targets = &_board->_tempTargets; // for debugging only
    if( occupier != nullptr && occupier->color() == move.piece.color() ) { return false; }
    
    ( *_board )( move.newX, move.newY )->deoccupy();
    ( *_board )( move.newX, move.newY )->occupyWith( move.piece );
    ( *_board )( move.prevX, move.prevY )->deoccupy();
    
    // get all capture targets
    auto pieceList = &( ( _turn == Piece::WHITE ) ? _activeBlack : _activeWhite );
    for( auto& s : *pieceList ) {
        if( s.get() == occupier ) { continue; }
        s->getMoveOptions( true ); // options are added to _board->_tempTargets because of false argument
        //NSLog([NSString stringWithFormat:@"after: %ld", _board->_tempTargets.size()]);
    }
    
    bool outOfCheck = true;
    // check if king's square is in the list
    // note: if it's the king's move that is being tested, then the king's square is (move.newX, move.newY) rather than king->currentSquare()
    for( auto& s : _board->_tempTargets ) {
        if( ( &move.piece != king && s == king->currentSquare() ) ||
           ( &move.piece == king && s->x() == move.newX && s->y() == move.newY ) ) {
            outOfCheck = false;
        }
    }
    
    // 'move' the pieces back where they were
    ( *_board )( move.newX, move.newY )->deoccupy();
    if( occupier != nullptr ) {
        ( *_board )( move.newX, move.newY )->occupyWith( *occupier );
    }
    ( *_board )( move.prevX, move.prevY )->occupyWith( move.piece );
    
    return outOfCheck;
}

/*
bool Game::moveGetsOutOfCheck( Piece &p, int x, int y ) {
    return moveGetsOutOfCheck( move_t( p, p.x(), p.y(), x, y ) );
}*/

// henceforth I can no longer replace std::forward_list<>s with std:deque<>s for debugging
void Game::removeCapturedPiecesFromActiveLists( std::vector<piece_ptr>& whiteCapturedList, std::vector<piece_ptr>& blackCapturedList ) {
    for ( auto& a : whiteCapturedList ) {
        _activeWhite.remove( a );
    }
    for ( auto& a : blackCapturedList ) {
        _activeBlack.remove( a );
    }
}

/*
void Game::moveSelectionTo( int onscreenX, int onscreenY ) {
    int squareX = onscreenX / _squareSize, squareY = onscreenY / _squareSize;
    if ( squareX < 0 || squareX > _board->_sizeX - 1 ||
        squareY < 0 || squareY > _board->_sizeY - 1) {
        return;
    } else {
        if( _check ) {
            move_t move( *_selection, _selection->x(), _selection->y(), squareX, squareY );
            bool moveIsPossible = false;
            for( auto& m : _turn == Piece::WHITE ? _allWhiteMoveOptions : _allBlackMoveOptions ) {
                if( *m.get() == move ) { moveIsPossible = true; }
            }
            if( !moveIsPossible ) { return; }
        }
        _selection->moveToSquareIfPossible( *( *_board )( squareX, squareY ) );
    }
}*/

bool Game::moveSelectionTo( int squareX, int squareY ) {
    //if( _check ) {
        move_t move( *_selection, _selection->x(), _selection->y(), squareX, squareY );
        bool moveIsPossible = false;
        for( auto& m : _turn == Piece::WHITE ? _allWhiteMoveOptions : _allBlackMoveOptions ) {
            if( *m.get() == move ) {
                moveIsPossible = true;
            }
        }
        if( !moveIsPossible ) { return false; }
    //}
    return _selection->moveToSquareIfPossible( *( *_board )( squareX, squareY ) );
}

void Game::moveRookForCastle() {
    //NSLog(@"castling...");
    King* k = static_cast<King*>( _turn == Piece::WHITE ? _whiteKing : _blackKing );
    // the below is witchcraft
    int rookX = ( k->x() > _board->sizeX() / 2 ) ? _board->sizeX() - 1 : 0;
    int rookY = ( _turn == Piece::BLACK ) ? 0 : _board->sizeY() - 1;
    Rook* rook = static_cast<Rook*>( ( *_board )( rookX, rookY )->occupier() );
    
    int newRookX = k->x() + ( k->x() > _board->sizeX() / 2 ? -1 : 1 );
    rook->forceMoveTo( *( *_board )( newRookX, rookY ) );
}
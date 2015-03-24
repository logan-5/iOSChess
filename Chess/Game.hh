//
//  Game.hh
//  Chess
//
//  Created by Logan Smith on 3/12/15.
//  Copyright (c) 2015 Logan Smith. All rights reserved.
//
#pragma once
#ifndef _GAME_H_
#define _GAME_H_
#include <memory>
#include <forward_list>
#include <deque> // for debugging only.  if you see a std::deque<> somewhere it's because I forgot to change it back to a std::forward_list<>
#include "Board.hh"
#include "Piece.hh"
class Pawn;

class Game {
    friend class Board;
public:
    typedef std::shared_ptr<Piece> piece_ptr;
    enum status_e { MOVED, SELECTED, PROMOTED, NONE };
    enum promotion_e { QUEEN, ROOK, KNIGHT, BISHOP };
    Game(int squareSize) : _squareSize( squareSize ), _turn( Piece::WHITE ), _check( false ), _checkmate( false ), _draw( false ), _stalemate( false ), _first ( true ), _status ( NONE ) {
        _board = std::unique_ptr<Board>( new Board( this ) );
        initTurn();
    }
    ~Game(){}
    status_e status() { return _status; }
    Piece::color_e turn() { return _turn; }
    bool check() { return _check; }
    bool checkMate() { return _checkmate; }
    bool draw() { return _draw; }
    bool staleMate() { return _stalemate; }
    std::vector<Drawable*> getDrawables();
    status_e eventOnSquare( int squareX, int squareY ); // either selects or moves, depending
    bool selectionIs( Piece* p ) { return p == _selection; }
    bool promoteeIs( Drawable* p ) { return p == _promotee; }
    bool squareIsInCheck( Square& s, Piece::color_e color ); // determines whether the king having the given color would be in check were he in the given square
    Drawable* promotePieceTo( promotion_e p );
    
private:
    status_e _status;
    int _squareSize;
    Piece::color_e _turn;
    std::unique_ptr<Board> _board;
    Piece *_whiteKing, *_blackKing;
    std::forward_list<piece_ptr> _activeWhite, _activeBlack, _capturedWhite, _capturedBlack;
    bool _check, _checkmate, _draw, _stalemate, _first;
    typedef struct move_t { // contains data for the last move, as well as hypothetical ones
        Piece& piece;
        uint8_t prevX, prevY, newX, newY;
        move_t( Piece& p, uint8_t px, uint8_t py, uint8_t nx, uint8_t ny ) : piece(p), prevX(px), prevY(py), newX(nx), newY(ny) {}
        bool operator==( const move_t& other ) { return &piece == &other.piece && prevX == other.prevX && prevY == other.prevY && newX == other.newX && newY == other.newY; }
    } _lastMove;
    std::forward_list<std::shared_ptr<move_t>> _allWhiteMoveOptions, _allBlackMoveOptions;
    // bool moveGetsOutOfCheck( Piece& p, int x, int y );
    bool moveIsInvalidOrPutsKingIntoCheck( const move_t& move );
    bool moveGetsOutOfCheck( const move_t& move );
    
    Piece* _selection;
    Piece* _promotee;
    void initTurn(); // sets up the turn, including calculating all move targets and testing for check
    void select(Piece* p) { _selection = p; }
    //void moveSelectionTo( int onscreenX, int onscreenY );
    bool moveSelectionTo( int squareX, int squareY );
    void removeCapturedPiecesFromActiveLists( std::vector<piece_ptr>& whiteCapturedList, std::vector<piece_ptr>&blackCapturedList );
    void moveRookForCastle();
};

#endif
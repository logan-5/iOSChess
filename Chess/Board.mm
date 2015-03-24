//
//  Board.cpp
//  Chess
//
//  Created by Logan Smith on 3/12/15.
//  Copyright (c) 2015 Logan Smith. All rights reserved.
//

#include "Board.hh"
#include "Rook.hh"
#include "Bishop.hh"
#include "Queen.hh"
#include "King.hh"
#include "Knight.hh"
#include "Pawn.hh"
#include "Game.hh"
#include <forward_list>
#include <memory>

Board::Board( Game* game )  : _game( game ) {
    Square::color_e nextSquareColor = Square::WHITE;
    for( int i = 0; i < 8; ++i ) {
        _board.push_back( std::vector<std::unique_ptr<Square>>() );
        for( int j = 0; j < 8; ++j ) {
            _board[i].push_back( std::move( std::unique_ptr<Square>( new Square( nextSquareColor, i, j ) ) ) );
            nextSquareColor = ( nextSquareColor == Square::WHITE ) ? Square::BLACK : Square::WHITE;
        }
        nextSquareColor = ( nextSquareColor == Square::WHITE ) ? Square::BLACK : Square::WHITE;
    }

    // left-side rooks
    int x = 0;
    int y[2] = { 0, _sizeY - 1 };
    Rook* blackRook1 = new Rook( this, Piece::BLACK, _board[x][y[0]].get() );
    Rook* whiteRook1 = new Rook( this, Piece::WHITE, _board[x][y[1]].get() );
    _game->_activeBlack.push_front( std::move( Game::piece_ptr( blackRook1 ) ) );
    _game->_activeWhite.push_front( std::move( Game::piece_ptr( whiteRook1 ) ) );
    
    // right-side rooks
    ++x;
    Rook* blackRook2 = new Rook( this, Piece::BLACK, _board[_sizeX - x][y[0]].get() );
    Rook* whiteRook2 = new Rook( this, Piece::WHITE, _board[_sizeX - x][y[1]].get() );
    _game->_activeBlack.push_front( std::move( Game::piece_ptr( blackRook2 ) ) );
    _game->_activeWhite.push_front( std::move( Game::piece_ptr( whiteRook2 ) ) );
    
    // left-side knights    
    Piece* blackKnight1 = new Knight( this, Piece::BLACK, _board[x][y[0]].get() );
    Piece* whiteKnight1 = new Knight( this, Piece::WHITE, _board[x][y[1]].get() );
    _game->_activeBlack.push_front( std::move( Game::piece_ptr( blackKnight1 ) ) );
    _game->_activeWhite.push_front( std::move( Game::piece_ptr( whiteKnight1 ) ) );
    
    // right-side knights
    ++x;
    Piece* blackKnight2 = new Knight( this, Piece::BLACK, _board[_sizeX - x][y[0]].get() );
    Piece* whiteKnight2 = new Knight( this, Piece::WHITE, _board[_sizeX - x][y[1]].get() );
    _game->_activeBlack.push_front( std::move( Game::piece_ptr( blackKnight2 ) ) );
    _game->_activeWhite.push_front( std::move( Game::piece_ptr( whiteKnight2 ) ) );
    
    // left-side bishops
    Piece* blackBishop1 = new Bishop( this, Piece::BLACK, _board[x][y[0]].get() );
    Piece* whiteBishop1 = new Bishop( this, Piece::WHITE, _board[x][y[1]].get() );
    _game->_activeBlack.push_front( std::move( Game::piece_ptr( blackBishop1 ) ) );
    _game->_activeWhite.push_front( std::move( Game::piece_ptr( whiteBishop1 ) ) );
    
    // right-side bishops
    ++x;
    Piece* blackBishop2 = new Bishop( this, Piece::BLACK, _board[_sizeX - x][y[0]].get() );
    Piece* whiteBishop2 = new Bishop( this, Piece::WHITE, _board[_sizeX - x][y[1]].get() );
    _game->_activeBlack.push_front( std::move( Game::piece_ptr( blackBishop2 ) ) );
    _game->_activeWhite.push_front( std::move( Game::piece_ptr( whiteBishop2 ) ) );
    
    // queens
    Piece* blackQueen = new Queen( this, Piece::BLACK, _board[x][y[0]].get() );
    Piece* whiteQueen = new Queen( this, Piece::WHITE, _board[x][y[1]].get() );
    _game->_activeBlack.push_front( std::move( Game::piece_ptr( blackQueen ) ) );
    _game->_activeWhite.push_front( std::move( Game::piece_ptr( whiteQueen ) ) );
    

    // kings
    ++x;
    Piece* blackKing = new King( this, Piece::BLACK, _board[x][y[0]].get(), *_game, { blackRook1, blackRook2 } );
    Piece* whiteKing = new King( this, Piece::WHITE, _board[x][y[1]].get(), *_game, { whiteRook1, whiteRook2 } );
    _game->_activeBlack.push_front( std::move( Game::piece_ptr( blackKing ) ) );
    _game->_activeWhite.push_front( std::move( Game::piece_ptr( whiteKing ) ) );
    _game->_blackKing = blackKing;
    _game->_whiteKing = whiteKing;

    
    // pawns
    ++y[0], --y[1];
    for( x = 0; x < _sizeX; ++x ) {
        Piece* blackPawn = new Pawn( this, Piece::BLACK, _board[x][y[0]].get() );
        Piece* whitePawn = new Pawn( this, Piece::WHITE, _board[x][y[1]].get() );
        _game->_activeBlack.push_front( std::move( Game::piece_ptr( blackPawn ) ) );
        _game->_activeWhite.push_front( std::move( Game::piece_ptr( whitePawn ) ) );
    }
    
    /*
    // STRAY QUEEN FOR TESTING ONLY
    Piece* testQueen = new Queen( this, Piece::WHITE, _board[5][4].get() );
    _game->_activeWhite.push_front( std::move( Game::piece_ptr( testQueen ) ) );
     */
}

std::vector<Square*> Board::getSquareList() {
    std::vector<Square*> squareList;
    for( auto& l : _board ) {
        for( auto& s : l ) {
            squareList.push_back( s.get() );
        }
    }
    return squareList;
}

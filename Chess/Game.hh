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

#include "Board.hh"

class Game {
public:
    Game() {}
    ~Game(){}
private:
    Board _board;
};

#endif
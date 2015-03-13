//
//  ViewController.m
//  Chess
//
//  Created by Logan Smith on 3/12/15.
//  Copyright (c) 2015 Logan Smith. All rights reserved.
//

#import "ViewController.hh"
#import "GameWrapper.hh"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    GameWrapper* g = [[GameWrapper alloc] init];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

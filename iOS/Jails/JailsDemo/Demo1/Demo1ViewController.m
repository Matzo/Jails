//
//  Demo1ViewController.m
//  Jails
//
//  Created by Matsuo, Keisuke | Matzo | TRVDD on 4/19/13.
//  Copyright (c) 2013 Matzo. All rights reserved.
//

#import "Demo1ViewController.h"
#import "Jails.h"

@interface Demo1ViewController ()

@end

@implementation Demo1ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [Jails loadJSON:@"http://localhost/jails/test.json"];
    
    [Jails abTestWithViewController:self];
    NSLog(@"AB Name:%@ seed:%d", [Jails abNameWithViewController:self], [[Jails sharedInstance] abSeed]);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end

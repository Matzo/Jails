//
//  JailsAdjusterTestViewController.m
//  Jails
//
//  Created by Matsuo Keisuke on 2013/04/20.
//  Copyright (c) 2013年 Matzo. All rights reserved.
//

#import "JailsAdjusterTestViewController.h"

@interface JailsAdjusterTestViewController ()

@end

@implementation JailsAdjusterTestViewController

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
    
    [self.button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)buttonClicked:(id)sender {
    self.buttonSelectorChanged = NO;
    NSLog(@"buttonClicked");
}
- (IBAction)adjustedButtonClicked:(id)sender {
    self.buttonSelectorChanged = YES;
    NSLog(@"adjustedButtonClicked");
}
- (IBAction)createdButtonClicked:(id)sender {
    self.buttonCreated = YES;
    NSLog(@"createdButtonClicked");
}


@end

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
    [self dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"buttonClicked");
}
- (IBAction)adjustedButtonClicked:(id)sender {
    self.buttonSelectorChanged = YES;
    [self dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"adjustedButtonClicked");
}
- (IBAction)createdButtonClicked:(id)sender {
    self.buttonCreated = YES;
    NSLog(@"createdButtonClicked");
}
- (IBAction)webAdapterSelector {
    NSLog(@"webAdapterSelector");
}
- (IBAction)webAdapterSelectorWithParam1:(NSString*)p1 {
    NSLog(@"webAdapterSelectorWithParam1:%@", p1);
}
- (IBAction)webAdapterSelectorWithParam1:(NSString*)p1 param2:(NSString*)p2 {
    NSLog(@"webAdapterSelectorWithParam1:%@ param2:%@", p1, p2);
}


@end

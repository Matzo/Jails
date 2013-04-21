//
//  ViewController.m
//  JailsDemo
//
//  Created by Matsuo, Keisuke | Matzo | TRVDD on 4/19/13.
//  Copyright (c) 2013 Matzo. All rights reserved.
//

#import "ViewController.h"
#import "JailsAdjusterTestViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)openJail:(id)sender {
    JailsAdjusterTestViewController *vc = [[JailsAdjusterTestViewController alloc] initWithNibName:@"JailsAdjusterTestViewController" bundle:nil];
    
    [self presentViewController:vc animated:YES completion:^{
    }];
}
@end

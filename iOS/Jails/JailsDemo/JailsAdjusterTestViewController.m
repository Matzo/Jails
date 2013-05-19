//
//  JailsAdjusterTestViewController.m
//  Jails
//
//  Created by Matsuo Keisuke on 2013/04/20.
//  Copyright (c) 2013 Matzo. All rights reserved.
//

#import "JailsAdjusterTestViewController.h"
#import "JailsAdjusterTestCellData.h"
#import "JailsAdjusterTestCell.h"

@interface JailsAdjusterTestViewController ()

@end

@implementation JailsAdjusterTestViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        NSMutableArray *cellDataList = [NSMutableArray array];
        for (int i = 0; i < 100; i++) {
            JailsAdjusterTestCellData *cellData = [[JailsAdjusterTestCellData alloc] init];
            cellData.title = [NSString stringWithFormat:@"%d:title", i];
            cellData.subtitle = [NSString stringWithFormat:@"%d:subtitle", i];
            [cellDataList addObject:cellData];
        }
        self.cellDataList = cellDataList;
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


- (void)openURL:(NSString*)url {
    UIApplication *app = [UIApplication sharedApplication];
    NSURL *_url = [NSURL URLWithString:url];
    if ([app canOpenURL:_url]) {
        [app openURL:_url];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.cellDataList count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"JailsAdjusterTestCell";
    
    JailsAdjusterTestCellData *data = [self.cellDataList objectAtIndex:indexPath.row];
    JailsAdjusterTestCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[JailsAdjusterTestCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:cellIdentifier];
    }
    cell.data = data;
    
    return cell;
}


@end

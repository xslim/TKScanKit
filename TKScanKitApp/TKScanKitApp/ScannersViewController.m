//
//  ScannersViewController.m
//  TKScanKitApp
//
//  Created by Taras Kalapun on 20/11/13.
//  Copyright (c) 2013 Kalapun. All rights reserved.
//

#import "ScannersViewController.h"
#import <TKScanKit.h>

@interface ScannersViewController () <TKScanningProviderDelegate>

@property (nonatomic, strong) NSDictionary *items;
@property (nonatomic, strong) TKScanningProvider *currentProvider;

@end

@implementation ScannersViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.items = [TKScanKit availableProviders];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)scanWith:(NSString *)name
{
    self.currentProvider = [TKScanKit presentScanner:name fromViewController:self];
}

- (void)showMessageWithTitle:(NSString *)title text:(NSString *)text
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:text
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil, nil];
    [alert show];
}

#pragma mark - TKScanningProviderDelegate

- (void)scanningProvider:(TKScanningProvider *)provider didFinishScanningWithText:(NSString *)text info:(NSDictionary *)info
{
    NSString *title = [NSString stringWithFormat:@"Scanned: %@", text];
    [self showMessageWithTitle:title text:[info description]];
}

- (void)scanningProviderDidCancel:(TKScanningProvider *)provider
{
    
}

- (void)scanningProvider:(TKScanningProvider *)provider didFailedScanningWithError:(NSError *)error
{
    [self showMessageWithTitle:@"Error" text:[error localizedDescription]];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.items allKeys].count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    NSString *itemName = [self.items allKeys][indexPath.row];
    NSString *itemCls = self.items[itemName];
    
    cell.textLabel.text = itemName;
    cell.detailTextLabel.text = itemCls;
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *itemName = [self.items allKeys][indexPath.row];    
    [self scanWith:itemName];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

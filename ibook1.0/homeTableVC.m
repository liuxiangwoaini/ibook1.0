//
//  homeTableVC.m
//  ibook1.0
//
//  Created by liuxiang on 15-10-25.
//  Copyright (c) 2015年 liuxiang. All rights reserved.
//

#import "homeTableVC.h"

@interface homeTableVC ()

@end

@implementation homeTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *item1 =[[UIBarButtonItem alloc] initWithTitle:@"hehe" style:UIBarButtonItemStyleDone target:self action:nil];
    UIBarButtonItem *item2 =[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_location.png"] style:UIBarButtonItemStyleDone target:self action:nil];
    self.navigationItem.rightBarButtonItems =@[item1, item2];
    self.navigationItem.title = @"das";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 0;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/




@end

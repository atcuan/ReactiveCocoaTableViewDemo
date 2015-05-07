//
//  ViewController.m
//  ReactiveCocoaTableViewDemo
//
//  Created by Moch Xiao on 5/6/15.
//  Copyright (c) 2015 Moch Xiao. All rights reserved.
//

#import "ViewController.h"
#import "ViewModel.h"
#import "TableViewCell.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "CHXArrayDataSource.h"

#define THIN_VC

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) ViewModel *viewModel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *data;
@property (nonatomic, assign) NSInteger currentPage;


@property (nonatomic, strong) CHXArrayDataSource *arrayDataSource;


@end

@implementation ViewController

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (!self) {
        return nil;
    }
    
    self.viewModel = [ViewModel new];
    
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
#ifdef THIN_VC
    self.tableView.dataSource = self.arrayDataSource;
#endif
    
    
    
    @weakify(self);
    RAC(self, data) = [RACObserve(self.viewModel, tableViewData) map:^id(id value) {
        @strongify(self);
        
#ifdef THIN_VC
        NSMutableArray *currentData = [self.data mutableCopy];
        if (!currentData.count) {
            [currentData addObject:[[CHXArrayDataSourceSectionItem alloc] initWithContent:value]];
        } else {
            [[currentData firstObject] addContentFromArray:value];
        }
        return [NSArray arrayWithArray:currentData];
#else
        NSMutableArray *currentData = [self.data mutableCopy];
        [currentData addObjectsFromArray:value];
        return [NSArray arrayWithArray:currentData];
#endif
    }];

    [RACObserve(self, data) subscribeNext:^(id x) {
        @strongify(self);
        [self.tableView reloadData];
    }];
    RAC(self.viewModel, currentPage) = RACObserve(self, currentPage);
    
    self.currentPage++;
    [self.viewModel triggerRequest];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.currentPage++;
        [self.viewModel triggerRequest];
        self.currentPage--;
    });

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.currentPage++;
        [self.viewModel triggerRequest];
    });
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.data = self.data[indexPath.row];
    return cell;
}

#pragma mark - Accessor

- (CHXArrayDataSource *)arrayDataSource {
    __weak typeof(self) weakSelf = self;
    if (!_arrayDataSource) {
        _arrayDataSource = [[CHXArrayDataSource alloc] initWithDataArrayBlock:^NSArray *{
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            return strongSelf.data;
        } cellReuseIdentifierForIndexPath:^NSString *(NSIndexPath *indexPath) {
            return @"Cell";
        } cellConfigureBlock:^(TableViewCell *cell, id item) {
            cell.data = item;
        }];
    }
    
    return _arrayDataSource;
}

@end

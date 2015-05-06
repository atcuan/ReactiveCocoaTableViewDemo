//
//  ViewModel.h
//  ReactiveCocoaTableViewDemo
//
//  Created by Moch Xiao on 5/6/15.
//  Copyright (c) 2015 Moch Xiao. All rights reserved.
//

#import "RVMViewModel.h"

@interface ViewModel : RVMViewModel

// VC

@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) NSArray *tableViewData;

- (void)triggerRequest;

// Cell
@property (nonatomic, strong) id data;
@property (nonatomic, copy) NSString *textLabelText;

@end

//
//  TableViewCell.m
//  ReactiveCocoaTableViewDemo
//
//  Created by Moch Xiao on 5/6/15.
//  Copyright (c) 2015 Moch Xiao. All rights reserved.
//

#import "TableViewCell.h"
#import "ViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>


@interface TableViewCell ()
@property (nonatomic, strong) ViewModel *viewModel;
@end

@implementation TableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.viewModel = [ViewModel new];
    
    RAC(self.textLabel, text) = RACObserve(self.viewModel, textLabelText);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setData:(id)data {
    if (_data == data) {
        return;
    }
    
    self.viewModel.data = data;
}

@end

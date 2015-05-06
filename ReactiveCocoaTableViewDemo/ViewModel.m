//
//  ViewModel.m
//  ReactiveCocoaTableViewDemo
//
//  Created by Moch Xiao on 5/6/15.
//  Copyright (c) 2015 Moch Xiao. All rights reserved.
//

#import "ViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface ViewModel ()
@property (nonatomic, assign) BOOL trigger;
@end

@implementation ViewModel

- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    @weakify(self);
    RAC(self, tableViewData) = [[[[RACObserve(self, trigger) filter:^BOOL(id value) {
        @strongify(self);
        return self.currentPage > 0;
    }] map:^id(id value) {
        @strongify(self);
        return [self request];
    }] switchToLatest] deliverOn:[RACScheduler mainThreadScheduler]];
    
    RAC(self, textLabelText) = [RACObserve(self, data) map:^id(id value) {
        return [NSString stringWithFormat:@"Cell formated: %@", value];
    }];
    
    return self;
}

static int start = 0;

- (RACSignal *)request {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSMutableArray *array = [NSMutableArray new];
        for (int i = start; i < start + 20 * self.currentPage; i++) {
            NSString *string = [NSString stringWithFormat:@"ViewModelData: %@", @(i)];
            [array addObject:string];
        }
        [subscriber sendNext:array];
        
        start = 20;
        
        return nil;
    }];
}

- (void)triggerRequest {
    self.trigger = !self.trigger;
}

@end

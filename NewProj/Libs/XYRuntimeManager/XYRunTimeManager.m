//
//  XYRunTimeManager.m
//  Risenb
//
//  Created by fabs on 2017/1/4.
//  Copyright © 2017年 Risenb. All rights reserved.
//

#import "XYRunTimeManager.h"

@interface XYRunTimeManager ()

@property (strong, nonatomic) dispatch_queue_t queue;

@property (strong, nonatomic) dispatch_source_t timer;

@property (assign, nonatomic) NSTimeInterval timeInterval;

@end

@implementation XYRunTimeManager

- (void)dealloc {
    _queue = NULL;
}

+ (instancetype)shareInstance {
    static XYRunTimeManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!manager) {
            manager = [[[self class] alloc] init];
        }
    });
    return manager;
}

- (void)startRunTimeWithTimeInterval:(NSTimeInterval)timeInterval
                        eventHandler:(void(^)(NSNumber *timeInterval))eventHandler
                          completion:(void(^)())completion {
    [self cancleRunTime];
    self.timeInterval = timeInterval;
    NSTimeInterval period = 1.0;
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, self.queue);
    dispatch_source_set_timer(self.timer, dispatch_walltime(NULL, 0), period * NSEC_PER_SEC, 0); 
    dispatch_source_set_event_handler(self.timer, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.timeInterval <= 1) {
                [self cancleRunTime];
                RYSafeBlock(completion, nil);
            }else{
                self.timeInterval--;
                RYSafeBlock(eventHandler, @(self.timeInterval));
            }
        });
    });
    dispatch_resume(self.timer);

}

- (void)cancleRunTime {
    if (self.timer) {
        dispatch_cancel(self.timer);
    }
}

- (dispatch_queue_t)queue {
    if (!_queue) {
        _queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    }
    return _queue;
}

@end

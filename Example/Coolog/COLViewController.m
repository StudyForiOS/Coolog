//
//  COLViewController.m
//  Coolog
//
//  Created by yao.li on 05/15/2018.
//  Copyright (c) 2018 yao.li. All rights reserved.
//

#import "COLViewController.h"
#import <Coolog/Coolog.h>
#import "MyLogger.h"
#import "MyLogFormatter.h"

@interface COLViewController ()

@end

@implementation COLViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
//    COLLoggerDriver *myDriver = [[COLLoggerDriver alloc] initWithLogger:[MyLogger logger]
//                                                              formatter:[[MyLogFormatter alloc] init]
//                                                                  level:COLLogLevelInfo];
//    [[COLLogManager sharedInstance].logEngine addDriver:myDriver];
}

- (IBAction)buttonOnTapped:(UIButton *)sender {
    NSMutableArray *message = [NSMutableArray array];
    for (int i=0; i<100; i++) {
        [message addObject:[NSString stringWithFormat:@"value%@", @(i)]];
    }
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [self logTimeTakenToRunBlock:^{
//            for (int i=0; i<10000; i++) {
//                CLogError(@"tag", @"%@", [message description]);
//            }
//        } withPrefix:@"LOG in main thread"];
//    });
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    queue.maxConcurrentOperationCount = 10;
    for (int i=0; i<1; i++) {
        [queue addOperationWithBlock:^{
            CLogInfo(@"标签标", @"%@", [message description]);
        }];
        [queue addOperationWithBlock:^{
            CLogError(@"tag", @"%@", [message description]);
        }];
        [queue addOperationWithBlock:^{
            CLogWarning(@"tag", @"%@", [message description]);
        }];
    }

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self logTimeTakenToRunBlock:^{
            for (int i=0; i<2; i++) {
//                NSLog(@"tag %@ %@ %@", [message description], [NSThread currentThread], [NSDate date]);
                CLogE(@"%@", @"test");
            }
        } withPrefix:@"LOG in global thread"];
    });
}

- (IBAction)exportButtonOnTapped:(UIButton *)sender {
    [[COLLogManager sharedInstance] exportLog];
}

- (void)logTimeTakenToRunBlock:(void(^)(void))block withPrefix:(NSString *)prefixString {
    
    double a = CACurrentMediaTime();
    block();
    double b = CACurrentMediaTime();
    
    unsigned int m = ((b-a) * 1000.0f); // convert from seconds to milliseconds
    
    NSLog(@"%@: %d ms", prefixString ? prefixString : @"Time taken", m);
}

- (IBAction)restartButtonOnTapped:(UIButton *)sender {
    [[COLLogManager sharedInstance] enableRemoteConsole];
}
@end

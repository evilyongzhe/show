//
//  ViewController.m
//  7-05GCDDemo
//
//  Created by 郝海圣 on 16/1/20.
//  Copyright © 2016年 郝海圣. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //GCD grand central dispatch
    //1实现多线程的一种技术
    //2有三种队列 主队列，全局队列，自己创建的队列
    //3gcd 把任务放在队列中，指定是否是异步执行还是同步执行
    //4gcd 任务放到队列中，自动帮我们开辟线程

//    [self getMainQueue];
//    [self getGlobalQueue];
//    [self createMyQueue];
    [self gcdGroup];
}
/**
 *  组的概念，一组任务是并发的，做完一组之后 通知 做另一个任务
 */
-(void)gcdGroup{
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0);
    //dispatch_group_t 组
    //组的队列任意
    //组的任务个数任意
    
    //dispatch_group_create 创建组
    dispatch_group_t myGroup = dispatch_group_create();
    //dispatch_group_async 异步执行组中的任务
    //参数一：组
    //参数二：队列（可以不是同一个队列）任意
    //参数三：队列中的任务
    dispatch_group_async(myGroup, globalQueue, ^{
        for (int i = 0; i < 10; i++) {
            NSLog(@"买碗 %d",i);
        }
    });
    dispatch_group_async(myGroup, globalQueue, ^{
        for (int i = 0; i < 10; i++) {
            NSLog(@"买面 小鸡炖蘑菇 %d",i);
        }
    });
    dispatch_group_async(myGroup, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        for (int i = 0; i < 10; i++) {
            NSLog(@"烧水");
        }
    });
    //这一组任务完成之后，通知dispatch_group_notify 中的队列中的任务
    dispatch_group_notify(myGroup, globalQueue, ^{
        NSLog(@"%@",[NSThread currentThread]);

        for (int i = 0; i < 10; i++) {
            NSLog(@"吃泡面 %d",i);
        }
    });
    dispatch_group_notify(myGroup, dispatch_get_main_queue()  , ^{
        NSLog(@"%@",[NSThread currentThread]);
        for (int i = 0; i < 10; i++) {
            NSLog(@"看电视 %d",i);
        }
    });
    
    
}
/**
 *  创建自己的队列
 */
-(void)createMyQueue{
    //dispatch_queue_create 创建队列
    //参数一：队列的名字
    //参数二：指定队列的类型，串行还是并发
    //DISPATCH_QUEUE_CONCURRENT 并发队列
    //DISPATCH_QUEUE_SERIAL 串行队列
    dispatch_queue_t myQueue = dispatch_queue_create("myQueue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(myQueue, ^{
        for (int i = 0; i < 10; i++) {
            NSLog(@"昨天星期二");
        }
    });
    dispatch_async(myQueue, ^{
        for (int i = 0; i < 10; i++) {
            NSLog(@"今天星期三");
        }
    });
    dispatch_async(myQueue, ^{
        for (int i = 0; i < 10; i++) {
            NSLog(@"明天星期四");
        }
    });
}
/**
 *  获得全局队列，并发队列
 */
-(void)getGlobalQueue{
    //全局队列 是苹果封装好的队列
    //（重点） 是并发的队列
    //dispatch_get_global_queue 获得全局队列
    //参数一：优先级别，如果有资源，先给级别高的，从上到下依次降低
    // DISPATCH_QUEUE_PRIORITY_HIGH 2
    // DISPATCH_QUEUE_PRIORITY_DEFAULT 0
    // DISPATCH_QUEUE_PRIORITY_LOW (-2)
    // DISPATCH_QUEUE_PRIORITY_BACKGROUND
    //参数二：缺省值，现在无实际意义，留作以后的参数。写为0
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
    //dispatch_async 把block放在全局队列中，异步执行
    dispatch_async(globalQueue, ^{
        for (int i = 0; i < 10;i++) {
            NSLog(@"今天周三了 i %d",i);
        }
    });
    dispatch_async(globalQueue, ^{
        for (int i = 0; i < 10; i++) {
            NSLog(@"明天周四了 %d",i);
        }
    });
    
    
    
}
/**
 *  获得主队列，主队列的任务在主线程的执行的
 */
-(void)getMainQueue{
    
    //dispatch_queue_t 表示队列
    //dispatch_get_main_queue 获得主队列
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    //dispatch_async 异步执行放在主队列中的任务
    //主队列中的任务，万万不可同步
    dispatch_async(mainQueue, ^{
        self.view.backgroundColor = [UIColor redColor];
    });
}



@end

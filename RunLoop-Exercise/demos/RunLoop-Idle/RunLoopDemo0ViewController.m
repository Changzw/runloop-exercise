//
//  RunLoopDemo0ViewController.m
//  RunLoop-Exercise
//
//  Created by czw on 5/27/20.
//  Copyright © 2020 czw. All rights reserved.
//

#import "RunLoopDemo0ViewController.h"

static void runloopCallout(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info){
//  kCFRunLoopEntry = (1UL << 0),
//  kCFRunLoopBeforeTimers = (1UL << 1),
//  kCFRunLoopBeforeSources = (1UL << 2),
//  kCFRunLoopBeforeWaiting = (1UL << 5),
//  kCFRunLoopAfterWaiting = (1UL << 6),
//  kCFRunLoopExit = (1UL << 7),
//  kCFRunLoopAllActivities = 0x0FFFFFFFU
  switch (activity) {
    case kCFRunLoopEntry:
      NSLog(@"1-kCFRunLoopEntry");
      break;
    case kCFRunLoopBeforeTimers:
      NSLog(@"1-kCFRunLoopBeforeTimers");
      break;
    case kCFRunLoopBeforeSources:
      NSLog(@"1-kCFRunLoopBeforeSources");
      break;
    case kCFRunLoopBeforeWaiting:
      NSLog(@"1-kCFRunLoopBeforeWaiting");
      break;
    case kCFRunLoopAfterWaiting:
      NSLog(@"1-kCFRunLoopAfterWaiting");
      break;
    case kCFRunLoopExit:
      NSLog(@"1-kCFRunLoopExit");
      break;
    case kCFRunLoopAllActivities:
      break;
  }
}

static void __runloop_callback(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info){
  NSString *str;
  switch (activity) {
    case kCFRunLoopEntry:
      str = @"Min Entry";
      break;
    case kCFRunLoopBeforeTimers:
      str = @"Min Before Timersr";
      break;
    case kCFRunLoopBeforeSources:
      str = @"Min Before Sources";
      break;
    case kCFRunLoopBeforeWaiting:
      str = @"Min Before Waiting";
      break;
    case kCFRunLoopAfterWaiting:
      str = @"Min After Waiting";
      break;
    case kCFRunLoopExit:
      str = @"Min Exit";
      break;
    case kCFRunLoopAllActivities:
      str = @"Min AllActivities";
      break;
    default:
      break;
  }
  NSLog(@"current activity:%@",str);
}

static void __runloop_before_waiting_callback(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info) {
  NSString *str;
  switch (activity) {
    case kCFRunLoopEntry:
      str = @"Max Entry";
      break;
    case kCFRunLoopBeforeTimers:
      str = @"Max Before Timersr";
      break;
    case kCFRunLoopBeforeSources:
      str = @"Max Before Sources";
      break;
    case kCFRunLoopBeforeWaiting:
      str = @"Max Before Waiting";
      break;
    case kCFRunLoopAfterWaiting:
      str = @"Max After Waiting";
      break;
    case kCFRunLoopExit:
      str = @"Max Exit";
      break;
    case kCFRunLoopAllActivities:
      str = @"Max AllActivities";
      break;
    default:
      break;
  }
  NSLog(@"current activity:%@",str);
}

@interface RunLoopDemo0ViewController ()

@end

@implementation RunLoopDemo0ViewController

static int count = 0;
- (void)viewDidLoad {
  [super viewDidLoad];
  self.view.backgroundColor = [UIColor whiteColor];
  
  [self testRunLoopObserver];
}

- (void)testRunloopIdle{
  CFRunLoopRef rl = CFRunLoopGetCurrent();
  CFRunLoopObserverRef o1 = CFRunLoopObserverCreate(kCFAllocatorDefault, kCFRunLoopBeforeWaiting, true, 0, runloopCallout, nil);
  CFRunLoopObserverRef o2 = CFRunLoopObserverCreateWithHandler( kCFAllocatorDefault, kCFRunLoopBeforeWaiting, true, 0, ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
    if (count == 3) {
      CFRunLoopRemoveObserver(rl, o1, kCFRunLoopDefaultMode);
      CFRunLoopRemoveObserver(rl, observer, kCFRunLoopDefaultMode);
      CFRelease(o1);
      CFRelease(observer);
      return;
    }
    
    [self performSelector:@selector(runloopObserver:) onThread:NSThread.mainThread withObject:@(count) waitUntilDone:false modes:@[NSDefaultRunLoopMode]];
    ++count;
    switch (activity) {
      case kCFRunLoopEntry:
        NSLog(@"2-kCFRunLoopEntry");
        break;
      case kCFRunLoopBeforeTimers:
        NSLog(@"2-kCFRunLoopBeforeTimers");
        break;
      case kCFRunLoopBeforeSources:
        NSLog(@"2-kCFRunLoopBeforeSources");
        break;
      case kCFRunLoopBeforeWaiting:
        NSLog(@"2-kCFRunLoopBeforeWaiting");
        break;
      case kCFRunLoopAfterWaiting:
        NSLog(@"2-kCFRunLoopAfterWaiting");
        break;
      case kCFRunLoopExit:
        NSLog(@"2-kCFRunLoopExit");
        break;
      case kCFRunLoopAllActivities:
        break;
    }
  });
  
  CFRunLoopAddObserver(rl, o1, kCFRunLoopDefaultMode);
  CFRunLoopAddObserver(rl, o2, kCFRunLoopDefaultMode);
}

- (void) runloopObserver:(id) value {
  NSLog(@"2333--%@", value);
}


- (void)testRunLoopObserver{
  CFRunLoopObserverContext ctx = { 0, (__bridge void *)self, NULL, NULL };
  CFRunLoopObserverRef allActivitiesObserver = CFRunLoopObserverCreate(kCFAllocatorDefault, kCFRunLoopAllActivities, YES, NSIntegerMin, &__runloop_callback, &ctx);
  CFRunLoopAddObserver(CFRunLoopGetCurrent(), allActivitiesObserver, kCFRunLoopCommonModes);
  
  CFRunLoopObserverRef beforeWaitingObserver = CFRunLoopObserverCreate(kCFAllocatorDefault, kCFRunLoopBeforeWaiting, YES, NSIntegerMax, &__runloop_before_waiting_callback, &ctx);
  CFRunLoopAddObserver(CFRunLoopGetCurrent(), beforeWaitingObserver, kCFRunLoopCommonModes);
}
@end

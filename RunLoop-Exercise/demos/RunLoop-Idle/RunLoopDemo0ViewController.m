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
      NSLog(@"RunLoop: Entry");
      break;
    case kCFRunLoopBeforeTimers:
      NSLog(@"RunLoop: BeforeTimers");
      break;
    case kCFRunLoopBeforeSources:
      NSLog(@"RunLoop: BeforeSources");
      break;
    case kCFRunLoopBeforeWaiting:
      NSLog(@"RunLoop: BeforeWaiting");
      break;
    case kCFRunLoopAfterWaiting:
      NSLog(@"RunLoop: AfterWaiting");
      break;
    case kCFRunLoopExit:
      NSLog(@"RunLoop: Exit");
      break;
    case kCFRunLoopAllActivities:
      break;
  }
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

- (void) runloopObserver:(id) value {
  NSLog(@"beforeWaiting: doing --%@", value);
}

- (void)testRunLoopObserver{
  CFRunLoopObserverContext ctx = { 0, (__bridge void *)self, NULL, NULL };
  CFRunLoopObserverRef allActivitiesObserver = CFRunLoopObserverCreate(kCFAllocatorDefault, kCFRunLoopAllActivities, YES, NSIntegerMin, &runloopCallout, &ctx);
  CFRunLoopAddObserver(CFRunLoopGetCurrent(), allActivitiesObserver, kCFRunLoopCommonModes);
  
  CFRunLoopRef rl = CFRunLoopGetCurrent();
  CFRunLoopObserverRef beforeWaitingObserver = CFRunLoopObserverCreateWithHandler( kCFAllocatorDefault, kCFRunLoopBeforeWaiting, true, 0, ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
    if (count == 3) {
      CFRunLoopRemoveObserver(rl, observer, kCFRunLoopDefaultMode);
      CFRelease(observer);
      return;
    }
    NSLog(@"observer beforeWaiting");
    [self performSelector:@selector(runloopObserver:) onThread:NSThread.mainThread withObject:@(count) waitUntilDone:false modes:@[NSDefaultRunLoopMode]];
    ++count;
  });
  CFRunLoopAddObserver(CFRunLoopGetCurrent(), beforeWaitingObserver, kCFRunLoopCommonModes);
}
@end

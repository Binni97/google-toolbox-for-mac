//
//  GTMUILocalizerAndLayoutTweakerTest.m
//
//  Copyright 2009 Google Inc.
//
//  Licensed under the Apache License, Version 2.0 (the "License"); you may not
//  use this file except in compliance with the License.  You may obtain a copy
//  of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
//  WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.  See the
//  License for the specific language governing permissions and limitations under
//  the License.
//

#import "GTMSenTestCase.h"
#import "GTMUILocalizerAndLayoutTweakerTest.h"
#import "GTMNSObject+UnitTesting.h"
#import "GTMUILocalizerAndLayoutTweaker.h"

static NSUInteger gTestPass = 0;

@interface GTMUILocalizerAndLayoutTweakerTest : GTMTestCase
@end

@implementation GTMUILocalizerAndLayoutTweakerTest

- (void)testWindowLocalization {
  // Test with nib 1
  for (gTestPass = 0; gTestPass < 3; ++gTestPass) {
    GTMUILocalizerAndLayoutTweakerTestWindowController *controller =
      [[GTMUILocalizerAndLayoutTweakerTestWindowController alloc]
        initWithWindowNibName:@"GTMUILocalizerAndLayoutTweakerTest1"];
    NSWindow *window = [controller window];
    STAssertNotNil(window, @"Pass %zu", gTestPass);
    NSString *imageName =
      [NSString stringWithFormat:@"GTMUILocalizerAndLayoutTweakerTest1-%ld",
        (long)gTestPass];
    GTMAssertObjectImageEqualToImageNamed(window, imageName,
                                          @"Pass %zu", gTestPass);
    [controller release];
  }
  // Test with nib 2
  for (gTestPass = 0; gTestPass < 3; ++gTestPass) {
    GTMUILocalizerAndLayoutTweakerTestWindowController *controller =
      [[GTMUILocalizerAndLayoutTweakerTestWindowController alloc]
        initWithWindowNibName:@"GTMUILocalizerAndLayoutTweakerTest2"];
    NSWindow *window = [controller window];
    STAssertNotNil(window, @"Pass %zu", gTestPass);
    NSString *imageName =
      [NSString stringWithFormat:@"GTMUILocalizerAndLayoutTweakerTest2-%ld",
        (long)gTestPass];
    GTMAssertObjectImageEqualToImageNamed(window, imageName,
                                          @"Pass %zu", gTestPass);
    [controller release];
  }
}

- (void)testSizeToFitFixedWidthTextField {
  // In the xib, the one field is over sized, the other is undersized, this
  // way we make sure the code handles both condions as there was a bahavior
  // change between the 10.4 and 10.5 SDKs.
  // The right field is also right aligned to make sure the width of the text
  // field stays constant.
  NSString *kTestStrings[] = {
    @"The fox jumps the dog.",
    @"The quick brown fox jumps over the lazy dog.",
    @"The quick brown fox jumps over the lazy dog.  The quick brown fox jumps "
      @"over the lazy dog.  The quick brown fox jumps over the lazy dog.  "
      @"The quick brown fox jumps over the lazy dog.  The quick brown fox "
      @"jumps over the lazy dog.",
    @"The quick brown fox jumps over the lazy dog.\nThe quick brown fox jumps "
      @"over the lazy dog.\nThe quick brown fox jumps over the lazy dog.\n"
      @"The quick brown fox jumps over the lazy dog.\nThe quick brown fox "
      @"jumps over the lazy dog.",
    @"The quick brown fox jumps over the lazy dog.  The quick brown fox jumps "
      @"over the lazy dog.\nThe quick brown fox jumps over the lazy dog.  "
      @"The quick brown fox jumps over the lazy dog.  The quick brown fox "
      @"jumps over the lazy dog.  The quick brown fox jumps over the lazy "
      @"dog.  The quick brown fox jumps over the lazy dog.\n\nThe End.",
  };
  for (size_t lp = 0;
       lp < (sizeof(kTestStrings) / sizeof(kTestStrings[0]));
       ++lp) {
    GTMUILocalizerAndLayoutTweakerTestWindowController *controller =
      [[GTMUILocalizerAndLayoutTweakerTestWindowController alloc]
        initWithWindowNibName:@"GTMUILocalizerAndLayoutTweakerTest3"];
    NSWindow *window = [controller window];
    STAssertNotNil(window, @"Pass %zu", lp);
    NSTextField *field;
    GTM_FOREACH_OBJECT(field, [[window contentView] subviews]) {
      STAssertTrue([field isMemberOfClass:[NSTextField class]],
                   @"Pass %zu", lp);
      [field setStringValue:kTestStrings[lp]];
      [GTMUILocalizerAndLayoutTweaker sizeToFitFixedWidthTextField:field];
    }
    NSString *imageName =
      [NSString stringWithFormat:@"GTMUILocalizerAndLayoutTweakerTest3-%ld",
       (long)lp];
    GTMAssertObjectImageEqualToImageNamed(window, imageName,
                                          @"Pass %zu", lp);
    [controller release];
  }
}

- (void)testButtonStyleLocalizations {
  // Since we special case standard push buttons, test all button types.

  // This also tests the vertical vs. horizontal layout code on widthbox, if
  // you look at the xib in IB, turn on the bounds rectagle display, and you'll
  // see how IB's left alignment is a visual alignment, it doesn't actually
  // align the bounds of the views.

  for (gTestPass = 0; gTestPass < 3; ++gTestPass) {
    GTMUILocalizerAndLayoutTweakerTestWindowController *controller =
      [[GTMUILocalizerAndLayoutTweakerTestWindowController alloc]
        initWithWindowNibName:@"GTMUILocalizerAndLayoutTweakerTest4"];
    NSWindow *window = [controller window];
    STAssertNotNil(window, @"Pass %zu", gTestPass);
    NSString *imageName =
      [NSString stringWithFormat:@"GTMUILocalizerAndLayoutTweakerTest4-%ld",
        (long)gTestPass];
    GTMAssertObjectImageEqualToImageNamed(window, imageName,
                                          @"Pass %zu", gTestPass);
    [controller release];
  }
}

- (void)testWrappingForWidth {
  NSString *kTestStrings[] = {
    @"The fox jumps the dog.",
    @"The quick brown fox jumps over the lazy dog.",
    @"The quick brown fox jumps over the lazy dog.  The quick brown fox jumps "
      @"over the lazy dog.  The quick brown fox jumps over the lazy dog.  "
      @"The quick brown fox jumps over the lazy dog.",
  };
  for (size_t lp = 0;
       lp < (sizeof(kTestStrings) / sizeof(kTestStrings[0]));
       ++lp) {
    GTMUILocalizerAndLayoutTweakerTestWindowController *controller =
      [[GTMUILocalizerAndLayoutTweakerTestWindowController alloc]
        initWithWindowNibName:@"GTMUILocalizerAndLayoutTweakerTest5"];
    NSWindow *window = [controller window];
    STAssertNotNil(window, @"Pass %zu", lp);
    NSView *view;
    GTM_FOREACH_OBJECT(view, [[window contentView] subviews]) {
      if ([view isMemberOfClass:[NSButton class]]) {
        NSButton *btn = (id)view;
        [btn setTitle:kTestStrings[lp]];
        [GTMUILocalizerAndLayoutTweaker wrapButtonTitleForWidth:btn];
      } else {
        STAssertTrue([view isMemberOfClass:[NSMatrix class]],
                     @"Pass %zu", lp);
        NSMatrix *mtx = (id)view;
        NSCell *cell;
        int i = 0;
        GTM_FOREACH_OBJECT(cell, [mtx cells]) {
          [cell setTitle:[NSString stringWithFormat:@"%d %@",
                          ++i, kTestStrings[lp]]];
        }
        [GTMUILocalizerAndLayoutTweaker wrapRadioGroupForWidth:mtx];
      }
      [GTMUILocalizerAndLayoutTweaker sizeToFitView:view];
    }
    NSString *imageName =
      [NSString stringWithFormat:@"GTMUILocalizerAndLayoutTweakerTest5-%ld",
       (long)lp];
    GTMAssertObjectImageEqualToImageNamed(window, imageName,
                                          @"Pass %zu", lp);
    [controller release];
  }
}

- (void)testTabViewLocalization {
  // Test with nib 6
  for (gTestPass = 0; gTestPass < 3; ++gTestPass) {
    GTMUILocalizerAndLayoutTweakerTestWindowController *controller =
      [[GTMUILocalizerAndLayoutTweakerTestWindowController alloc]
        initWithWindowNibName:@"GTMUILocalizerAndLayoutTweakerTest6"];
    NSWindow *window = [controller window];
    STAssertNotNil(window, @"Pass %zu", gTestPass);
    NSTabView *tabView = [controller tabView];
    for (NSInteger tabIndex = 0; tabIndex < [tabView numberOfTabViewItems];
         ++tabIndex) {
      [tabView selectTabViewItemAtIndex:tabIndex];
      NSString *imageName =
        [NSString stringWithFormat:
          @"GTMUILocalizerAndLayoutTweakerTest6-tab%ld-%ld",
          (long)tabIndex, (long)gTestPass];
      GTMAssertObjectImageEqualToImageNamed(window, imageName,
                                            @"Pass %zu", gTestPass);
    }
    [controller release];
  }
  // Test with nib 2
  for (gTestPass = 0; gTestPass < 3; ++gTestPass) {
    GTMUILocalizerAndLayoutTweakerTestWindowController *controller =
      [[GTMUILocalizerAndLayoutTweakerTestWindowController alloc]
        initWithWindowNibName:@"GTMUILocalizerAndLayoutTweakerTest2"];
    NSWindow *window = [controller window];
    STAssertNotNil(window, @"Pass %zu", gTestPass);
    NSString *imageName =
      [NSString stringWithFormat:@"GTMUILocalizerAndLayoutTweakerTest2-%ld",
        (long)gTestPass];
    GTMAssertObjectImageEqualToImageNamed(window, imageName,
                                          @"Pass %zu", gTestPass);
    [controller release];
  }
}

#if MAC_OS_X_VERSION_MIN_REQUIRED >= MAC_OS_X_VERSION_10_5

- (void)testSizeToFitFixedHeightTextField {
  struct {
    const char *name;
    NSUInteger minWidth;
  } kTestModes[] = {
    { "NoMin", 0 },
    { "Min", 450 },
  };
  NSString *kTestStrings[] = {
    @"The fox jumps the dog.",
    @"The quick brown fox jumps over the lazy dog.",
    @"The quick brown fox jumps over the lazy dog.  The quick brown fox jumps "
    @"over the lazy dog.  The quick brown fox jumps over the lazy dog.  "
    @"The quick brown fox jumps over the lazy dog.  The quick brown fox "
    @"jumps over the lazy dog.",
    @"The quick brown fox jumps over the lazy dog.  The quick brown fox jumps "
    @"over the lazy dog. The quick brown fox jumps over the lazy dog.  "
    @"The quick brown fox jumps over the lazy dog.  The quick brown fox "
    @"jumps over the lazy dog.  The quick brown fox jumps over the lazy "
    @"dog.  The quick brown fox jumps over the lazy dog.  The End.",
  };
  for (size_t modeLoop = 0;
       modeLoop < (sizeof(kTestModes) / sizeof(kTestModes[0]));
       ++modeLoop) {
      for (size_t lp = 0;
         lp < (sizeof(kTestStrings) / sizeof(kTestStrings[0]));
         ++lp) {
      GTMUILocalizerAndLayoutTweakerTestWindowController *controller =
          [[GTMUILocalizerAndLayoutTweakerTestWindowController alloc]
           initWithWindowNibName:@"GTMUILocalizerAndLayoutTweakerTest7"];
      NSWindow *window = [controller window];
      STAssertNotNil(window, @"Pass %zu", lp);
      NSTextField *field;
      GTM_FOREACH_OBJECT(field, [[window contentView] subviews]) {
        STAssertTrue([field isMemberOfClass:[NSTextField class]],
                     @"Pass %zu", lp);
        [field setStringValue:kTestStrings[lp]];
        NSUInteger minWidth = kTestModes[modeLoop].minWidth;
        if (minWidth) {
          [GTMUILocalizerAndLayoutTweaker sizeToFitFixedHeightTextField:field
                                                               minWidth:minWidth];
        } else {
          [GTMUILocalizerAndLayoutTweaker sizeToFitFixedHeightTextField:field];
        }
      }
      NSString *imageName =
        [NSString stringWithFormat:@"GTMUILocalizerAndLayoutTweakerTest7-%s-%ld",
         kTestModes[modeLoop].name, (long)lp];
      GTMAssertObjectImageEqualToImageNamed(window, imageName,
                                            @"Pass %zu-%zu", modeLoop, lp);
      [controller release];
    }
  }
}

- (void)testSizeToFitFixedHeightTextFieldIntegral {
  NSTextField* textField =
      [[NSTextField alloc] initWithFrame:NSMakeRect(0, 0, 100, 50)];
  [textField setBezeled:NO];
  [textField setStringValue:@"The quick brown fox jumps over the lazy dog."];
  [GTMUILocalizerAndLayoutTweaker sizeToFitFixedHeightTextField:textField];
  STAssertTrue(
      NSEqualRects([textField bounds], NSIntegralRect([textField bounds])),
      nil);
  [textField release];
}

#endif  // MAC_OS_X_VERSION_MIN_REQUIRED >= MAC_OS_X_VERSION_10_5

@end

@implementation GTMUILocalizerAndLayoutTweakerTestWindowController

- (NSTabView *)tabView {
  return tabView_;
}

@end

@implementation GTMUILocalizerAndLayoutTweakerTestLocalizer

- (NSString *)localizedStringForString:(NSString *)string {
  // "[FRAGMENT]:[COUNT]:[COUNT]"
  // String is split, fragment is repeated count times, and spaces are then
  // trimmed.  Gives us strings that don't change for the test, but easy to
  // vary in size.  Which count is used, is controled by |gTestPass| so we
  // can use a nib more then once.
  NSArray *parts = [string componentsSeparatedByString:@":"];
  if ([parts count] > (gTestPass + 1)) {
    NSString *fragment = [parts objectAtIndex:0];
    NSInteger count = [[parts objectAtIndex:gTestPass + 1] intValue];
    if (count) {
      NSMutableString *result =
        [NSMutableString stringWithCapacity:count * [fragment length]];
      while (count--) {
        [result appendString:fragment];
      }
      NSCharacterSet *ws = [NSCharacterSet whitespaceCharacterSet];
      return [result stringByTrimmingCharactersInSet:ws];
    }
  }
  return nil;
}

- (void)awakeFromNib {
  // Stop the base one from logging or doing anything since we don't need it
  // for this test.
}

@end

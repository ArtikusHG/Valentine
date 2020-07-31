@interface UIImage (Private)
- (UIImage *)_flatImageWithColor:(UIColor *)color;
@end

BOOL fixOffset = NO;

void drawCustomIcon(CGContextRef ctx, CGSize imageSize, UIImage *base, NSCalendar *calendar, NSString *dayNumberString, BOOL fixOffset) {
  base = [base _flatImageWithColor:[UIColor whiteColor]];
  [base drawInRect:CGRectMake(0, 0, imageSize.width, imageSize.height)];
  NSInteger offset = (fixOffset) ? 5 : 0;

  NSDateFormatter *formatter = [NSDateFormatter new];
  formatter.locale = [NSLocale currentLocale];
  if (!dayNumberString) {
    formatter.dateFormat = @"d";
    dayNumberString = [formatter stringFromDate:[NSDate date]];
  }
  if (!calendar) calendar = [NSCalendar currentCalendar];

  CGFloat proportion = imageSize.width / 60.0f;
  UIFont *dayNumberFont;
  if (@available(iOS 8.2, *)) dayNumberFont = [UIFont systemFontOfSize:39.5 * proportion weight:UIFontWeightLight];
  else dayNumberFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:39.5 * proportion];
  CGSize size = [dayNumberString sizeWithAttributes:@{NSFontAttributeName:dayNumberFont}];
  [dayNumberString drawInRect:CGRectMake((imageSize.width - size.width + offset) / 2.0f, 12.0f * proportion, size.width, size.height) withAttributes:@{NSFontAttributeName:dayNumberFont, NSForegroundColorAttributeName:[UIColor blackColor]}];

  NSArray *shortWeeks = [formatter shortWeekdaySymbols];
  NSInteger day = [[calendar components:NSCalendarUnitWeekday fromDate:[NSDate date]] weekday];
  NSString *dayName = [shortWeeks[day - 1] uppercaseString];

  UIFont *dayNameFont = [UIFont boldSystemFontOfSize:12.0f * proportion];
  size = [dayName sizeWithAttributes:@{NSFontAttributeName:dayNameFont}];
  [dayName drawInRect:CGRectMake((imageSize.width - size.width) / 2.0f, 4.0f * proportion, size.width, size.height) withAttributes:@{NSFontAttributeName:dayNameFont, NSForegroundColorAttributeName:[UIColor colorWithRed:254.0 / 255.0 green: 72.0 / 255.0 blue:43.0 / 255.0 alpha:1]}];
}

// iOS 13
%hook CUIKDefaultIconGenerator
+ (void)_drawIconInContext:(CGContextRef)ctx imageSize:(CGSize)imageSize scale:(double)scale iconBase:(UIImage *)base calendar:(NSCalendar *)calendar dayNumberString:(NSString *)dayNumberString dateNameBlock:(id)dateNameBlock dateNameFormatType:(long long)dateNameFormatType showGrid:(BOOL)showGrid {
  drawCustomIcon(ctx, imageSize, base, calendar, dayNumberString, NO);
}
%end

// iOS 10 - 12
%hook CUIKCalendarApplicationIcon
+ (void)_drawIconInContext:(CGContextRef)ctx imageSize:(CGSize)imageSize iconBase:(UIImage *)base calendar:(NSCalendar *)calendar dayNumberString:(NSString *)dayNumberString dateNameBlock:(id)dateNameBlock dateNameFormatType:(long long)dateNameFormatType format:(long long)format showGrid:(BOOL)showGrid {
  drawCustomIcon(ctx, imageSize, base, calendar, dayNumberString, NO);
}
%end

%hook SBCalendarApplicationIcon
- (void)_drawIconIntoCurrentContextWithImageSize:(CGSize)imageSize iconBase:(UIImage *)base {
  drawCustomIcon(UIGraphicsGetCurrentContext(), imageSize, base, nil, nil, fixOffset);
}
%end

%ctor {
  if (kCFCoreFoundationVersionNumber < 1348.00) {
    NSDictionary *prefs = [NSDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/com.artikus.valentine.plist"];
    if (prefs && prefs[@"kFixOffset"]) fixOffset = [prefs[@"kFixOffset"] boolValue];
  }
}

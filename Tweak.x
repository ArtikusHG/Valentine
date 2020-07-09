@interface UIImage (Private)
- (UIImage *)_flatImageWithColor:(UIColor *)color;
@end

void drawCustomIcon(CGContextRef ctx, CGSize imageSize, UIImage *base, NSCalendar *calendar, NSString *dayNumberString) {
  base = [base _flatImageWithColor:[UIColor whiteColor]];
  [base drawInRect:CGRectMake(0, 0, imageSize.width, imageSize.height)];

  CGFloat proportion = imageSize.width / 60;
  UIFont *dayNumberFont = [UIFont systemFontOfSize:39.5 * proportion weight:UIFontWeightLight];
  CGSize size = [dayNumberString sizeWithAttributes:@{NSFontAttributeName:dayNumberFont}];
  [dayNumberString drawInRect:CGRectMake((imageSize.width - size.width) / 2, 12.0f * proportion, size.width, size.height) withAttributes:@{NSFontAttributeName:dayNumberFont, NSForegroundColorAttributeName:[UIColor blackColor]}];

  NSDateFormatter *formatter = [NSDateFormatter new];
  [formatter setLocale:[NSLocale currentLocale]];
  NSArray *shortWeeks = [formatter shortWeekdaySymbols];
  NSInteger day = [calendar component:NSCalendarUnitWeekday fromDate:[NSDate date]];
  NSString *dayName = [shortWeeks[day - 1] uppercaseString];

  UIFont *dayNameFont = [UIFont boldSystemFontOfSize:12.0f * proportion];
  size = [dayName sizeWithAttributes:@{NSFontAttributeName:dayNameFont}];
  [dayName drawInRect:CGRectMake((imageSize.width - size.width) / 2, 4.0f * proportion, size.width, size.height) withAttributes:@{NSFontAttributeName:dayNameFont, NSForegroundColorAttributeName:[UIColor colorWithRed:254.0 / 255.0 green: 72.0 / 255.0 blue:43.0 / 255.0 alpha:1]}];
}

// iOS 13
%hook CUIKDefaultIconGenerator
+ (void)_drawIconInContext:(CGContextRef)ctx imageSize:(CGSize)imageSize scale:(double)scale iconBase:(UIImage *)base calendar:(NSCalendar *)calendar dayNumberString:(NSString *)dayNumberString dateNameBlock:(id)dateNameBlock dateNameFormatType:(long long)dateNameFormatType showGrid:(BOOL)showGrid {
  drawCustomIcon(ctx, imageSize, base, calendar, dayNumberString);
}
%end

// iOS 10 - 12
%hook CUIKCalendarApplicationIcon
+ (void)_drawIconInContext:(CGContextRef)ctx imageSize:(CGSize)imageSize iconBase:(UIImage *)base calendar:(NSCalendar *)calendar dayNumberString:(NSString *)dayNumberString dateNameBlock:(id)dateNameBlock dateNameFormatType:(long long)dateNameFormatType format:(long long)format showGrid:(BOOL)showGrid {
  drawCustomIcon(ctx, imageSize, base, calendar, dayNumberString);
}
%end

#include <AppKit/NSAttributedString.h>

@implementation NSAttributedString (AppKit)

- (BOOL) containsAttachments
{
  // Currently there are no attachment in GNUstep.
  // FIXME.
  return NO;
}

- (NSDictionary*) fontAttributesInRange: (NSRange)range
{
  NSDictionary	*all;
  static SEL	sel = @selector(objectForKey:);
  IMP		objForKey;
  id		objects[8];
  id		keys[8];
  int		count = 0;

  if (range.location < 0 || NSMaxRange(range) > [self length])
    {
      [NSException raise: NSRangeException
		  format: @"RangeError in method -fontAttributesInRange:"];
    }
  all = [self attributesAtIndex: range.location
		 effectiveRange: &range];

  objForKey = [all methodForSelector: sel];

  keys[count] = NSFontAttributeName;
  objects[count] = (*objForKey)(all, sel, keys[count]);
  if (objects[count] != nil)
    count++;

  keys[count] = NSForegroundColorAttributeName;
  objects[count] = (*objForKey)(all, sel, keys[count]);
  if (objects[count] != nil)
    count++;

  keys[count] = NSBackgroundColorAttributeName;
  objects[count] = (*objForKey)(all, sel, keys[count]);
  if (objects[count] != nil)
    count++;

  keys[count] = NSUnderlineStyleAttributeName;
  objects[count] = (*objForKey)(all, sel, keys[count]);
  if (objects[count] != nil)
    count++;

  keys[count] = NSSuperscriptAttributeName;
  objects[count] = (*objForKey)(all, sel, keys[count]);
  if (objects[count] != nil)
    count++;

  keys[count] = NSBaselineOffsetAttributeName;
  objects[count] = (*objForKey)(all, sel, keys[count]);
  if (objects[count] != nil)
    count++;

  keys[count] = NSKernAttributeName;
  objects[count] = (*objForKey)(all, sel, keys[count]);
  if (objects[count] != nil)
    count++;

  keys[count] = NSLigatureAttributeName;
  objects[count] = (*objForKey)(all, sel, keys[count]);
  if (objects[count] != nil)
    count++;

  return [NSDictionary dictionaryWithObjects: objects
				     forKeys: keys
				       count: count];
}

- (NSDictionary*) rulerAttributesInRange: (NSRange)range
{
  id	style;

  if (range.location < 0 || NSMaxRange(range) > [self length])
    {
      [NSException raise: NSRangeException
		  format: @"RangeError in method -rulerAttributesInRange:"];
    }

  style = [self attribute: NSParagraphStyleAttributeName
		  atIndex: range.location
	   effectiveRange: &range];

  if (style)
    {
      return [NSDictionary dictionaryWithObject: style
					 forKey: NSParagraphStyleAttributeName];
    }
  return [NSDictionary dictionary];
}

- (unsigned) lineBreakBeforeIndex: (unsigned)location
                      withinRange: (NSRange)aRange
{
  NSScanner *tScanner;
  unsigned int sL;

  tScanner = [[NSScanner alloc] initWithString: [[self string]
	substringWithRange: aRange]];
  [tScanner scanUpToString: [NSText newlineString] intoString:NULL];
  sL = [tScanner scanLocation] + 2;

  [tScanner release];

  if (sL > aRange.length)
    return NSNotFound;
  else
    return sL;
}

- (NSRange) doubleClickAtIndex: (unsigned)location
{
}

- (unsigned) nextWordFromIndex: (unsigned)location
		       forward: (BOOL)isForward
{
}

/*
 * This is where the fun begins with RTF/RTFD/HTML
 * This is currently ALL FIXME. :-)
 * With love from Michael, hehe.
 */

- (id) initWithRTF: (NSData*)data
  documentAttributes: (NSDictionary**)dict
{
  return self;
}

- (id) initWithRTFD: (NSData*)data
 documentAttributes: (NSDictionary**)dict
{
  return self;
}

- (id) initWithPath: (NSString*)path
 documentAttributes: (NSDictionary**)dict
{
  return self;
}

- (id) initWithURL: (NSURL*)url 
documentAttributes: (NSDictionary**)dict
{
  return self;
}

- (id) initWithRTFDFileWrapper: (NSFileWrapper*)wrapper
            documentAttributes: (NSDictionary**)dict
{
  return self;
}

- (id) initWithHTML: (NSData*)data
 documentAttributes: (NSDictionary**)dict
{
  return self;
}

- (id) initWithHTML: (NSData*)data
            baseURL: (NSURL*)base
 documentAttributes: (NSDictionary**)dict
{
  return self;
}

- (NSData*) RTFFromRange: (NSRange)range
      documentAttributes: (NSDictionary*)dict
{
  return (NSData *)self;
}

- (NSData*) RTFDFromRange: (NSRange)range
       documentAttributes: (NSDictionary*)dict
{
  return (NSData *)self;
}

- (NSFileWrapper*) RTFDFileWrapperFromRange: (NSRange)range
			 documentAttributes: (NSDictionary*)dict
{
  return (NSFileWrapper *)self;
}
@end

@implementation NSMutableAttributedString (AppKit)
- (void) superscriptRange: (NSRange)range
{
  id value;
  int sValue;

  value = [self attribute: NSSuperscriptAttributeName
		  atIndex: range.location
	   effectiveRange: &range];

  sValue = [value intValue];

  sValue++;

  [self addAttribute: NSSuperscriptAttributeName
	       value: [[NSNumber alloc] initWithInt: sValue]
	       range: range];
}

- (void) subscriptRange: (NSRange)range
{
  id value;
  int sValue;

  value = [self attribute: NSSuperscriptAttributeName
		  atIndex: range.location
	   effectiveRange: &range];

  sValue = [value intValue];

  sValue--;

  [self addAttribute: NSSuperscriptAttributeName
	       value: [[NSNumber alloc] initWithInt: sValue]
	       range: range];
}

- (void)unscriptRange:(NSRange)range
{
  [self addAttribute:NSSuperscriptAttributeName value:[[NSNumber alloc]
        initWithInt:0] range:range];
}

- (void)applyFontTraits:(NSFontTraitMask)traitMask range:(NSRange)range
{
/* We don't use font traits yet, oops. */
/*
  id value;

  value = [self attribute:NSFontAttributeName
		atIndex:range.location effectiveRange:range];

  [value setFontTraits:traitMask];

  [self addAttribute:NSFontAttributeName value:value range:range];
*/
}

- (void)setAlignment:(NSTextAlignment)alignment range:(NSRange)range
{
  id value;

  value = [self attribute:NSParagraphStyleAttributeName
		atIndex:range.location effectiveRange:&range];

  [value setAlignment:alignment];

  [self addAttribute:NSParagraphStyleAttributeName value:value range:range];
}

- (void)fixAttributesInRange:(NSRange)range
{
  [self fixFontAttributeInRange:range];
  [self fixParagraphStyleAttributeInRange:range];
  [self fixAttachmentAttributeInRange:range];
}

- (void)fixFontAttributeInRange:(NSRange)range
{
}

- (void)fixParagraphStyleAttributeInRange:(NSRange)range
{
}

- (void)fixAttachmentAttributeInRange:(NSRange)range
{
}
@end

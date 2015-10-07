//
//  ConceptView4Colors.m
//  BoolyConcept
//
//  Created by NL on 10/3/15.
//  Copyright © 2015 Nur Lan. All rights reserved.
//

#import "ObjectToGraphics.h"
#import "BoolObjectView4Colors.h"

@implementation BoolObjectView4Colors

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {

    if (!self.boolObject) return;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIBezierPath *p;
    CGRect rect1 = rect;
    rect1.size.width = rect.size.width / 2;
    rect1.size.height = rect.size.height / 2;
    UIColor *currColor;
    NSInteger currVal;

    for (int i=0; i<4; i++) {
        rect1.origin.x = rect.origin.x + (i%2 == 0 ? 0 : (rect.size.width / 2));
        rect1.origin.y = rect.origin.y + (i < 2 ? 0 : (rect.size.height / 2));
        p = [UIBezierPath bezierPathWithRect:rect1];
        currVal = [[self.boolObject getFeatureValue:i] integerValue];
        currColor = [self.parentViewController.objectToGraphicsHandler colorForFeature:i withValue:currVal];
        CGFloat r,g,b;
        [currColor getRed:&r green:&g blue:&b alpha:nil];
        CGContextSetFillColorWithColor(context, currColor.CGColor);
        [p fill];
    }
}


@end

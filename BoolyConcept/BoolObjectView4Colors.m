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
    CGRect myRect = rect;
    float rectWidth = rect.size.width;
    float rectHeight = rect.size.height;
    myRect.size.width = rectWidth / 2;
    myRect.size.height = rectHeight / 2;
    UIColor *currColor;
    NSInteger currVal;
    
    
    //draw the four colored squares
    for (int i=0; i<4; i++) {
        myRect.origin.x = rect.origin.x + (i%2 == 0 ? 0 : (rect.size.width / 2));
        myRect.origin.y = rect.origin.y + (i < 2 ? 0 : (rect.size.height / 2));
        p = [UIBezierPath bezierPathWithRect:myRect];
        currVal = [[self.boolObject getFeatureValue:i] integerValue];
        currColor = [self.parentViewController.objectToGraphicsHandler colorForFeature:i withValue:currVal];
        CGFloat r,g,b;
        [currColor getRed:&r green:&g blue:&b alpha:nil];
        CGContextSetFillColorWithColor(context, currColor.CGColor);
        [p fill];
    }
    
    if (!self.shouldDrawArrow) return;
    //draw arrow between two positive quarters
    NSLog(@"should draw line 1");
    
    int numOfPositives = 0;
    int positiveIndexes[] = {0, 0};

    for (int i=0; i<self.boolObject.numberOfFeaturesD; i++) {
        currVal = [[self.boolObject getFeatureValue:i] integerValue];
        if (currVal != [BOOL_VECTOR_IGNORE_FEATURE integerValue]) {
            positiveIndexes[numOfPositives] = i;
            numOfPositives++;
            if (numOfPositives > 2) break;
        }
    }
    if (numOfPositives < 2) return; //verify exactly 2 squares to be linked
    NSLog(@"should draw line 2");
    float x1,x2,y1,y2;

    x1 = rect.origin.x + (positiveIndexes[0]%2 == 0 ? rectWidth * 0.25 : (rectWidth * 0.75));
    x2 = rect.origin.x + (positiveIndexes[1]%2 == 0 ? rectWidth * 0.25 : (rectWidth * 0.75));
    y1 = rect.origin.y + (positiveIndexes[0] < 2 ? rectHeight * 0.25 : (rectHeight * 0.75));
    y2 = rect.origin.y + (positiveIndexes[1] < 2 ? rectHeight * 0.25 : (rectHeight * 0.75));
    //draw line
    NSLog(@"drawing line");
    
    UIBezierPath *arrowPath = [[UIBezierPath alloc] init];
    [arrowPath moveToPoint:CGPointMake(x1, y1)];
    [arrowPath addLineToPoint:CGPointMake(x2, y2)];
    arrowPath.lineWidth = 1.5;
    [[UIColor whiteColor] setStroke];
    [arrowPath stroke];

    
    CGPoint circleCenter = (CGPoint){x1,y1};
    float pi = 3.14159265;

    UIBezierPath *arrowHead = [UIBezierPath bezierPathWithArcCenter:circleCenter radius:(myRect.size.width / 8) startAngle:0 endAngle:pi*2 clockwise:YES];
    arrowHead.lineWidth = 2.5;
    [[UIColor whiteColor] setStroke];
    [[UIColor whiteColor] setFill];
    [arrowHead fill];
    
}



@end

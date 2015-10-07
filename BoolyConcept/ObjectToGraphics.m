//
//  ObjectToGraphics.m
//  BoolyConcept
//
//  Created by NL on 10/2/15.
//  Copyright © 2015 Nur Lan. All rights reserved.
//

#import "BoolConceptObject.h"
#import "ObjectToGraphics.h"

@implementation ObjectToGraphics

- (id)init {
    self = [super init];
    if (self) {
        self.colorPalette = [NSArray arrayWithObjects:color_palette_8_hex, nil];
    }
    return self;
}

- (UIColor*)colorForFeature:(NSInteger)feature withValue:(NSInteger)val {

    if (val == [BOOL_VECTOR_IGNORE_FEATURE integerValue]) {
        return DONT_CARE_COLOR;
    }
    if (val > 1)  {
        return [UIColor blackColor];   //TODO support non-binary
    }
    NSInteger colorIndex = (feature*2) + val;
    if (colorIndex > [self.colorPalette count])   {
        return [UIColor blackColor];   //TODO support non-binary
    }
    NSInteger colorInt = [[self.colorPalette objectAtIndex:colorIndex] integerValue];
    UIColor *retCol = UIColorFromRGB(colorInt);
    return retCol;
}


@end

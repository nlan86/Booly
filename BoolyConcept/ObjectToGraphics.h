//
//  ObjectToGraphics.h
//  BoolyConcept
//
//  Created by NL on 10/2/15.
//  Copyright © 2015 Nur Lan. All rights reserved.
//

#import "BoolConceptObject.h"
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#define UIColorFromRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >>  8))/255.0 \
blue:((float)((rgbValue & 0x0000FF) >>  0))/255.0 \
alpha:1.0]

#define color_palette_8_hex @(0x00cafc), @(0xffcd00), @(0xff9600), @(0xfe2955), @(0x007aff), @(0x00da5a), @(0xff382b), @(0x908f95)
#define DONT_CARE_COLOR [UIColor lightGrayColor]

/*!
 @class ObjectToGraphics
 Handles representing boolean objects as graphical objects. In current case, as colored squares.
 */

@interface ObjectToGraphics : NSObject

/*! Color palette to be used */
@property NSArray* colorPalette;

/*! Returns a color for a specific feature and its value, according to color_palette_8_hex values */
- (UIColor*)colorForFeature:(NSInteger)feature withValue:(NSInteger)val;

@end

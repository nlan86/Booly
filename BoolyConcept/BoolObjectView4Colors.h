//
//  ConceptView4Colors.h
//  BoolyConcept
//
//  Created by NL on 10/3/15.
//  Copyright © 2015 Nur Lan. All rights reserved.
//

#import "ColorsMainScreenViewController.h"
#import "BoolConceptObject.h"
#import <UIKit/UIKit.h>

@class ColorsMainScreenViewController;

/*! @class ConceptView4Colors
 UIView that represents a 4-feature boolean object 
 */

@interface BoolObjectView4Colors : UIView <UIGestureRecognizerDelegate>
/* Sets an arrow to be drawn in case of two-factor polynomial hint */
@property BOOL shouldDrawArrow;
@property (weak) ColorsMainScreenViewController *parentViewController;
/*! The boolean object to represent */
@property BoolConceptObject *boolObject;

@end

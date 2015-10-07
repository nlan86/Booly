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

@interface BoolObjectView4Colors : UIView <UIGestureRecognizerDelegate>

@property (weak) ColorsMainScreenViewController *parentViewController;
@property BoolConceptObject *boolObject;

@end

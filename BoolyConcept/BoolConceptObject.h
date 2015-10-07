//
//  Concept.h
//  BoolConcepts Framework
//
//  Created by NL on 9/3/15.
//  Copyright (c) 2015 Nur Lan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BoolPolynomial.h"
#import "BooleanVector.h"
#import "BooleanCommons.h"
#import "BoolConcept.h"

@class BoolPolynomial;

@interface BoolConceptObject : NSObject <NSCopying>

@property int numberOfFeaturesD;
@property BooleanVector* objectFeatureVector;


- (id)initWithFeatureVector: (BooleanVector*)featureVector;
- (id)initWithNumberOfFeatures: (int)numberOfFeatures;
- (BOOL)isWithinAreaDefinedByPolynomial:(BoolPolynomial*)poly;
- (NSString*)generateStringRepresentation;
- (BOOL)isEqualsToObject: (BoolConceptObject*)otherObj;
- (BOOL_FEATURE_DATA_TYPE)getFeatureValue:(int)fromFeatureNumber;


@end
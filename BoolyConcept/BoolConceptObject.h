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

/*!
 This class defines a boolean concept object, i.e., basically just a vector with features + more handy info. Also handles determining whether the object matches a polynomial theory.
 */
@class BoolPolynomial;

@interface BoolConceptObject : NSObject <NSCopying>

@property int numberOfFeaturesD;
@property BooleanVector* objectFeatureVector;

/*! Initalize new boolean concept object with existing feature vector
 @param featureVector Existing feature vector
 */
- (id)initWithFeatureVector: (BooleanVector*)featureVector;
/*! Initalize new boolean concept object
 @param numberOfFeatures Number of features in feature vector
 */
- (id)initWithNumberOfFeatures: (int)numberOfFeatures;
/*! Compares the object's feature vector with a regularity polynomial.
 \param poly the polynomial to compare with
 \returns YES if all terms of polynomial match or "don't care" about the object's features values
 */
- (BOOL)isWithinAreaDefinedByPolynomial:(BoolPolynomial*)poly;
/*! Generates a string representation of the object
 @return String representation
 */
- (NSString*)generateStringRepresentation;
/*! Compares current object to other object. Compares values, not references.
 @param otherObj other object to compare to
 @return YES if objects have the same feature values
 */
- (BOOL)isEqualsToObject: (BoolConceptObject*)otherObj;
/*! Fetches relevant feature value of object */
- (BOOL_FEATURE_DATA_TYPE)getFeatureValue:(int)fromFeatureNumber;


@end
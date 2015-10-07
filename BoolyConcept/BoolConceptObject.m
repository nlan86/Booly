//
//  Concept.m
//  BoolConcepts Framework
//
//  Created by NL on 9/3/15.
//  Copyright (c) 2015 Nur Lan. All rights reserved.
//

#import "BoolPolynomial.h"
#import "BoolConceptObject.h"


@implementation BoolConceptObject

/** Initalize new boolean concept object with existing feature vector
 @param featureVector Existing feature vector
 */
- (id)initWithFeatureVector: (BooleanVector*)featureVector {
    self = [super init];
    if (self) {
        _objectFeatureVector = featureVector;
        _numberOfFeaturesD = [featureVector numberOfFeatures];
    }
    return self;
}

/** Initalize new boolean concept object
 @param numberOfFeatures Number of features in feature vector
 */
- (id)initWithNumberOfFeatures: (int)numberOfFeatures {
    self = [super init];
    if (self) {
        BooleanVector *objectFeatureVector = [[BooleanVector alloc] initVectorWithNumberOfFeatures:numberOfFeatures];    //init with new empty feature vector
        self = [self initWithFeatureVector:objectFeatureVector];
    }
    return self;
}

- (id)init {
    return [self initWithNumberOfFeatures:BOOL_CONCEPT_DEFAULT_NUMBER_OF_FEATURES];
}

/** Fetches relevant feature value of object */
- (BOOL_FEATURE_DATA_TYPE)getFeatureValue:(int)fromFeatureNumber {
    return [self.objectFeatureVector getFeatureValue:fromFeatureNumber];
}

/*! Compares the object's feature vector with a regularity polynomial.
 \param poly the polynomial to compare with
 \returns YES if all terms of polynomial match or "don't care" about the object's features values
 */
-(BOOL)isWithinAreaDefinedByPolynomial:(BoolPolynomial*)poly {
    if (poly.numberOfFeatures != self.numberOfFeaturesD)    //comparing mismatching polynomial and object. must be an error
        return NO;
    NSInteger objectFeatureVal;
    NSInteger polyTermVal;
    
    for (int i=0; i<self.numberOfFeaturesD; i++) {
        objectFeatureVal = [[self.objectFeatureVector getFeatureValue:i] integerValue];
        polyTermVal = [[poly getTermValueAt:i] integerValue];
        if (polyTermVal != [BOOL_VECTOR_IGNORE_FEATURE integerValue] && objectFeatureVal !=  polyTermVal) return NO;
    }
    return YES;
}

/** Generates a string representation of the object
 @return String representation
 */
- (NSString*)generateStringRepresentation {
    return [self.objectFeatureVector generateStringRepresentation];
}

/** Compares current object to other object. Compares values, not references.
 @param otherObj other object to compare to
 @return YES if objects have the same feature values
 */
- (BOOL)isEqualsToObject: (BoolConceptObject*)otherObj {
    if (self.numberOfFeaturesD != otherObj.numberOfFeaturesD) return NO;
    for (int i=0; i<self.numberOfFeaturesD; i++) {
        if ([self.objectFeatureVector getFeatureValue:i] != [otherObj.objectFeatureVector getFeatureValue:i]) return NO;
    }
    return YES;
}

#pragma mark NSCopying

-(id)copyWithZone:(NSZone *)zone {
    BoolConceptObject *copyObject = [[BoolConceptObject alloc] initWithFeatureVector:[self.objectFeatureVector copy]];
    return copyObject;
}

@end

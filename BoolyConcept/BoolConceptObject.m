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

- (id)initWithFeatureVector: (BooleanVector*)featureVector {
    self = [super init];
    if (self) {
        _objectFeatureVector = featureVector;
        _numberOfFeaturesD = [featureVector numberOfFeatures];
    }
    return self;
}


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

- (BOOL_FEATURE_DATA_TYPE)getFeatureValue:(int)fromFeatureNumber {
    return [self.objectFeatureVector getFeatureValue:fromFeatureNumber];
}


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


- (NSString*)generateStringRepresentation {
    return [self.objectFeatureVector generateStringRepresentation];
}


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

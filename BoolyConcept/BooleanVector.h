//
//  BoolFeatureVector.h
//  BoolConcepts Framework
//
//  Created by NL on 9/3/15.
//  Copyright (c) 2015 Nur Lan. All rights reserved.
//

#import "BooleanCommons.h"
#import <Foundation/Foundation.h>

/*!
 @class BooleanVector
 Defines a feature vector with handy features for retrieving values and manipulating the vector.
 */

@interface BooleanVector : NSObject <NSCopying>

/*! The actual data structor representing the feature vector - an array with NSNumbers */
@property NSMutableArray *featVector;
/*! Number of features in concept universe */
@property int numberOfFeatures;

- (BOOL_FEATURE_DATA_TYPE)getFeatureValue:(int)fromFeatureNumber;
- (void)setFeatureValueAtIndex:(int)forFeatureNumber toValue:(BOOL_FEATURE_DATA_TYPE)theValue;
/*! Compare to another feature vector
 @param vector the other vector
 @return YES if vectors are equal
 */
- (BOOL)isEqualToVector: (BooleanVector*)vector;
/*! Counts number of positive features (not 'dont care's) in instance
 @returns count of positive features in vector
 */
- (NSInteger)countNumberOfPositiveFeaturesInVector;
/*! Used for debugging, represents the vector in ASCII chars */
- (NSString*)generateStringRepresentation;
/*! Zero all vector values to value
 @param valueObject Object to set values to
 */
-(void)setAllFeatureVectorValuesToObject:(id)valueObject;

#pragma mark Initializors

/*! Initializes a new boolean vector
 @param numberOfFeatures number of features
 @returns A vector with all features set to NO
 */
- (id)initVectorWithNumberOfFeatures:(int)numberOfFeatures;

#pragma mark Class methods
/*! Class method - Generates all 2^num_of_features vectors in lexical order. Used for creating universes for concepts.
 @param forNumberOfFeatures number of features
 @param numOfValues number of values possible
 @param featureOffset Add this amount to all feature values. Used with -1 when creating polynomials
 @returns Mutable array filled with all feature vectures in lexical order
 */
+ (NSMutableArray*)generateAllVectorsForNumberOfFeatures:(int)forNumberOfFeatures forNumberOfValues: (int)numOfValues withFeatureOffset:(int)featureOffset;


@end

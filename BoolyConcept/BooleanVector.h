//
//  BoolFeatureVector.h
//  BoolConcepts Framework
//
//  Created by NL on 9/3/15.
//  Copyright (c) 2015 Nur Lan. All rights reserved.
//

#import "BooleanCommons.h"
#import <Foundation/Foundation.h>

@interface BooleanVector : NSObject <NSCopying>

/** The actual data structor representing the feature vector - an array with NSNumbers */
@property NSMutableArray *featVector;
/** Number of features in concept universe */
@property int numberOfFeatures;

- (BOOL_FEATURE_DATA_TYPE)getFeatureValue:(int)fromFeatureNumber;
- (void)setFeatureValueAtIndex:(int)forFeatureNumber toValue:(BOOL_FEATURE_DATA_TYPE)theValue;
- (BOOL)isEqualToVector: (BooleanVector*)vector;
- (NSInteger)countNumberOfPositiveFeaturesInVector;
- (NSString*)generateStringRepresentation;

#pragma mark Initializors
- (id)initVectorWithNumberOfFeatures:(int)numberOfFeatures;

#pragma mark Class methods
+ (NSMutableArray*)generateAllVectorsForNumberOfFeatures:(int)forNumberOfFeatures forNumberOfValues: (int)numOfValues withFeatureOffset:(int)featureOffset;


@end

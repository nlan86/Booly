//
//  BoolFeatureVector.m
//  BoolConcepts Framework
//
//  Created by NL on 9/3/15.
//  Copyright (c) 2015 Nur Lan. All rights reserved.
//

#import "BooleanCommons.h"
#import "BooleanVector.h"

@implementation BooleanVector

#pragma mark Class methods
/** Class method - Generates all 2^num_of_features vectors in lexical order.
 \\param forNumberOfFeatures number of features
 \\param withFeatureOffset Add this amount to all feature values. Used with -1 when creating polynomials
 \\returns Mutable array filled with all feature vectures in lexical order
 */
+ (NSMutableArray*)generateAllVectorsForNumberOfFeatures:(int)forNumberOfFeatures forNumberOfValues: (int)numOfValues withFeatureOffset:(int)featureOffset {
    
    int numberOfObjects = (int) pow(numOfValues, forNumberOfFeatures);
    NSMutableArray *retArray = [[NSMutableArray alloc] initWithCapacity:numberOfObjects];

    int maximal_value = (numOfValues - 1) + featureOffset;
    int minimal_value = 0 + featureOffset;
    int rightmost_feature = forNumberOfFeatures - 1;
    int currentFeature;
    NSInteger currentFeatureVal = minimal_value;
    
    BooleanVector *currFeatureVector = [[BooleanVector alloc] initVectorWithNumberOfFeatures:forNumberOfFeatures];
    [retArray addObject:currFeatureVector];
    [currFeatureVector setAllFeatureVectorValuesToObject:@(minimal_value)]; //zero all values to minimal_value
    
    //iteratively create values^features vectors in lexical order.
    while (YES) {
        currFeatureVector = [currFeatureVector copy];   //clone previous feature vector
        currentFeature = rightmost_feature;
        currentFeatureVal = [[currFeatureVector getFeatureValue:currentFeature] integerValue];
        
        while (currentFeatureVal == maximal_value) {
            [currFeatureVector setFeatureValueAtIndex:currentFeature toValue:@(minimal_value)];
            currentFeature--;
            if (currentFeature < 0) break;
            currentFeatureVal = [[currFeatureVector getFeatureValue:currentFeature] integerValue];
        }
        if (currentFeature<0) break;
        [currFeatureVector setFeatureValueAtIndex:currentFeature toValue:@(currentFeatureVal + 1)];
        [retArray addObject:currFeatureVector]; //add +1-ed feature vector
    }
    
    return retArray;
}

#pragma mark Instance methods

/*! Counts number of positive features (1's) in instance
 \\returns count of positive features in vector
*/
-(NSInteger)countNumberOfPositiveFeaturesInVector {
    NSInteger count = 0;
    
    NSUInteger numOfTerms = self.featVector.count;
    BOOL_FEATURE_DATA_TYPE current_feature;
    
    for (int i=0; i<numOfTerms; i++) {
        current_feature = (BOOL_FEATURE_DATA_TYPE)[self.featVector objectAtIndex:i];
        if ([current_feature compare:BOOL_VECTOR_IGNORE_FEATURE] != NSOrderedSame) count++;
    }
    return count;

}

/** Zero all vector values to value
 @param valueObject Object to set values to
 */
-(void)setAllFeatureVectorValuesToObject:(id)valueObject {
    for (int i=0; i<self.numberOfFeatures; i++) {
        [self.featVector setObject:[valueObject copy] atIndexedSubscript:i];
    }
}

/*! Initializes a new boolean vector
 \\param numberOfFeatures number of features
 \\returns A vector with all features set to NO
 */
- (id)initVectorWithNumberOfFeatures:(int)numberOfFeatures {
    self = [super init];
    if (self) {
        _numberOfFeatures = numberOfFeatures;
        _featVector = [[NSMutableArray alloc] initWithCapacity:_numberOfFeatures];
        [self setAllFeatureVectorValuesToObject:BOOL_VECTOR_DEFAULT_FEATURE_VALUE];
    }
    return self;
}

-  (id)init {
    return [self initVectorWithNumberOfFeatures:BOOL_CONCEPT_DEFAULT_NUMBER_OF_FEATURES];
}

/** Compare to another feature vector
 @param vector the other vector
 @return YES if vectors are equal
 */
- (BOOL) isEqualToVector: (BooleanVector*)vector {
    if (self.featVector == vector.featVector) return YES;
    return NO;
}


- (BOOL_FEATURE_DATA_TYPE) getFeatureValue:(int)fromFeatureNumber {
    if (self.numberOfFeatures > fromFeatureNumber) {
        return [self.featVector objectAtIndex:fromFeatureNumber];
    }
    else NSLog(@"getFeatureValue: Index %d Out of bounds", fromFeatureNumber);
    return BOOL_VECTOR_IGNORE_FEATURE;
}

- (void) setFeatureValueAtIndex:(int)forFeatureNumber toValue:(BOOL_FEATURE_DATA_TYPE)theValue {
    if ([self numberOfFeatures] > forFeatureNumber) {
        [self.featVector setObject:theValue atIndexedSubscript:forFeatureNumber];
    }
    else NSLog(@"setFeatureValueAtIndex: Index %d Out of bounds", forFeatureNumber);
}


- (NSString*) featureToString:(BOOL_FEATURE_DATA_TYPE)featureVal {
    NSDictionary *alphabet = @{ VECTOR_CHARS_DICT };
    return alphabet[featureVal];
}

- (NSString*) generateStringRepresentation {
    NSString *retStr = @"";
    BOOL_FEATURE_DATA_TYPE currFeature;
    for (int i = 0; i < [self numberOfFeatures]; i++) { //count backwards to print in big endianness
        currFeature = [self getFeatureValue:i];
        retStr = [retStr stringByAppendingString:[NSString stringWithFormat:@"%@", [self featureToString:currFeature]]];
    }
    
    return retStr;
}

#pragma mark NSCopying

- (id)copyWithZone:(NSZone *)zone {
    BooleanVector *vecCopy = [[BooleanVector alloc] initVectorWithNumberOfFeatures:self.numberOfFeatures];
    for (int i=0; i<[self.featVector count]; i++) {
        [vecCopy setFeatureValueAtIndex:i toValue:[[self getFeatureValue:i] copy]];
    }
    return vecCopy;
}

@end

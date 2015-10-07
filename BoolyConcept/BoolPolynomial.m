//
//  BoolPolynomial.m
//  BoolConcepts Framework
//
//  Created by NL on 9/30/15.
//  Copyright © 2015 Nur Lan. All rights reserved.
//

#import "BooleanCommons.h"
#import "BoolPolynomial.h"

typedef NSMutableArray PolynomialTheory;


@implementation BoolPolynomial

/*! Comparison function used to sort the polynomials array */
NSInteger comparePolynomialKs (id first_p, id second_p, void *context) {
    NSInteger k1 = ((BoolPolynomial*)first_p).numberOfRegularitiesK;
    NSInteger k2 = ((BoolPolynomial*)second_p).numberOfRegularitiesK;
    if (k1 < k2)
        return NSOrderedAscending;
    else if (k1 > k2)
        return NSOrderedDescending;
    else
        return NSOrderedSame;
}



-(id)initWithRegularityVector:(BooleanVector*)regVector {
    self = [super init];
    if (self) {
        _regularity = regVector; //using copy to avoid trouble when
        _numberOfFeatures = regVector.numberOfFeatures;
        _numberOfRegularitiesK = [_regularity countNumberOfPositiveFeaturesInVector]; 
    }
    return self;
}


-(id)initWithNumberOfFeatures: (int)numOfFeatures {
    BooleanVector* tempVector = [[BooleanVector alloc] initVectorWithNumberOfFeatures:numOfFeatures];
    return [self initWithRegularityVector:tempVector];
}

/*! Init new polynomial with default number of features and regularity features all set to 0
 */
-(id)init {
    return [self initWithNumberOfFeatures:BOOL_CONCEPT_DEFAULT_NUMBER_OF_FEATURES];
}

-(NSNumber*)getTermValueAt:(int)termIndex {
    return [self.regularity getFeatureValue:termIndex];
}

- (NSString*)generateStringRepresentation {
    return [self.regularity generateStringRepresentation];
}

- (BoolConceptObject*)returnAsObject {
    BooleanVector *myVector = self.regularity;
    BoolConceptObject *retObject = [[BoolConceptObject alloc] initWithFeatureVector:[myVector copy]];
    return retObject;
}

#pragma mark Class methods


+ (NSMutableArray*)generateTheoryOfPolynomialsOfDegreeK:(int)k numberOfPolynomials:(int)num withNumberOfFeaturesD:(int)numOfFeatures forNumberOfValues:(int)numOfValues {
    
    NSArray *all_polynomials_sorted = [BoolPolynomial generateAllPolynomialsSortedForNumberOfFeatures:numOfFeatures forNumberOfValues:numOfValues];
    
    NSMutableArray *retArray = [NSMutableArray arrayWithCapacity:num];
    //TODO
    NSUInteger numOfPolys = [all_polynomials_sorted count];
    NSUInteger loopCounter = 0, randP = 0;
    BoolPolynomial *currPoly;
    while ([retArray count] < num && loopCounter < numOfPolys) {
        do {    //keep drawing random polys until found a correct K value
            randP = rand() % numOfPolys;
            currPoly = [all_polynomials_sorted objectAtIndex:randP];
        } while (currPoly.numberOfRegularitiesK != k);
        loopCounter++;  //make sure selection not exhausted
        if ([retArray containsObject:currPoly]) continue;   //if polynomial already in collectio, keep going
        [retArray addObject:currPoly];  //found new poly with correct K, add to return array
    } //end outer while
    return retArray;
}


+ (NSArray*) generateAllPolynomialsSortedForNumberOfFeatures: (int)numberOfFeatures forNumberOfValues:(int)numOfValues {
    
    NSMutableArray *all_polynomials_feature_vectors = [BooleanVector generateAllVectorsForNumberOfFeatures: numberOfFeatures forNumberOfValues:numOfValues+1 withFeatureOffset: -1];   //feature vectors for all polynomials, including a possibility of 'dont care' features (created by the -1 offset and the +1 for the values)
    
    NSMutableArray *all_polynomials = [[NSMutableArray alloc] initWithCapacity:all_polynomials_feature_vectors.count];  //array for all polynomials, yet unsorted
    
    BoolPolynomial *new_polynomial;
    BooleanVector *current_regularity_vector;
    
    //Create all possible polynomials for universe with D features and VALS+1 feature values (VALS + dont care's)
    for (int i=0; i < all_polynomials_feature_vectors.count; i++) {
        current_regularity_vector = [all_polynomials_feature_vectors objectAtIndex:i];
        new_polynomial = [[BoolPolynomial alloc] initWithRegularityVector:current_regularity_vector];
        [all_polynomials addObject:new_polynomial];
    }
    //Sort polynomials according to K value. See Feldman (2006) theorem proof for details.
    NSArray *sorted_polynomials = [all_polynomials sortedArrayUsingFunction:comparePolynomialKs context:NULL];
    
    return sorted_polynomials;
}


@end

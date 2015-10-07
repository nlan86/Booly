//
//  PowerSeries.m
//  BoolConcepts Framework
//
//  Created by NL on 9/9/15.
//  Copyright (c) 2015 Nur Lan. All rights reserved.
//

#import "BoolPolynomial.h"
#import "PowerSeries.h"

@implementation PowerSeries


/*! Initializes power series with given concept and calculates
 \param theConcept concept to base on
 */
-(id)initWithConcept:(BoolConcept *)theConcept {
    self = [super init];
    if (self) {
        _booleanConcept = theConcept;
        [self generatePowerSeries];
        [self generateSpectrum];
        [self calculateComplexity];
    }
    return self;
}

/*! Creates random concept and initializes power series instance
    @param numOfFeatures number of features
    @param numPositiveObjects number of positive objects in concept
 */
-(id)initCreateRandomConceptWithNumberOfFeatures:(int)numOfFeatures positiveObjects:(int)numPositiveObjects {
   BoolConcept* tempConcept = [[BoolConcept alloc] initRandomConceptWithNumberOfFeatures:numOfFeatures numberOfPositiveObjects:numPositiveObjects withUniverse:self.booleanConcept.universe];
    return [self initWithConcept:tempConcept];
}

/*! Initializes Power Series with new random concept with default features and default positive features
 */
-(id)init {
    BoolConcept* tempConcept = [[BoolConcept alloc] init];
    return [self initWithConcept:tempConcept];
}

/** Calculates the weighed K+1 complexity of power series, see Feldman (2006)
 */
-(void)calculateComplexity {
    if (self.powerSpectrum == nil) {
        NSLog(@"Error: power spectrum not generated yet. Use generateSpectrum().");
        return;
    }
    int numOfFeatures = self.booleanConcept.numberOfFeatures;
    NSMutableArray *weights = [NSMutableArray arrayWithCapacity:numOfFeatures];
    NSUInteger complexity = 0;
    for (int k=0; k<numOfFeatures; k++) {   //create weights vector for K+1 weighing
        [weights addObject:@(k+1)];
        complexity += ([weights[k] integerValue] * [self.powerSpectrum[k] integerValue]);
    }
    self.conceptComplexity = complexity;
}

/** Sorts the power series into a power spectrum, keeps buckets of K values and counts number of polynomials in each K */
-(void)generateSpectrum {
    
    if (self.powerSeries == nil) {
        NSLog(@"Error: power series not generated yet. Use generatePowerSeries().");
        return;
    }
    int numOfFeatures = self.booleanConcept.numberOfFeatures;
    NSMutableArray *retSpectrum = [NSMutableArray arrayWithCapacity:numOfFeatures];

    //zero all K values
    for (int k=0; k<numOfFeatures; k++) {
        [retSpectrum addObject:@(0)];
    }
    
    //count number of polynomials in each K
    BoolPolynomial *currPol;
    NSInteger currK;
    NSInteger currVal;
    for (int p=0; p<[self.powerSeries count]; p++) {
        currPol = self.powerSeries[p];
        currK = currPol.numberOfRegularitiesK;
        currVal = [((NSNumber*)(retSpectrum[currK - 1])) integerValue];
        retSpectrum[currK - 1] = @(currVal + 1);
    }
    self.powerSpectrum = retSpectrum;
}

/*! Generate the power series of the current concept (self.booleanConcept)
 \returns Array of BoolPolynomial's representing the power series
 */
-(void)generatePowerSeries {

    //Sort polynomials according to K value. See Feldman (2006) theorem proof for details.
    NSArray *sorted_polynomials = [BoolPolynomial generateAllPolynomialsSortedForNumberOfFeatures:self.booleanConcept.numberOfFeatures forNumberOfValues:BOOL_DEFAULT_NUM_OF_VALUES];
    
    /*uncomment for rule-in duality
    BoolConcept *empty_concept = [[BoolConcept alloc] initRandomConceptWithNumberOfFeatures:self.booleanConcept.numberOfFeatures numberOfPositiveObjects:0 withUniverse:self.booleanConcept.universe];
    */
    
    BoolConcept *univere_concept = [[BoolConcept alloc] initAsEntireUniverseWithNumberOfFeatures:self.booleanConcept.numberOfFeatures withUniverse:self.booleanConcept.universe];

    NSMutableArray *current_theory = [NSMutableArray array];
    
    NSInteger currentPolynomialIndex = 1;    //starting from 1 since polys[0] is all 'dont care's
    BoolPolynomial *current_polynomial;
    
    BOOL is_model_complete = NO;
    
//    BoolConcept *current_model = empty_concept;     //opt-in duality. for opt-out use object_universe
    BoolConcept *current_model = univere_concept;    //opt-out duality. for opt-in use line commented above
    
    //main loop
    while (!is_model_complete) {
        current_polynomial = sorted_polynomials[currentPolynomialIndex];
        if ([self is_polynomial_correct_and_nontrivial:current_polynomial current_theory:current_theory current_model:current_model]) {
            [current_theory addObject:current_polynomial];
            current_model = [[BoolConcept alloc] initConceptFromTheory:current_theory forNumberOfFeatures:self.booleanConcept.numberOfFeatures withUniverse:self.booleanConcept.universe];
            if ([current_model isEqualToConcept:self.booleanConcept]) {
                is_model_complete = YES;
            }
        }
        currentPolynomialIndex++;   //move to next polynomial
    }   //end main loop
    
    self.powerSeries = current_theory;
}


#pragma mark Secret_Not_In_Interface

/** Checks if the candidate polynomial is correct for the given concept, and non-trivial. It is correct if it only produces objects within the concept, and non-trivial if in combination with the existing theory it generates a new model different from the current one. 
 @param candidate_poly The candidate polynomial to check
 @param current_theory The current collection of polynomials agreed to create the concept, sorted by K ascending order
 @param current_model the current collection of objects generated by the current theory
 @return YES if polynomial is correct and nontrivial
 */
-(BOOL)is_polynomial_correct_and_nontrivial:(BoolPolynomial*)candidate_poly current_theory:(NSMutableArray*)current_theory current_model:(BoolConcept*)current_model {
    
    NSMutableArray *testing_theory = [NSMutableArray arrayWithArray:current_theory];
    [testing_theory addObject:candidate_poly];  //testing new theory with candidate polynomial
    BoolConcept *new_model = [[BoolConcept alloc] initConceptFromTheory:testing_theory forNumberOfFeatures:current_model.numberOfFeatures withUniverse:self.booleanConcept.universe]; //theory2model
    
    if ([new_model isEqualToConcept:current_model]) return NO;  //trivial
    
    BoolConceptObject *currObject;
    /* ruleout correctness check: all positive objects in concept don't violate polynomial */
    for (int i=0; i<[self.booleanConcept.positiveObjects count]; i++) {
        currObject = [self.booleanConcept.positiveObjects objectAtIndex:i];
        if ([currObject isWithinAreaDefinedByPolynomial:candidate_poly]) return NO;
    }
     
    /* rulein "correctness" check:  objects are a superset of polynomial. i.e. all objects generated by tested polynomial are positive in the concept
     
     NSMutableArray *candidate_poly_in_array = [NSMutableArray arrayWithObjects:candidate_poly, nil];
     BoolConcept *new_part_of_model = [[BoolConcept alloc] initConceptFromTheory:candidate_poly_in_array forNumberOfFeatures:current_model.numberOfFeatures withUniverse:self.booleanConcept.universe];   //theory2model of only candidate polynomial, to save time
    BoolConceptObject *currObject;

    for (int i=0; i<[new_part_of_model.positiveObjects count]; i++) {
        currObject = [new_part_of_model.positiveObjects objectAtIndex:i];
        if (![self.booleanConcept isObjectInConcept:currObject]) return NO;
    }
     */
    return YES;
}

@end

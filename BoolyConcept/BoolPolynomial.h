//
//  BoolPolynomial.h
//  BoolConcepts Framework
//
//  Created by NL on 9/30/15.
//  Copyright © 2015 Nur Lan. All rights reserved.
//

#import "BooleanVector.h"
#import "BoolConceptObject.h"
#import <Foundation/Foundation.h>

@class BoolConceptObject;

/*! @class BoolPolynomial 
 This class represents a polynomial, basically identical to BoolConceptObject, but offers more feature values - i.e., a "Dont Care" value, indicating a certain feature is not relevant in this polynomial. Also handles creating all permutations of polynomials in universe */

@interface BoolPolynomial : NSObject

/*! The polynomial regularity vector. Contains a value for each feature corresponding to the term's value, or 'Dont Care' **/
@property BooleanVector* regularity;
/*! Number of features in polynomial for the concept's universe */
@property NSInteger numberOfFeatures;
/*! Number of  non-dont-care regularities in the polynomial */
@property NSInteger numberOfRegularitiesK;

/*! Initialize new polynomial with readymade regularity vector
 @param regVector BooleanVector of boolean regularity features
 */
- (id)initWithRegularityVector:(BooleanVector*)regVector;
/*! Initialize new polynomial with number of features. Will create a polynomial of all 0's
 @param numOfFeatures number of features
 */
- (id)initWithNumberOfFeatures:(int)numOfFeatures;
- (NSString*)generateStringRepresentation;
- (NSNumber*)getTermValueAt:(int)termIndex;
/*!Returns a representation of the polynomial as a boolean object. "Dont cares" will be left as -1 */
- (BoolConceptObject*)returnAsHint;
/*! Generates a specified number of polynomials relevant to current universe with a specified degree K */
+ (NSMutableArray*)generateTheoryOfPolynomialsOfDegreeK:(int)k numberOfPolynomials:(int)num withNumberOfFeaturesD:(int)numOfFeatures forNumberOfValues:(int)numOfValues ;
/*! Generates all polynomials for current universe, lexically ordered according to Feldman (2006) algorythm. **/
+ (NSArray*) generateAllPolynomialsSortedForNumberOfFeatures: (int)numberOfFeatures forNumberOfValues:(int)numOfValues;

@end

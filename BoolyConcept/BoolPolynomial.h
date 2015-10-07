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

@interface BoolPolynomial : NSObject

/** The polynomial regularity vector. Contains a value for each feature corresponding to the term's value, or 'Dont Care' **/
@property BooleanVector* regularity;
/** Number of features in polynomial for the concept's universe */
@property NSInteger numberOfFeatures;
/** Number of  non-dont-care regularities in the polynomial */
@property NSInteger numberOfRegularitiesK;

- (id)initWithRegularityVector:(BooleanVector*)regVector;
- (id)initWithNumberOfFeatures:(int)numOfFeatures;
- (NSString*)generateStringRepresentation;
- (NSNumber*)getTermValueAt:(int)termIndex;
- (BoolConceptObject*)returnAsObject;
+ (NSMutableArray*)generateTheoryOfPolynomialsOfDegreeK:(int)k numberOfPolynomials:(int)num withNumberOfFeaturesD:(int)numOfFeatures forNumberOfValues:(int)numOfValues ;
+ (NSArray*) generateAllPolynomialsSortedForNumberOfFeatures: (int)numberOfFeatures forNumberOfValues:(int)numOfValues;

@end

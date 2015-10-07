//
//  BoolConcept.h
//  BoolConcepts Framework
//
//  Created by NL on 9/3/15.
//  Copyright (c) 2015 Nur Lan. All rights reserved.
//

#import "PowerSeries.h"
#import "BooleanVector.h"
#import "BooleanCommons.h"
#import <Foundation/Foundation.h>

typedef NSMutableArray BoolConceptUniverse;

@class BoolConceptObject;
@class PowerSeries;

/*!
 @class BoolConcept
 This class simulates a boolean concept as defined by Feldman (2006), i.e., a collection of objects selected from the universe of all possible objects for a specified number of features and values.
    This also includes handling creation of concepts from theories (i.e., collection of polynomials).
 */

@interface BoolConcept : NSObject <NSCopying>

/*! Array of all objects possible for this concept, whether actually included in it or not */
@property BoolConceptUniverse* universe;
/*! Array of objects actually selected in concept. Contains pointers of BoolConceptObjects */
@property NSMutableArray* positiveObjects;
/*! Number of features in concept feature vector */
@property int numberOfFeatures;
/*! Power series object for concept. Contains spectrum and complexity. Use generatePowerSeriesAndSpectrum to generate */
@property PowerSeries* powerSeries;


/*! Number of objects in concept
 @return number of objects in concept
 */
- (int)getNumberOfPositiveObjects;
/*! Checks if two concepts are the same. Compares actual values, not referenes. Efficient: only goes over positive objects.
 @param concept the other concept to compare to
 @returns YES if both concept have the same number of features, and contain the same positive objects.
 */
- (BOOL)isEqualToConcept: (BoolConcept*)concept;
/*! Checks if object value exists in this concept (compares values, not pointer references)
 @returns YES if identical object is positive in object
 */
- (BOOL)isObjectInConcept: (BoolConceptObject*)obj;
/*! Marks an object as belonging to concept
 @param obj The object to mark as positive
 */
- (void)markObjectAsInConcept: (BoolConceptObject*)obj;
/*! Deletes an object currently belonging to concept
 @param obj The object to mark as negative
 */
- (void)deleteObjectFromConcept: (BoolConceptObject*)obj;
/*! Getter for boolean objects in concept
 \param conceptNumber the object's index in universe
 \returns BoolConceptObject* of wanted object
 */
- (BoolConceptObject*)getBoolObjectAtIndex:(NSInteger)conceptNumber;
/*! Generates the power series, power spectrum and complexity for this concept.
 Power Series object is accessed through self.powerSeries **/
- (void)generatePowerSeries;

/*! Randomly selects n objects from current concept and marks them as positive in the concept.
 \param numberOfObjectsToMark Number of objects to randomly select
 \returns Nothing.
 */
- (void)randomSelectObjectsToConcept: (int)numberOfObjectsToMark;

#pragma mark initialiazors

/*! Initializes a new concept with randomly selected positive objects.
 \param withNumberOfFeatures number of features in universe
 \param numberOfPositiveObjects number of positive objects to randomly select
 */
- (id)initRandomConceptWithNumberOfFeatures:(int)withNumberOfFeatures numberOfPositiveObjects:(int)numberOfPositiveObjects withUniverse:(NSMutableArray*)universe;
/*! Initializes a new concept with all objects marked as positive
 \param withNumberOfFeatures number of features in universe
 */
- (id)initAsEntireUniverseWithNumberOfFeatures: (int)numberOfFeatures withUniverse:(NSMutableArray*)universe;
/*! Creates a concept of objects from a polynomial collection theory. Implementation of theory2model by Feldman (2006). Important: Not always returns objects in same lexical order.
 \returns a new concept object filled with matching objects to given polynomials
 */
- (BoolConcept*)initConceptFromTheory: (NSMutableArray*)theoryPolynomials forNumberOfFeatures:(int)numOfFeatures withUniverse:(NSMutableArray*)universe;
/*! Randomly draw linear polynomials (K=0 and K=1) and create a concept based on them. See Feldman (2006). **/
-(BoolConcept*)initRandomLinearConceptForNumberOfFeatures:(int)numOfFeatures  numberOfConstantImplications:(int)numOfConstants numberOfPairwiseImplications:(int)numOfPairwise numOfValues:(int)numOfValues WithUniverse:(BoolConceptUniverse*)universe;

#pragma mark Debugging
/*! Used for debugging, prints all information about the concept */
- (NSMutableString*)dumpConceptLog;

#pragma mark class methods

/*! Generates all boolean objects for given number of features. Used to save space and time when generating multiple concepts that use the same universe.
 \param numOfFeatures number of features in concept universe.
 \returns NSMutableArray of all BoolConceptObjects in concept universe, in lexical order.
 */
+ (NSMutableArray*)generateUniverseForNumberOfFeatures:(int)forNumberOfFeatures;



@end

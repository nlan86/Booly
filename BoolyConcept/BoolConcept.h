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

@interface BoolConcept : NSObject <NSCopying>

/** Array of all objects possible for this concept, whether actually included in it or not */
@property BoolConceptUniverse* universe;
/** Array of objects actually selected in concept. Contains pointers of BoolConceptObjects */
@property NSMutableArray* positiveObjects;
/** Number of features in concept feature vector */
@property int numberOfFeatures;
/** Power series object for concept. Contains spectrum and complexity. Use generatePowerSeriesAndSpectrum to generate */
@property PowerSeries* powerSeries;

- (int)getNumberOfPositiveObjects;
- (BOOL)isEqualToConcept: (BoolConcept*)concept;
- (BOOL)isObjectInConcept: (BoolConceptObject*)obj;
- (void)markObjectAsInConcept: (BoolConceptObject*)obj;
- (void)deleteObjectFromConcept: (BoolConceptObject*)obj;
- (BoolConceptObject*)getBoolObjectAtIndex:(NSInteger)conceptNumber;
- (void)generatePowerSeries;

#pragma mark initialiazors
- (id)initRandomConceptWithNumberOfFeatures:(int)withNumberOfFeatures numberOfPositiveObjects:(int)numberOfPositiveObjects withUniverse:(NSMutableArray*)universe;
- (id)initAsEntireUniverseWithNumberOfFeatures: (int)numberOfFeatures withUniverse:(NSMutableArray*)universe;
- (BoolConcept*)initConceptFromTheory: (NSMutableArray*)theoryPolynomials forNumberOfFeatures:(int)numOfFeatures withUniverse:(NSMutableArray*)universe;
-(BoolConcept*)initRandomLinearConceptForNumberOfFeatures:(int)numOfFeatures  numberOfConstantImplications:(int)numOfConstants numberOfPairwiseImplications:(int)numOfPairwise numOfValues:(int)numOfValues WithUniverse:(BoolConceptUniverse*)universe;

#pragma mark Debugging
- (void)dumpConceptLog;

#pragma mark class methods
+ (NSMutableArray*)generateUniverseForNumberOfFeatures:(int)forNumberOfFeatures;



@end

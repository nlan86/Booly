//
//  PowerSeries.h
//  BoolConcepts Framework
//
//  Created by NL on 9/9/15.
//  Copyright (c) 2015 Nur Lan. All rights reserved.
//

#import "BoolConcept.h"
#import "BooleanVector.h"
#import "BoolConceptObject.h"
#import <Foundation/Foundation.h>

@class BoolConcept;

@interface PowerSeries : NSObject

/** the boolean concept to generate the series and spectrum for. Weak because mutually linked from concept. */
@property (nonatomic, weak) BoolConcept* booleanConcept;
/** An array of BoolPolynomials representing the power series */
@property NSMutableArray* powerSeries;
/** An array of values representing the number of polynomials for each K */
@property NSMutableArray* powerSpectrum;
/** A scalar representing the K+1 complexity for the concept. See Feldman (2006) for explanation */
@property NSUInteger conceptComplexity;

-(void)generatePowerSeries;
-(void)generateSpectrum;
-(void)calculateComplexity;

- (id)initWithConcept: (BoolConcept*)theConcept;    //Boolean Concept to base power series on

@end

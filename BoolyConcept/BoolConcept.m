//
//  BoolConcept.m
//  BoolConcepts Framework
//
//  Created by NL on 9/3/15.
//  Copyright (c) 2015 Nur Lan. All rights reserved.
//

#import "BoolPolynomial.h"
#import "BoolConcept.h"
#import "BooleanVector.h"
#import "BoolConceptObject.h"

@implementation BoolConcept


- (BOOL)isObjectInConcept: (BoolConceptObject*)obj {
    BoolConceptObject *currObject;
    for (int i=0; i<[self.positiveObjects count]; i++) {
        currObject = [self.positiveObjects objectAtIndex:i];
        if ([currObject isEqualsToObject:obj]) return YES;
    }
    return NO;
}


- (BOOL)isEqualToConcept: (BoolConcept*)concept {
    NSUInteger mysize = [self.positiveObjects count];
    NSUInteger othersize = [concept.positiveObjects count];
    if (mysize != othersize)
        return NO;
    if (self.numberOfFeatures != concept.numberOfFeatures)
        return NO;
    
    BoolConceptObject *currObj;
    for (int i=0; i<mysize; i++) {
        currObj = [self.positiveObjects objectAtIndex:i];
        if (![concept isObjectInConcept:currObj])
            return NO;
    }
    return YES;
}


- (void)markObjectAsInConcept: (BoolConceptObject*)obj {
    if ([self isObjectInConcept:obj]) return;   //verify object doesn't already exist in concept
    [self.positiveObjects addObject:obj];   //add object
}

- (void)deleteObjectFromConcept: (BoolConceptObject*)obj {
    if ([self isObjectInConcept:obj])   //verify object exists in concept before deleting it
        [self.positiveObjects removeObject:obj];
}

- (int)getNumberOfPositiveObjects {
    return (int)[self.positiveObjects count];
}

- (void)randomSelectObjectsToConcept: (int)numberOfObjectsToMark {

    int r = 0;
    int totalObjects = (int)[self.universe count];
    BoolConceptObject* currObject;

    for (int i=0; i<numberOfObjectsToMark; i++) {
        r = rand() % totalObjects;
        currObject = [self.universe objectAtIndex:r];
        while ([self isObjectInConcept:currObject]) {
            //if randomly drawn object is already marked, advance until found new one
            r = (r+1) % totalObjects;
            currObject = self.universe[r];
        }
        [self markObjectAsInConcept:currObject];
    }
}


- (BoolConceptObject*)getBoolObjectAtIndex:(NSInteger)conceptNumber {
    if (conceptNumber <= [[self universe] count])
    {
        return self.universe[conceptNumber];
    }
    else {
        NSLog(@"getBoolObjectAtIndex: Concept %ld out of bounds, number of objects: %lul", (long)conceptNumber, [self.universe count]);
        return nil;
    }
}

- (void)generatePowerSeries {
    PowerSeries *retPowerSeries = [[PowerSeries alloc] initWithConcept:self];
    self.powerSeries = retPowerSeries;
}

#pragma mark initializors


- (id)initRandomConceptWithNumberOfFeatures:(int)withNumberOfFeatures numberOfPositiveObjects:(int)numberOfPositiveObjects withUniverse:(BoolConceptUniverse*)universe {
    
    self = [super init];

     if (self)
     {
         int numOfObjects = exp2(withNumberOfFeatures);
         if (numberOfPositiveObjects > numOfObjects) numberOfPositiveObjects = numOfObjects;
         _numberOfFeatures = withNumberOfFeatures;
         _positiveObjects = [[NSMutableArray alloc] initWithCapacity:numberOfPositiveObjects];
         if (!universe) {   //if not given readymade universe, create new one
             _universe = [BoolConcept generateUniverseForNumberOfFeatures:withNumberOfFeatures];
         }
         else {
             _universe = universe;
         }
        [self randomSelectObjectsToConcept:numberOfPositiveObjects]; //mark random objects as belonging to concept
    }
    return self;
}


- (id)initAsEntireUniverseWithNumberOfFeatures: (int)numberOfFeatures withUniverse:(BoolConceptUniverse*)universe {
    self = [super init];
    
    if (self)
    {
        _numberOfFeatures = numberOfFeatures;
        if (universe == nil) {   //if not given readymade universe, create new one
            _universe = [BoolConcept generateUniverseForNumberOfFeatures:numberOfFeatures];
        }
        else {
            _universe = universe;
        }
        _positiveObjects = [_universe copy];  //mark all objects as positive
    }
    return self;
}

-(BoolConcept*)initRandomLinearConceptForNumberOfFeatures:(int)numOfFeatures  numberOfConstantImplications:(int)numOfConstants numberOfPairwiseImplications:(int)numOfPairwise numOfValues:(int)numOfValues WithUniverse:(BoolConceptUniverse*)universe {
    
    NSMutableArray *polys_k0 = [BoolPolynomial generateTheoryOfPolynomialsOfDegreeK:1 numberOfPolynomials:numOfConstants withNumberOfFeaturesD:numOfFeatures forNumberOfValues:numOfValues]; //randomly draw polynomials with degree K=0
    NSMutableArray *polys_k1 = [BoolPolynomial generateTheoryOfPolynomialsOfDegreeK:2 numberOfPolynomials:numOfPairwise withNumberOfFeaturesD:numOfFeatures forNumberOfValues:numOfValues]; //randomly draw polynomials with degree K=0
    [polys_k0 addObjectsFromArray:polys_k1];    //Combine polynomials to theory
    
    BoolPolynomial *currP;      //TODO REMOVE
    for (int i=0; i<[polys_k0 count]; i++) {    //TODO REMOVE
        currP = [polys_k0 objectAtIndex:i];
        NSLog(@"Chose polynomial %@ for new concept", [currP generateStringRepresentation]);
    }
    
    return [self initConceptFromTheory:polys_k0 forNumberOfFeatures:numOfFeatures withUniverse:universe];   //genereate concept from this theory
}

-(BoolConcept*)initConceptFromTheory: (NSMutableArray*)theoryPolynomials forNumberOfFeatures:(int)numOfFeatures withUniverse:(BoolConceptUniverse*)universe {
    self = [super init];
    if (self)
    {
        if (universe == nil) {   //if not given readymade universe, create new one
            _universe = [BoolConcept generateUniverseForNumberOfFeatures:numOfFeatures];
        }
        else {
            _universe = universe;
        }
        _numberOfFeatures = numOfFeatures;
        _positiveObjects = [NSMutableArray array];
        BoolConceptObject *currObj;
        BoolPolynomial *currPol;
        int p = 0;
        
        for (int i=0; i<[_universe count]; i++)
        {
            //for each object in entire universe, go over all polynomials in theory and check if it matches all (rule-out) or any (rule-in). if yes, add this object to concept
            currObj = [_universe objectAtIndex:i];
            for (p=0; p<[theoryPolynomials count]; p++) {
                currPol = [theoryPolynomials objectAtIndex:p];
                //to return this function to rule-in duality: move "add object back inside this if, remove the 'if p=all polynomials count'
                if ([currObj isWithinAreaDefinedByPolynomial:currPol]) {    //verify object doesn't-obey all polynomials, i.e. not-defined-by all polynomials (rule-out)
                    break;
                }
                
            } //end p loop over polynomials
            if (p==[theoryPolynomials count]) {
                [_positiveObjects addObject:currObj];
            }
        }  //end i loop over universe
    } //end if(self)
    return self;
}

- (NSMutableString*)dumpConceptLog {
    
    NSMutableString *retStr = [NSMutableString stringWithFormat:@""];
    NSLog(@"%@",retStr);
    [retStr appendString:@"Debug dump for concept:"];
    [retStr appendString:[NSString stringWithFormat:@"\nNumber of objects = %lu", (unsigned long)[self.universe count]]];
    [retStr appendString:[NSString stringWithFormat:@"\nNumber of positives = %d", [self getNumberOfPositiveObjects]]];
    
    BoolConceptObject *currObj;
    for (int i=0; i<[self.universe count]; i++) {
        currObj = [self getBoolObjectAtIndex:i];
        if ([self isObjectInConcept:currObj]) [retStr appendString:[NSString stringWithFormat:@"\nObject %@ - Containment: %d",  [currObj generateStringRepresentation], [self isObjectInConcept:currObj]]];
    }
    
    
    if (self.powerSeries) {
        PowerSeries *power = self.powerSeries;
        for (int i=0; i<[power.powerSeries count]; i++) {
            [retStr appendString:[NSString stringWithFormat:@"\n#%d power series: %@", i, [(BoolPolynomial*)[power.powerSeries objectAtIndex:i] generateStringRepresentation]]];
        }
        for (int k=0; k<[power.powerSpectrum count]; k++) {
            [retStr appendString:[NSString stringWithFormat:@"\nK=%d, Power: %ld", k, (long)[power.powerSpectrum[k] integerValue]]];
        }
        [retStr appendString:[NSString stringWithFormat:@"\nK+1 Complexity = %lu", (unsigned long)power.conceptComplexity]];;
    }
    return retStr;
}

#pragma mark class methods


+ (NSMutableArray*)generateUniverseForNumberOfFeatures:(int)forNumberOfFeatures  {
    NSMutableArray *allObjectsFeatureVectors = [BooleanVector generateAllVectorsForNumberOfFeatures:forNumberOfFeatures forNumberOfValues:BOOL_DEFAULT_NUM_OF_VALUES withFeatureOffset:0];
    NSMutableArray *retAllObjects = [[NSMutableArray alloc] initWithCapacity:exp2(forNumberOfFeatures)];
    BoolConceptObject *currObject;
    
    for (int i=0; i<[allObjectsFeatureVectors count]; i++) {
        currObject = [[BoolConceptObject alloc] initWithFeatureVector:allObjectsFeatureVectors[i]];
        retAllObjects[i]=currObject;
    }
    return retAllObjects;
}



#pragma mark NSCopying

-(id)copyWithZone:(NSZone *)zone {
    BoolConcept *copyConcept = [[BoolConcept alloc] init];
    BoolConceptObject *currObject;
    for (int i=0; i<[self.universe count]; i++) {
        currObject = [self getBoolObjectAtIndex:i];
        [copyConcept.universe addObject:[currObject copy]];
        if ([self isObjectInConcept:currObject]) {
            [copyConcept.positiveObjects addObject:copyConcept];
        }
    }
    copyConcept.numberOfFeatures = self.numberOfFeatures;
    return copyConcept;
}

@end

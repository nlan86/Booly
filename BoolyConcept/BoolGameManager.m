//
//  BoolGameManager.m
//  BoolyConcept
//
//  Created by NL on 10/4/15.
//  Copyright © 2015 Nur Lan. All rights reserved.
//

#import "BoolGameManager.h"

@implementation BoolGameManager

/** Drawn a new concept and starts a new game, assumes universe was already created for first game with same number of features and values */
- (void)startNewGame {
    BoolConcept *existingConcept = self.boolConcept;
    BoolConcept *newConcept = [[BoolConcept alloc] initRandomLinearConceptForNumberOfFeatures:existingConcept.numberOfFeatures numberOfConstantImplications:1 numberOfPairwiseImplications:1 numOfValues:2 WithUniverse:existingConcept.universe];   //generate simple linear concept with 1 K0 and 1 K1 polynomials
    self.boolConcept = newConcept;
    [self setupGameVars];
}

/** Sets up game variables, exemplars, etc. */
- (void)setupGameVars {
    
    [self.boolConcept generatePowerSeries];
    NSString *dump = [self.boolConcept dumpConceptLog]; //TODO REMOVE
    NSLog(@"%@",dump);
    
    //setup positive examplars
    //TODO CHOOSE RANDOMLY
    NSMutableArray *exemplars = [NSMutableArray arrayWithCapacity:BOOL_GAME_DEFAULT_NUMBER_OF_EXEMPLARS];
    BoolConceptObject *currObj;
    for (int i=0; i<MIN(BOOL_GAME_DEFAULT_NUMBER_OF_EXEMPLARS, [self.boolConcept.positiveObjects count]); i++) {
        currObj = [self.boolConcept.positiveObjects objectAtIndex:i];
        if (!currObj) continue;
        [exemplars addObject:currObj];
    }
    self.positiveExemplars = exemplars;
    
    //setup negative exemplars
    NSUInteger numOfObjects = [self.boolConcept.universe count];
    NSUInteger numOfPositives = [self.boolConcept.positiveObjects count];
    NSUInteger numOfNegativesInConcept = numOfObjects - numOfPositives;
    NSUInteger numOfNegativesToCollect = MIN(numOfNegativesInConcept, BOOL_GAME_DEFAULT_NUMBER_OF_NEGATIVE_EXEMPLARS);
    NSMutableArray *negative_exemplars = [NSMutableArray arrayWithCapacity:numOfNegativesToCollect];

    NSUInteger collectedNegativeOjbects = 0;
    int startAtObject = rand() % (numOfObjects - 1);
    int currObjIndex = startAtObject;
    while (collectedNegativeOjbects < numOfNegativesToCollect) {
        currObj = [self.boolConcept getBoolObjectAtIndex:currObjIndex];
        if (![self.boolConcept isObjectInConcept:currObj]) {    //if objects is negative, add to collection
            [negative_exemplars addObject:currObj];
            collectedNegativeOjbects++;
            NSLog(@"added negative: %@", [currObj generateStringRepresentation]);
        }
        currObjIndex = (currObjIndex + 1) % numOfObjects;
        if (currObjIndex == startAtObject) break;   //for some reason finished all objects without filling quota
    }
    self.negativeExemplars = negative_exemplars;
    
    self.current_hint = 0;
    
    //set currrent bool object + init counter
    self.number_of_object_in_game = [self.boolConcept.universe count];
    int startindex = rand() % self.number_of_object_in_game;
    self.currBoolObjectIndex = startindex;
    self.currBoolObject = [self.boolConcept getBoolObjectAtIndex:startindex];

    //init correct counter
    self.correct_in_a_row = 0;
    self.corrects = 0;
}

/** returns YES if more hints, i.e., polynomials are left to give. */
- (BOOL)isAnyHintLeft {
    return (self.current_hint < [self.boolConcept.powerSeries.powerSeries count]);
}

/** Returns a boolean object serving as a hint. Actually representing one of the polynomials of the power series
    @param a pointer to the object to assign to
    @return YES if the hint is positive, NO if the hint is negative
 */
- (BOOL)getHintTo: (BoolConceptObject**)boolObj {
    //TODO implement
    if (![self isAnyHintLeft]) return nil;   //Just a sanity check. isAnyHintLeft should still be called before getHint.
    
    NSInteger numOfPositivesInPoly = [[self.boolConcept.powerSeries.powerSeries objectAtIndex:self.current_hint] numberOfRegularitiesK];

    BoolConceptObject *retObj = [[self.boolConcept.powerSeries.powerSeries objectAtIndex:self.current_hint] returnAsObject];

    //if polynomial is K=0, we need to switch the color and present the hint as positive. if not, we leave it as is and declare the hint negative
    NSInteger currFeature;
    BOOL isHintPositive = (numOfPositivesInPoly == 1);
    if (isHintPositive) {
        for (int i=0; i<retObj.numberOfFeaturesD; i++) {
            currFeature = [[retObj.objectFeatureVector.featVector objectAtIndex:i] integerValue];
            if (currFeature == [BOOL_VECTOR_IGNORE_FEATURE integerValue]) continue; //keep going until 'care' feature is found
            if (currFeature % 2 == 0) { //switch feature value
                currFeature++;
            }
            else {
                currFeature--;
            }
            [retObj.objectFeatureVector.featVector setObject:@(currFeature) atIndexedSubscript:i];
        }
    }
    
    self.current_hint++;
    *boolObj = retObj;
    return isHintPositive;
}

- (void)resetHints {
    self.current_hint = 0;
}


/** Initializes a new game with difficulty affecting the concept complexity */
- (id)initGameWithDifficulty:(NSInteger)difficulty {
    
    self = [super init];
    if (self) {
        int numOfFeatures = BOOL_CONCEPT_DEFAULT_NUMBER_OF_FEATURES;
        //setup game concept
        BoolConceptUniverse *theUniverse = [BoolConcept generateUniverseForNumberOfFeatures:numOfFeatures]; //create universe
        
        BoolConcept *myConcept = [[BoolConcept alloc] initRandomLinearConceptForNumberOfFeatures:numOfFeatures numberOfConstantImplications:1 numberOfPairwiseImplications:1 numOfValues:2 WithUniverse:theUniverse];   //generate simple linear concept with 1 K0 and 1 K1 polynomials
        //TODO CONSIDER DIFFICULTY
        self.boolConcept = myConcept;
        [self setupGameVars];
    }
    return self;
    
}

/** Returns next object for concept */
- (BoolConceptObject*)getNextObject {
    //TODO ADVANCE RANDOMLY
    NSInteger nextIndex = (self.currBoolObjectIndex + 1) % self.number_of_object_in_game;
    self.currBoolObjectIndex = nextIndex;
    self.currBoolObject = [self.boolConcept getBoolObjectAtIndex:nextIndex];
    BoolConceptObject *nextObj = [self.boolConcept.universe objectAtIndex:nextIndex];
    NSLog(@"new object: %@  in concept? %@", [nextObj generateStringRepresentation], [self.boolConcept isObjectInConcept:nextObj] ? @"YES" : @"NO");
    return nextObj;
}

/** Checks if the user managed to learn the concept. Current criterion is being able to correctly identify all objects in a row */
- (BOOL)isWin {
    //TODO MAYBE CONDITION TO WIN LESS HARSH?
    return (self.correct_in_a_row == self.number_of_object_in_game);
//    return (self.corrects == self.number_of_object_in_game);
}

/** Checks if user was correct about current object being or not being correct for the regularity */
- (BOOL)sendAnswerCheckIfCorrect:(BOOL)yesOrNo {
    NSLog(@"user answered %@", yesOrNo ? @"YES" : @"NO");
    NSLog(@"for object %@", [self.currBoolObject generateStringRepresentation]);
    BOOL isObjectInConcept = [self.boolConcept isObjectInConcept:self.currBoolObject];
    BOOL correct = ((yesOrNo && isObjectInConcept) || (!yesOrNo && !isObjectInConcept));
    
    if (correct) {
        NSLog(@"game manager: correct");
        if (![self.objects_answered_correctly containsObject:self.currBoolObject]) {
                    self.corrects++;
        }
        self.correct_in_a_row++;
        [self.objects_answered_correctly addObject:self.currBoolObject];
        //caller should now request next object
    }
    else {
        NSLog(@"game manager: NOT correct");
        self.correct_in_a_row = 0;
    }
    
    return correct;
}

@end

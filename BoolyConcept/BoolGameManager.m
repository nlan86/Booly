//
//  BoolGameManager.m
//  BoolyConcept
//
//  Created by NL on 10/4/15.
//  Copyright © 2015 Nur Lan. All rights reserved.
//

#import "BoolGameManager.h"

@implementation BoolGameManager

- (void)startNewGame {
    BoolConcept *existingConcept = self.boolConcept;
    BoolConcept *newConcept = [[BoolConcept alloc] initRandomLinearConceptForNumberOfFeatures:existingConcept.numberOfFeatures numberOfConstantImplications:DEFAULT_DIFFICULTY_NUMBER_OF_CONSTANTS numberOfPairwiseImplications:DEFAULT_DIFFICULTY_NUMBER_OF_PAIRWISE numOfValues:2 WithUniverse:existingConcept.universe];   //generate simple linear concept with 1 K0 and 1 K1 polynomials
    self.boolConcept = newConcept;
    [self setupGameVars];
}

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

- (BOOL)isAnyHintLeft {
    return (self.current_hint < [self.boolConcept.powerSeries.powerSeries count]);
}

- (BOOL)getHintTo: (BoolConceptObject**)boolObj {
    if (![self isAnyHintLeft]) return nil;   //Just a sanity check. isAnyHintLeft should still be called before getHint.
    
    NSInteger numOfPositivesInPoly = [[self.boolConcept.powerSeries.powerSeries objectAtIndex:self.current_hint] numberOfRegularitiesK];

    BoolConceptObject *retObj = [[self.boolConcept.powerSeries.powerSeries objectAtIndex:self.current_hint] returnAsHint];

    //if polynomial is K=0, we need to switch the color and present the hint as positive. if not, we leave the first feature as is and switch the second one
    NSInteger indexOfPositive = 0;
    NSInteger currFeatureVal;
    
    for (int i=0; i<retObj.numberOfFeaturesD; i++) {
        currFeatureVal = [[retObj.objectFeatureVector.featVector objectAtIndex:i] integerValue];
        if (currFeatureVal == [BOOL_VECTOR_IGNORE_FEATURE integerValue]) continue; //keep going until 'care' feature is found
        
        if ((numOfPositivesInPoly == 1 && indexOfPositive == 0) || (numOfPositivesInPoly == 2 && indexOfPositive == 1)) {
            
            if (currFeatureVal % 2 == 0) { //switch feature value
                currFeatureVal++;
            }
            else {
                currFeatureVal--;
            }
            [retObj.objectFeatureVector.featVector setObject:@(currFeatureVal) atIndexedSubscript:i];
            break;
        }
        indexOfPositive++;
    }
    
    
    BOOL isHintImplication = (numOfPositivesInPoly == 2);
    self.current_hint++;
    *boolObj = retObj;
    return isHintImplication;
}

- (void)resetHints {
    self.current_hint = 0;
}


- (id)initGameWithDifficulty:(NSInteger)difficulty {
    self = [super init];
    if (self) {
        int numOfFeatures = BOOL_CONCEPT_DEFAULT_NUMBER_OF_FEATURES;
        //setup game concept
        BoolConceptUniverse *theUniverse = [BoolConcept generateUniverseForNumberOfFeatures:numOfFeatures]; //create universe
        
        BoolConcept *myConcept = [[BoolConcept alloc] initRandomLinearConceptForNumberOfFeatures:numOfFeatures numberOfConstantImplications:DEFAULT_DIFFICULTY_NUMBER_OF_CONSTANTS numberOfPairwiseImplications:DEFAULT_DIFFICULTY_NUMBER_OF_PAIRWISE numOfValues:2 WithUniverse:theUniverse];   //generate simple linear concept with 1 K0 and 1 K1 polynomials
        //TODO CONSIDER DIFFICULTY
        self.boolConcept = myConcept;
        [self setupGameVars];
    }
    return self;
    
}

- (BoolConceptObject*)getNextObject {
    //TODO ADVANCE RANDOMLY
    NSInteger nextIndex = (self.currBoolObjectIndex + 1) % self.number_of_object_in_game;
    self.currBoolObjectIndex = nextIndex;
    self.currBoolObject = [self.boolConcept getBoolObjectAtIndex:nextIndex];
    BoolConceptObject *nextObj = [self.boolConcept.universe objectAtIndex:nextIndex];
    NSLog(@"new object: %@  in concept? %@", [nextObj generateStringRepresentation], [self.boolConcept isObjectInConcept:nextObj] ? @"YES" : @"NO");
    return nextObj;
}

- (BOOL)isWin {
    //TODO MAYBE CONDITION TO WIN LESS HARSH?
    return (self.correct_in_a_row == self.number_of_object_in_game);
//    return (self.corrects == self.number_of_object_in_game);
}

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

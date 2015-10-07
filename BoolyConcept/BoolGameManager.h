//
//  BoolGameManager.h
//  BoolyConcept
//
//  Created by NL on 10/4/15.
//  Copyright © 2015 Nur Lan. All rights reserved.
//

#import "BoolConcept.h"
#import <Foundation/Foundation.h>

/*!
 @class BoolGameManager
 This class handles functions and data relevant for the Boolean Concept game - initiating new games, providing the next object, providing hints and telling when a user won. 
 */

@interface BoolGameManager : NSObject

/*! Array of examplars for current concept */
@property NSMutableArray *positiveExemplars;
@property NSMutableArray *negativeExemplars;
/*! Boolean concept for this game */
@property BoolConcept *boolConcept;
/*! Current boolean object displayed on screen */
@property BoolConceptObject *currBoolObject;
/*! Index of current boolean object */
@property NSInteger currBoolObjectIndex;
/*! Number of correct answers in a row so far */
@property NSInteger correct_in_a_row;
/*! number of correct answers so far */
@property NSInteger corrects;
/*! Number of objects in concept */
@property NSInteger number_of_object_in_game;
/*! Current hint number. Actually index of polynomial in power series */
@property NSInteger current_hint;
/*! collects objects user answered correctly about */
@property NSMutableArray *objects_answered_correctly;

/*! Initializes a new game with difficulty affecting the concept complexity */
- (id)initGameWithDifficulty: (NSInteger)difficulty;
/*! Returns next object for concept */
- (BoolConceptObject*)getNextObject;
/*! Checks if the user managed to learn the concept. Current criterion is being able to correctly identify all objects in a row */
- (BOOL)isWin;
/*! Drawn a new concept and starts a new game, assumes universe was already created for first game with same number of features and values */
- (void)startNewGame;
/*! Sets up game variables, exemplars, etc. */
- (void)setupGameVars;
/*! Checks if user was correct about current object being or not being correct for the regularity */
- (BOOL)sendAnswerCheckIfCorrect:(BOOL)yesOrNo;
/*! Returns a boolean object serving as a hint. Actually representing one of the polynomials of the power series
 @param boolObj pointer to the object to assign to
 @return YES if the hint is positive, NO if the hint is negative
 */
- (BOOL)getHintTo: (BoolConceptObject**)boolObj;
/*! returns YES if more hints, i.e., polynomials are left to give. */
- (BOOL)isAnyHintLeft;
- (void)resetHints;


@end

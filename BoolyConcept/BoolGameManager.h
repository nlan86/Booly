//
//  BoolGameManager.h
//  BoolyConcept
//
//  Created by NL on 10/4/15.
//  Copyright © 2015 Nur Lan. All rights reserved.
//

#import "BoolConcept.h"
#import <Foundation/Foundation.h>

@interface BoolGameManager : NSObject

/** Array of examplars for current concept */
@property NSMutableArray *positiveExemplars;
@property NSMutableArray *negativeExemplars;
/** Boolean concept for this game */
@property BoolConcept *boolConcept;
/** Current boolean object displayed on screen */
@property BoolConceptObject *currBoolObject;
/** Index of current boolean object */
@property NSInteger currBoolObjectIndex;
/** Number of correct answers in a row so far */
@property NSInteger correct_in_a_row;
/** number of correct answers so far */
@property NSInteger corrects;
/** Number of objects in concept */
@property NSInteger number_of_object_in_game;
/** Current hint number. Actually index of polynomial in power series */
@property NSInteger current_hint;
/** collects objects user answered correctly about */
@property NSMutableArray *objects_answered_correctly;

- (id)initGameWithDifficulty: (NSInteger)difficulty;
- (BoolConceptObject*)getNextObject;
- (BOOL)isWin;
- (void)startNewGame;
- (BOOL)sendAnswerCheckIfCorrect:(BOOL)yesOrNo;
- (BoolConceptObject*)getHint;
- (BOOL)isAnyHintLeft;
- (void)resetHints;


@end

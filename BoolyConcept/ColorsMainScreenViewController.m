//
//  ColorsMainScreenViewController.m
//  BoolyConcept
//
//  Created by NL on 10/3/15.
//  Copyright © 2015 Nur Lan. All rights reserved.
//

#import "BoolGameManager.h"
#import "BoolConcept.h"
#import "ColorsMainScreenViewController.h"

@interface ColorsMainScreenViewController ()
- (IBAction)clickedYes:(id)sender;
- (IBAction)clickedNo:(id)sender;

@end

@implementation ColorsMainScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"Main view did load");
    
    srand((unsigned)time(nil));   //seed for random function
    
    //init graphics object
    self.objectToGraphicsHandler = [[ObjectToGraphics alloc] init];

    //init new game
    self.gameManager = [[BoolGameManager alloc] initGameWithDifficulty:0];
    
    //collect exemplar views to array
    self.exemplarViews = [NSMutableArray arrayWithCapacity:BOOL_GAME_DEFAULT_NUMBER_OF_EXEMPLARS];
    [self.exemplarViews addObject:self.examplarView1];
    [self.exemplarViews addObject:self.examplarView2];
    [self.exemplarViews addObject:self.examplarView3];
    [self.exemplarViews addObject:self.examplarView4];

    self.negativeExemplarViews = [NSMutableArray arrayWithCapacity:BOOL_GAME_DEFAULT_NUMBER_OF_NEGATIVE_EXEMPLARS];
    [self.negativeExemplarViews addObject:self.negativeExamplarView1];
    [self.negativeExemplarViews addObject:self.negativeExamplarView2];
    [self.negativeExemplarViews addObject:self.negativeExamplarView3];
    [self.negativeExemplarViews addObject:self.negativeExamplarView4];

    //collect hint views to array
    self.hintViews = [NSMutableArray arrayWithCapacity:DEFAULT_NUMBER_OF_HINTS];
    [self.hintViews addObject:self.hintView1];
    [self.hintViews addObject:self.hintView2];
    [self.hintViews addObject:self.hintView3];
    //collect hint images to array
    self.hintImages = [NSMutableArray arrayWithCapacity:DEFAULT_NUMBER_OF_HINTS];
    [self.hintImages addObject:self.hintImage1];
    [self.hintImages addObject:self.hintImage2];
    [self.hintImages addObject:self.hintImage3];
    
    //setup views to new game
    
    [self setupViewsToNewGame];
    
}

#pragma mark - Game methods

- (void)setupViewsToNewGame {
    //setup ui labels
    NSUInteger numOfObjects = [self.gameManager.boolConcept.universe count];
    self.label_corrects.text = [NSString stringWithFormat:@"%d/%ld",0,numOfObjects];
    
    //reset exemplars according to current game
    BoolObjectView4Colors *currExemplarView;
    NSMutableArray *exemplars = self.gameManager.positiveExemplars;
    for (int e=0; e<[exemplars count]; e++) {
        currExemplarView = (BoolObjectView4Colors*)[self.exemplarViews objectAtIndex:e];
        currExemplarView.boolObject = [exemplars objectAtIndex:e];
        currExemplarView.parentViewController = self;
        [currExemplarView setNeedsDisplay];
    }
    //reset negative exemplars
    NSMutableArray *negative_exemplars = self.gameManager.negativeExemplars;
    for (int e=0; e<[negative_exemplars count]; e++) {
        currExemplarView = (BoolObjectView4Colors*)[self.negativeExemplarViews objectAtIndex:e];
        currExemplarView.boolObject = [negative_exemplars objectAtIndex:e];
        currExemplarView.parentViewController = self;
        [currExemplarView setNeedsDisplay];

    }

    //setup main object view
    self.mainObjectView.boolObject = self.gameManager.currBoolObject;
    self.mainObjectView.parentViewController = self;
    [self.mainObjectView setNeedsDisplay];
    
    //setup hint views and hide them + hint positive views
    BoolObjectView4Colors *curHintView;
    UIImageView *curHintImgView;
    for (int h=0; h<[self.hintViews count]; h++) {
        curHintView = [self.hintViews objectAtIndex:h];
        curHintView.parentViewController = self;
        [curHintView setHidden:YES];
        
        curHintImgView = [self.hintImages objectAtIndex:h];
        [curHintImgView setHidden:YES];
    }
    [self.hintPlus1 setHidden:YES];
    [self.hintPlus2 setHidden:YES];
    
    //setup last object view
    [self.lastObjectView setHidden:YES];
    self.lastObjectView.parentViewController = self;
    
    //hide right/wrong labels
    self.label_did_didnt_match.hidden = YES;
    self.label_right_wrong.hidden = YES;
}

- (void)startNewGame {
    [self.gameManager startNewGame];
    [self setupViewsToNewGame];
}

- (void)getNextMainObj {
    //put current object in last object view
    self.lastObjectView.boolObject = self.mainObjectView.boolObject;
    [self.lastObjectView setNeedsDisplay];
    
    //get next object and display it
    self.mainObjectView.boolObject = [self.gameManager getNextObject];
    self.label_current_object.text = [self.mainObjectView.boolObject generateStringRepresentation];
    [self.mainObjectView setNeedsDisplay];
}


- (void)handleUserAnswer: (BOOL)yesOrNo {
    BOOL correct = [self.gameManager sendAnswerCheckIfCorrect:yesOrNo];
    NSUInteger numOfObjects = [self.gameManager.boolConcept.universe count];
    self.label_corrects.text = [NSString stringWithFormat:@"%ld/%ld",self.gameManager.correct_in_a_row,numOfObjects];
    self.label_right_wrong.hidden = NO;
    self.label_did_didnt_match.hidden = NO;
    self.lastObjectView.hidden = NO;
    
    //player just won
    if ([self.gameManager isWin]) {
        UIAlertController *alert =
        [UIAlertController alertControllerWithTitle:@"You win" message:@"Start a new game?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self startNewGame];
        }];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else {  //didn't win yet
        //get and dislpay next object. game manager will take care of counts, etc.
        if (correct) {
            self.label_right_wrong.text = @"CORRECT!";
            self.label_did_didnt_match.text = yesOrNo ? @"did match" : @"didn't match";
        }
        else {
            self.label_right_wrong.text = @"WRONG!";
            self.label_did_didnt_match.text = yesOrNo ? @"didn't match" : @"did match";
        }
        [self getNextMainObj];
    } //end no win
}

- (void)getHint {
    //TODO show hints in different view
    //TODO or better, light-up the relevant squares in the exemplars
    
    if (![self.gameManager isAnyHintLeft]) {  //verify there are hints left
        //TODO make
        UIAlertController *alert =
        [UIAlertController alertControllerWithTitle:@"No Hints Left" message:@"Try harder!" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    NSInteger hint_index = self.gameManager.current_hint;
    BoolConceptObject *hintObj;
    BOOL isHintImplication = [self.gameManager getHintTo:&hintObj];
    NSLog(@"hint implication? %@", isHintImplication ? @"YES" : @"NO");
    BoolObjectView4Colors *hintView =     [self.hintViews objectAtIndex:hint_index];
    hintView.shouldDrawArrow = isHintImplication;  //if hint is of 2 terms, draw a line between them
    hintView.boolObject = hintObj;
    
    //turn on hint pluses
    switch (hint_index) {
        case 1:
            [self.hintPlus1 setHidden:NO];
            break;
        case 2:
            [self.hintPlus2 setHidden:NO];
            break;
        default:
            break;
    }
    [hintView setHidden:NO];
    
    /* hint positive/negative indicators. not relevant now
     UIImageView *hintPositiveImage = [self.hintImages objectAtIndex:hint_index];

    UIImage *hintImg = [UIImage imageNamed:isHintImplication ? HINT_POSITIVE_IMG : HINT_NEGATIVE_IMG];
    [hintPositiveImage setImage:hintImg];
    [hintPositiveImage setHidden:NO];
    

    */
    
    [hintView setNeedsDisplay];
}

#pragma Mark - UI actions

- (IBAction)clickedYes:(id)sender {
    [self handleUserAnswer:YES];
}

- (IBAction)clickedNo:(id)sender {
    [self handleUserAnswer:NO];
}

- (IBAction)clickedGetHint:(id)sender {
    [self getHint];
}

- (IBAction)clickedRestart:(id)sender {
    [self startNewGame];
}

- (IBAction)clickedRules:(id)sender {
    //TODO show rules
}

- (IBAction)clickedInfo:(id)sender {
    NSMutableString *info = [self.gameManager.boolConcept dumpConceptLog];
    
    UIAlertController *alert =
    [UIAlertController alertControllerWithTitle:@"Game Complexity Info" message:info preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}

@end

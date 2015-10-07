//
//  ColorsMainScreenViewController.h
//  BoolyConcept
//
//  Created by NL on 10/3/15.
//  Copyright © 2015 Nur Lan. All rights reserved.
//

#import "BoolGameManager.h"
#import "ObjectToGraphics.h"
#import "BoolObjectView4Colors.h"
#import <UIKit/UIKit.h>

@class BoolObjectView4Colors;

@interface ColorsMainScreenViewController : UIViewController

//positive object views
@property (weak, nonatomic) IBOutlet BoolObjectView4Colors *mainObjectView;
@property (weak, nonatomic) IBOutlet BoolObjectView4Colors *examplarView1;
@property (weak, nonatomic) IBOutlet BoolObjectView4Colors *examplarView2;
@property (weak, nonatomic) IBOutlet BoolObjectView4Colors *examplarView3;
@property (weak, nonatomic) IBOutlet BoolObjectView4Colors *examplarView4;

//negative exemplars view
@property (weak, nonatomic) IBOutlet BoolObjectView4Colors *negativeExamplarView1;
@property (weak, nonatomic) IBOutlet BoolObjectView4Colors *negativeExamplarView2;
@property (weak, nonatomic) IBOutlet BoolObjectView4Colors *negativeExamplarView3;
@property (weak, nonatomic) IBOutlet BoolObjectView4Colors *negativeExamplarView4;

//hint views
@property (weak, nonatomic) IBOutlet BoolObjectView4Colors *hintView1;
@property (weak, nonatomic) IBOutlet BoolObjectView4Colors *hintView2;
@property (weak, nonatomic) IBOutlet BoolObjectView4Colors *hintView3;

@property (weak, nonatomic) IBOutlet BoolObjectView4Colors *lastObjectView;

//buttons
@property (weak, nonatomic) IBOutlet UIButton *getHintButton;


//array of exemplar views and hint views
@property NSMutableArray *exemplarViews;
@property NSMutableArray *negativeExemplarViews;
@property NSMutableArray *hintViews;

//labels
@property (weak, nonatomic) IBOutlet UILabel *label_complexity;
@property (weak, nonatomic) IBOutlet UILabel *label_current_object;
@property (weak, nonatomic) IBOutlet UILabel *label_corrects;
@property (weak, nonatomic) IBOutlet UILabel *label_right_wrong;
@property (weak, nonatomic) IBOutlet UILabel *label_did_didnt_match;


//graphics handler
@property ObjectToGraphics *objectToGraphicsHandler;

//game variables
@property BoolGameManager *gameManager;

@end

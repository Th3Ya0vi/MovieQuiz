//
//  QuizScreen.h
//  MovieQuiz
//
//  Created by Tony Baik and Lucas Ou on 3/10/14.
//  Copyright (c) 2014 Tony Baik. All rights reserved.
//

#import <UIKit/UIKit.h>

int QuestionSelected;
BOOL Answer1Correct;
BOOL Answer2Correct;
BOOL Answer3Correct;
BOOL Answer4Correct;
int ScoreNumber;
int WrongNumber;
int dblElapsedSeconds = 180;
int tmrElapsedTime;
BOOL GameInProgress;

@interface QuizScreen : UIViewController
{
    IBOutlet UILabel *QuestionText;
    IBOutlet UIButton *Answer1;
    IBOutlet UIButton *Answer2;
    IBOutlet UIButton *Answer3;
    IBOutlet UIButton *Answer4;
    IBOutlet UIButton *Exit;
    IBOutlet UILabel *Score;
    IBOutlet UILabel *TimeLeft;
    IBOutlet UIImageView *Result;
}

-(void)RightAnswer;
-(void)WrongAnswer;
-(void)updateElapsedTime;
-(IBAction)Answer1:(id)sender;
-(IBAction)Answer2:(id)sender;
-(IBAction)Answer3:(id)sender;
-(IBAction)Answer4:(id)sender;

@end

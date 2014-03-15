//
//  QuizScreen.m
//  MovieQuiz
//
//  Created by Tony Baik and Lucas Ou on 3/10/14.
//  Copyright (c) 2014 Tony Baik. All rights reserved.
//

#import "QuizScreen.h"
#import "TimeUp.h"

@interface QuizScreen ()

@end

@implementation QuizScreen

-(void)updateElapsedTime
{
    dblElapsedSeconds -= 1;
    //double seconds = [[NSDate date] timeIntervalSinceDate:self.startTime];
    if(dblElapsedSeconds < 1)
    {
        //Time is up / reset
        GameInProgress = NO;
        tmrElapsedTime.invalidate;
        TimeUp *timeUp = [[UIStoryboard storyboardWithName:@"Main" bundle:NULL] instantiateViewControllerWithIdentifier:@"TimeUp"];
        //logic for exiting to gameover screen
        [self presentViewController:timeUp animated:YES completion:NULL];
    }
    int hours,minutes, lseconds;
    hours = dblElapsedSeconds / 3600;
    minutes = (dblElapsedSeconds - (hours*3600)) / 60;
    lseconds = fmod(dblElapsedSeconds, 60);
    [TimeLeft setText:[NSString stringWithFormat:@"%01d:%02d",minutes, lseconds]];
}

-(void)RightAnswer{
    ScoreNumber++;
    Score.text = [NSString stringWithFormat:@"%i", ScoreNumber];
    Result.hidden = NO;
    Result.image = [UIImage imageNamed:@"correct.png"];
    [self loadViewAgain];
}
-(void)WrongAnswer{
    WrongNumber++;
    Result.hidden = NO;
    Result.image = [UIImage imageNamed:@"wrong.png"];
    [self loadViewAgain];
}
-(IBAction)Answer1:(id)sender{
    if(Answer1Correct == YES){
        [self RightAnswer];
    }
    else{
        [self WrongAnswer];
    }
}
-(IBAction)Answer2:(id)sender{
    if(Answer1Correct == YES){
        [self RightAnswer];
    }
    else{
        [self WrongAnswer];
    }
}
-(IBAction)Answer3:(id)sender{
    if(Answer1Correct == YES){
        [self RightAnswer];
    }
    else{
        [self WrongAnswer];
    }
}
-(IBAction)Answer4:(id)sender{
    if(Answer1Correct == YES){
        [self RightAnswer];
    }
    else{
        [self WrongAnswer];
    }
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    if(GameInProgress == NO)
    {
        ScoreNumber = 0;
        dblElapsedSeconds=10; //Declare this in header
        GameInProgress = YES;
    }
    
    Result.hidden = YES;
    Score.text = [NSString stringWithFormat:@"%i", ScoreNumber];

    tmrElapsedTime = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateElapsedTime) userInfo:nil repeats:YES]; //Declare timer variable in header
    
    Answer1Correct = NO;
    Answer2Correct = NO;
    Answer3Correct = NO;
    Answer4Correct = NO;
    
    QuestionSelected = arc4random() % 8;
    
    switch (QuestionSelected) {
        case 0:
            QuestionText.text = [NSString stringWithFormat:@"Who directed the movie X?"];
            [Answer1 setTitle:@"Christopher Nolan" forState:UIControlStateNormal];
            [Answer2 setTitle:@"Peter Jackson" forState:UIControlStateNormal];
            [Answer3 setTitle:@"Steven Spielberg" forState:UIControlStateNormal];
            [Answer4 setTitle:@"Martin Scorsese" forState:UIControlStateNormal];
            Answer1Correct = YES;
            break;
        case 1:
            QuestionText.text = [NSString stringWithFormat:@"When was the movie X released?"];
            [Answer1 setTitle:@"Christopher Nolan" forState:UIControlStateNormal];
            [Answer2 setTitle:@"Peter Jackson" forState:UIControlStateNormal];
            [Answer3 setTitle:@"Steven Spielberg" forState:UIControlStateNormal];
            [Answer4 setTitle:@"Martin Scorsese" forState:UIControlStateNormal];
            Answer2Correct = YES;
            break;
        case 2:
            QuestionText.text = [NSString stringWithFormat:@"Which star (was/was not) in the movie X?"];
            [Answer1 setTitle:@"Christopher Nolan" forState:UIControlStateNormal];
            [Answer2 setTitle:@"Peter Jackson" forState:UIControlStateNormal];
            [Answer3 setTitle:@"Steven Spielberg" forState:UIControlStateNormal];
            [Answer4 setTitle:@"Martin Scorsese" forState:UIControlStateNormal];
            Answer3Correct = YES;
            break;
        case 3:
            QuestionText.text = [NSString stringWithFormat:@"In which movie the stars X and Y appear together?"];
            [Answer1 setTitle:@"Christopher Nolan" forState:UIControlStateNormal];
            [Answer2 setTitle:@"Peter Jackson" forState:UIControlStateNormal];
            [Answer3 setTitle:@"Steven Spielberg" forState:UIControlStateNormal];
            [Answer4 setTitle:@"Martin Scorsese" forState:UIControlStateNormal];
            Answer4Correct = YES;
            break;
        case 4:
            QuestionText.text = [NSString stringWithFormat:@"Who directed/did not direct the star X?"];
            [Answer1 setTitle:@"Christopher Nolan" forState:UIControlStateNormal];
            [Answer2 setTitle:@"Peter Jackson" forState:UIControlStateNormal];
            [Answer3 setTitle:@"Steven Spielberg" forState:UIControlStateNormal];
            [Answer4 setTitle:@"Martin Scorsese" forState:UIControlStateNormal];
            Answer1Correct = YES;
            break;
        case 5:
            QuestionText.text = [NSString stringWithFormat:@"Which star appears in both movies X and Y?"];
            [Answer1 setTitle:@"Christopher Nolan" forState:UIControlStateNormal];
            [Answer2 setTitle:@"Peter Jackson" forState:UIControlStateNormal];
            [Answer3 setTitle:@"Steven Spielberg" forState:UIControlStateNormal];
            [Answer4 setTitle:@"Martin Scorsese" forState:UIControlStateNormal];
            Answer2Correct = YES;
            break;
        case 6:
            QuestionText.text = [NSString stringWithFormat:@"Which star did not appear in the same movie with the star X?"];
            [Answer1 setTitle:@"Christopher Nolan" forState:UIControlStateNormal];
            [Answer2 setTitle:@"Peter Jackson" forState:UIControlStateNormal];
            [Answer3 setTitle:@"Steven Spielberg" forState:UIControlStateNormal];
            [Answer4 setTitle:@"Martin Scorsese" forState:UIControlStateNormal];
            Answer3Correct = YES;
            break;
        case 7:
            QuestionText.text = [NSString stringWithFormat:@"Who directed the star X in year Y?"];
            [Answer1 setTitle:@"Christopher Nolan" forState:UIControlStateNormal];
            [Answer2 setTitle:@"Peter Jackson" forState:UIControlStateNormal];
            [Answer3 setTitle:@"Steven Spielberg" forState:UIControlStateNormal];
            [Answer4 setTitle:@"Martin Scorsese" forState:UIControlStateNormal];
            Answer4Correct = YES;
            break;
        default:
            break;
    }
    
    
    [super viewDidLoad];
}

- (void)loadViewAgain
{
    if(GameInProgress == NO)
    {
        ScoreNumber = 0;
        dblElapsedSeconds=10; //Declare this in header
        GameInProgress = YES;
        
    }
    
    Score.text = [NSString stringWithFormat:@"%i", ScoreNumber];
    
    Answer1Correct = NO;
    Answer2Correct = NO;
    Answer3Correct = NO;
    Answer4Correct = NO;
    
    QuestionSelected = arc4random() % 8;
    
    switch (QuestionSelected) {
        case 0:
            QuestionText.text = [NSString stringWithFormat:@"Who directed the movie X?"];
            [Answer1 setTitle:@"Christopher Nolan" forState:UIControlStateNormal];
            [Answer2 setTitle:@"Peter Jackson" forState:UIControlStateNormal];
            [Answer3 setTitle:@"Steven Spielberg" forState:UIControlStateNormal];
            [Answer4 setTitle:@"Martin Scorsese" forState:UIControlStateNormal];
            Answer1Correct = YES;
            break;
        case 1:
            QuestionText.text = [NSString stringWithFormat:@"When was the movie X released?"];
            [Answer1 setTitle:@"Christopher Nolan" forState:UIControlStateNormal];
            [Answer2 setTitle:@"Peter Jackson" forState:UIControlStateNormal];
            [Answer3 setTitle:@"Steven Spielberg" forState:UIControlStateNormal];
            [Answer4 setTitle:@"Martin Scorsese" forState:UIControlStateNormal];
            Answer2Correct = YES;
            break;
        case 2:
            QuestionText.text = [NSString stringWithFormat:@"Which star (was/was not) in the movie X?"];
            [Answer1 setTitle:@"Christopher Nolan" forState:UIControlStateNormal];
            [Answer2 setTitle:@"Peter Jackson" forState:UIControlStateNormal];
            [Answer3 setTitle:@"Steven Spielberg" forState:UIControlStateNormal];
            [Answer4 setTitle:@"Martin Scorsese" forState:UIControlStateNormal];
            Answer3Correct = YES;
            break;
        case 3:
            QuestionText.text = [NSString stringWithFormat:@"In which movie the stars X and Y appear together?"];
            [Answer1 setTitle:@"Christopher Nolan" forState:UIControlStateNormal];
            [Answer2 setTitle:@"Peter Jackson" forState:UIControlStateNormal];
            [Answer3 setTitle:@"Steven Spielberg" forState:UIControlStateNormal];
            [Answer4 setTitle:@"Martin Scorsese" forState:UIControlStateNormal];
            Answer4Correct = YES;
            break;
        case 4:
            QuestionText.text = [NSString stringWithFormat:@"Who directed/did not direct the star X?"];
            [Answer1 setTitle:@"Christopher Nolan" forState:UIControlStateNormal];
            [Answer2 setTitle:@"Peter Jackson" forState:UIControlStateNormal];
            [Answer3 setTitle:@"Steven Spielberg" forState:UIControlStateNormal];
            [Answer4 setTitle:@"Martin Scorsese" forState:UIControlStateNormal];
            Answer1Correct = YES;
            break;
        case 5:
            QuestionText.text = [NSString stringWithFormat:@"Which star appears in both movies X and Y?"];
            [Answer1 setTitle:@"Christopher Nolan" forState:UIControlStateNormal];
            [Answer2 setTitle:@"Peter Jackson" forState:UIControlStateNormal];
            [Answer3 setTitle:@"Steven Spielberg" forState:UIControlStateNormal];
            [Answer4 setTitle:@"Martin Scorsese" forState:UIControlStateNormal];
            Answer2Correct = YES;
            break;
        case 6:
            QuestionText.text = [NSString stringWithFormat:@"Which star did not appear in the same movie with the star X?"];
            [Answer1 setTitle:@"Christopher Nolan" forState:UIControlStateNormal];
            [Answer2 setTitle:@"Peter Jackson" forState:UIControlStateNormal];
            [Answer3 setTitle:@"Steven Spielberg" forState:UIControlStateNormal];
            [Answer4 setTitle:@"Martin Scorsese" forState:UIControlStateNormal];
            Answer3Correct = YES;
            break;
        case 7:
            QuestionText.text = [NSString stringWithFormat:@"Who directed the star X in year Y?"];
            [Answer1 setTitle:@"Christopher Nolan" forState:UIControlStateNormal];
            [Answer2 setTitle:@"Peter Jackson" forState:UIControlStateNormal];
            [Answer3 setTitle:@"Steven Spielberg" forState:UIControlStateNormal];
            [Answer4 setTitle:@"Martin Scorsese" forState:UIControlStateNormal];
            Answer4Correct = YES;
            break;
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

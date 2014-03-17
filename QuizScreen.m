//
//  QuizScreen.m
//  MovieQuiz
//
//  Created by Tony Baik and Lucas Ou on 3/10/14.
//  Copyright (c) 2014 Tony Baik. All rights reserved.
//

#import "QuizScreen.h"
#import "TimeUp.h"
#import "MovieDBObjects.h"
#import "DBEngine.h"

@interface QuizScreen ()

@end

@implementation QuizScreen

-(void)updateElapsedTime
{
    dblElapsedSeconds -= 1;
    //Time is up.
    if(dblElapsedSeconds < 1)
    {
        //Time is up / reset
        GameInProgress = NO;
        //free up elapsed time / reset it
        tmrElapsedTime.invalidate;
        
        //+1 for # of quizzes taken
        NSUserDefaults* preferences = [NSUserDefaults standardUserDefaults];
        NSString* QuizKey = @"quizNumber";
        
        if([preferences objectForKey:QuizKey] == nil)
        {
            //do nothing. doesnt exist already.
            [preferences setInteger:1 forKey:QuizKey];
        }
        else
        {
            const NSInteger NewQuizNum = [preferences integerForKey:QuizKey] + 1;
            [preferences setInteger:NewQuizNum forKey:QuizKey];
        }
        
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
    Result.textColor = [UIColor greenColor];
    Result.text = [NSString stringWithFormat:@"Correct!"];
    [self loadViewAgain];
}

-(void)WrongAnswer{
    WrongNumber++;
    Result.hidden = NO;
    Result.textColor = [UIColor redColor];
    Result.text = [NSString stringWithFormat:@"Wrong!"];
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

-(int)ScoreNumber;
{
    return ScoreNumber;
}

-(int)WrongNumber
{
    return WrongNumber;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)dbTestSuite
{
    DBEngine *db = [DBEngine database];
    // res1 should be Tim Burton
    NSString *res1 = [db titleToDirector:@"Tim Burton" secondD:@"Taylor Hackford" thirdD:@"Tony Baik"
                                 fourthD:@"Lucas Ou-Yang" title:@"Sleepy Hollow"];
    
    // res2 should be 2005
    NSString *res2 = [db titleToYear:@"Star Wars: Episode III - Revenge of theSith"
                              firstD:@"1700" secondD:@"2005" thirdD:@"2000" fourthD:@"1995"];
    
    // res3 should be Tony Baik
    NSString *res3 = [db starNotInMovie:@"Russell Crowe" secondS:@"Jennifer Connelly"
                                 thirdS:@"Ed Harris" fourthS:@"Tony Baik" movie:@"A Beautiful Mind"];
    
    // res4 should be All Over Me
    NSString *res4 = [db sharedMovie:@"Tara Subkoff" secondStar:@"Samuel Jackson"];
    
    // res5 should be AlexSichel
    NSString *res5 = [db directedTheStar:@"Tara Subkoff" d1:@"AlexSichel" d2:@"Tony Baik"
                                      d3:@"George Lucas" d4:@"Robin Williams"];
    
    // res6 should be Nicole Kidman
    NSString *res6 = [db starBothMovies:@"Moulin Rouge" movie2:@"The Others" star1:@"Kate Beckinsale"
                                  star2:@"Nicole Kidman" star3:@"Hayden Christensen" star4:@"Leonardo DiCaprio"];
    
    // res7 should be Lucas Ou-Yang
    NSString *res7 = [db notInSameMovie:@"Nicole Kidman" s1:@"Tom Cruise" s2:@"Renee Zellweger"
                                     s3:@"Christopher Walken" s4:@"Lucas Ou-Yang"];
    
    // res8 should be AlexSichel
    NSString *res8 = [db directorOfStar:@"Steven Spielberg" d2:@"Ron Howard" d3:@"Bill Forsyth"
                                     d4:@"Bill Forsyth" star:@"Samuel Jackson" year:@"1997"];
    
    NSLog(@"\
          \n=====START OF TEST SEQUENCE=====\
          \ntitleToDirector TEST: %@\
          \ntitleToYear TEST: %@\
          \nstarNotInMovie TEST: %@\
          \nsharedMovie TEST: %@\
          \ndirectedTheStar TEST: %@\
          \nstarBothMovies TEST: %@\
          \nnotInSameMovie TEST: %@\
          \ndirectorOfStar TEST: %@",
          res1, res2, res3, res4, res5, res6, res7, res8);
    
    NSArray *movies = [DBEngine database].movieDBObjects;
    for (MovieDBObjects *movie in movies) {
        //NSLog(@"%d: %@ %d %@ %@ %@", movie.uniqueId, movie.title, movie.year,\
        //      movie.director, movie.banner_url, movie.trailer_url);
    }
    
}

- (void)viewDidLoad
{
    [self dbTestSuite];
    
    if(GameInProgress == NO)
    {
        ScoreNumber = 0;
        WrongNumber = 0;
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

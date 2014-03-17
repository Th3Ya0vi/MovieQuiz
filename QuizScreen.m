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
    // Time is up.
    if(dblElapsedSeconds < 1)
    {
        // Time is up / reset
        GameInProgress = NO;
        //free up elapsed time / reset it
        tmrElapsedTime.invalidate;
        
        // +1 for # of quizzes taken
        NSUserDefaults* preferences = [NSUserDefaults standardUserDefaults];
        NSString* QuizKey = @"quizNumber";
        
        if([preferences objectForKey:QuizKey] == nil) {
            [preferences setInteger:1 forKey:QuizKey];
        }
        else {
            const NSInteger NewQuizNum = [preferences integerForKey:QuizKey] + 1;
            [preferences setInteger:NewQuizNum forKey:QuizKey];
        }
        
        TimeUp *timeUp = [[UIStoryboard storyboardWithName:@"Main" bundle:NULL] instantiateViewControllerWithIdentifier:@"TimeUp"];
        // logic for exiting to gameover screen
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
    if(Answer2Correct == YES){
        [self RightAnswer];
    }
    else{
        [self WrongAnswer];
    }
}

-(IBAction)Answer3:(id)sender{
    if(Answer3Correct == YES){
        [self RightAnswer];
    }
    else{
        [self WrongAnswer];
    }
}

-(IBAction)Answer4:(id)sender{
    if(Answer4Correct == YES){
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

-(void)dbTestSuite {
    DBEngine *db = [DBEngine database];
    // res1 should be Tim Burton
    // options: directors
    NSString *res1 = [db titleToDirector:@"Tim Burton" secondD:@"Taylor Hackford" thirdD:@"Tony Baik"
                                 fourthD:@"Lucas Ou-Yang" title:@"Sleepy Hollow"];
    
    // res2 should be 2005
    // options: years
    NSString *res2 = [db titleToYear:@"Star Wars: Episode III - Revenge of theSith"
                              firstD:@"1700" secondD:@"2005" thirdD:@"2000" fourthD:@"1995"];
    
    // res3 should be Tony Baik
    // options: Actors
    NSString *res3 = [db starNotInMovie:@"Russell Crowe" secondS:@"Jennifer Connelly"
                                 thirdS:@"Ed Harris" fourthS:@"Tony Baik" movie:@"A Beautiful Mind"];
    
    // res4 should be All Over Me
    // options: movies (which one did these two appear in together)
    NSString *res4 = [db sharedMovie:@"Tara Subkoff" secondStar:@"Samuel Jackson"];
    
    // res5 should be AlexSichel
    // options: directors (directed the star)
    NSString *res5 = [db directedTheStar:@"Tara Subkoff" d1:@"AlexSichel" d2:@"Tony Baik"
                                      d3:@"George Lucas" d4:@"Robin Williams"];
    
    // res6 should be Nicole Kidman
    // options: actors (stared in both movies)
    NSString *res6 = [db starBothMovies:@"Moulin Rouge" movie2:@"The Others" star1:@"Kate Beckinsale"
                                  star2:@"Nicole Kidman" star3:@"Hayden Christensen" star4:@"Leonardo DiCaprio"];
    
    // res7 should be Lucas Ou-Yang
    // options: actors (not in the same movie together)
    NSString *res7 = [db notInSameMovie:@"Nicole Kidman" s1:@"Tom Cruise" s2:@"Renee Zellweger"
                                     s3:@"Christopher Walken" s4:@"Lucas Ou-Yang"];
    
    // res8 should be AlexSichel
    // options: directors (of a specified star and year)
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
    
    /*
    NSArray *movies = [DBEngine database].movieDBObjects;
    for (MovieDBObjects *movie in movies) {
        NSLog(@"%d: %@ %d %@ %@ %@", movie.uniqueId, movie.title, movie.year,\
              movie.director, movie.banner_url, movie.trailer_url);
    }
    */
}

- (void)viewDidLoad
{
    // [self dbTestSuite];
    DBEngine *db = [DBEngine database];
    if(GameInProgress == NO)
    {
        ScoreNumber = 0;
        WrongNumber = 0;
        dblElapsedSeconds=10;
        GameInProgress = YES;
    }
    Result.hidden = YES;
    Score.text = [NSString stringWithFormat:@"%i", ScoreNumber];

    tmrElapsedTime = [NSTimer scheduledTimerWithTimeInterval:1 target:self
                                                    selector:@selector(updateElapsedTime)
                                                    userInfo:nil
                                                     repeats:YES];
    Answer1Correct = NO;
    Answer2Correct = NO;
    Answer3Correct = NO;
    Answer4Correct = NO;
    
    int selection = 7;//arc4random() % 8;
    
    if (selection == 0) {
        NSMutableArray *randomTitleArr = [db randomElements:@"movie" howMany:1];
        NSString *randomTitle = [randomTitleArr objectAtIndex:0];
        QuestionText.text = [NSString stringWithFormat:@"Who directed the movie %@?", randomTitle];

        NSMutableArray *wrongs = [db randomElements:@"director" howMany:3];
        NSString *rightAnswer = [db answerOne:randomTitle];
            
        [Answer1 setTitle:rightAnswer forState:UIControlStateNormal];
        [Answer2 setTitle:[wrongs objectAtIndex:0] forState:UIControlStateNormal];
        [Answer3 setTitle:[wrongs objectAtIndex:1] forState:UIControlStateNormal];
        [Answer4 setTitle:[wrongs objectAtIndex:2] forState:UIControlStateNormal];
        Answer1Correct = YES;
    }
    else if (selection == 1) {
        NSMutableArray *randomTitleArr = [db randomElements:@"movie" howMany:1];
        NSString *randomTitle = [randomTitleArr objectAtIndex:0];
        QuestionText.text = [NSString stringWithFormat:@"When was the movie %@ released?", randomTitle];
        
        NSMutableArray *wrongs = [db randomElements:@"year" howMany:3];
        NSString *rightAnswer = [db answerTwo:randomTitle];
        
        [Answer1 setTitle:[wrongs objectAtIndex:0] forState:UIControlStateNormal];
        [Answer2 setTitle:rightAnswer forState:UIControlStateNormal];
        [Answer3 setTitle:[wrongs objectAtIndex:1] forState:UIControlStateNormal];
        [Answer4 setTitle:[wrongs objectAtIndex:2] forState:UIControlStateNormal];
        Answer2Correct = YES;
    }
    else if (selection == 2) {
        NSMutableArray *randomTitleArr = [db randomElements:@"movie" howMany:1];
        NSString *randomTitle = [randomTitleArr objectAtIndex:0];
        QuestionText.text = [NSString stringWithFormat:@"Which star was in the movie %@?", randomTitle];
        
        NSMutableArray *wrongs = [db randomElements:@"star" howMany:3];
        NSString *rightAnswer = [db answerThree:randomTitle];
        
        [Answer1 setTitle:[wrongs objectAtIndex:0] forState:UIControlStateNormal];
        [Answer2 setTitle:rightAnswer forState:UIControlStateNormal];
        [Answer3 setTitle:[wrongs objectAtIndex:0] forState:UIControlStateNormal];
        [Answer4 setTitle:[wrongs objectAtIndex:0] forState:UIControlStateNormal];
        Answer3Correct = YES;
    }
    else if (selection == 3) {
        // find two stars that actually appear in the same movie
        NSMutableArray *starArr = [db randomElements:@"star" howMany:2];
        QuestionText.text = [NSString stringWithFormat:@"In which movie the stars %@ and %@ appear together?",
                             [starArr objectAtIndex:0], [starArr objectAtIndex:1]];
        
        NSMutableArray *wrongs = [db randomElements:@"movie" howMany:3];
        NSString *rightAnswer = [db answerFour:[starArr objectAtIndex:0]
                                    secondStar:[starArr objectAtIndex:1]];
        
        [Answer1 setTitle:[wrongs objectAtIndex:0] forState:UIControlStateNormal];
        [Answer2 setTitle:[wrongs objectAtIndex:1] forState:UIControlStateNormal];
        [Answer3 setTitle:[wrongs objectAtIndex:2] forState:UIControlStateNormal];
        [Answer4 setTitle:rightAnswer forState:UIControlStateNormal];
        Answer4Correct = YES;
    }
    else if (selection == 4) {
        NSMutableArray *starArr = [db randomElements:@"star" howMany:1];
        NSString *curStar = [starArr objectAtIndex:0];
        QuestionText.text = [NSString stringWithFormat:@"Who directed direct the star %@?", curStar];
        NSMutableArray *wrongs = [db randomElements:@"director" howMany:3];
        
        NSString *rightAnswer = [db answerFive:curStar];
        
        [Answer1 setTitle:[wrongs objectAtIndex:0] forState:UIControlStateNormal];
        [Answer2 setTitle:[wrongs objectAtIndex:1] forState:UIControlStateNormal];
        [Answer3 setTitle:[wrongs objectAtIndex:2] forState:UIControlStateNormal];
        [Answer4 setTitle:rightAnswer forState:UIControlStateNormal];
        Answer4Correct = YES;
    }
    else if (selection == 5) {
        // find two movies that actually share the same star
        NSMutableArray *movieArr = [db randomElements:@"movie" howMany:2];
        QuestionText.text = [NSString stringWithFormat:@"Which star appears in both movies %@ and %@?",
                             [movieArr objectAtIndex:0], [movieArr objectAtIndex:1]];
        NSMutableArray *wrongs = [db randomElements:@"star" howMany:3];
        
        NSString *rightAnswer = [db answerSix:[movieArr objectAtIndex:0] movie2:[movieArr objectAtIndex:1]];
        
        [Answer1 setTitle:[wrongs objectAtIndex:0] forState:UIControlStateNormal];
        [Answer2 setTitle:[wrongs objectAtIndex:1] forState:UIControlStateNormal];
        [Answer3 setTitle:[wrongs objectAtIndex:2] forState:UIControlStateNormal];
        [Answer4 setTitle:rightAnswer forState:UIControlStateNormal];
        Answer4Correct = YES;
    }
    else if (selection == 6) {
        NSMutableArray *starArr = [db randomElements:@"star" howMany:1];
        NSString *curStar = [starArr objectAtIndex:0];
        QuestionText.text = [NSString stringWithFormat:@"Which star did not appear in the same movie with the star %@?", curStar];
        NSMutableArray *wrongs = [db randomElements:@"star" howMany:3];
        NSString *rightAnswer = [db answerSeven:curStar];
        
        [Answer1 setTitle:[wrongs objectAtIndex:0] forState:UIControlStateNormal];
        [Answer2 setTitle:[wrongs objectAtIndex:1] forState:UIControlStateNormal];
        [Answer3 setTitle:[wrongs objectAtIndex:2] forState:UIControlStateNormal];
        [Answer4 setTitle:rightAnswer forState:UIControlStateNormal];
        Answer4Correct = YES;
    }
    else if (selection == 7) {
        NSMutableArray *yearName = [db getLinkedStarAndMovie];
        NSString *curYear = [yearName objectAtIndex:0];
        NSString *curStar = [yearName objectAtIndex:1];
        QuestionText.text = [NSString stringWithFormat:@"Who directed the star %@ in year %@?", curStar, curYear];
        NSMutableArray *wrongs = [db randomElements:@"director" howMany:3];
        NSString *rightAnswer = [db answerEight:curStar year:curYear];
        
        [Answer1 setTitle:[wrongs objectAtIndex:0] forState:UIControlStateNormal];
        [Answer2 setTitle:[wrongs objectAtIndex:1] forState:UIControlStateNormal];
        [Answer3 setTitle:[wrongs objectAtIndex:2] forState:UIControlStateNormal];
        [Answer4 setTitle:rightAnswer forState:UIControlStateNormal];
        Answer4Correct = YES;
    }
    
    [super viewDidLoad];
}

- (void)loadViewAgain {
    DBEngine *db = [DBEngine database];
    
    if (GameInProgress == NO) {
        ScoreNumber = 0;
        dblElapsedSeconds = 10;
        GameInProgress = YES;
    }
    Score.text = [NSString stringWithFormat:@"%i", ScoreNumber];
    
    Answer1Correct = NO;
    Answer2Correct = NO;
    Answer3Correct = NO;
    Answer4Correct = NO;
    
    int selection = arc4random() % 8;
    
    if (selection == 0) {
        NSMutableArray *randomTitleArr = [db randomElements:@"movie" howMany:1];
        NSString *randomTitle = [randomTitleArr objectAtIndex:0];
        QuestionText.text = [NSString stringWithFormat:@"Who directed the movie %@?", randomTitle];
        
        NSMutableArray *wrongs = [db randomElements:@"director" howMany:3];
        NSString *rightAnswer = [db answerOne:randomTitle];
        
        [Answer1 setTitle:rightAnswer forState:UIControlStateNormal];
        [Answer2 setTitle:[wrongs objectAtIndex:0] forState:UIControlStateNormal];
        [Answer3 setTitle:[wrongs objectAtIndex:1] forState:UIControlStateNormal];
        [Answer4 setTitle:[wrongs objectAtIndex:2] forState:UIControlStateNormal];
        Answer1Correct = YES;
    }
    else if (selection == 1) {
        NSMutableArray *randomTitleArr = [db randomElements:@"movie" howMany:1];
        NSString *randomTitle = [randomTitleArr objectAtIndex:0];
        QuestionText.text = [NSString stringWithFormat:@"When was the movie %@ released?", randomTitle];
        
        NSMutableArray *wrongs = [db randomElements:@"year" howMany:3];
        NSString *rightAnswer = [db answerTwo:randomTitle];
        
        [Answer1 setTitle:[wrongs objectAtIndex:0] forState:UIControlStateNormal];
        [Answer2 setTitle:rightAnswer forState:UIControlStateNormal];
        [Answer3 setTitle:[wrongs objectAtIndex:1] forState:UIControlStateNormal];
        [Answer4 setTitle:[wrongs objectAtIndex:2] forState:UIControlStateNormal];
        Answer2Correct = YES;
    }
    else if (selection == 2) {
        NSMutableArray *randomTitleArr = [db randomElements:@"movie" howMany:1];
        NSString *randomTitle = [randomTitleArr objectAtIndex:0];
        QuestionText.text = [NSString stringWithFormat:@"Which star was in the movie %@?", randomTitle];
        
        NSMutableArray *wrongs = [db randomElements:@"star" howMany:3];
        NSString *rightAnswer = [db answerThree:randomTitle];
        
        [Answer1 setTitle:[wrongs objectAtIndex:0] forState:UIControlStateNormal];
        [Answer2 setTitle:rightAnswer forState:UIControlStateNormal];
        [Answer3 setTitle:[wrongs objectAtIndex:0] forState:UIControlStateNormal];
        [Answer4 setTitle:[wrongs objectAtIndex:0] forState:UIControlStateNormal];
        Answer3Correct = YES;
    }
    else if (selection == 3) {
        NSMutableArray *starArr = [db randomElements:@"star" howMany:2];
        QuestionText.text = [NSString stringWithFormat:@"In which movie the stars %@ and %@ appear together?",
                             [starArr objectAtIndex:0], [starArr objectAtIndex:1]];
        
        NSMutableArray *wrongs = [db randomElements:@"movie" howMany:3];
        NSString *rightAnswer = [db answerFour:[starArr objectAtIndex:0]
                                    secondStar:[starArr objectAtIndex:1]];
        
        [Answer1 setTitle:[wrongs objectAtIndex:0] forState:UIControlStateNormal];
        [Answer2 setTitle:[wrongs objectAtIndex:1] forState:UIControlStateNormal];
        [Answer3 setTitle:[wrongs objectAtIndex:2] forState:UIControlStateNormal];
        [Answer4 setTitle:rightAnswer forState:UIControlStateNormal];
        Answer4Correct = YES;
    }
    else if (selection == 4) {
        NSMutableArray *starArr = [db randomElements:@"star" howMany:1];
        NSString *curStar = [starArr objectAtIndex:0];
        QuestionText.text = [NSString stringWithFormat:@"Who directed direct the star %@?", curStar];
        NSMutableArray *wrongs = [db randomElements:@"director" howMany:3];
        
        NSString *rightAnswer = [db answerFive:curStar];
        
        [Answer1 setTitle:[wrongs objectAtIndex:0] forState:UIControlStateNormal];
        [Answer2 setTitle:[wrongs objectAtIndex:1] forState:UIControlStateNormal];
        [Answer3 setTitle:[wrongs objectAtIndex:2] forState:UIControlStateNormal];
        [Answer4 setTitle:rightAnswer forState:UIControlStateNormal];
        Answer4Correct = YES;
    }
    else if (selection == 5) {
        NSMutableArray *movieArr = [db randomElements:@"movie" howMany:2];
        QuestionText.text = [NSString stringWithFormat:@"Which star appears in both movies %@ and %@?",
                             [movieArr objectAtIndex:0], [movieArr objectAtIndex:1]];
        NSMutableArray *wrongs = [db randomElements:@"star" howMany:3];
        
        NSString *rightAnswer = [db answerSix:[movieArr objectAtIndex:0] movie2:[movieArr objectAtIndex:1]];
        
        [Answer1 setTitle:[wrongs objectAtIndex:0] forState:UIControlStateNormal];
        [Answer2 setTitle:[wrongs objectAtIndex:1] forState:UIControlStateNormal];
        [Answer3 setTitle:[wrongs objectAtIndex:2] forState:UIControlStateNormal];
        [Answer4 setTitle:rightAnswer forState:UIControlStateNormal];
        Answer4Correct = YES;
    }
    else if (selection == 6) {
        NSMutableArray *starArr = [db randomElements:@"star" howMany:1];
        NSString *curStar = [starArr objectAtIndex:0];
        QuestionText.text = [NSString stringWithFormat:@"Which star did not appear in the same movie with the star %@?", curStar];
        NSMutableArray *wrongs = [db randomElements:@"star" howMany:3];
        NSString *rightAnswer = [db answerSeven:curStar];
        
        [Answer1 setTitle:[wrongs objectAtIndex:0] forState:UIControlStateNormal];
        [Answer2 setTitle:[wrongs objectAtIndex:1] forState:UIControlStateNormal];
        [Answer3 setTitle:[wrongs objectAtIndex:2] forState:UIControlStateNormal];
        [Answer4 setTitle:rightAnswer forState:UIControlStateNormal];
        Answer4Correct = YES;
    }
    else if (selection == 7) {
        NSMutableArray *curStar = [[db randomElements:@"star" howMany:1] objectAtIndex:0];
        NSString *curYear = [[db randomElements:@"year" howMany:1] objectAtIndex:0];
        QuestionText.text = [NSString stringWithFormat:@"Who directed the star %@ in year %@?", curStar, curYear];
        NSMutableArray *wrongs = [db randomElements:@"director" howMany:3];
        NSString *rightAnswer = [db answerEight:curStar year:curYear];
        
        [Answer1 setTitle:[wrongs objectAtIndex:0] forState:UIControlStateNormal];
        [Answer2 setTitle:[wrongs objectAtIndex:1] forState:UIControlStateNormal];
        [Answer3 setTitle:[wrongs objectAtIndex:2] forState:UIControlStateNormal];
        [Answer4 setTitle:rightAnswer forState:UIControlStateNormal];
        Answer4Correct = YES;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

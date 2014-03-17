//
//  Statistics.m
//  MovieQuiz
//
//  Created by Tony Baik on 3/15/14.
//  Copyright (c) 2014 Tony Baik. All rights reserved.
//

#import "Statistics.h"
#import "QuizScreen.h"

@interface Statistics ()

@end

@implementation Statistics

-(IBAction)ClearStats:(id)sender
{
    NSUserDefaults* preferences = [NSUserDefaults standardUserDefaults];
    NSString* CorrectKey = @"correctNumber";
    
    if([preferences objectForKey:CorrectKey] == nil)
    {
        //do nothing. doesnt exist already.
    }
    else
    {
        [preferences setInteger:0 forKey:CorrectKey];
    }
    
    NSString* WrongKey = @"wrongNumber";
    
    if([preferences objectForKey:WrongKey] == nil)
    {
        //do nothing. doesnt exist already.
    }
    else
    {
        [preferences setInteger:0 forKey:WrongKey];
    }
    
    NSString* QuizKey = @"quizNumber";
    
    if([preferences objectForKey:QuizKey] == nil)
    {
    }
    else
    {
        [preferences setInteger:0 forKey:QuizKey];
    }
    
    const BOOL didSave = [preferences synchronize];
    
    if(!didSave)
    {
        //  Couldn't save (I've never seen this happen in real world testing)
    }
    else{
        TotalCorrectLabel.text = [NSString stringWithFormat:@"%li", (long)[preferences integerForKey:CorrectKey]];
        TotalWrongLabel.text = [NSString stringWithFormat:@"%li", (long)[preferences integerForKey:WrongKey]];
        QuizTakenLabel.text = [NSString stringWithFormat:@"%li", (long)[preferences integerForKey:QuizKey]];
        TimeSpentLabel.text = [NSString stringWithFormat:@"%0.2f s", 0.00];
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
    QuizScreen *quizScreen = [[QuizScreen alloc] initWithNibName:@"QuizScreen" bundle:nil];
    CorrectLabel.text = [NSString stringWithFormat:@"%i", quizScreen.ScoreNumber];
    WrongLabel.text = [NSString stringWithFormat:@"%i", quizScreen.WrongNumber];
    
    int totalAttempts = 0;
    
    
    //for overall scores. use NSUserDefault
    NSUserDefaults* preferences = [NSUserDefaults standardUserDefaults];
    //write first
    NSString* CorrectKey = @"correctNumber";
    
    if([preferences objectForKey:CorrectKey] == nil)
    {
        const NSInteger CorrectNumber = quizScreen.ScoreNumber;
        [preferences setInteger:CorrectNumber forKey:CorrectKey];
        //  Save to disk
        const BOOL didSave = [preferences synchronize];
        
        if(!didSave)
        {
            //  Couldn't save (I've never seen this happen in real world testing)
        }
        else{
            TotalCorrectLabel.text = [NSString stringWithFormat:@"%li", (long)[preferences integerForKey:CorrectKey]];
            totalAttempts += [preferences integerForKey:CorrectKey];
        }

    }
    else
    {
        const NSInteger CorrectNumber = [preferences integerForKey:CorrectKey] + quizScreen.ScoreNumber;
        [preferences setInteger:CorrectNumber forKey:CorrectKey];
        //  Save to disk
        const BOOL didSave = [preferences synchronize];
        
        if(!didSave)
        {
            //  Couldn't save (I've never seen this happen in real world testing)
        }
        else{
            TotalCorrectLabel.text = [NSString stringWithFormat:@"%li", (long)[preferences integerForKey:CorrectKey]];
            totalAttempts += [preferences integerForKey:CorrectKey];
        }
    }
    
    NSString* WrongKey = @"wrongNumber";
    
    if([preferences objectForKey:WrongKey] == nil)
    {
        const NSInteger WrongNumber = quizScreen.WrongNumber;
        [preferences setInteger:WrongNumber forKey:WrongKey];
        //  Save to disk
        const BOOL didSave = [preferences synchronize];
        
        if(!didSave)
        {
            //  Couldn't save (I've never seen this happen in real world testing)
        }
        else{
            TotalWrongLabel.text = [NSString stringWithFormat:@"%li", (long)[preferences integerForKey:WrongKey]];
            totalAttempts += [preferences integerForKey:WrongKey];
        }
        
    }
    else
    {
        const NSInteger WrongNumber = [preferences integerForKey:WrongKey] + quizScreen.WrongNumber;
        [preferences setInteger:WrongNumber forKey:WrongKey];
        //  Save to disk
        const BOOL didSave = [preferences synchronize];
        
        if(!didSave)
        {
            //  Couldn't save (I've never seen this happen in real world testing)
        }
        else{
            TotalWrongLabel.text = [NSString stringWithFormat:@"%li", (long)[preferences integerForKey:WrongKey]];
            totalAttempts += [preferences integerForKey:WrongKey];
        }
    }
    NSString* QuizKey = @"quizNumber";
    //This won't ever be null since it will be set beforehand.
    QuizTakenLabel.text = [NSString stringWithFormat:@"%li", (long)[preferences integerForKey:QuizKey]];
    
    //calculate Average time it takes per question overall.
    //180 seconds * number of quizzes divided by number of total attempts.
    TimeSpentLabel.text = [NSString stringWithFormat:@"%0.2f s", (180.0 * (long)[preferences integerForKey:QuizKey])/totalAttempts];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

//
//  Statistics.h
//  MovieQuiz
//
//  Created by Tony Baik on 3/15/14.
//  Copyright (c) 2014 Tony Baik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Statistics : UIViewController
{
    IBOutlet UILabel *CorrectLabel;
    IBOutlet UILabel *WrongLabel;
    IBOutlet UILabel *TotalCorrectLabel;
    IBOutlet UILabel *TotalWrongLabel;
    IBOutlet UILabel *QuizTakenLabel;
    IBOutlet UILabel *TimeSpentLabel;
    IBOutlet UIButton *Exit;
    IBOutlet UIButton *ClearStats;
    
}

-(IBAction)ClearStats:(id)sender;

@end

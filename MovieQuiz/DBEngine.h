//
//  DBEngine.h
//  MovieQuiz
//
//  Created by Lucas Ou-Yang on 3/16/14.
//  Copyright (c) 2014 Tony Baik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface DBEngine : NSObject {
    sqlite3 *_database;
}

+ (DBEngine*)database;
- (NSArray *)movieDBObjects;
- (NSMutableArray *)randomElements:(NSString *)type howMany:(int)num;
- (NSString *)titleToDirector:(NSString *)d1 secondD:(NSString *)d2 thirdD:(NSString *)d3
                      fourthD:(NSString *)d4 title:(NSString *)title;
- (NSString *)titleToYear:(NSString *)title firstD:(NSString *)d1 secondD:(NSString *)d2
                   thirdD:(NSString *)d3 fourthD:(NSString *)d4;
- (NSString *)starNotInMovie:(NSString *)s1 secondS:(NSString *)s2 thirdS:(NSString *)s3
                     fourthS:(NSString *)s4 movie:(NSString *)title;
- (NSString *)sharedMovie:(NSString *)s1 secondStar:(NSString *)s2;
- (NSString *)directedTheStar:(NSString *)star d1:(NSString *)d1 d2:(NSString *)d2
                           d3:(NSString *)d3 d4:(NSString *)d4;
- (NSString *)starBothMovies:(NSString *)m1Title movie2:(NSString *)m2Title star1:(NSString *)s1
                       star2:(NSString *)s2 star3:(NSString *)s3 star4:(NSString *)s4;
- (NSString *)notInSameMovie:(NSString *)inStar s1:(NSString *)s1 s2:(NSString *)s2
                          s3:(NSString *)s3 s4:(NSString *)s4;
- (NSString *)directorOfStar:(NSString *)d1 d2:(NSString *)d2 d3:(NSString *)d3
                          d4:(NSString *)d4 star:(NSString *)star year:(NSString *)year;

- (NSString *)answerOne:(NSString *)title;
- (NSString *)answerTwo:(NSString *)title;
- (NSString *)answerThree:(NSString *)title;
- (NSString *)answerFour:(NSString *)s1 secondStar:(NSString *)s2;
- (NSString *)answerFive:(NSString *)star;
- (NSString *)answerSix:(NSString *)m1Title movie2:(NSString *)m2Title;
- (NSString *)answerSeven:(NSString *)inStar;
- (NSString *)answerEight:(NSString *)star year:(NSString *)year;

- (NSMutableArray *)getLinkedStarAndMovie;
- (NSMutableArray *)twoMoviesSameYear;
- (NSMutableArray *)twoMoviesWithOneStar:(NSString *)starName;
- (NSString *)starMoreThanOneMovie;

@end


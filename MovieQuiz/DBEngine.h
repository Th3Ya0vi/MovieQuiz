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
- (NSString *)directorToMovie:(NSString *)d1 secondD:(NSString *)d2 thirdD:(NSString *)d3
                      fourthD:(NSString *)d4 title:(NSString *)title;
- (NSString *)titleToYear:(NSString *)title firstD:(NSString *)d1 secondD:(NSString *)d2
                   thirdD:(NSString *)d3 fourthD:(NSString *)d4;
- (NSString *)starNotInMovie:(NSString *)s1 secondS:(NSString *)s2 thirdS:(NSString *)s3
                     fourthS:(NSString *)s4 movie:(NSString *)title;
- (NSString *)sharedMovie:(NSString *)s1 secondStar:(NSString *)s2;


@end


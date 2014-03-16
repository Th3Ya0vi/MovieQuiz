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
- (NSString *)directorToMovie:(NSString *)director;
- (NSString *)titleToYear:(NSString *)title;

@end


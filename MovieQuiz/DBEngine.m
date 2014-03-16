//
//  DBEngine.m
//  MovieQuiz
//
//  Created by Lucas Ou-Yang on 3/16/14.
//  Copyright (c) 2014 Tony Baik. All rights reserved.
//

#import "DBEngine.h"
#import "MovieDBObjects.h"

@implementation DBEngine

static DBEngine *_database;

+ (DBEngine*)database {
    if (_database == nil) {
        _database = [[DBEngine alloc] init];
    }
    return _database;
}

- (id)init {
    if ((self = [super init])) {
        NSString *sqLiteDb = [[NSBundle mainBundle] pathForResource:@"moviedb"
                ofType:@"sqlite3"];
        
        if (sqlite3_open([sqLiteDb UTF8String], &_database) != SQLITE_OK) {
            NSLog(@"Failed to open database!");
        }
    }
    return self;
}

- (void)dealloc {
    sqlite3_close(_database);
}

/*
    Who directed the movie X?
    When was the movie X released?
    Which star (was/was not) in the movie X?
    In which movie the stars X and Y appear together?
    Who directed/did not direct the star X?
    Which star appears in both movies X and Y?
    Which star did not appear in the same movie with the star X?
    Who directed the star X in year Y?
*/

// Input 4 directors and a title, return winning director.
- (NSString *)directorToMovie:(NSString *)d1 secondD:(NSString *)d2 thirdD:(NSString *)d3
                      fourthD:(NSString *)d4 title:(NSString *)title {
    NSMutableArray *dirs = [[NSMutableArray alloc] init];
    NSString *query = [NSString stringWithFormat:@"SELECT director FROM movies WHERE title = '%@'", title];
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(_database, [query UTF8String], -1, &statement, nil)
        == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            char *titleChars = (char *) sqlite3_column_text(statement, 0);
            NSString *retTitle = [[NSString alloc] initWithUTF8String:titleChars];
            [dirs addObject:retTitle];
        }
    }
    if ([dirs containsObject:d1]) {
        return d1;
    }
    else if ([dirs containsObject:d2]) {
        return d2;
    }
    else if ([dirs containsObject:d3]) {
        return d3;
    }
    else {
        return d4;
    }
}

// Given a movie title and four release dates return winning date.
- (NSString *)titleToYear:(NSString *)title firstD:(NSString *)d1 secondD:(NSString *)d2
                   thirdD:(NSString *)d3 fourthD:(NSString *)d4 {
    NSString *retYear = nil;
    NSString *query = [NSString stringWithFormat:@"SELECT year FROM movies WHERE title = '%@'", title];
    sqlite3_stmt *statement;
    // Just grab the first one.
    if (sqlite3_prepare_v2(_database, [query UTF8String], -1, &statement, nil)
        == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            int intYear = sqlite3_column_int(statement, 0);
            // Lmao, this is really how you convert integers to Strings in this language.
            retYear = [[NSString alloc] initWithFormat:@"%d", intYear];
            break;
        }
    }
    return retYear;
}

// Given 4 stars, find which one is not in a given movie.
// Inputs are star firstname + lastname
- (NSString *)starNotInMovie:(NSString *)s1 secondS:(NSString *)s2 thirdS:(NSString *)s3
                     fourthS:(NSString *)s4 movie:(NSString *)title {
    NSMutableArray *stars = [[NSMutableArray alloc] init];
    NSString *query = [NSString stringWithFormat:@"SELECT DISTINCT stars.first_name, stars.last_name\
                    FROM movies join stars join stars_in_movies\
                    WHERE movies.title = '%@' AND stars_in_movies.star_id = stars.id\
                    AND stars_in_movies.movie_id = movies.id", title];
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(_database, [query UTF8String], -1, &statement, nil)
        == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            char *fNameChars = (char *) sqlite3_column_text(statement, 0);
            char *sNameChars = (char *) sqlite3_column_text(statement, 1);
            NSString *s1 = [[NSString alloc] initWithUTF8String:fNameChars];
            NSString *s2 = [[NSString alloc] initWithUTF8String:sNameChars];
            NSString *s = [NSString stringWithFormat:@"%@ %@", s1, s2];
            [stars addObject:s];
        }
    }
    if (![stars containsObject:s1]) {
        return s1;
    }
    else if (![stars containsObject:s2]) {
        return s2;
    }
    else if (![stars containsObject:s3]) {
        return s3;
    }
    else {
        return s4;
    }
}

// Top movie which two stars share, input first + last name with a space
// returns a title.
- (NSString *)sharedMovie:(NSString *)s1 secondStar:(NSString *)s2 {
    NSString *retTitle = nil;
    
    NSArray *s1A = [s1 componentsSeparatedByString:@" "];
    NSArray *s2A = [s2 componentsSeparatedByString:@" "];

    NSString *starOneFirstName = [s1A objectAtIndex:0];
    NSString *starOneLastName = [s1A objectAtIndex:1];
    
    NSString *starTwoFirstName = [s2A objectAtIndex:0];
    NSString *starTwoLastName = [s2A objectAtIndex:1];
    
    NSString *query = [NSString stringWithFormat:@"SELECT DISTINCT movies.title FROM movies\
                JOIN stars_in_movies JOIN stars JOIN stars AS stars2 JOIN movies AS movies2 JOIN stars_in_movies AS stars_in_movies2\
                WHERE stars_in_movies.star_id = stars.id AND stars_in_movies.movie_id = movies.id\
                AND stars.first_name = '%@' AND AND stars.last_name = '%@' stars2.first_name = '%@' AND stars2.last_name = '%@'\
                AND stars_in_movies2.star_id = stars2.id AND stars_in_movies2.movie_id = movies2.id\
                AND movies2.title = movies.title;", starOneFirstName, starOneLastName, starTwoFirstName, starTwoLastName];
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(_database, [query UTF8String], -1, &statement, nil)
        == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            char *titleChars = (char *) sqlite3_column_text(statement, 0);
            retTitle = [[NSString alloc] initWithUTF8String:titleChars];
            break;
        }
    }
    return retTitle;
}

// Given 4 directors and a star, who did direct that star.
// Star is first + " " + last name as always.
- (NSString *)directedTheStar:(NSString *)star d1:(NSString *)d1 d2:(NSString *)d2
                           d3:(NSString *)d3 d4:(NSString *)d4 {
    NSArray *sa = [star componentsSeparatedByString:@" "];
    
    NSString *fname = [sa objectAtIndex:0];
    NSString *lname = [sa objectAtIndex:1];
    
    NSMutableArray *dirs = [[NSMutableArray alloc] init];
    
    NSString *query = [NSString stringWithFormat:@"select distinct movies.director from stars join movies\
                       join stars_in_movies where movies.id = stars_in_movies.movie_id\
                       and stars.id = stars_in_movies.star_id and stars.first_name = '%@'\
                       and stars.last_name = '%@';", fname, lname];
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(_database, [query UTF8String], -1, &statement, nil)
        == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            char *dirChars = (char *) sqlite3_column_text(statement, 1);
            NSString *dirName = [[NSString alloc] initWithUTF8String:dirChars];
            [dirs addObject:dirName];
        }
    }
    bool is1 = [dirs containsObject:d1];
    if (is1) {
        return d1;
    }
    bool is2 = [dirs containsObject:d2];
    if (is2) {
        return d2;
    }
    bool is3 = [dirs containsObject:d3];
    if (is3) {
        return d3;
    }
    // bool is4 = [dirs containsObject:d4];
    return d4;
}

// Given 4 stars and 2 movies, find which one appears in both.
// As always, stars are concatenated to first+" "+last name.
- (NSString *)starBothMovies:(NSString *)m1Title movie2:(NSString *)m2Title star1:(NSString *)s1
                       star2:(NSString *)s2 star3:(NSString *)s3 star4:(NSString *)s4 {
    NSString *query = [NSString stringWithFormat:@"select distinct first_name, last_name from stars join movies\
                       join stars_in_movies where movies.id = stars_in_movies.movie_id and stars.id = stars_in_movies.star_id\
                       and movies.title = '%@';", m1Title];
    NSString *query2 = [NSString stringWithFormat:@"select distinct first_name, last_name from stars join movies\
                       join stars_in_movies where movies.id = stars_in_movies.movie_id and stars.id = stars_in_movies.star_id\
                       and movies.title = '%@';", m2Title];
    
    NSMutableArray *m1 = [[NSMutableArray alloc] init];
    NSMutableArray *m2 = [[NSMutableArray alloc] init];
    
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(_database, [query UTF8String], -1, &statement, nil)
        == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            char *fname = (char *) sqlite3_column_text(statement, 0);
            char *lname = (char *) sqlite3_column_text(statement, 1);
            NSString *fnames = [[NSString alloc] initWithUTF8String:fname];
            NSString *lnames = [[NSString alloc] initWithUTF8String:lname];
            NSString *name = [NSString stringWithFormat:@"%@ %@", fnames, lnames];
            [m1 addObject:name];
        }
    }
    
    sqlite3_stmt *statement2;
    if (sqlite3_prepare_v2(_database, [query2 UTF8String], -1, &statement2, nil)
        == SQLITE_OK) {
        while (sqlite3_step(statement2) == SQLITE_ROW) {
            char *fname = (char *) sqlite3_column_text(statement2, 0);
            char *lname = (char *) sqlite3_column_text(statement2, 1);
            NSString *fnames = [[NSString alloc] initWithUTF8String:fname];
            NSString *lnames = [[NSString alloc] initWithUTF8String:lname];
            NSString *name = [NSString stringWithFormat:@"%@ %@", fnames, lnames];
            [m2 addObject:name];
        }
    }
    bool is1 = [m1 containsObject:s1] && [m2 containsObject:s1];
    if (is1) {
        return s1;
    }
    bool is2 = [m1 containsObject:s2] && [m2 containsObject:s2];
    if (is2) {
        return s2;
    }
    bool is3 = [m1 containsObject:s3] && [m2 containsObject:s3];
    if (is3) {
        return s3;
    }
    // bool is4 = [m1 containsObject:s4] && [m2 containsObject:s4];
    return s4;
}

// Given 4 stars and a star, find which one were not ever in the same movie

// Given 4 directors and a star and a year (get the list of movies), who directed him.

- (NSArray *)movieDBObjects {
    NSMutableArray *retval = [[NSMutableArray alloc] init];
    NSString *query = @"SELECT id, title, year, director, banner_url, trailer_url FROM movies";
    sqlite3_stmt *statement;
    // Just grab the first one.
    if (sqlite3_prepare_v2(_database, [query UTF8String], -1, &statement, nil)
        == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            int uniqueId = sqlite3_column_int(statement, 0);
            char *titleChars = (char *) sqlite3_column_text(statement, 1);
            int year = sqlite3_column_int(statement, 2);
            char *directorChars = (char *) sqlite3_column_text(statement, 3);
            char *banner_urlChars = (char *) sqlite3_column_text(statement, 4);
            char *trailer_urlChars = (char *) sqlite3_column_text(statement, 5);
            
            NSString *title = [[NSString alloc] initWithUTF8String:titleChars];
            NSString *director = [[NSString alloc] initWithUTF8String:directorChars];
            NSString *banner_url = [[NSString alloc] initWithUTF8String:banner_urlChars];
            NSString *trailer_url = [[NSString alloc] initWithUTF8String:trailer_urlChars];
            
            MovieDBObjects *info = [[MovieDBObjects alloc]
                                    initWithUniqueId:uniqueId
                                    title:title
                                    year:year
                                    director:director
                                    banner_url:banner_url
                                    trailer_url:trailer_url];
            [retval addObject:info];
            
            // TODO: All my delloc/release statements are commented out
            // because in the new ARC setup referencing is done for us.
            // [title release];
            // [year release];
            // [director release];
            // [banner_url release];
        }
        sqlite3_finalize(statement);
    }
    return retval;
}
@end

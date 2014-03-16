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
    // [super dealloc];
}

/*
 - (id)initWithUniqueId:(int)uniqueId title:(NSString *)title year:(int)year
 director:(NSString *)director banner_url:(NSString *)banner_url
 trailer_url:(NSString *)trailer_url {
 */

- (NSArray *)movieDBObjects {
    
    NSMutableArray *retval = [[NSMutableArray alloc] init];
    NSString *query = @"SELECT id, title, year, director, banner_url, trailer_url FROM movies";
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(_database, [query UTF8String], -1, &statement, nil)
        == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            
            int uniqueId = sqlite3_column_int(statement, 0);
            char *titleChars = (char *) sqlite3_column_text(statement, 1);
            int year = sqlite3_column_int(statement, 2);
            // char *yearChars = (char *) sqlite3_column_text(statement, 2);
            char *directorChars = (char *) sqlite3_column_text(statement, 3);
            char *banner_urlChars = (char *) sqlite3_column_text(statement, 4);
            char *trailer_urlChars = (char *) sqlite3_column_text(statement, 5);
            
            NSString *title = [[NSString alloc] initWithUTF8String:titleChars];
            // NSInteger *year = [[NSString alloc] initWithUTF8String:yearChars];
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

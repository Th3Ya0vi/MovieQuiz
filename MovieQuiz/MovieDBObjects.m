//
//  MovieDBObjects.m
//  MovieQuiz
//
//  Created by Lucas Ou-Yang on 3/16/14.
//  Copyright (c) 2014 Tony Baik. All rights reserved.
//

#import "MovieDBObjects.h"


@implementation MovieDBObjects

@synthesize uniqueId = _uniqueId;
@synthesize title = _title;
@synthesize year = _year;
@synthesize director = _director;
@synthesize banner_url = _banner_url;
@synthesize trailer_url = _trailer_url;


- (id)initWithUniqueId:(int)uniqueId title:(NSString *)title year:(int)year
              director:(NSString *)director banner_url:(NSString *)banner_url
           trailer_url:(NSString *)trailer_url {
    if ((self = [super init])) {
        self.uniqueId = uniqueId;
        self.title = title;
        self.year = year;
        self.director = director;
        self.banner_url = banner_url;
        self.trailer_url = trailer_url;

    }
    return self;
}

- (void) dealloc {
    self.title = nil;
    // self.year = nil;
    self.director = nil;
    self.banner_url = nil;
    self.trailer_url = nil;
    // [super dealloc]; TODO WTF?
}

@end

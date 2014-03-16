//
//  MovieDBObjects.h
//  MovieQuiz
//
//  Created by Lucas Ou-Yang on 3/16/14.
//  Copyright (c) 2014 Tony Baik. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MovieDBObjects : NSObject {
    int _uniqueId;
    NSString *_title;
    int _year;
    NSString *_director;
    NSString *_banner_url;
    NSString *_trailer_url;
}

@property (nonatomic, assign) int uniqueId;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) int year;
@property (nonatomic, copy) NSString *director;
@property (nonatomic, copy) NSString *banner_url;
@property (nonatomic, copy) NSString *trailer_url;

- (id)initWithUniqueId:(int)uniqueId title:(NSString *)title year:(int)year
                 director:(NSString *)director banner_url:(NSString *)banner_url
                 trailer_url:(NSString *)trailer_url;

@end

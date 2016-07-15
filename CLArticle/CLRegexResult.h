//
//  CLRegexResult.h
//  CLArticle
//
//  Created by Darren on 16/7/15.
//  Copyright © 2016年 shanku. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CLRegexResult : NSObject

@property (nonatomic,copy) NSString *string;
@property (nonatomic,assign) NSRange range;

@property (nonatomic,assign) BOOL isPic;

@end

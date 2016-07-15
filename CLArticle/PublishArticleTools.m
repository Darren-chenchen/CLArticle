//
//  PublishArticleTools.m
//  ymw
//
//  Created by darren on 16/7/13.
//  Copyright © 2016年 yesmywine. All rights reserved.
//

#import "PublishArticleTools.h"
#import "RegexKitLite.h"
#import "CLRegexResult.h"  // 导入这个框架需要2步操作：1.-fobjc-arc    2.引入库libicucore.A.tbd
#import <UIKit/UIKit.h>
#import "YMWTextAttachment.h"

@implementation PublishArticleTools
+ (PublishArticleTools *)sharedPublishArticleTools
{
    static id sharedInstance;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[PublishArticleTools alloc] init];
    });
    return sharedInstance;
}
- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.goodName forKey:@"goodName"];
    [encoder encodeObject:self.goodID forKey:@"goodID"];
    [encoder encodeObject:self.articleContent forKey:@"content"];
    [encoder encodeObject:self.articleTitle forKey:@"title"];
    [encoder encodeObject:self.imgDict forKey:@"imgDict"];
    [encoder encodeObject:self.ymwTextAtt forKey:@"ymwTextAtt"];


}
- (id)initWithCoder:(NSCoder *)decoder
{
    if(self = [super init])
    {
        self.goodName = [decoder decodeObjectForKey:@"goodName"];
        self.goodID = [decoder decodeObjectForKey:@"goodID"];
        self.articleContent = [decoder decodeObjectForKey:@"content"];
        self.articleTitle = [decoder decodeObjectForKey:@"title"];
        self.imgDict = [decoder decodeObjectForKey:@"imgDict"];
        self.ymwTextAtt = [decoder decodeObjectForKey:@"ymwTextAtt"];
        
        [self setAttriText:self.articleContent];

    }
    return  self;
}

- (void)setAttriText:(NSString *)articleContent
{
    _articleContent = [articleContent copy];
    
    // 1.匹配字符串
    NSArray *regexResults = [self regexResultsWithText:articleContent];
    
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] init];
    // 遍历
    [regexResults enumerateObjectsUsingBlock:^(CLRegexResult *result, NSUInteger idx, BOOL *stop) {
        NSMutableAttributedString *substr = [[NSMutableAttributedString alloc] initWithString:result.string];
        if (!result.isPic) {
            [attributedText appendAttributedString:substr];
        }
            // 匹配超链接
            NSString *httpRegex = @"(?=#).+(?<=#)";
            [result.string enumerateStringsMatchedByRegex:httpRegex usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
                
                YMWTextAttachment *attachment = [[YMWTextAttachment alloc] init];
                attachment.image = [UIImage imageWithData:[self.imgDict valueForKey:*capturedStrings]];
                attachment.imgUrl = *capturedStrings;
                attachment.bounds = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width-40, 300);
                NSAttributedString *subtring2 = [NSAttributedString attributedStringWithAttachment:attachment];
                [attributedText appendAttributedString:subtring2];
                
                //修改行间距
                NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
                [paragraphStyle setLineSpacing:5];
                
                [attributedText addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [attributedText length])];
            }];
    }];
    
    [attributedText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, attributedText.length)];
    self.attributedText = attributedText;
    
}

 - (NSArray *)regexResultsWithText:(NSString *)text
{
    // 用来存放所有的匹配结果
    NSMutableArray *regexResults = [NSMutableArray array];
    
    // 匹配表情
    NSString *emotionRegex = @"(?=#).+(?<=#)";

    [text enumerateStringsMatchedByRegex:emotionRegex usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
        CLRegexResult *rr = [[CLRegexResult alloc] init];
        rr.string = *capturedStrings;
        rr.isPic = YES;
        rr.range = *capturedRanges;
        [regexResults addObject:rr];
    }];
    
    // 匹配非url
    [text enumerateStringsSeparatedByRegex:emotionRegex usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
        CLRegexResult *rr = [[CLRegexResult alloc] init];
        rr.string = *capturedStrings;
        rr.isPic = NO;
        rr.range = *capturedRanges;
        [regexResults addObject:rr];
    }];
    
    // 排序
    [regexResults sortUsingComparator:^NSComparisonResult(CLRegexResult *rr1, CLRegexResult *rr2) {
        int loc1 = (int)rr1.range.location;
        int loc2 = (int)rr2.range.location;
        return [@(loc1) compare:@(loc2)];
    }];
    return regexResults;
}


@end

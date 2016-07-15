//
//  PublishArticleTools.h
//  ymw
//
//  Created by darren on 16/7/13.
//  Copyright © 2016年 yesmywine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YMWTextAttachment.h"

@interface PublishArticleTools : NSObject
+ (PublishArticleTools *)sharedPublishArticleTools;

/**保存文章标题*/
@property(nonatomic, copy)NSString* articleTitle;
/**保存内容*/
@property(nonatomic, copy)NSString* articleContent;
/**经过转化的textView的内容*/
@property(nonatomic, copy)NSAttributedString* attributedText;
/**图片*/
@property(nonatomic, strong)NSDictionary* imgDict;

@property(nonatomic, strong)YMWTextAttachment* ymwTextAtt;

/**保存搜索商品的id*/
@property(nonatomic, copy)NSString* goodID;
/**保存搜索商品的名称*/
@property(nonatomic, copy)NSString* goodName;

@end

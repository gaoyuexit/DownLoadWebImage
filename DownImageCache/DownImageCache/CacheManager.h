//
//  CacheManager.h
//  DownImageCache
//
//  Created by 郜宇 on 16/3/30.
//  Copyright © 2016年 郜宇. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CacheManager : NSObject

+ (NSCache *)Cache;

+ (NSString *)cachePath;

+ (void)clearCache;

+ (unsigned long long)cacheBytesCount;

@end

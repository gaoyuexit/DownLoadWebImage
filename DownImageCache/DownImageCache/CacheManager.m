//
//  CacheManager.m
//  DownImageCache
//
//  Created by 郜宇 on 16/3/30.
//  Copyright © 2016年 郜宇. All rights reserved.
//

#import "CacheManager.h"

static NSCache *s_imageCache = nil;
@implementation CacheManager

+ (NSCache *)Cache
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_imageCache = [[NSCache alloc] init];
        s_imageCache.name = @"imageCache";
    });
    return s_imageCache;
}

+ (NSString *)cachePath
{
    NSString *document = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    return document;
}

+ (void)clearCache
{
    [[NSFileManager defaultManager] removeItemAtPath:[self cachePath] error:nil];
    [[NSFileManager defaultManager] createDirectoryAtPath:[self cachePath] withIntermediateDirectories:YES attributes:nil error:nil];
    [[self Cache] removeAllObjects];
}

+ (unsigned long long)cacheBytesCount
{
    NSFileManager *manager = [NSFileManager defaultManager];
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:[self cachePath]] objectEnumerator];
    NSString *fileName = nil;
    unsigned long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil) {
        NSString *fileAbsolutePath = [[self cachePath] stringByAppendingPathComponent:fileName];
        folderSize += [[manager attributesOfItemAtPath:fileAbsolutePath error:nil] fileSize]; 
    }
    return folderSize;
}



@end

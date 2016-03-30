//
//  UIImageView+Cache.m
//  DownImageCache
//
//  Created by 郜宇 on 16/3/30.
//  Copyright © 2016年 郜宇. All rights reserved.
//

#import "UIImageView+Cache.h"
#import <CommonCrypto/CommonCrypto.h>
#import "CacheManager.h"
@interface NSURL (md5)

- (NSString *)md5;

@end

@implementation NSURL (md5)

- (NSString *)md5
{
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(self.absoluteString.UTF8String, (unsigned int)strlen(self.absoluteString.UTF8String), result);
    NSMutableString *resultStr = [NSMutableString string];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i ++) {
        [resultStr appendFormat:@"%02x",result[i]];
    }
    return resultStr;
}

@end





@implementation UIImageView (Cache)

- (void)setImageWithURL:(NSURL *)url
{
    [self setImageWithURL:url placeHolderImage:nil];
}
- (void)setImageWithURL:(NSURL *)url placeHolderImage:(UIImage *)image
{
    self.image = image;
    // 从缓存中加载
    __block NSData *imageData = [[CacheManager Cache] objectForKey:url.md5];
    if (imageData != nil)
    {
        NSLog(@"缓存加载图片");
        UIImage *img = [UIImage imageWithData:imageData];
        self.image = img;
        return;
    }
    // 从本地加载
    NSString *file = [[CacheManager cachePath] stringByAppendingPathComponent:url.md5];
    imageData = [NSData dataWithContentsOfFile:file];
    if (imageData != nil)
    {
        NSLog(@"从本地加载图片");
        UIImage *img = [UIImage imageWithData:imageData];
        self.image = img;
        [[CacheManager Cache] setObject:imageData forKey:url.md5];
        return;
    }
    // 从网络加载
    NSURLSessionDownloadTask *task = [[NSURLSession sharedSession] downloadTaskWithRequest:[NSURLRequest requestWithURL:url] completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSURL *fileURL = [NSURL fileURLWithPath:file];
        [[NSFileManager defaultManager] copyItemAtURL:location toURL:fileURL error:nil];
        
        imageData = [NSData dataWithContentsOfURL:location];
        [[CacheManager Cache] setObject:imageData forKey:url.md5];
        NSLog(@"网络加载图片");
        dispatch_async(dispatch_get_main_queue(), ^{
            self.image = [UIImage imageWithData:imageData];
        });
    }];
    [task resume];
    
    
    
    
}

@end

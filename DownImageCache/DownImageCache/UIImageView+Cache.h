//
//  UIImageView+Cache.h
//  DownImageCache
//
//  Created by 郜宇 on 16/3/30.
//  Copyright © 2016年 郜宇. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (Cache)

- (void)setImageWithURL:(NSURL *)url;
- (void)setImageWithURL:(NSURL *)url placeHolderImage:(UIImage *)image;


@end

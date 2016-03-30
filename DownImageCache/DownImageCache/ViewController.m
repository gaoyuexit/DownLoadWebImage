//
//  ViewController.m
//  DownImageCache
//
//  Created by 郜宇 on 16/3/29.
//  Copyright © 2016年 郜宇. All rights reserved.
//

#import "ViewController.h"
#import "UIImageView+Cache.h"
#import "CacheManager.h"
#define KMUSICURL @"http://mobile.ximalaya.com/mobile/discovery/v1/category/album?calcDimension=hot&categoryId=2&device=iPhone&pageId=1&pageSize=20&status=0&tagName=%E6%96%B0%E7%A2%9F%E4%B8%8A%E6%9E%B6"

static NSString *ID = @"imageCell";
@interface ViewController () <UITableViewDataSource, UITableViewDelegate>
{
    NSArray *_imageArray;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:ID];
    [self beginDownLoad];
}

- (void)beginDownLoad
{
    NSURL *url = [NSURL URLWithString:KMUSICURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSessionDownloadTask *task = [[NSURLSession sharedSession] downloadTaskWithRequest:request completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSLog(@"--%@", location);
        NSData *content = [NSData dataWithContentsOfURL:location];
        id dic = [NSJSONSerialization JSONObjectWithData:content options:NSJSONReadingMutableContainers error:nil];
        _imageArray = [dic objectForKey:@"list"];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
        
    }];
    [task resume];
}


- (IBAction)refresh:(UIBarButtonItem *)sender {
    NSLog(@"刷新数据");
    [self beginDownLoad];
}


- (IBAction)clear:(UIBarButtonItem *)sender {
    NSLog(@"清除数据");
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:NULL]];
    
    NSString *string = [NSString stringWithFormat:@"清空缓存大小%llu",[CacheManager cacheBytesCount]];
    
    alert.message = string;
    
    [self presentViewController:alert animated:YES completion:NULL];
    
    [CacheManager clearCache];
    
    _imageArray = nil;
    [self.tableView reloadData];
}

#pragma mark -- tableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
    NSDictionary *dict = [_imageArray objectAtIndex:indexPath.row];
    NSString *urlStr = dict[@"coverMiddle"];
    cell.textLabel.text = dict[@"title"];
    [cell.imageView setImageWithURL:[NSURL URLWithString:urlStr] placeHolderImage:[UIImage imageNamed:@"123"]];
    [cell setNeedsLayout];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _imageArray.count;
}





@end

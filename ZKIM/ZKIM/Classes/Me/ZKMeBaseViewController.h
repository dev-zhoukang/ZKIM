//
//  ZKMeBaseViewController.h
//  ZKIM
//
//  Created by ZK on 16/9/18.
//  Copyright © 2016年 ZK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZKMeBaseViewController : ZKViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray <NSArray *> *dataSource;

@end

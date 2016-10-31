//
//  ZKWeChatCell.m
//  ZKIM
//
//  Created by ZK on 16/9/20.
//  Copyright © 2016年 ZK. All rights reserved.
//

#import "ZKWeChatCell.h"

@interface ZKWeChatCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@end

@implementation ZKWeChatCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    _nameLabel.font = [UIFont fontWithName:FZLTHFontName size:AutoFitFontSize(15.5)];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"周杰伦"];
    long number = 1.5;
    CFNumberRef num = CFNumberCreate(kCFAllocatorDefault, kCFNumberSInt8Type,&number);
    attributedString.attributes = @{
                                    (id)kCTKernAttributeName:(__bridge id)num
                                    };
    _nameLabel.attributedText = attributedString;
    
    _detailLabel.font = [UIFont fontWithName:FZLTHFontName size:AutoFitFontSize(12.5)];
    attributedString = [[NSMutableAttributedString alloc] initWithString:@"这是聊天的细节哦"];
    attributedString.attributes = @{
                                    (id)kCTKernAttributeName:(__bridge id)num
                                    };
    _detailLabel.attributedText = attributedString;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *cellIdentify = @"ZKWeChatCell";
    ZKWeChatCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].firstObject;
    }
    return cell;
}

- (void)setDataInfo:(NSDictionary *)dataInfo
{
    _dataInfo = dataInfo;
}

@end

//
//  News1ImageCell.m
//  CalendarEveryday
//
//  Created by YouMeng on 2017/7/26.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "News1ImageCell.h"

@interface News1ImageCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *sourceLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;

@end

@implementation News1ImageCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
-(void)setModel:(NewsModel *)model{
    _model = model;
    _titleLabel.text = model.title;
    _sourceLabel.text = model.source;
    _numberLabel.text = [NSString stringWithFormat:@"%@人",model.show_num];
    [_imgView sd_setImageWithURL:[NSURL URLWithString:model.thumbnail_pic_s1] placeholderImage:[UIImage imageNamed:@"placeholder"]];
}


+(instancetype)shareCell{
    return [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:nil options:nil]lastObject];
}
@end

//
//  News3ImageCell.m
//  CalendarEveryday
//
//  Created by YouMeng on 2017/7/26.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "News3ImageCell.h"


@interface News3ImageCell()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *imgsArr;
@property (weak, nonatomic) IBOutlet UILabel *sourceLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@end

@implementation News3ImageCell

- (void)awakeFromNib {
    [super awakeFromNib];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}
+(instancetype)shareCell{
    return [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:nil options:nil]lastObject];
}

-(void)setModel:(NewsModel *)model{
    _model = model;
    _titleLabel.text = model.title;
    _sourceLabel.text = model.source;
    _countLabel.text = [NSString stringWithFormat:@"%@人",model.show_num];
    for (int i = 0; i < _imgsArr.count; i ++) {
        UIImageView* imgV = _imgsArr[i];
        NSString* urlStr = [NSString stringWithFormat:@"thumbnail_pic_s%d",i + 1];
         [imgV sd_setImageWithURL:[NSURL URLWithString:[model valueForKey:urlStr]] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    }
    
   // [_imgView sd_setImageWithURL:[NSURL URLWithString:model.thumbnail_pic_s1] placeholderImage:[UIImage imageNamed:@"placeholder"]];

}
@end

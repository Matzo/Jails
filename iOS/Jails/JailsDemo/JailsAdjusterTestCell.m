//
//  JailsAdjusterTestCell.m
//  Jails
//
//  Created by Matsuo Keisuke on 2013/05/19.
//  Copyright (c) 2013 Matzo. All rights reserved.
//

#import "JailsAdjusterTestCell.h"

@implementation JailsAdjusterTestCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect titleFrame = self.textLabel.frame;
    titleFrame.origin.x = 0.0;
    titleFrame.origin.y = 0.0;
    self.textLabel.frame = titleFrame;
    
    CGRect subtitleFrame = self.detailTextLabel.frame;
    subtitleFrame.origin.x = 0.0;
    subtitleFrame.origin.y = CGRectGetMaxY(titleFrame);
    self.detailTextLabel.frame = subtitleFrame;
}

- (void)setData:(JailsAdjusterTestCellData *)data {
    _data = data;
    self.textLabel.text = data.title;
    self.detailTextLabel.text = data.subtitle;
    [self setNeedsLayout];
}

@end

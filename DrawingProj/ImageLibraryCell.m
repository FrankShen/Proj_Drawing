//
//  ImageLibraryCell.m
//  DrawingProj
//
//  Created by BuG.BS on 12-8-31.
//  Copyright (c) 2012年 BuG.BS. All rights reserved.
//

#import "ImageLibraryCell.h"

@implementation ImageLibraryCell
@synthesize image;
@synthesize unreadSignal;

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

@end

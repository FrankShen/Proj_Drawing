//
//  ImageLibraryCell.h
//  DrawingProj
//
//  Created by BuG.BS on 12-8-31.
//  Copyright (c) 2012年 BuG.BS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageLibraryCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UIImageView *unreadSignal;

@end

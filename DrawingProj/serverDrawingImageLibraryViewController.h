//
//  serverDrawingImageLibraryViewController.h
//  DrawingProj
//
//  Created by BuG.BS on 12-8-29.
//  Copyright (c) 2012年 BuG.BS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "serverDrawingSettingTableViewController.h"
#import "GlobalVariable.h"
#import "ImageLibraryTableViewCell.h"
@interface serverDrawingImageLibraryViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *imageLibrary;

@end

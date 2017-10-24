//
//  QTUMImageTagCell.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 20.10.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SpinnerView.h"

extern NSString * const QTUMImageTagCellReuseIdentifire;

@interface QTUMImageTagCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *tagImageView;

@end

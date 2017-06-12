//
//  SubscribeTokenDataSourceDelegate.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 03.03.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "SubscribeTokenDataSourceDelegate.h"
#import "TockenCell.h"

@implementation SubscribeTokenDataSourceDelegate

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.tokensArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TockenCell* cell = [tableView dequeueReusableCellWithIdentifier:tokenCellIdentifire];
    if (!cell){
        cell = [[TockenCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tokenCellIdentifire];
    }

    Contract* token = self.tokensArray[indexPath.row];
    cell.topSeparator.hidden = NO;
    cell.indicator.hidden = !token.isActive;
    cell.label.text = token.name;
    [cell setSelectedBackgroundView:[self highlightedView]];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.delegate respondsToSelector:@selector(tableView:didSelectContract:)]) {
        [self.delegate tableView:tableView didSelectContract:self.tokensArray[indexPath.row]];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TockenCell* cell = (TockenCell*)[tableView cellForRowAtIndexPath:indexPath];
    cell.topSeparator.backgroundColor = customBlackColor();
    cell.label.textColor = customBlackColor();
    cell.indicator.tintColor = customBlackColor();
}

- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TockenCell* cell = (TockenCell*)[tableView cellForRowAtIndexPath:indexPath];
    cell.topSeparator.backgroundColor = customBlueColor();
    cell.label.textColor = customBlueColor();
    cell.indicator.tintColor = customBlueColor();
}

#pragma mark - Lazy Getter

-(UIView*)highlightedView{
    UIView * selectedBackgroundView = [[UIView alloc] init];
    [selectedBackgroundView setBackgroundColor:customRedColor()];
    return selectedBackgroundView;
}



@end

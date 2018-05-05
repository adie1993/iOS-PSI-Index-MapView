//
//  InfoCollectionViewCell.m
//  PSI
//
//  Created by WGS-LAP189 on 04/05/18.
//  Copyright © 2018 Adie. All rights reserved.
//

#import "InfoCollectionViewCell.h"

@implementation InfoCollectionViewCell

-(void)awakeFromNib{
    [super awakeFromNib];
    
    self.infoView.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.infoView.layer.shadowOffset = CGSizeMake(0.3, 2.0);
    self.infoView.layer.shadowOpacity = 0.5;
    self.infoView.layer.shadowRadius = 5.0;
    self.infoView.layer.cornerRadius = 5.0;
    
    
    
}
@end

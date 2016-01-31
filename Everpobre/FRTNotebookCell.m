//
//  FRTNotebookCell.m
//  Everpobre
//
//  Created by Eloy Sanz Navarro on 30/1/16.
//  Copyright © 2016 keepcoding.io. All rights reserved.
//

#import "FRTNotebookCell.h"

@implementation FRTNotebookCell

#pragma mark -  class methods
+(NSString *)cellId{
    return NSStringFromClass(self);
}
+(CGFloat)cellHeight{
    return 50.0f;
}
- (void)awakeFromNib {
    // Initialization code
    
    
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

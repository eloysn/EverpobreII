//
//  FRTNotebookCell.h
//  Everpobre
//
//  Created by Eloy Sanz Navarro on 30/1/16.
//  Copyright © 2016 keepcoding.io. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FRTNotebookCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameView;
@property (weak, nonatomic) IBOutlet UILabel *numberNotesView;

+(NSString *)cellId;
+(CGFloat)cellHeight;

@end

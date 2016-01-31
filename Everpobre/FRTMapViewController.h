//
//  FRTMapViewController.h
//  Everpobre
//
//  Created by Eloy Sanz Navarro on 31/1/16.


#import <UIKit/UIKit.h>
#import "AGTCoreDataStack.h"

@interface FRTMapViewController : UIViewController
@property (strong, nonatomic) AGTCoreDataStack *model;
-(id)initWithModel:(AGTCoreDataStack *)model;

@end

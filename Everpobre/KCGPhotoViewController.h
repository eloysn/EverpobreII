//
//  KCGPhotoViewController.h
//  Everpobre
//
//  Created by Eloy Sanz Navarro on 30/1/16.

@import UIKit;
@class KCGNote;

@interface KCGPhotoViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

-(id) initWithModel:(KCGNote*) note;

@end

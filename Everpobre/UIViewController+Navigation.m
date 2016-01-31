//
//  UIViewController+Navigation.m
//  Everpobre
//
//  Created by Eloy Sanz Navarro on 30/1/16.



#import "UIViewController+Navigation.h"

@implementation UIViewController (Navigation)

-(UINavigationController *) wrappedInNavigation{
    
    // Creamos el navigation controller
    UINavigationController *nav = [UINavigationController new];
    
    // le encasquetamos
    [nav pushViewController:self
                   animated:NO];
    
    // Lo devolvemos
    return nav;
}
@end

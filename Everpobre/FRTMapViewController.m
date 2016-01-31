//
//  FRTMapViewController.m
//  Everpobre
//
//  Created by Eloy Sanz Navarro on 31/1/16.


#import "FRTMapViewController.h"
#import <MapKit/MapKit.h>


@interface FRTMapViewController () <MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation FRTMapViewController


-(id)initWithModel:(AGTCoreDataStack *)model{
    if (self = [super init]) {
        _model = model;
        
    }
    
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.mapView.delegate = self;

    
}
-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    

}

-(NSString *)title{
    return @"Map";
}


@end

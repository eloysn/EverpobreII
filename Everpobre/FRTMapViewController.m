//
//  FRTMapViewController.m
//  Everpobre
//
//  Created by Eloy Sanz Navarro on 31/1/16.


#import "FRTMapViewController.h"
#import <MapKit/MapKit.h>
#import "FRTLocation.h"



@interface FRTMapViewController () <MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) NSArray *locationArr;

@end

@implementation FRTMapViewController


-(id)initWithModel:(AGTCoreDataStack *)model{
    if (self = [super init]) {
        _model = model;
        
    }
    
    return self;
}
-(void)viewDidAppear:(BOOL)animated {
    
    
    
    
    [super viewDidAppear:animated];
    NSFetchRequest *req = [NSFetchRequest fetchRequestWithEntityName:[FRTLocation entityName]];
    self.locationArr = [self.model executeFetchRequest:req errorBlock:^(NSError *error) {
        
        NSLog(@"No se encontraron Locations");
        
    }];
    
    if (self.locationArr > 0 ) {
       
        for ( FRTLocation *loc in self.locationArr) {
            
            FRTLocation *l = loc;
            CLLocationCoordinate2D initialLocation;
            initialLocation.latitude = l.latitudeValue;
            initialLocation.longitude = l.longitudeValue;
            MKPointAnnotation *aPoint = [[MKPointAnnotation alloc]init];
            aPoint.coordinate = initialLocation;
            MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(initialLocation, 20000, 20000);
            [self.mapView setRegion:region];
            [self.mapView addAnnotation:aPoint];
            
            
            
            
        }
    }
    
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

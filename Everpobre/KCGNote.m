



#import "KCGNote.h"
#import "KCGPhoto.h"
#import "KCGNotebook.h"
#import "FRTLocation.h"

@import CoreLocation;
@interface KCGNote () <CLLocationManagerDelegate>

// Private interface goes here.
@property (nonatomic, strong) CLLocationManager *locationManger;
@end

@implementation KCGNote


@synthesize locationManger = _locationManger;

-(BOOL) hasLocation {
    
   
    return (nil != self.location);
}

+(NSArray*)observableKeys{
    return @[@"name", @"text", @"notebook",@"photo.imageData", @"location"];
}


+(instancetype)noteWithName:(NSString *) name
                   notebook: (KCGNotebook*) notebook
                    context:(NSManagedObjectContext*) context{
    
    
    KCGNote *note = [self insertInManagedObjectContext:context];
    note.name = name;
    note.notebook = notebook;
    note.creationDate = [NSDate date];
    note.photo = [KCGPhoto insertInManagedObjectContext:context];
    note.modificationDate = [NSDate date];
    
    return  note;
}

#pragma mark - Life cycle
-(void) awakeFromInsert{
    [super awakeFromInsert];
    
    // Se llama solo una vez
    [self setupKVO];
    
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    
    if (((status == kCLAuthorizationStatusAuthorizedWhenInUse) || (status == kCLAuthorizationStatusNotDetermined))){
        //&& [CLLocationManager locationServicesEnabled]
        NSLog(@"dispnemos de servicio");
        //disponemos de localizacion
        self.locationManger = [CLLocationManager new];
        self.locationManger.delegate = self;
        self.locationManger.desiredAccuracy = kCLLocationAccuracyBest;
        [self.locationManger requestWhenInUseAuthorization];
        [self.locationManger startUpdatingLocation];
      
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self zapLocationManager];
            
            
        });
        
        
    }
    
    
}

-(void)awakeFromFetch{
    [super awakeFromFetch];
    // Se llama un huevo de veces
    [self setupKVO];
}

-(void) willTurnIntoFault{
    [super willTurnIntoFault];
    [self tearDownKVO];
}


#pragma mark - KVO
-(void) setupKVO{
    // Alta en notificaciones
    
    for (NSString *key in [self.class observableKeys]) {
        [self addObserver:self
               forKeyPath:key
                  options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:NULL];
    }
    
    
}

-(void) tearDownKVO{
    // Baja en notificaciones
    
    for (NSString *key in [self.class observableKeys]) {
        [self removeObserver:self
                  forKeyPath:key];
    }
}

-(void)observeValueForKeyPath:(NSString *)keyPath
                     ofObject:(id)object
                       change:(NSDictionary<NSString *,id> *)change
                      context:(void *)context{
    
    self.modificationDate = [NSDate date];
}



#pragma mark -CLLocationManagerDelegate

-(void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    
    [self zapLocationManager];
    
    if (![self hasLocation]) {
       
        CLLocation *loc = [locations firstObject];
        NSLog(@"%@",loc);
        self.location = [FRTLocation locationWithCLLocation: loc forNote: self];
    }else{
        NSLog(@"No deveriamos estar aqui");
        
    }
    
    
    
    
    
}
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    
    NSLog(@"No tenemos la localizacion activada");
    
}

-(void) zapLocationManager{
    
    [self.locationManger stopUpdatingLocation];
    self.locationManger.delegate = nil;
    self.locationManger = nil;
    
    
}







@end

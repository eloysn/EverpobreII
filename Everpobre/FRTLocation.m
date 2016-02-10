


#import "FRTLocation.h"
#import "KCGNote.h"

@import AddressBook;
@import Contacts;
@interface FRTLocation ()

// Private interface goes here.

@end

@implementation FRTLocation

+(instancetype)locationWithCLLocation:(CLLocation *)location forNote:(KCGNote *)note {
   
    NSFetchRequest *req = [NSFetchRequest fetchRequestWithEntityName:[FRTLocation entityName]];
    NSPredicate *latitude = [NSPredicate predicateWithFormat:@"abs(latitude) - abs(%lf) < 0.001",
                             location.coordinate.latitude];
    NSPredicate *longitude = [NSPredicate predicateWithFormat:@"abs(longitude) - abs(%lf) < 0.001",
                              location.coordinate.longitude];
    req.predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[latitude, longitude]];
    
    NSError *error;
    NSArray *results = [note.managedObjectContext executeFetchRequest:req
                                                                error:&error];
    
    NSAssert(results, @"¡Error al buscar una AGTLocation!");
    
    if ([results count]) {
        
        FRTLocation *found = [results lastObject];
        [found addNotesObject:note];
        return found;
        

    }else{
    
        FRTLocation *loc = [self insertInManagedObjectContext:note.managedObjectContext];
        loc.latitudeValue = location.coordinate.latitude;
        loc.longitudeValue = location.coordinate.longitude;
        [loc addNotesObject:note];
        
        //obtener direccion
        CLGeocoder *coder = [CLGeocoder new];
        [coder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            
            if (error){
                NSLog(@"Error obteniendo localizacion");
                
            }else{
                CLPlacemark *placemark = [placemarks lastObject];
                NSArray *lines = placemark.addressDictionary[ @"FormattedAddressLines"];
                loc.address = [lines componentsJoinedByString:@"\n"];
                
                
            }
            
            
        }];
        return loc;
    }
    
    
    
}


@end

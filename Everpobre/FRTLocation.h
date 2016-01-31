



#import "_FRTLocation.h"
@import CoreLocation;
@class KCGNote;

@interface FRTLocation : _FRTLocation {}


+(instancetype)locationWithCLLocation:(CLLocation *)location forNote:(KCGNote *)note;


@end

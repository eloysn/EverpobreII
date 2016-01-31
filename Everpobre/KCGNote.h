



#import "_KCGNote.h"

@class KCGNotebook;

@interface KCGNote : _KCGNote {}

@property (nonatomic, readonly) BOOL hasLocation;

+(instancetype)noteWithName:(NSString *) name
                   notebook: (KCGNotebook*) notebook
                    context:(NSManagedObjectContext*) context;

@end

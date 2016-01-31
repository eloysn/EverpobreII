//
//  KCGPhotoViewController.m
//  Everpobre
//
//  Created by Eloy Sanz Navarro on 30/1/16.


#import "KCGPhotoViewController.h"
#import "KCGNote.h"
#import "KCGPhoto.h"
@import CoreImage;

@interface KCGPhotoViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *photoView;
@property (nonatomic) BOOL shouldSaveImageToModel;
@property (nonatomic, strong) KCGNote *model;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *deleteButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityView;
@end

@implementation KCGPhotoViewController

-(id) initWithModel:(KCGNote*) note{
    
    if (self = [super initWithNibName:nil
                               bundle:nil]) {
        _model = note;
        if (note.photo.imageData == nil) {
            _shouldSaveImageToModel = NO;
        }else{
            _shouldSaveImageToModel = YES;
        }
    }
    
    return self;
}

#pragma mark - Ciclo de vida
-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.title = self.model.name;
    if (self.model.photo.imageData != nil){
        self.photoView.image = self.model.photo.image;
        self.shouldSaveImageToModel = YES;
    }else{
        self.photoView.image = [UIImage imageNamed:@"no-image-available.png"];
        self.shouldSaveImageToModel = NO;
    }
    
    self.deleteButton.enabled = self.shouldSaveImageToModel;
}

-(void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    if(self.shouldSaveImageToModel){
        self.model.photo.image = self.photoView.image;
    }
    
}
#pragma mark - Actions
- (IBAction)delete:(id)sender {
    
    
    
    CGRect oldBounds = self.photoView.bounds;
    
    [UIView animateWithDuration:0.9
                     animations:^{
                         self.photoView.alpha = 0;
                         self.photoView.bounds = CGRectZero;
                         self.photoView.transform = CGAffineTransformMakeRotation(M_2_PI);
                         
                     } completion:^(BOOL finished) {
                         
                         // Eliminamos de la photoView
                         self.photoView.image = nil;
                         
                         // La eliminamos del modelo
                         self.model.photo.image = nil;
                         
                         // Actualizamos estado del botón
                         self.deleteButton.enabled = NO;
                         
                         // Dejamos todo como estaba
                         self.photoView.alpha = 1;
                         self.photoView.bounds = oldBounds;
                         self.photoView.transform = CGAffineTransformIdentity;
                         
                     }];
    
    
    
    
    
}
- (IBAction)applyFilter:(id)sender {
    
    //creamos un context
    CIContext *ctxt = [CIContext contextWithOptions:nil];
    
    //ima de entrada
    CIImage *input = [CIImage imageWithCGImage: self.model.photo.image.CGImage];
    
    //primer filtro CIFalseColor
    CIFilter *old = [CIFilter filterWithName:@"CIFalseColor"];
    [old setDefaults];
    [old setValue:input forKeyPath:kCIInputImageKey];
    
    //segundo filtro CIVignette
    CIFilter *vignette = [CIFilter filterWithName:@"CIVignette"];
    [vignette setDefaults];
    [vignette setValue:@18 forKeyPath:kCIInputIntensityKey];
    
    // encadenamos
    [vignette setValue:old.outputImage forKeyPath:kCIInputImageKey];
    
    // Obtener la imagen de salida
    CIImage *output = [vignette outputImage];
    
    
    // Aplicar el filtro
    [self.activityView startAnimating];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        CGImageRef res = [ctxt createCGImage:output
                                    fromRect:[output extent]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.activityView stopAnimating];
            
            // Guardamos la imagen
            UIImage *img = [UIImage imageWithCGImage:res];
            self.photoView.image = img;
            
            // liberamos el CGImageRef
            CGImageRelease(res);
        });
    });
    
    

    
}
- (IBAction)takePhoto:(id)sender {
    
    // Crear un ImagePicker
    UIImagePickerController *pVC = [[UIImagePickerController alloc]init];
    
    // Configurarlo
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        // Habemus camara
        pVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    }else{
        // me conformo con carrete
        pVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    // Hacerme su delegado
    pVC.delegate = self;
    
    // Mostrarlo
    [self presentViewController:pVC
                       animated:YES
                     completion:nil];
    
    
    // Actualizamos estado del botón
    self.deleteButton.enabled = NO;
    
}


#pragma mark - UIImagePickerControllerDelegate
-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    // Extraer la foto del diccionario de info
    UIImage *img = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    // Asegurarnos que la imagen se guarda
    self.shouldSaveImageToModel = YES;
    
    // Lo metemos en el modelo
    self.model.photo.image = img;
    
    // Ocultamos el picker
    [self dismissViewControllerAnimated:YES
                             completion:nil];
    
    
}
















@end

//
//  FRTNotesViewController.m
//  Everpobre
//
//  Created by Eloy Sanz Navarro on 31/1/16.


#import "FRTNotesViewController.h"
#import "KCGNote.h"
#import "FRTNotebookCell.h"
#import "KCGPhoto.h"
#import "KCGNoteViewController.h"
#import "FRTNotesCell.h"
#import "KCGNotebook.h"
#import "KCGPhotoViewController.h"


@interface FRTNotesViewController ()


@end

@implementation FRTNotesViewController

    static NSString *cellId = @"cellid";



-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    UINib *nibCell = [UINib nibWithNibName:@"FRTNotesCell" bundle:nil];
    [self.collectionView registerNib:nibCell forCellWithReuseIdentifier:cellId];
    self.collectionView.backgroundColor = [UIColor grayColor];
    
    UIBarButtonItem *add = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                         target:self
                                                                         action:@selector(addNote:)];
    self.navigationItem.rightBarButtonItem = add;
    

    
}
-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    
}

#pragma mark - Data Source
-(UICollectionViewCell*) collectionView:(UICollectionView *)collectionView
                 cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    // Obtener el objeto
    KCGNote *note = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    // Obtener la celda
    FRTNotesCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    
    // Configurarla
    cell.nameView.text = note.name;
    cell.photoImage.image = note.photo.image;
    
    // Devolcerla
    return cell;
}
-(void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    KCGNote *note = [self.fetchedResultsController objectAtIndexPath:indexPath];
    KCGNoteViewController *pVC = [[KCGNoteViewController alloc]initWithModel:note];
    [self.navigationController pushViewController:pVC animated:YES];
}

#pragma mark - Utils
-(void) addNote:(id) sender{

    [KCGNote noteWithName:@"Nueva nota" notebook:self.notebook context:self.notebook.managedObjectContext];
    
  
    
    
}

@end

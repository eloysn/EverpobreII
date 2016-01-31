//
//  KCGNotebooksViewController.m
//  Everpobre
//
//
//  Created by Eloy Sanz Navarro on 30/1/16.


#import "KCGNotebooksViewController.h"
#import "KCGNotebook.h"
#import "KCGNote.h"
#import "KCGNotesViewController.h"
#import "FRTNotebookCell.h"
#import "FRTNotesViewController.h"

@interface KCGNotebooksViewController ()

@end

@implementation KCGNotebooksViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Everpobre";
    
    // Creamos botón de barra de +
    UIBarButtonItem *btn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewNotebook:)];
    
    // Lo añadimos
    self.navigationItem.rightBarButtonItem = btn;
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    //registramos la nueva celda
    UINib *nib = [UINib nibWithNibName:@"FRTNotebookCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:[FRTNotebookCell cellId]];
    
}

-(void) addNewNotebook:(id) sender{
    
    [KCGNotebook notebookWithName:@"Nueva Libreta"
                          context:self.fetchedResultsController.managedObjectContext];
}

#pragma mark - Data Source
-(void) tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        KCGNotebook *del = [self.fetchedResultsController objectAtIndexPath:indexPath];
        [self.fetchedResultsController.managedObjectContext deleteObject:del];
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    // Averiguar qué libreta es
    KCGNotebook *nb = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    // Crear la celda
    FRTNotebookCell *cell = [tableView dequeueReusableCellWithIdentifier:[FRTNotebookCell cellId]];
    
    
    // Sincronizar libreta -> celda
    cell.nameView.text = nb.name;
    cell.numberNotesView.text = [NSString stringWithFormat:@"%lu", (unsigned long)nb.notes.count];
    
    
    // Devolvemos la celda
    return cell;
}

#pragma mark - TableView delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [FRTNotebookCell cellHeight];
}






#pragma mark - Navigation
-(void) tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // Obtener la libreta
    KCGNotebook *nb = [self.fetchedResultsController
                       objectAtIndexPath:indexPath];
    
    // Crear el fetch request
    NSFetchRequest *r = [[NSFetchRequest alloc] initWithEntityName:[KCGNote entityName]];
    
    // Configurarlo con un predicado
    r.fetchBatchSize = 25;
    r.sortDescriptors = @[[NSSortDescriptor
                           sortDescriptorWithKey:KCGNoteAttributes.name
                           ascending:YES
                           selector:@selector(caseInsensitiveCompare:)],
                          [NSSortDescriptor
                           sortDescriptorWithKey:KCGNoteAttributes.modificationDate
                           ascending:NO]];
    r.predicate = [NSPredicate predicateWithFormat:@"notebook == %@", nb];
    
    // Crear el fetchedResults
    NSFetchedResultsController *fc = [[NSFetchedResultsController alloc] initWithFetchRequest:r managedObjectContext:nb.managedObjectContext sectionNameKeyPath:nil cacheName:[[NSUUID new]UUIDString]];
    
    // layout
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.minimumLineSpacing = 10;
    layout.minimumInteritemSpacing = 10;
    layout.itemSize = CGSizeMake(140, 150);
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    
    
//    KCGNotesViewController *nVC = [[KCGNotesViewController alloc]
//                                   initWithFetchedResultsController:fc
//                                   style:UITableViewStylePlain
//                                   notebook:nb];
    
    // Crear el controlador de la collectionView
    FRTNotesViewController *n = [FRTNotesViewController coreDataCollectionViewControllerWithFetchedResultsController:fc layout:layout];
    n.notebook = [self.fetchedResultsController
                  objectAtIndexPath:indexPath];
    
    
    
    
    // Pushearlo
    [self.navigationController pushViewController:n
                                         animated:YES];
}


@end













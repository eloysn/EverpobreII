//
//  KCGNotesViewController.h
//  Everpobre
//
//
//  Created by Eloy Sanz Navarro on 30/1/16.


@import UIKit;
@import CoreData;

#import "AGTCoreDataTableViewController.h"
@class KCGNotebook;


@interface KCGNotesViewController : AGTCoreDataTableViewController

-(id) initWithFetchedResultsController:(NSFetchedResultsController *)aFetchedResultsController style:(UITableViewStyle)aStyle notebook:(KCGNotebook*) notebook;



@end

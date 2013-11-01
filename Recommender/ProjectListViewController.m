//
//  PlanListViewController.m
//  Recommender
//
//  Created by Benson Yang on 9/5/13.
//  Copyright (c) 2013 Benson. All rights reserved.
//

#import "ProjectListViewController.h"
#import "TravelProject.h"
#import "User+DianPing.h"
#import "RecommenderDatabase.h"
#import "InsertCell.h"
#import "PlanListViewController.h"

@interface ProjectListViewController ()
@property (nonatomic) BOOL beganUpdates;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@property (nonatomic, strong) UIBarButtonItem *reservedRightBarButtonItem;
@property (nonatomic, strong) NSIndexPath *fieldIndexPath;
@property (nonatomic, strong) UITextField *editingField;

- (IBAction)insertNewTravelProject:(id)sender;
@end

@implementation ProjectListViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.isForAddingPoi = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.navigationItem.rightBarButtonItem.enabled = NO;
    [RecommenderDatabase openDatabaseOnCompletion:^(UIManagedDocument *document) {
        self.managedObjectContext = document.managedObjectContext;
        self.navigationItem.rightBarButtonItem.enabled = YES;
        
        if (!self.isForAddingPoi) {
            NSArray *barButtonItems = [NSArray arrayWithObjects:self.editButtonItem, self.navigationItem.rightBarButtonItem, nil];
            self.navigationItem.rightBarButtonItems = barButtonItems;
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Properties getters & setters
- (void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    _managedObjectContext = managedObjectContext;
    if (managedObjectContext) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"TravelProject"];
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"createDate" ascending:NO]];
        request.predicate = [NSPredicate predicateWithFormat:@"traveller = %@", [User userWithUserName:kHardCodingUserName andPassword:kHardCodingPassword inObjectContext:self.managedObjectContext]];
        self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:managedObjectContext sectionNameKeyPath:nil cacheName:nil];
        
    } else {
        self.fetchedResultsController = nil;
    }
}

- (void)setFetchedResultsController:(NSFetchedResultsController *)newfrc {
    NSFetchedResultsController *oldfrc = _fetchedResultsController;
    if (newfrc != oldfrc) {
        _fetchedResultsController = newfrc;
        newfrc.delegate = self;
        if ((!self.title || [self.title isEqualToString:oldfrc.fetchRequest.entity.name]) && (!self.navigationController || !self.navigationItem.title)) {
            self.title = newfrc.fetchRequest.entity.name;
        }
        if (newfrc) {
            NSError *error;
            [self.fetchedResultsController performFetch:&error];
            if (error) {
                // error handle
            }
            [self.tableView reloadData];
        } else {
            [self.tableView reloadData];
        }
    }
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    NSInteger row = indexPath.row;
    NSUInteger numberOfObjects = [[[self.fetchedResultsController sections] objectAtIndex:0] numberOfObjects];
    if (row + 1 > numberOfObjects) {
        cell = (InsertCell *)[tableView dequeueReusableCellWithIdentifier:@"InsertNewCell" forIndexPath:indexPath];
        self.fieldIndexPath = indexPath;
    }
    else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"TravelProjectCell" forIndexPath:indexPath];
        TravelProject *travelProject = [self.fetchedResultsController objectAtIndexPath:indexPath];
        cell.textLabel.text = travelProject.name;
        cell.detailTextLabel.text = [travelProject.createDate description];
    }
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[self.fetchedResultsController sections] objectAtIndex:section] numberOfObjects] + 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	return [[[self.fetchedResultsController sections] objectAtIndex:section] name];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
	return [self.fetchedResultsController sectionForSectionIndexTitle:title atIndex:index];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return [self.fetchedResultsController sectionIndexTitles];
}

#pragma mark - Editing table support methods
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isForAddingPoi) {
        return NO;
    }
    else {
        return [self.fetchedResultsController.fetchedObjects count] > indexPath.row;
    }
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        TravelProject *project = [self.fetchedResultsController objectAtIndexPath:indexPath];
        [self.managedObjectContext deleteObject:project];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
    self.beganUpdates = YES;
}

- (void)controller:(NSFetchedResultsController *)controller
  didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
		   atIndex:(NSUInteger)sectionIndex
	 forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type)
    {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
	   atIndexPath:(NSIndexPath *)indexPath
	 forChangeType:(NSFetchedResultsChangeType)type
	  newIndexPath:(NSIndexPath *)newIndexPath
{
    switch(type)
    {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeMove:
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    if (self.beganUpdates) [self.tableView endUpdates];
}

#pragma mark -
- (IBAction)insertNewTravelProject:(id)sender {
    // 只有1各section，取最后一个cell
    InsertCell *cell = (InsertCell *)[self.tableView cellForRowAtIndexPath:self.fieldIndexPath];
    self.editingField = cell.textField;
    [self.editingField becomeFirstResponder];
}

- (void)doneButtonPressed:(id)sender {
    [self.editingField resignFirstResponder];
    [self.editingField.delegate textFieldDidEndEditing:self.editingField];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"toPlanListView"]) {
        PlanListViewController *pVC = segue.destinationViewController;
        pVC.poi = self.poi;
        pVC.isForAddingPoi = self.isForAddingPoi;
        pVC.travelProject = [self.fetchedResultsController objectAtIndexPath:[self.tableView indexPathForCell:sender]];
        pVC.managedObjectContext = self.managedObjectContext; //set managedObjectContext will call viewDidLoad
    }
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (self.editingField != textField) {
        self.editingField = textField;
    }
    self.reservedRightBarButtonItem = self.navigationItem.rightBarButtonItem;
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonPressed:)];
    self.navigationItem.rightBarButtonItem = doneButton;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.navigationItem.rightBarButtonItem = self.reservedRightBarButtonItem;
    
    NSString *projectName = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (![projectName isEqualToString:@""]) {
        TravelProject *travelProj = [NSEntityDescription insertNewObjectForEntityForName:@"TravelProject" inManagedObjectContext:self.managedObjectContext];
        travelProj.name = projectName;
        travelProj.createDate = [NSDate date];
        
        // 每个计划都要和用户相关联
        User *user = [User userWithUserName:kHardCodingUserName andPassword:kHardCodingUserName inObjectContext:self.managedObjectContext];
        travelProj.traveller = user;
        
        NSError *error;
        [self.fetchedResultsController.managedObjectContext save:&error];
        if (error) {
            NSLog(@"%@", error);
        }
        textField.text = @"";
        
        [self.tableView reloadData];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end

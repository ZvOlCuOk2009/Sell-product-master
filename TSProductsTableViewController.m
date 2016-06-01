//
//  TSProductsTableViewController.m
//  Sell product
//
//  Created by Mac on 25.05.16.
//  Copyright © 2016 Tsvigun Alexandr. All rights reserved.
//

#import "TSProductsTableViewController.h"
#import "TSDetailsTableViewController.h"
#import "TSTableViewCell.h"
#import "TSDataManager.h"
#import "TSProduct+CoreDataProperties.h"
#import "TSImages+CoreDataProperties.h"
#import "TSDescriptionTableViewController.h"
#import <CoreData/CoreData.h>

@interface TSProductsTableViewController () <NSFetchedResultsControllerDelegate, UISearchBarDelegate>

@property (strong, nonatomic) TSProduct *product;
@property (strong, nonatomic) NSArray *arrayNames;
@property (strong, nonatomic) NSArray *searchResultsArray;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) UISearchBar *searchBar;

@end

@implementation TSProductsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView setContentInset:UIEdgeInsetsMake(4, 0, 0, 0)];
    
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - 35, 40)];
    searchBar.backgroundImage = [[UIImage alloc] init];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:searchBar];
    
    searchBar.showsCancelButton = YES;
    searchBar.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.tableView reloadData];
    /*
    UIButton *discover = [[UIButton alloc] initWithFrame:CGRectMake(0, 524, self.view.frame.size.width / 2, 44)];
    [discover setBackgroundImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
    UIButton *sell = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2, 524, self.view.frame.size.width / 2, 44)];
    [sell setBackgroundImage:[UIImage imageNamed:@"sell"] forState:UIControlStateNormal];
    [self.navigationController.view addSubview:discover];
    [self.navigationController.view addSubview:sell];
     */
    
    self.arrayNames = [NSArray array];
    
    UIButton *discoverButton = [[UIButton alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 44, self.view.frame.size.width / 2, 44)];
    [discoverButton setBackgroundImage:[UIImage imageNamed:@"discover"] forState:UIControlStateNormal];
    [discoverButton addTarget:self action:@selector(actionDiscover:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *sellButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2, self.view.frame.size.height - 44, self.view.frame.size.width / 2, 44)];
    [sellButton setBackgroundImage:[UIImage imageNamed:@"sell"] forState:UIControlStateNormal];
    [sellButton addTarget:self action:@selector(actionSell:) forControlEvents:UIControlEventTouchUpInside];
    
    discoverButton.tag = 1;
    sellButton.tag = 2;

    [self.navigationController.view addSubview:discoverButton];
    [self.navigationController.view addSubview:sellButton];
}

#pragma mark - NSManagedObjectContext

-(NSManagedObjectContext *) managedObjectContext {
    
    if (!_managedObjectContext) {
        _managedObjectContext = [[TSDataManager sharedManager] managedObjectContext];
    }
    return _managedObjectContext;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id<NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo numberOfObjects];
}

- (TSTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TSTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

#pragma mark - Configure Cell

- (void)configureCell:(TSTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    TSProduct *product = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.nameLabel.text = product.name;
    cell.priceLabel.text = product.price;
    NSArray *images = [NSKeyedUnarchiver unarchiveObjectWithData:product.images];
    cell.imageProduct.image = [images objectAtIndex:0];
}

#pragma mark - UITableviewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TSDescriptionTableViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"TSDescriptionTableViewController"];
    self.product = [self.fetchedResultsController objectAtIndexPath:indexPath];
    controller.name = self.product.name;
    controller.price = self.product.price;
    controller.specification = self.product.specification;
    controller.images = [NSKeyedUnarchiver unarchiveObjectWithData:self.product.images];
    [controller receiveCell:self.product];
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - Acrions

- (void)actionDiscover:(UIBarButtonItem *)item
{
    
}

- (void)actionSell:(UIBarButtonItem *)item
{
    TSDetailsTableViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"TSDetailsTableViewController"];
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - UISearchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
    [searchBar becomeFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    /*
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"TSProduct"];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"TSProduct" inManagedObjectContext:self.managedObjectContext];
    
    fetchRequest.resultType = NSDictionaryResultType;
    fetchRequest.propertiesToFetch = [NSArray arrayWithObject:[[entity propertiesByName] objectForKey:@"name"]];
    fetchRequest.returnsDistinctResults = YES;
    
    self.arrayNames = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    
    
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"name contains[c] %@", searchText];
    
    self.searchResultsArray = [self.arrayNames filteredArrayUsingPredicate:resultPredicate];
    */
    
    [self reloadTableView];
    
    //NSLog (@"names: %@", self.searchResultsArray);
}


//////////////////////////////


- (void)reloadTableView
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"TSProduct"
                                              inManagedObjectContext:[self managedObjectContext]];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sortNameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects: sortNameDescriptor, nil];
    fetchRequest.sortDescriptors = sortDescriptors;
    
    //NSPredicate *idPredicate = [NSPredicate predicateWithFormat:@"agency_server_id CONTAINS[cd] %@", agency.server_id];
    NSString *searchString = self.searchBar.text;
    if (searchString.length > 0)
    {
        NSPredicate *namePredicate = [NSPredicate predicateWithFormat:@"name contains[c] %@", searchString];
        NSPredicate *orPredicate = [NSCompoundPredicate orPredicateWithSubpredicates:[NSArray arrayWithObjects:namePredicate, nil]];
//        NSPredicate *andPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:[NSArray arrayWithObjects:idPredicate, nil]];
        NSPredicate *finalPred = [NSCompoundPredicate andPredicateWithSubpredicates:[NSArray arrayWithObjects:orPredicate, nil]];
        [fetchRequest setPredicate:finalPred];
    }
    else
    {
        //[fetchRequest setPredicate:idPredicate];
    }
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc]initWithFetchRequest:fetchRequest
                                                                       managedObjectContext:[self managedObjectContext]sectionNameKeyPath:nil
                                                                                  cacheName:nil];
    self.fetchedResultsController.delegate = self;
    
    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error])
    {
        NSLog(@"Unresolved error %@, %@", [error localizedDescription], [error localizedFailureReason]);
    };
    
    [self.tableView reloadData];
}


//////////////////////////////


#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"TSProduct" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSSortDescriptor *sortDescriptorImage = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:NO];
    [fetchRequest setSortDescriptors:@[sortDescriptorImage]];
    
    NSFetchedResultsController *aFetchedResultsController =
    [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                        managedObjectContext:self.managedObjectContext
                                          sectionNameKeyPath:nil
                                                   cacheName:nil];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error]) {
        NSLog(@"Error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _fetchedResultsController;
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller
  didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex
     forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
            
        default:
            return;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

@end

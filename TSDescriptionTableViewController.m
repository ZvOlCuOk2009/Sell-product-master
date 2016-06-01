//
//  TSDescriptionTableViewController.m
//  Sell product
//
//  Created by Mac on 25.05.16.
//  Copyright © 2016 Tsvigun Alexandr. All rights reserved.
//

#import "TSDescriptionTableViewController.h"
#import "TSProduct.h"
#import "TSDataManager.h"
#import "TSDetailsTableViewController.h"

@interface TSDescriptionTableViewController () <UIScrollViewDelegate, UITextViewDelegate>

@property (strong, nonatomic) TSProduct *currentProduct;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@end

@implementation TSDescriptionTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.nameTextView.text = self.name;
    self.priceTextView.text = self.price;
    self.descriptionTextView.text = self.specification;
    
    self.pageControl.numberOfPages = [self.images count];
    [self.tableView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
        
    self.nameTextView.editable = NO;
    self.priceTextView.editable = NO;
    self.descriptionTextView.editable = NO;
    
    [self.nameTextView setDelegate:self];
    [self.priceTextView setDelegate:self];
    [self.descriptionTextView setDelegate:self];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [self setupScroll];
}

#pragma mark - NSManagedObjectContext

-(NSManagedObjectContext *) managedObjectContext {
    
    if (!_managedObjectContext) {
        _managedObjectContext = [[TSDataManager sharedManager] managedObjectContext];
    }
    return _managedObjectContext;
}

#pragma mark - Transfer pressed cell

- (void)receiveCell:(TSProduct *)product
{
    self.currentProduct = product;
}

#pragma mark - Actions

- (IBAction)trashButton:(id)sender
{
    [self.managedObjectContext deleteObject:self.currentProduct];
    [self.managedObjectContext save:nil];
    [self.navigationController popToRootViewControllerAnimated:YES];
    [self.tableView reloadData];
}

- (IBAction)editButton:(id)sender
{
    /*
    self.nameTextView.editable = YES;
    self.priceTextView.editable = YES;
    self.descriptionTextView.editable = YES;
    
    self.currentProduct.name = self.nameTextView.text;
    NSMutableString *formatingString = [NSMutableString stringWithString:self.priceTextView.text];
    [formatingString insertString:@"$" atIndex:0];
    [formatingString insertString:@"," atIndex:3];
    
    self.currentProduct.price = formatingString;
    self.currentProduct.specification = self.descriptionTextView.text;
    [self.managedObjectContext save:nil];
     */
    
    TSDetailsTableViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"TSDetailsTableViewController"];
    controller.name = self.name;
    controller.price = self.price;
    controller.specification = self.specification;
    controller.images = self.images;
    //[self.managedObjectContext deleteObject:self.currentProduct];
    //[self.managedObjectContext save:nil];
    [controller editingCurrentProduct:self.currentProduct];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)actionDiscover:(UIBarButtonItem *)item
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - UIScrollView

- (void) setupScroll
{
    self.scrollView.contentSize = CGSizeMake(self.scrollView.bounds.size.width * [self.images count], self.scrollView.bounds.size.height);
    
    for (int i = 0; i < [self.images count]; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * self.scrollView.bounds.size.width,
                                                                               0 * self.scrollView.bounds.size.height,
                                                                               self.scrollView.bounds.size.width,
                                                                               self.scrollView.bounds.size.height)];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        imageView.image = [self.images objectAtIndex:i];
        [self.scrollView addSubview:imageView];
    }
}

#pragma mark -  UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = scrollView.bounds.size.width;
    NSInteger pageNumber = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageControl.currentPage = pageNumber;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

@end

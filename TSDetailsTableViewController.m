//
//  TSDetailsTableViewController.m
//  Sell product
//
//  Created by Mac on 25.05.16.
//  Copyright © 2016 Tsvigun Alexandr. All rights reserved.
//

#import "TSDetailsTableViewController.h"
#import "TSDataManager.h"
#import <CoreData/CoreData.h>

@interface TSDetailsTableViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate>

@property (strong, nonatomic) UIImage *imageOne;
@property (strong, nonatomic) UIImage *imageTwo;
@property (strong, nonatomic) UIImage *imageThree;

@property (strong, nonatomic) NSMutableArray *arrayImages;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *collectionButton;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) UIImagePickerController *imagePicker;

@property (strong, nonatomic) TSProduct *currentProduct;
@property (assign, nonatomic) NSInteger currentTag;

@end

@implementation TSDetailsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Post your item";
    [self.navigationItem.backBarButtonItem setTitle:@""];
    self.arrayImages = [NSMutableArray array];
    
    [[self.navigationController.view viewWithTag:1] setHidden:YES];
    [[self.navigationController.view viewWithTag:2] setHidden:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    self.nameTextField.text = self.name;
    self.priceTextField.text = self.price;
    self.descriptionTextField.text = self.specification;
}

- (void)editingCurrentProduct:(TSProduct *)product
{
    self.currentProduct = product;
}

#pragma mark - NSManagedObjectContext

-(NSManagedObjectContext *) managedObjectContext {
    
    if (!_managedObjectContext) {
        _managedObjectContext = [[TSDataManager sharedManager] managedObjectContext];
    }
    return _managedObjectContext;
}

#pragma mark - Actions

- (IBAction)photoAction:(UIButton *)sender {
    
    /*
     
     if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypePhotoLibrary])
     {
     UIImagePickerController *picker = [[UIImagePickerController alloc] init];
     picker.delegate = self;
     picker.sourceType = UIImagePickerControllerSourceTypeCamera;
     //picker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
     picker.showsCameraControls = NO;
     //        [self presentViewController:picker animated:YES
     //                         completion:^ {
     //                             [picker takePicture];
     //                         }];
     }
     
     
     
     if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
     UIImagePickerController *picker = [[UIImagePickerController alloc] init];
     picker.delegate = self;
     [picker setSourceType:UIImagePickerControllerSourceTypeCamera];
     picker.allowsEditing = false;
     [self presentViewController:picker animated:true completion:nil];
     }
     
     
     */
        
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        [picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        picker.allowsEditing = true;
        [self presentViewController:picker animated:YES completion:nil];
    }
    self.currentTag = sender.tag;
}

- (IBAction)postItAction:(id)sender
{
    if (self.currentProduct) {
        [self saveNewProduct];
        [self.managedObjectContext deleteObject:self.currentProduct];
        [self.managedObjectContext save:nil];
    } else {
        [self saveNewProduct];
        [self.managedObjectContext save:nil];
    }
}

- (void)saveNewProduct
{
    TSProduct *product = [NSEntityDescription insertNewObjectForEntityForName:@"TSProduct"
                                                       inManagedObjectContext:self.managedObjectContext];
    product.name = self.nameTextField.text;
    NSMutableString *formatingString = [NSMutableString stringWithString:self.priceTextField.text];
    [formatingString insertString:@"$" atIndex:0];
    [formatingString insertString:@"," atIndex:3];
    product.price = formatingString;
    product.specification = self.descriptionTextField.text;
    product.images = [NSKeyedArchiver archivedDataWithRootObject:self.arrayImages];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - UIImagePickerController

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    if (self.currentTag == 0) {
        self.imageOne = image;
        [self.arrayImages addObject:self.imageOne];
    } else if (self.currentTag == 1) {
        self.imageTwo = image;
        [self.arrayImages addObject:self.imageTwo];
    } else if (self.currentTag == 2) {
        self.imageThree = image;
        [self.arrayImages addObject:self.imageThree];
    }
    
    [self setButtonImageBackgruond:self.currentTag];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setButtonImageBackgruond:(NSInteger)tagButton
{
    UIButton *currentButton = [self.collectionButton objectAtIndex:tagButton];
    
    if (currentButton.tag == 0) {
        [currentButton setImage:self.imageOne forState:UIControlStateNormal];
    } else if (currentButton.tag == 1) {
        [currentButton setImage:self.imageTwo forState:UIControlStateNormal];
    } else if (currentButton.tag == 2) {
        [currentButton setImage:self.imageThree forState:UIControlStateNormal];
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.nameTextField && textField == self.descriptionTextField) {
        [self.descriptionTextField becomeFirstResponder];
    } else if (textField == self.priceTextField) {
        [textField resignFirstResponder];
    }
    return YES;
}

@end

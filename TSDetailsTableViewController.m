//
//  TSDetailsTableViewController.m
//  Sell product
//
//  Created by Mac on 25.05.16.
//  Copyright © 2016 Tsvigun Alexandr. All rights reserved.
//

#import "TSDetailsTableViewController.h"
#import "TSProduct.h"
#import "TSImages.h"
#import "TSDataManager.h"
#import <CoreData/CoreData.h>

@interface TSDetailsTableViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *descriptionTextField;
@property (weak, nonatomic) IBOutlet UITextField *priceTextField;

@property (strong, nonatomic) UIImage *imageOne;
@property (strong, nonatomic) UIImage *imageTwo;
@property (strong, nonatomic) UIImage *imageThree;

@property (strong, nonatomic) NSMutableArray *arrayImages;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *collectionButton;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) UIImagePickerController *imagePicker;

@property (strong, nonatomic) TSProduct *product;
@property (assign, nonatomic) NSInteger currentTag;

@end

@implementation TSDetailsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Post your item";
    [self.navigationItem.backBarButtonItem setTitle:@""];
    self.arrayImages = [NSMutableArray array];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.hidesBottomBarWhenPushed = YES;
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
    TSProduct *product = [NSEntityDescription insertNewObjectForEntityForName:@"TSProduct"
                                                       inManagedObjectContext:self.managedObjectContext];
    product.name = self.nameTextField.text;
    product.price = self.priceTextField.text;
    product.specification = self.descriptionTextField.text;
    product.images = [NSKeyedArchiver archivedDataWithRootObject:self.arrayImages];
    [self.managedObjectContext save:nil];
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

@end

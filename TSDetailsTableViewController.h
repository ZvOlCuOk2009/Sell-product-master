//
//  TSDetailsTableViewController.h
//  Sell product
//
//  Created by Mac on 25.05.16.
//  Copyright © 2016 Tsvigun Alexandr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TSProduct.h"


@interface TSDetailsTableViewController : UITableViewController

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *price;
@property (strong, nonatomic) NSString *specification;
@property (strong, nonatomic) NSArray *images;

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *priceTextField;
@property (weak, nonatomic) IBOutlet UITextField *descriptionTextField;

- (void)currentProduct:(TSProduct *)product;

@end

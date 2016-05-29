//
//  TSDescriptionTableViewController.h
//  Sell product
//
//  Created by Mac on 25.05.16.
//  Copyright © 2016 Tsvigun Alexandr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TSProduct.h"

@interface TSDescriptionTableViewController : UITableViewController

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *price;
@property (strong, nonatomic) NSString *specification;
@property (strong, nonatomic) NSArray *images;
@property (weak, nonatomic) IBOutlet UITextView *nameTextView;
@property (weak, nonatomic) IBOutlet UITextView *priceTextView;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;

- (void)receiveCell:(TSProduct *)product;

@end

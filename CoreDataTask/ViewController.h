//
//  ViewController.h
//  CoreDataTask
//
//  Created by Bala on 28/01/16.
//  Copyright © 2016 Kaizen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *nameText;
@property (weak, nonatomic) IBOutlet UITextField *ageInteger;
@property (weak, nonatomic) IBOutlet UITextField *qualificationText;
@property (weak, nonatomic) IBOutlet UITextField *emailText;

- (IBAction)saveButton:(id)sender;
- (IBAction)fetchButton:(id)sender;
- (IBAction)SearchButton:(id)sender;

@property (weak, nonatomic) IBOutlet UIImageView *ImageView;


@end


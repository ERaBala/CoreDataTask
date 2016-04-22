//
//  ViewController.m
//  CoreDataTask
//
//  Created by Bala on 28/01/16.
//  Copyright © 2016 Kaizen. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    AppDelegate *appDelegate ;
    NSManagedObjectContext *context;
    NSString * identifier;
    NSManagedObject *result;
    UIAlertAction* cancel;

}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    

}


- (IBAction)saveButton:(id)sender {
    [self saveCoreData];
}

-(void)saveCoreData
{
    appDelegate = [[UIApplication sharedApplication] delegate];
    if ([_emailText.text  isEqual: @""] && [_nameText.text isEqual: @""] && [_ageInteger.text  isEqual: @""] && [_qualificationText.text isEqual: @""]) {
        NSLog(@"enter values");
        }
    else{
        context =[appDelegate managedObjectContext];
        NSManagedObject *object = [NSEntityDescription insertNewObjectForEntityForName:@"Table" inManagedObjectContext:context];
        
        NSNumber *integerValue = [NSNumber numberWithInt:[_ageInteger.text intValue]]; //convert integer values to string
        NSLog(@"number %@",integerValue);
        
        [self nextIdentifies];
        
        [object setValue:_emailText.text forKey:@"emailid"];
        [object setValue:_nameText.text forKey:@"name"];
        [object setValue:_qualificationText.text forKey:@"qualification"];
        [object setValue:integerValue forKey:@"age"];
        [object setValue:identifier forKey:@"id"];
        
        NSError *error;
        if (![context save:&error]) {
            NSLog(@"Failed to save - error: %@", [error localizedDescription]);
        }
        NSString * aleartMessage = [NSString stringWithFormat:@"Your id :%@ \n Name:%@ \n Age:%@ \n Email ID: %@ \n Qualification:%@ ",identifier,_nameText.text,integerValue,_emailText.text,_qualificationText.text];
        [self aleartController:@"Info" :aleartMessage];
        [self Clearstring];
    }
}



- (void ) Clearstring
{
    _nameText.text = @"";
    _ageInteger.text=@"";
    _qualificationText.text =@"";
    _emailText.text=@"";

}

-(NSInteger)nextIdentifies;
{
    static NSString* lastID = @"lastID";
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSInteger identifierGendrate = [defaults integerForKey:lastID] + 1;
    [defaults setInteger:identifierGendrate forKey:lastID];
    [defaults synchronize];
//    NSLog(@"%ld",(long)identifierGendrate);
    identifier = [NSString stringWithFormat:@"CDT0%ld", (long)identifierGendrate];
//    NSLog(@"%@",identifier);
    
    return identifierGendrate;
}


- (IBAction)fetchButton:(id)sender {
    
    UIImage *image = [UIImage imageNamed:@"find.png"];
    
    NSData *imageData = UIImagePNGRepresentation(image);
    NSUInteger len = [imageData length];
    Byte *byteData= (Byte*)malloc(len);
    /*
//    [imageData  getBytes:byteData length:len];
//    NSLog(@"***** \n %@",imageData);
//   UIImage *ShowImage = [UIImage imageWithData: imageData];
//    self.ImageView.image = [[UIImageView alloc]initWithImage:ShowImage];
//    UIImage *img = [UIImage imageWithData:data];
//    UIImageView *imgView = [[UIImageView alloc]initWithImage:img];
    
     
     http://stackoverflow.com/questions/12257619/how-can-i-convert-images-to-bytes-and-bytes-to-image
     
    */
    
    
    NSData *data = [NSData dataWithBytes:byteData length:len];

    
    UIImage *images = [[UIImage alloc]initWithData:data];
    [self.ImageView setImage:images];
    
//    self.ImageView.image = imgView;
}

-(void)fetchCoreData: (NSString *)identifervalue
{
    
    appDelegate = [[UIApplication sharedApplication] delegate];
    
    context =[appDelegate managedObjectContext];
    
    NSEntityDescription *entity =[NSEntityDescription entityForName:@"Table" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    
    NSPredicate * predication =[NSPredicate predicateWithFormat:@"(id = %@)",identifervalue];
    [request setPredicate:predication];
//    result = nil;

    
    NSError *error;
    NSArray *objects = [context executeFetchRequest:request
                                              error:&error];
    
    if ([objects count] == 0) {
          [self aleartController:@"ERROR" :@"NO MATCHES FOUND"];
    } else {
        result = objects[0];
        NSLog(@"%@ matches ",result);
        
        NSString * aleartMessage = [NSString stringWithFormat:@"Your id :%@ \n Name:%@ \n Age:%@ \n Email ID: %@ \n Qualification:%@ ",identifervalue,[result valueForKey:@"name"],[result valueForKey:@"age"],[result valueForKey:@"emailid"],[result valueForKey:@"qualification"]];
        [self aleartController:@"Details" :aleartMessage];
    }
}

- (void)clearCoreData {
    
    appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context2= [appDelegate managedObjectContext];

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Table" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [context2 executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects == nil) {
        NSLog(@"Could not delete Entity Objects");
    }
    for (entity in fetchedObjects) {
        [context2 deleteObject:result];
    }
    
    [self saveContext];
    
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = context;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            
            NSLog(@"Saving didn't work so well.. Error: %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

- (void)updateCoreData {
    
    NSError *error = nil;

    appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *aBook= [appDelegate managedObjectContext];
    //This is your NSManagedObject subclass
     aBook = nil;
    
    //Set up to get the thing you want to update
    NSFetchRequest * request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"Table" inManagedObjectContext:context]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"id=%@",@"CDT01"]];
    
    //Ask for it
    aBook = [[context executeFetchRequest:request error:&error] lastObject];
    
    if (error) {
        //Handle any errors01
        NSLog(@"error***********");
    }else
    {
        self.nameText.text=[aBook valueForKey:@"name"];
        NSString * agestring = [NSString stringWithFormat:@"%@",[aBook valueForKey:@"age"]];
        self.ageInteger.text= agestring;
        self.emailText.text=[aBook valueForKey:@"emailid"];
        self.qualificationText.text=[aBook valueForKey:@"qualification"];
    }
    
    if (!aBook) {
        //Nothing there to update
        
    }
    
    //Update the object
//    aBook.Title = @"BarBar";
    
    //Save it
    error = nil;
    if (![context save:&error]) {
        //Handle any error with the saving of the context
    }
}

-(void)aleartController: (NSString *)TitleValue: (NSString *)message
{

     UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:TitleValue
                                  message:message
                                  preferredStyle:UIAlertControllerStyleAlert];
    if ([TitleValue isEqualToString:@"Search"])
    {
        
            [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
                textField.placeholder = @"Enter your ID";
                textField.borderStyle = UITextBorderStyleRoundedRect;
                textField.textColor = [UIColor blackColor];
                textField.backgroundColor = [UIColor whiteColor];
                textField.keyboardType = UIKeyboardTypeDefault;
                textField.clearButtonMode = UITextFieldViewModeWhileEditing;
                
                [self.view addSubview:textField];
            }];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action)
                                                {
                                                       NSString *text = ((UITextField *)[alert.textFields objectAtIndex:0]).text;
                                                       NSLog(@"what is alert text? %@",text);
                                                    if ([TitleValue isEqualToString:@"Search"])
                                                    {
                                                           [self fetchCoreData:text];
                                                    }}];
        cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * action) {
                                                           [alert dismissViewControllerAnimated:YES completion:nil];
                                                       }];
        
        [alert addAction:ok];
        [alert addAction:cancel];
    }else if ([TitleValue isEqualToString:@"ERROR"]||[TitleValue isEqualToString:@"Info"])
    {
        cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * action) {
                                                           [alert dismissViewControllerAnimated:YES completion:nil];
                                                       }];
        [alert addAction:cancel];
    
    }
    else
    {
        
        UIAlertAction* Delete = [UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * action) {
                                                           //Do Some action here
                                                           [self clearCoreData];
                                                       }];
        
        UIAlertAction* Update = [UIAlertAction actionWithTitle:@"Update" style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * action) {
                                                           [self updateCoreData];
                                                       }];

        cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * action) {
                                                           [alert dismissViewControllerAnimated:YES completion:nil];
                                                       }];
        [alert addAction:Delete];
        [alert addAction:Update];
        [alert addAction:cancel];
    }
    
    [self presentViewController:alert animated:YES completion:nil];
}




- (IBAction)SearchButton:(id)sender {
[self aleartController:@"Search" :@"Enter Your ID"];
}
@end

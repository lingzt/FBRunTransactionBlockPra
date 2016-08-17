//
//  ViewController.m
//  FBRunTransactionBlockPra
//
//  Created by ling toby on 8/14/16.
//  Copyright © 2016 Detroit Labs. All rights reserved.
//

#import "ViewController.h"
@import FirebaseAuth;
@import Firebase;
@import FirebaseDatabase;

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;

@end

@implementation ViewController
FIRDatabaseReference *ref;


- (void)viewDidLoad {
    [super viewDidLoad];
    ref = [[FIRDatabase database]reference];
}
- (IBAction)login:(id)sender {
    [self loginUserToFirebase];
}


-(void)loginUserToFirebase{
    NSString *newPwd = @"111111";
    [[FIRAuth auth] signInWithEmail:_emailTextField.text
                           password:newPwd
                         completion:^(FIRUser *user, NSError *error) {
                             
                             if (error) {
                                 NSString *message=@"Invalid email or password";
                                 NSString *alertTitle=@"Invalid!";
                                 NSString *OKText=@"OK";
                                 
                                 UIAlertController *alertView = [UIAlertController alertControllerWithTitle:alertTitle message:message preferredStyle:UIAlertControllerStyleAlert];
                                 UIAlertAction *alertAction = [UIAlertAction actionWithTitle:OKText style:UIAlertActionStyleCancel handler:nil];
                                 [alertView addAction:alertAction];
                                 [self presentViewController:alertView animated:YES completion:nil];
                             }else{
                                 NSLog(@"Login success!!!!!!!!!!!!");
                                 
                             }
                         }];
}


- (IBAction)addCount:(id)sender {
    [self addCount];
}

- (IBAction)likePost:(id)sender {
    [self likeThePost];
}


-(void)addCount{
    FIRDatabaseReference *counterRef;
    counterRef = [ref child:@"counter"];
    [counterRef runTransactionBlock:^FIRTransactionResult * _Nonnull(FIRMutableData * _Nonnull currentData) {
        id count = currentData.value;
        if (count == [NSNull null]) {
            count = 0;
        }else{
            currentData.value = @([count integerValue] +1);
        }
        
        return [FIRTransactionResult successWithValue:currentData];
        
    }];
}

-(void)likeThePost{
    [ref runTransactionBlock:^FIRTransactionResult * _Nonnull(FIRMutableData * _Nonnull currentData) {
        NSMutableDictionary *post = currentData.value;
        if (!post || [post isEqual:[NSNull null]]) {
            return [FIRTransactionResult successWithValue:currentData];
        }
        
        NSMutableDictionary *stars = [post objectForKey:@"stars"];
        if (!stars) {
            stars = [[NSMutableDictionary alloc] initWithCapacity:1];
        }
        NSString *uid = [FIRAuth auth].currentUser.uid;
        int starCount = [post[@"starCount"] intValue];
        if ([stars objectForKey:uid]) {
            // Unstar the post and remove self from stars
            starCount--;
            [stars removeObjectForKey:uid];
        } else {
            // Star the post and add self to stars
            
            for (int i=0; i<100000; i++) {
                starCount++;
                stars[uid] = @YES;
                NSLog(@"the current starCount is %d",starCount);
            }
        }
        post[@"stars"] = stars;
        post[@"starCount"] = [NSNumber numberWithInt:starCount];
        
        // Set value and report transaction success
        [currentData setValue:post];
        return [FIRTransactionResult successWithValue:currentData];
    } andCompletionBlock:^(NSError * _Nullable error,
                           BOOL committed,
                           FIRDataSnapshot * _Nullable snapshot) {
        // Transaction completed
        if (error) {
            NSLog(@"%@", error.localizedDescription);
        }
    }];

}



@end

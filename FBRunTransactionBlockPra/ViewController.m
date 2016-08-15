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

@end

@implementation ViewController
FIRDatabaseReference *ref;


- (void)viewDidLoad {
    [super viewDidLoad];
    [self loginUserToFirebase];
    ref = [[FIRDatabase database]reference];
}

-(void)loginUserToFirebase{
    NSString *newPwd = @"111111";
    [[FIRAuth auth] signInWithEmail:@"ling@gmail.com"
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
- (IBAction)signOutBtnPressed:(id)sender {
    NSError *error;
    [[FIRAuth auth] signOut:&error];
    if (!error) {
        
    }
}

- (IBAction)likePost:(id)sender {
    [self likeThePost];
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
            starCount++;
            stars[uid] = @YES;
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

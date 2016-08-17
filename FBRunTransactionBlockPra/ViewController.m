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
    [self loginUserToFirebase];
    [super viewDidLoad];
    ref = [[FIRDatabase database]reference];
}



-(void)loginUserToFirebase{
    [[FIRAuth auth] signInWithEmail:@"ling@gmail.com"
                           password:@"111111"
                         completion:^(FIRUser *user, NSError *error) {
                             if (error) {
                             }else{
                                 NSLog(@"Login success!!!!!!!!!!!!");
                             }
                         }];
}


- (IBAction)addCount:(id)sender {
    [self addCount];
}



-(void)addCount{
    FIRDatabaseReference *counterRef;
    counterRef = [ref child:@"counter"];
    [counterRef runTransactionBlock:^FIRTransactionResult * _Nonnull(FIRMutableData * _Nonnull currentData) {
        id count = currentData.value;
        if (count == [NSNull null]) {
            count = 0;
        }else{
            for (int i = 0; i < 50001; i++) {
                currentData.value = @([count integerValue] +i);
                NSLog(@"%@",currentData.value);
            }
        }
        return [FIRTransactionResult successWithValue:currentData];
    }];
}





@end

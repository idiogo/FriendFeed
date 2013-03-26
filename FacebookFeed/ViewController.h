//
//  ViewController.h
//  FacebookFeed
//
//  Created by Diogo Carneiro on 25/03/13.
//  Copyright (c) 2013 Diogo Carneiro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface ViewController : UIViewController<FBLoginViewDelegate>

@property (strong, nonatomic) IBOutlet FBLoginView *loginView;

@property BOOL propositalCall;

- (IBAction)dismiss:(id)sender;

@end

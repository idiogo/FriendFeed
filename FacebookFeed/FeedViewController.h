//
//  FeedViewController.h
//  FacebookFeed
//
//  Created by Diogo Carneiro on 25/03/13.
//  Copyright (c) 2013 Diogo Carneiro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import <SDWebImage/UIImageView+WebCache.h>

@interface FeedViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>{
	NSArray *feed;
}


@property (strong, nonatomic) IBOutlet FBProfilePictureView *userProfileImage;
@property (strong, nonatomic) IBOutlet UILabel *userNameLabel;
@property (strong, nonatomic) IBOutlet UITableView *feedTable;

@end

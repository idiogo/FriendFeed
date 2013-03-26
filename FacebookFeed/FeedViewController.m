//
//  FeedViewController.m
//  FacebookFeed
//
//  Created by Diogo Carneiro on 25/03/13.
//  Copyright (c) 2013 Diogo Carneiro. All rights reserved.
//

#import "FeedViewController.h"
#import "ViewController.h"

@implementation FeedViewController

- (void)viewDidLoad{
	[self.feedTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}

- (void)populateUserDetails
{
    if (FBSession.activeSession.isOpen) {
        [[FBRequest requestForMe] startWithCompletionHandler:
         ^(FBRequestConnection *connection,
           NSDictionary<FBGraphUser> *user,
           NSError *error) {
             if (!error) {
                 self.userNameLabel.text = user.name;
                 self.userProfileImage.profileID = user.id;
             }
         }];
		
		
		// Make the API request that uses FQL
		[FBRequestConnection startWithGraphPath:@"me/home"
									 parameters:nil
									 HTTPMethod:@"GET"
							  completionHandler:^(FBRequestConnection *connection,
												  id result,
												  NSError *error)
		 {
			 if (error)
				NSLog(@"Error: %@", [error localizedDescription]);
			 else{
				feed = [result valueForKey:@"data"];
				NSLog(@"Result: %@", feed);
				NSLog(@"Result: %d", [feed count]);
				 [[self feedTable] reloadData];
			 }
		 }];
    }
}

- (void) eraseUserDetails{
	self.userNameLabel.text = @"Bem-vindo!";
	self.userProfileImage.profileID = nil;
}

-(void)viewDidAppear:(BOOL)animated{
    if (FBSession.activeSession.isOpen) {
        [self populateUserDetails];
    }else{
		[self eraseUserDetails];
		[self performSegueWithIdentifier:@"login" sender:nil];
	}
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
	if ([(UIButton *)sender tag] == 1) {
		ViewController *loginView = (ViewController *)[segue destinationViewController];
		loginView.propositalCall = YES;
	}
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
	return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
	NSDictionary *post = [self postForRow:section];
	
	UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
	UIImageView *avatarView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
	UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, 270, 40)];
	
	nameLabel.backgroundColor = [UIColor clearColor];
	view.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.3];
	
	//avatar
	NSURL *imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture", [[post valueForKey:@"from"] valueForKey:@"id"]]];
	NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
	UIImage *avatar = [UIImage imageWithData:imageData];
	
	avatarView.image = avatar;
	nameLabel.text = [[post valueForKey:@"from"] valueForKey:@"name"];
	
	[view addSubview:avatarView];
	[view addSubview:nameLabel];
	
	return view;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
	return [feed count];
}

- (NSDictionary *)postForRow:(NSInteger)line{
	return (NSDictionary *)[feed objectAtIndex:line];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	return 300;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	static NSString *CellIdentifier = @"Cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:CellIdentifier];
	}
	
	NSDictionary *post = [self postForRow:indexPath.section];
	
	cell.textLabel.text = [[post valueForKey:@"from"] valueForKey:@"name"];
	
	//image
	@try {
		NSURL *imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture",[post valueForKey:@"object_id"]]];
		NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
		cell.imageView.image = [UIImage imageWithData:imageData];
		[cell.imageView sizeThatFits:CGSizeMake(320, 320)];
	}
	@catch (NSException *exception) {
		
	}
	
	[cell sizeToFit];
	
	return cell;
}

@end

//
//  tweetDetailsViewController.m
//  twitter
//
//  Created by Angel Gutierrez on 7/6/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import "tweetDetailsViewController.h"
#import "APIManager.h"
#import "Tweet.h"
#import "UIImageView+AFNetworking.h"

@interface tweetDetailsViewController ()

@end

@implementation tweetDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	if (self.tweet.favorited) {
		self.likeButton.selected = YES;
	}
	
	if (self.tweet.retweeted) {
		self.retweetButton.selected = YES;
	}
	
	self.nameLabel.text = self.tweet.user.screenName;
	
	NSString *handle = self.tweet.user.screenName;
	NSString *fullHandle = [@"@" stringByAppendingString:handle];
	self.handleLabel.text = fullHandle;
	
	self.dateLabel.text = self.tweet.createdAtString;
	
	self.tweetView.text = self.tweet.text;
	
	NSURL *profileImageURL = [NSURL URLWithString:self.tweet.user.profilePicture];
	[self.profileImageView setImageWithURL:profileImageURL];
	
	[self.likeButton setTitle:[NSString stringWithFormat:@"%i", self.tweet.favoriteCount] forState:UIControlStateNormal];
	
	[self.retweetButton setTitle:[NSString stringWithFormat:@"%i", self.tweet.retweetCount] forState:UIControlStateNormal];
}

- (void) refreshCounts {
	[self.likeButton setTitle:[NSString stringWithFormat:@"%i", self.tweet.favoriteCount] forState:UIControlStateNormal];
	
	[self.retweetButton setTitle:[NSString stringWithFormat:@"%i", self.tweet.retweetCount] forState:UIControlStateNormal];
}

- (IBAction)didTapLike:(id)sender {
	if (!self.tweet.favorited) {
		self.tweet.favorited = YES;
		self.tweet.favoriteCount += 1;
		
		self.likeButton.selected = YES;
		
		[self refreshCounts];
		
		[[APIManager shared] favorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
			if (error) {
				 NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
			} else {
				NSLog(@"Successfully favorited the following Tweet: %@", tweet.text);
			}
		}];
	} else {
		self.tweet.favorited = NO;
		self.tweet.favoriteCount -= 1;
		
		self.likeButton.selected = NO;
		
		[self refreshCounts];
		
		[[APIManager shared] unfavorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
			if (error) {
				 NSLog(@"Error unfavoriting tweet: %@", error.localizedDescription);
			} else {
				NSLog(@"Successfully unfavorited the following Tweet: %@", tweet.text);
			}
		}];
	}
}

- (IBAction)didTapRetweet:(id)sender {
	if (!self.tweet.retweeted) {
		self.tweet.retweeted = YES;
		self.tweet.retweetCount += 1;
		
		self.retweetButton.selected = YES;
		
		[self refreshCounts];
		
		[[APIManager shared] retweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
			if (error) {
				 NSLog(@"Error retweeting tweet: %@", error.localizedDescription);
			} else {
				NSLog(@"Successfully retweeted the following Tweet: %@", tweet.text);
			}
		}];
	} else {
		self.tweet.retweeted = NO;
		self.tweet.retweetCount -= 1;
		
		self.retweetButton.selected = NO;
		
		[self refreshCounts];
		
		[[APIManager shared] unretweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
			if (error) {
				 NSLog(@"Error unretweeting tweet: %@", error.localizedDescription);
			} else {
				NSLog(@"Successfully unretweeted the following Tweet: %@", tweet.text);
			}
		}];
	}
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

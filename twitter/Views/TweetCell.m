//
//  TweetCell.m
//  twitter
//
//  Created by Angel Gutierrez on 7/2/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import "TweetCell.h"
#import "Tweet.h"
#import "APIManager.h"
#import "NSDate+TimeAgo.h"
#import "UIImageView+AFNetworking.h"

@implementation TweetCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) refreshTweets {
	self.nameLabel.text = self.tweet.user.name;
	self.tweetView.text = self.tweet.text;
	
	NSString *handle = self.tweet.user.screenName;
	NSString *fullHandle = [@"@" stringByAppendingString:handle];
	self.handleLabel.text = fullHandle;
	
	NSString *createdAt = self.tweet.createdAtString;
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	formatter.dateFormat = @"E MMM d HH:mm:ss Z y";
	NSDate *date = [formatter dateFromString:createdAt];
	formatter.dateStyle = NSDateFormatterShortStyle;
	formatter.timeStyle = NSDateFormatterNoStyle;
	
	NSString *ago = [date timeAgo];
	self.timeLabel.text = ago;
	
	NSURL *profileImageURL = [NSURL URLWithString:self.tweet.user.profilePicture];
	[self.profileImageView setImageWithURL:profileImageURL];
	
	[self.likeButton setTitle:[NSString stringWithFormat:@"%i", self.tweet.favoriteCount] forState:UIControlStateNormal];
	
	[self.retweetButton setTitle:[NSString stringWithFormat:@"%i", self.tweet.retweetCount] forState:UIControlStateNormal];
}

- (IBAction)didTapLike:(id)sender {
	if (!self.tweet.favorited) {
		self.tweet.favorited = YES;
		self.tweet.favoriteCount += 1;
		
		self.likeButton.selected = YES;
		
		[self refreshTweets];
		
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
		
		[self refreshTweets];
		
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
		
		[self refreshTweets];
		
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
		
		[self refreshTweets];
		
		[[APIManager shared] unretweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
			if (error) {
				 NSLog(@"Error unretweeting tweet: %@", error.localizedDescription);
			} else {
				NSLog(@"Successfully unretweeted the following Tweet: %@", tweet.text);
			}
		}];
	}
}

@end

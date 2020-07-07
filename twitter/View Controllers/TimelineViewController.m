//
//  TimelineViewController.m
//  twitter
//
//  Created by emersonmalca on 5/28/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "TimelineViewController.h"
#import "ComposeViewController.h"
#import "tweetDetailsViewController.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "Tweet.h"
#import "TweetCell.h"
#import "APIManager.h"

@interface TimelineViewController () <ComposeViewControllerDelegate, UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *tweets;
@property (nonatomic, strong) UIRefreshControl *refreshControl;


@end

@implementation TimelineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.tableView.dataSource = self;
	self.tableView.delegate = self;
	
	
	self.refreshControl = [[UIRefreshControl alloc] init];
	[self.refreshControl addTarget:self action:@selector(fetchTweets) forControlEvents:UIControlEventValueChanged];
	[self.tableView insertSubview:self.refreshControl atIndex:0];
	
	[self fetchTweets];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)fetchTweets {
    [[APIManager shared] getHomeTimelineWithCompletion:^(NSArray *tweets, NSError *error) {
        if (tweets) {
            NSLog(@"😎😎😎 Successfully loaded home timeline");
			
			self.tweets = (NSMutableArray *) tweets;
			
			// Array of objs now, so we access through the "." operator
			for (Tweet *tweet in tweets) {
				NSString *text = tweet.text;
                NSLog(@"%@", text);
            }
			
			[self.tableView reloadData];
			
        } else {
            NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
        }
		[self.refreshControl endRefreshing];
    }];
}

// Logout button calls the logout function
- (IBAction)logoutButtonTapped:(id)sender {
	[self logoutTapped];
}

- (void) logoutTapped {
	AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
		
	UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
	LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
	appDelegate.window.rootViewController = loginViewController;
	
	[[APIManager shared] logout];
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	
	if ([segue.identifier isEqual:@"detailsView"]) {
		// Then pass some data here
		// Grab the tweet you're trying to pass
		// Pass it to the destinatation view controller
		UITableViewCell *tappedCell = sender;
		NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
		Tweet *tweet = self.tweets[indexPath.row];
		
		tweetDetailsViewController *tweetViewController = [segue destinationViewController];
		tweetViewController.tweet = tweet;
	}
	else if ([segue.identifier isEqual:@"composeView"]) {
		// Other data or whatever you wanna do here
		UINavigationController *navigationController = [segue destinationViewController];
		ComposeViewController *composeController = (ComposeViewController*)navigationController.topViewController;
		composeController.delegate = self;
	}
}

- (void) didTweet:(Tweet *)tweet {
	[self.tweets insertObject:tweet atIndex:0];
	[self.tableView reloadData];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
	TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell" forIndexPath:indexPath];

	
	Tweet *tweet = self.tweets[indexPath.row];
	
	cell.tweet = tweet;
	
	NSString *handle = cell.tweet.user.screenName;
	NSString *fullHandle = [@"@" stringByAppendingString:handle];
	cell.handleLabel.text = fullHandle;
	cell.nameLabel.text = tweet.user.name;
	
	cell.tweetView.text = tweet.text;
	cell.dateLabel.text = tweet.createdAtString.capitalizedString;
	
	if (cell.tweet.favorited) {
		[cell.likeButton.imageView setImage:[UIImage imageNamed:@"favor-icon-red"]];
	}
	[cell.likeButton setTitle:[NSString stringWithFormat:@"%i", cell.tweet.favoriteCount] forState:UIControlStateNormal];
	
	if (cell.tweet.retweeted) {
		[cell.retweetButton.imageView setImage:[UIImage imageNamed:@"retweet-icon-green"]];
	}
	[cell.retweetButton setTitle:[NSString stringWithFormat:@"%i", cell.tweet.retweetCount] forState:UIControlStateNormal];
	
//	cell.profileImageView.image = tweet.user.profileImage;
	return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.tweets.count;
}

@end

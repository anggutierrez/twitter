//
//  tweetDetailsViewController.m
//  twitter
//
//  Created by Angel Gutierrez on 7/6/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import "tweetDetailsViewController.h"

@interface tweetDetailsViewController ()

@end

@implementation tweetDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	self.handleLabel.text = self.tweet.user.name;
	self.nameLabel.text = self.tweet.user.screenName;
	self.tweetView.text = self.tweet.text;
	
	
	
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

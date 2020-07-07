//
//  tweetDetailsViewController.h
//  twitter
//
//  Created by Angel Gutierrez on 7/6/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

NS_ASSUME_NONNULL_BEGIN

@interface tweetDetailsViewController : UIViewController
@property (nonatomic, strong) Tweet *tweet;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *handleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *tweetView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end

NS_ASSUME_NONNULL_END

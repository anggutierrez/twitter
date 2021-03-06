//
//  User.m
//  twitter
//
//  Created by Angel Gutierrez on 7/2/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import "User.h"

@implementation User

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.name = dictionary[@"name"];
        self.screenName = dictionary[@"screen_name"];
		self.profilePicture = dictionary[@"profile_image_url_https"];
		
      // Initialize any other properties
    }
    return self;
}



@end

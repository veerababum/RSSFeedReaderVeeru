//
//  FeedBO.h
//  RSSFeedReaderVeeru
//
//  Created by veerababu mulugu on 9/27/16.
//  Copyright © 2016 veerababu m. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FeedBO : NSObject

@property (nonatomic, strong) NSString *strTitle;
@property (nonatomic, strong) NSString *strDescription;
@property (nonatomic, strong) NSString *strImageURL;
@property (nonatomic, strong) UIImage  *image;
@property (nonatomic, strong) NSDate   *date;
@property (nonatomic, strong) NSString *strFeedURL;

@end

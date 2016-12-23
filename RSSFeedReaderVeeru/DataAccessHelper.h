//
//  DataAccessHelper.h
//  RSSFeedReaderVeeru
//
//  Created by veerababu mulugu on 9/27/16.
//  Copyright © 2016 veerababu m. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataAccessHelper : NSObject

typedef void (^DataCompletionBlock)(NSData * data, NSError *error);
typedef void (^ParseCompletionBlock)(NSMutableArray * array, NSError *error);

-(void)getNewsFeedWithCompletionHandler:(DataCompletionBlock)completionHandler;
-(void)parseFeedDataWithData:(NSData *)data completionHandler:(ParseCompletionBlock)completionHandler;
-(void)downloadImagesForFeed:(NSMutableArray *)arrFeedBO competionHandler:(void(^)(NSMutableArray * array))competionHandler;
@end

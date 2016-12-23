//
//  DataAccessHelper.m
//  RSSFeedReaderVeeru
//
//  Created by veerababu mulugu on 9/27/16.
//  Copyright © 2016 veerababu m. All rights reserved.
//

#import "DataAccessHelper.h"
#import "DataParser.h"
#import "FeedBO.h"
#import "CoreDateManager.h"

@interface DataAccessHelper()

@end


@implementation DataAccessHelper

-(void)getNewsFeedWithCompletionHandler:(DataCompletionBlock)completionHandler {
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://news.google.com/?output=rss"]];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:urlRequest
                                            completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error) {
                                      
                                      if(error == nil && data != nil) {
                                          NSHTTPURLResponse *httpResponce = (NSHTTPURLResponse *)response;
                                          if(httpResponce.statusCode == 200) {
                                              //success responce
                                              completionHandler(data, nil);
                                          }
                                          else {
                                              NSLog(@"Error with server, status code: %ld",httpResponce.statusCode);
                                              NSError *err = [NSError errorWithDomain:@"http://news.google.com/?output=rss" code:httpResponce.statusCode userInfo:@{@"error":@"Error with server"}];
                                              completionHandler(nil, err);
                                          }
                                      }
                                      else {
                                          if(error != nil) {
                                              //error
                                              NSLog(@"Error: %@",error);
                                              completionHandler(nil, error);
                                          }
                                          else {
                                              //data nil
                                              NSLog(@"No Data found");
                                              completionHandler(nil, nil);
                                          }
                                      }
                                  }];

    [task resume];
}

-(void)parseFeedDataWithData:(NSData *)data completionHandler:(ParseCompletionBlock)completionHandler {
    
    DataParser *dataParser = [[DataParser alloc] init];
    dataParser.reference = self;
    dataParser.data = data;
    [dataParser parseDataWithCompletion:^(BOOL success) {
        if(success) {
            //parsing done
            NSLog(@"parsing done");
            
            
            CoreDateManager *dataManager = [[CoreDateManager alloc] init];
            [dataManager storeFeedData:dataParser.arrFeedBO];
            completionHandler(dataParser.arrFeedBO, nil);
        }
        else {
            //parser error occured
            NSLog(@"parser error occured");
            
            completionHandler(nil, nil);
        }
    }];
}

-(void)downloadImagesForFeed:(NSMutableArray *)arrFeedBO competionHandler:(void(^)(NSMutableArray * array))competionHandler {
    if(arrFeedBO.count == 0) {
        competionHandler(arrFeedBO);
    }
    else {
        NSMutableArray *arrFeedBOWithImages = [NSMutableArray array];
        
        __block NSInteger index = 0;
        for (FeedBO *feedBO in arrFeedBO) {
            [self getImageFromURL:feedBO.strImageURL completionHandler:^(UIImage *image) {
                feedBO.image = image;
                [arrFeedBOWithImages addObject:feedBO];
                
                index++;
                
                if(index == arrFeedBO.count) {
                    competionHandler(arrFeedBOWithImages);
                }
            }];
        }
    }
}

-(void)getImageFromURL:(NSString *)strURL completionHandler:(void(^) (UIImage *image))completionHandler {
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:strURL]];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:urlRequest
                                            completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error) {
                                      if(data != nil) {
                                          UIImage *image = [UIImage imageWithData:data];
                                          completionHandler(image);
                                      }
                                      else {
                                          completionHandler(nil);
                                      }
                                  }];
    
    [task resume];
}


@end

//
//  DataParser.h
//  RSSFeedReaderVeeru
//
//  Created by veerababu mulugu on 9/27/16.
//  Copyright © 2016 veerababu m. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataAccessHelper.h"


@interface DataParser : NSObject  

@property (nonatomic, strong) NSData *data;
@property (nonatomic, strong) NSMutableArray *arrFeedBO;

@property (nonatomic, weak) DataAccessHelper *reference;

typedef void (^SuccessCompletionBlock)(BOOL success);

-(void)parseDataWithCompletion:(SuccessCompletionBlock)completionHandler;

@end

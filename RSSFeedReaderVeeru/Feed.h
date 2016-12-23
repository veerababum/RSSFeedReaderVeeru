//
//  Feed.h
//  RSSFeedReaderVeeru
//
//  Created by veerababu mulugu on 9/27/16.
//  Copyright © 2016 veerababu m. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "FeedBO.h"

NS_ASSUME_NONNULL_BEGIN

@interface Feed : NSManagedObject

// Insert code here to declare functionality of your managed object subclass

-(id)initWithFeedBO:(FeedBO *)feedBO inManagedObjectContext:(NSManagedObjectContext *)context;

@end

NS_ASSUME_NONNULL_END

#import "Feed+CoreDataProperties.h"

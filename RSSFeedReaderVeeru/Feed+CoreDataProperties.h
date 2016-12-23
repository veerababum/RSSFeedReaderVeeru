//
//  Feed+CoreDataProperties.h
//  RSSFeedReaderVeeru
//
//  Created by veerababu mulugu on 9/27/16.
//  Copyright © 2016 veerababu m. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Feed.h"

NS_ASSUME_NONNULL_BEGIN

@interface Feed (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *feedDescription;
@property (nullable, nonatomic, retain) NSString *feedURL;
@property (nullable, nonatomic, retain) id date;
@property (nullable, nonatomic, retain) id image;
@property (nullable, nonatomic, retain) NSString *imageURL;
@property (nullable, nonatomic, retain) NSString *feedTitle;

@end

NS_ASSUME_NONNULL_END

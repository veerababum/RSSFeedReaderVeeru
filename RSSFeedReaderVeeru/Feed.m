//
//  Feed.m
//  RSSFeedReaderVeeru
//
//  Created by veerababu mulugu on 9/27/16.
//  Copyright © 2016 veerababu m. All rights reserved.
//

#import "Feed.h"
#import "AppDelegate.h"

@implementation Feed

// Insert code here to add functionality to your managed object subclass
-(id)initWithFeedBO:(FeedBO *)feedBO inManagedObjectContext:(NSManagedObjectContext *)context; {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Feed" inManagedObjectContext:context];
    self = [self initWithEntity:entity insertIntoManagedObjectContext:appDelegate.managedObjectContext];

    if(self != nil) {
        self.feedTitle = feedBO.strTitle;
        self.feedDescription = feedBO.strDescription;
        self.imageURL = feedBO.strImageURL;
        self.date = feedBO.date;
        self.feedURL = feedBO.strFeedURL;
        self.image = feedBO.image;
    }
    
    return self;
}

@end

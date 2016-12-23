//
//  CoreDateManager.m
//  RSSFeedReaderVeeru
//
//  Created by veerababu mulugu on 9/27/16.
//  Copyright © 2016 veerababu m. All rights reserved.
//

#import "CoreDateManager.h"
#import "AppDelegate.h"
#import "FeedBO.h"
#import "Feed.h"

@implementation CoreDateManager

-(void)storeFeedData:(NSArray *)arrFeedBO {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = appDelegate.managedObjectContext;
    NSMutableArray *arrManagedObjects = [NSMutableArray array];
    
    //delete old data
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Feed"];
    NSArray *fetchedResults = [context executeFetchRequest:fetchRequest error:nil];
    for (NSManagedObject *object in fetchedResults) {
        [context deleteObject:object];
    }
    
    //save new data
    for (FeedBO *feedObject in arrFeedBO) {
        Feed *managedFeed = [[Feed alloc] initWithFeedBO:feedObject inManagedObjectContext:context];
        [arrManagedObjects addObject:managedFeed];
    }

    // save in core data
    NSError *error = nil;
    [context save:&error];
    
}

@end

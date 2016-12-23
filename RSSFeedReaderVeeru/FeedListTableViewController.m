//
//  FeedListTableViewController.m
//  RSSFeedReaderVeeru
//
//  Created by veerababu mulugu on 9/27/16.
//  Copyright © 2016 veerababu m. All rights reserved.
//
//

#import "FeedListTableViewController.h"
#import "DataAccessHelper.h"
#import "AppDelegate.h"
#import "DataParser.h"
#import "Feed.h"
#import "FeedListTableViewCell.h"
#import "FeedDetailsTableViewController.h"

@interface FeedListTableViewController ()

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@end

@implementation FeedListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.title = @"News Feed";
    
    [self reloadFeedTableView];
    
}

- (NSFetchedResultsController *)fetchedResultsController {
    
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *feedFetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Feed"];
    feedFetchRequest.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO]];
    NSFetchedResultsController *theFetchedResultsController =
    [[NSFetchedResultsController alloc] initWithFetchRequest:feedFetchRequest
                                        managedObjectContext:self.managedContext sectionNameKeyPath:nil
                                                   cacheName:nil];
    self.fetchedResultsController = theFetchedResultsController;
    
    return _fetchedResultsController;
    
}

-(void)reloadFeedTableView {
    
    DataAccessHelper *dataHelper = [[DataAccessHelper alloc] init];
    [dataHelper getNewsFeedWithCompletionHandler:^(NSData *data, NSError *error) {
        if(error) {
            [self showAlertMessages:@"Error Occuered"];
            NSLog(@"error :%@",error);
        }
        else {
//            NSLog(@"data :%@",data);
//            NSString *strData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//            NSLog(@"strData :%@",strData);
            
            [dataHelper parseFeedDataWithData:data completionHandler:^(NSArray *array, NSError *error) {
                if(error == nil) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [self.fetchedResultsController performFetch:nil];
                        
                        [self.tableView reloadData];
                        
                    });
                }
                else {
                    [self showAlertMessages:@"Error Occuered"];
                }
            }];
            
        }
    }];
    

}

- (IBAction)refreshTable:(UIRefreshControl *)sender {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self reloadFeedTableView];
        
        [sender endRefreshing];
    });

}

-(void)showAlertMessages:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"NEWS FEED" message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"Pressed OK");
    }];
    
    [alert addAction:defaultAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = [self.fetchedResultsController fetchedObjects].count;
    return count;

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FeedListTableViewCell *cell = (FeedListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"CellIdentifier" forIndexPath:indexPath];
    

    NSArray *arrFeed = [self.fetchedResultsController fetchedObjects];
    Feed *feedData = [arrFeed objectAtIndex:indexPath.row];
    cell.lblTitle.text = feedData.feedTitle;
    cell.lblDescription.text = feedData.feedDescription;
    
    UIImage *cellImage = feedData.image;
    if(cellImage) {
        cell.imgView.image = cellImage;
    }
    else {
        cell.imgView.image = [UIImage imageNamed:@"placeholder_image"];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"DetailsSegue" sender:indexPath];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    FeedDetailsTableViewController *detailsViewController = [segue destinationViewController];
    NSIndexPath *indexPath = (NSIndexPath *)sender;
    NSArray *arrFeed = [self.fetchedResultsController fetchedObjects];
    detailsViewController.feedManagedObject = [arrFeed objectAtIndex:indexPath.row];
}


@end

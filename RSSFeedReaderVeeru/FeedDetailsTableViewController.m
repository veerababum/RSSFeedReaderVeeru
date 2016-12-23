//
//  FeedDetailsTableViewController.m
//  RSSFeedReaderVeeru
//
//  Created by veerababu mulugu on 9/27/16.
//  Copyright © 2016 veerababu m. All rights reserved.
//

#import "FeedDetailsTableViewController.h"
#import "FeedDetailHeaderTableViewCell.h"

@interface FeedDetailsTableViewController ()<UIWebViewDelegate> {
    UIActivityIndicatorView *activityIndicator;
}

@end

@implementation FeedDetailsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.title = @"Feed Details";

    self.tableView.estimatedRowHeight = 100.0f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    CGFloat webViewHeight = self.tableView.frame.size.height - self.tableView.estimatedRowHeight - 64;
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, webViewHeight)];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.feedManagedObject.feedURL]]];
    webView.delegate = self;
    
    self.tableView.tableFooterView = webView;
    
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.center = self.tableView.center;
    [self.tableView addSubview:activityIndicator];
    [self.tableView bringSubviewToFront:activityIndicator];
    [activityIndicator startAnimating];
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
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FeedDetailHeaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DetailsCellId" forIndexPath:indexPath];
    
    cell.lblTitle.text = self.feedManagedObject.feedTitle;
    
    UIImage *cellImage = self.feedManagedObject.image;
    if(cellImage) {
        cell.imgView.image = cellImage;
    }
    else {
        cell.imgView.image = [UIImage imageNamed:@"placeholder_image"];
    }
    
    return cell;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UIWebView delegated
- (void)webViewDidStartLoad:(UIWebView *)webView {
    activityIndicator.hidden = NO;
    [activityIndicator startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [activityIndicator stopAnimating];
    activityIndicator.hidden = YES;
}

//- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error {
//    [activityIndicator stopAnimating];
//    activityIndicator.hidden = YES;
//}


@end

//
//  BrowseWebViewController.m
//  Recommender
//
//  Created by Benson Yang on 9/5/13.
//  Copyright (c) 2013 Benson. All rights reserved.
//

#import "BrowseWebViewController.h"
#import "MBProgressHUD.h"
#import "ProjectListViewController.h"

@interface BrowseWebViewController ()

@end

@implementation BrowseWebViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.navigationItem.title = self.poi.name;
    self.contentView.delegate = self;
    [self.contentView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.poi.poiUrl]]];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"toProjectListView"]) {
        ProjectListViewController *projectListVC = segue.destinationViewController;
        projectListVC.poi = self.poi;
        projectListVC.isForAddingPoi = YES;
    }
}

- (IBAction)addToList:(id)sender {
//    PlanListViewController *planListVC = [[PlanListViewController alloc] init];
//    planListVC.poi = self.poi;
//    [self presentViewController:planListVC animated:YES completion:^{
//        ;
//    }];
    
    [self performSegueWithIdentifier:@"toProjectListView" sender:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIWebViewDelegate Methods
- (void)webViewDidStartLoad:(UIWebView *)webView {
    [MBProgressHUD showHUDAddedTo:webView animated:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [MBProgressHUD hideHUDForView:webView animated:YES];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [MBProgressHUD hideHUDForView:webView animated:YES];
}

@end

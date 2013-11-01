//
//  BrowseRootViewController.m
//  Recommender
//
//  Created by Benson Yang on 8/31/13.
//  Copyright (c) 2013 Benson. All rights reserved.
//

#import "BrowseRootViewController.h"
#import "HelperMethods.h"
#import "BrowseWebViewController.h"
#import "BrowseMapViewController.h"

@interface BrowseRootViewController ()

@end

@implementation BrowseRootViewController

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
    
    self.browseMapViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"BrowseMapViewController"];
    self.browseTableViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"BrowseTableViewController"];
    [self addChildViewController:self.browseMapViewController];
    [self addChildViewController:self.browseTableViewController];
    
    self.mapOrTable.selectedSegmentIndex = [[NSUserDefaults standardUserDefaults] integerForKey:kBrowseViewMode];
    self.currentViewController = [self.childViewControllers objectAtIndex:self.mapOrTable.selectedSegmentIndex];
    [self.view addSubview:self.currentViewController.view];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"toPoiDetailWeb"]) {
        BrowseWebViewController *poiDetailWeb = segue.destinationViewController;
        
        if ([sender isKindOfClass: [NSIndexPath class]]) {
            NSIndexPath *index = sender;
            poiDetailWeb.poi = [self.browseTableViewController.poiStream.pois objectAtIndex:index.row];
        }
        else if ([sender isKindOfClass: [AnnotationButton class]]) {
            AnnotationButton *aButton = sender;
            poiDetailWeb.poi = aButton.poi;
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onChangeMapOrTableView:(id)sender {
    [[NSUserDefaults standardUserDefaults] setInteger:self.mapOrTable.selectedSegmentIndex forKey:kBrowseViewMode];
    
    UIViewController *toViewController = [[self childViewControllers] objectAtIndex:self.mapOrTable.selectedSegmentIndex];
    [self transitionFromViewController:self.currentViewController toViewController:toViewController duration:1 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
    } completion:^(BOOL finished) {
        if (finished) {
            self.currentViewController = toViewController;
        }
    }];
}

#pragma mark - Helper Methods


@end

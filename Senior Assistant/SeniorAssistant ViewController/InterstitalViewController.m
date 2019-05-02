//
//  InterstitalViewController.m
//  Senior Assistant
//
//  Created by Zelalem Terefe on 4/30/19.
//  Copyright © 2019 Zelalem Terefe. All rights reserved.
//

#import "InterstitalViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface InterstitalViewController () <CLLocationManagerDelegate>
@property (strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation InterstitalViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager requestWhenInUseAuthorization];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)didTapLogin:(id)sender
{
    [self performSegueWithIdentifier:@"toLoginSegue"sender:nil];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"THERE WAS AN ERROR - %@", error);
}

- (void)locationManager:(CLLocationManager *)manager didFinishDeferredUpdatesWithError:(NSError *)error
{
    NSLog(@"THERE WAS AN ERROR - %@", error);
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if(CLLocationManager.locationServicesEnabled)
    {
        if(CLLocationManager.authorizationStatus == kCLAuthorizationStatusAuthorizedWhenInUse)
        {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Allow Maps to access your location while you are using the app ?" message:@"Your current location will be displayed on the map and used for directions nearby search results, and estimated travle times" preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"Don't Allow"
                                                               style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * _Nonnull action)
                                       {
                                           
                                       }];
            [alert addAction:noAction];
            
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Allow"
                                                               style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * _Nonnull action)
                                       {
                                           
                                       }];
            [alert addAction:okAction];
            [self presentViewController:alert animated:YES completion:^
             {
             }];
        }
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

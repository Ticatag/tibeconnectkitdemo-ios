//
//  BeaconsTableViewController.m
//  tibedemo
//
//  Created by frederic Visticot on 03/11/2016.
//  Copyright © 2016 ticatag. All rights reserved.
//

#import "BeaconsTableViewController.h"
#import "BeaconViewController.h"
#import "BeaconTableViewCell.h"

@interface BeaconsTableViewController ()
@property(nonatomic, strong) NSArray *liveBeacons;
@property(nonatomic, strong) TBCManager *tiBeConnectManager;
@end

@implementation BeaconsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Beacons";
    
    _tiBeConnectManager = [TBCManager shared];
    _tiBeConnectManager.delegate=self;
    _liveBeacons = [NSArray array];
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

    return [_liveBeacons count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BeaconTableViewCell *cell = (BeaconTableViewCell*)[tableView dequeueReusableCellWithIdentifier: @"BeaconTableViewCell"];

    
    TBCBeacon *beacon = [_liveBeacons objectAtIndex: indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"Major: %@ Minor: %@", beacon.major, beacon.minor];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TBCBeacon *beacon = [_liveBeacons objectAtIndex: indexPath.row];
    BeaconViewController *beaconViewController = (BeaconViewController*)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier: @"BeaconViewController"];
    beaconViewController.beacon= beacon;
    [self.navigationController pushViewController: beaconViewController animated: YES];
}



/*
#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    BeaconViewController *beaconViewController = (BeaconViewController*)segue.destinationViewController;
    NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;
    beaconViewController.beacon= [_liveBeacons objectAtIndex: indexPath.row];
}
*/

-(void)tiBeConnectManager:(TBCManager *)manager didButtonActionChanged:(TBCBeaconButtonAction)action forBeacon:(TBCBeacon *)beacon
{
    NSString *title = @"";
    switch (action) {
        case TBCBeaconButtonActionSimpleClick:
            title = @"Simple click action";
            break;
        case TBCBeaconButtonActionDoubleClick:
            title = @"Double click action";
            break;
        case TBCBeaconButtonActionLongPressed:
            title = @"Long pressed action";
        default:
            break;
    }
    [self displayAlertWithTitle: title];
}

-(void)tiBeConnectManager:(TBCManager *)manager didBatteryValueChanged:(NSInteger)value forBeacon:(TBCBeacon *)beacon
{
    ;
}

-(void)tiBeConnectManager:(TBCManager *)manager didTemperatureValueChanged:(NSInteger)value forBeacon:(TBCBeacon *)beacon
{
    NSLog(@"Temperature changed: %ld", (long)value);
}

-(void)tiBeConnectManager:(TBCManager *)manager didRangeBeacon:(NSArray<TBCBeacon *>*)beacons
{
    _liveBeacons = beacons;
    [self.tableView reloadData];
}

-(void)tiBeConnectManager:(TBCManager *)manager didBluetoothStateChanged:(CBManagerState)state
{
    if (state == CBManagerStatePoweredOn)
    {
        if (![manager isMonitoring])
        {
            [manager startMonitoring];
        }
    }
}

-(void)displayAlertWithTitle: (NSString *)title
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Information" message: title preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"OK", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    }]];
    id rootViewController = [UIApplication sharedApplication].delegate.window.rootViewController;
    if([rootViewController isKindOfClass:[UINavigationController class]])
    {
        rootViewController = ((UINavigationController *)rootViewController).viewControllers.firstObject;
    }
    if([rootViewController isKindOfClass:[UITabBarController class]])
    {
        rootViewController = ((UITabBarController *)rootViewController).selectedViewController;
    }
    [rootViewController presentViewController:alertController animated:YES completion:nil];
}


@end

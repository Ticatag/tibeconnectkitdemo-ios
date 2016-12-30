//
//  BeaconViewController.m
//  tibedemo
//
//  Created by frederic Visticot on 03/11/2016.
//  Copyright © 2016 ticatag. All rights reserved.
//

#import "BeaconViewController.h"
#import <TiBeConnectKit/TBCKit.h>


@interface BeaconViewController ()
@property(nonatomic, strong) TBCManager *tiBeConnectManager;
@end

@implementation BeaconViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Beacon";
    _tiBeConnectManager = [TBCManager shared];
    [_activityIndicator startAnimating];
    _pingButton.hidden=YES;
    _accelerometerValuesLabel.text=@"";
    _temperatureLabel.text=@"";
    _rssiLabel.text=@"";
    
    //__block __weak id connectionObserver=
    [[NSNotificationCenter defaultCenter] addObserverForName: TBCBeaconDidConnectNotification object:_beacon queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        [_activityIndicator stopAnimating];
        
        [self hideScreen: NO];
        
        //[[NSNotificationCenter defaultCenter] removeObserver: connectionObserver];
        [_tiBeConnectManager setButtonActionsNotifications: YES forBeacon: _beacon];
        [_tiBeConnectManager setBatteryNotifications: YES forBeacon: _beacon];
        [_tiBeConnectManager setTemperatureNotifications:YES forBeacon: _beacon];
        
        [_tiBeConnectManager startRSSIMonitoringForBeacon: _beacon interval: 1.0 withCompletion:^(TBCManager *manager, TBCBeacon *beacon, NSError *error) {
            ;
        }];
        
        [_tiBeConnectManager temperatureForBeacon: _beacon withCompletion:^(TBCManager *manager, TBCBeacon *beacon, NSError *error) {
            ;
        }];
        
        [_tiBeConnectManager buttonModeForBeacon: _beacon withCompletion:^(TBCManager *manager, TBCBeacon *beacon, NSError *error) {
            ;
        }];
        
        [_tiBeConnectManager firmwareVersionForBeacon: _beacon withCompletion:^(TBCManager *manager, TBCBeacon *beacon, NSError *error) {
            ;
        }];
        
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName: TBCBeaconDidTemperatureChangeNotification object:_beacon queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        _temperatureLabel.text = [NSString stringWithFormat: @"Temperature: %d °C", [[note.userInfo objectForKey: @"value"] intValue]];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName: TBCBeaconButtonModeNotification object:_beacon queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        int mode = [[note.userInfo objectForKey: @"value"] intValue];
        _buttonModeSwitch.on = mode;
        [_tiBeConnectManager setAccelerometerNotifications: mode forBeacon: _beacon];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName: TBCBeaconDidAccelerometerAxisXChangeNotification object:_beacon queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        [self refreshAccelerometerValues];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName: TBCBeaconDidAccelerometerAxisYChangeNotification object:_beacon queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        [self refreshAccelerometerValues];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName: TBCBeaconDidAccelerometerAxisZChangeNotification object:_beacon queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        [self refreshAccelerometerValues];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName: TBCBeaconFirmwareVersionNotification object:_beacon queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        _firmwareVersionLabel.text = [NSString stringWithFormat:@"firmware: %@", note.userInfo[@"value"]];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName: TBCBeaconDidRSSIChangeNotification object:_beacon queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        NSLog(@"RSSI: %ld", [note.userInfo[@"value"] integerValue]);
        _rssiLabel.text = [NSString stringWithFormat: @"RSSI: %ld dB", [note.userInfo[@"value"] integerValue]];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName: TBCBeaconDidDisconnectNotification object:_beacon queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        [self hideScreen: YES];
    }];
    
    [_tiBeConnectManager connectBeacon: _beacon];
    
    
    
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
}

- (void)didMoveToParentViewController:(UIViewController *)parent
{
    if (![parent isEqual:self.parentViewController]) {
        NSLog(@"Back pressed");
        [_tiBeConnectManager stopRSSIMonitoringForBeacon: _beacon];
        [_tiBeConnectManager disconnectBeacon: _beacon];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)hideScreen: (BOOL)hidden
{
    _pingButton.hidden=hidden;
    _rssiLabel.hidden=hidden;
    _temperatureLabel.hidden=hidden;
    _buttonModeSwitch.hidden=hidden;
    _firmwareVersionLabel.hidden=hidden;
    _buttonModeLabel.hidden=hidden;
    _beaconDisconnectedLabel.hidden=!hidden;
}

-(void)refreshAccelerometerValues
{
    _accelerometerValuesLabel.text = [NSString stringWithFormat:@"AxisX: %ld, AxisY: %ld, AxisZ: %ld", (long)_beacon.accelerometer.axisX, (long)_beacon.accelerometer.axisY, (long)_beacon.accelerometer.axisZ];
}

- (IBAction)pingButtonClicked:(id)sender {
    [_tiBeConnectManager pingBeacon: _beacon];
}
- (IBAction)buttonModeValueChanged:(id)sender {
    _accelerometerValuesLabel.text=@"";
    [_tiBeConnectManager setButtonMode: _buttonModeSwitch.on forBeacon: _beacon];
    [_tiBeConnectManager setAccelerometerNotifications: _buttonModeSwitch.on forBeacon: _beacon];
}
@end

//
//  BeaconViewController.h
//  tibedemo
//
//  Created by frederic Visticot on 03/11/2016.
//  Copyright © 2016 ticatag. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TBCBeacon;
@interface BeaconViewController : UIViewController
@property(nonatomic, strong) TBCBeacon *beacon;
@property (weak, nonatomic) IBOutlet UIButton *pingButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UISwitch *buttonModeSwitch;
- (IBAction)buttonModeValueChanged:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *temperatureLabel;
@property (weak, nonatomic) IBOutlet UILabel *accelerometerValuesLabel;
@property (weak, nonatomic) IBOutlet UILabel *firmwareVersionLabel;
@property (weak, nonatomic) IBOutlet UILabel *rssiLabel;
@property (weak, nonatomic) IBOutlet UILabel *buttonModeLabel;
@property (weak, nonatomic) IBOutlet UILabel *beaconDisconnectedLabel;
@end

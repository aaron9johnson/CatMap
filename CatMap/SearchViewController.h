//
//  SearchViewController.h
//  CatMap
//
//  Created by Aaron Johnson on 2017-10-24.
//  Copyright © 2017 Aaron Johnson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
@protocol Photos
-(void)setPhotos:(NSMutableArray *)photos;
-(void)setCoordinate:(CLLocationCoordinate2D)coordinate;
@end
@interface SearchViewController : UIViewController <CLLocationManagerDelegate>
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations;
@property (weak, nonatomic) IBOutlet UISwitch *mySwitch;
@property (weak, nonatomic) IBOutlet UITextField *myTextField;
@property (weak, nonatomic) id<Photos> delegate;
@property (nonatomic,strong) CLLocationManager *myLocationManager;
@property CLLocationCoordinate2D coordinate;

@end

//
//  DetailViewController.h
//  CatMap
//
//  Created by Aaron Johnson on 2017-10-24.
//  Copyright © 2017 Aaron Johnson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Photo.h"
#import <MapKit/MapKit.h>
#import "ViewController.h"

@interface DetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet MKMapView *myMapView;
@property Photo *photo;
@property NSArray *photos;
@property (weak) ViewController *me;
@end

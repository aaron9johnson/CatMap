//
//  Photo.h
//  CatMap
//
//  Created by Aaron Johnson on 2017-10-24.
//  Copyright © 2017 Aaron Johnson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface Photo : NSObject <MKAnnotation>
@property (nonatomic) UIImage *image;
@property NSURL *url;
@property (nonatomic, copy) NSString *title;
@property NSString *photoId;
@property (nonatomic) CLLocationCoordinate2D coordinate;

@end

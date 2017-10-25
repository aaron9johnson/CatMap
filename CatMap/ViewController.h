//
//  ViewController.h
//  CatMap
//
//  Created by Aaron Johnson on 2017-10-24.
//  Copyright © 2017 Aaron Johnson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchViewController.h"

@interface ViewController : UIViewController <UICollectionViewDataSource,UICollectionViewDelegate,Photos>
@property (strong, nonatomic) NSMutableArray *photos;
@property CLLocationCoordinate2D coordinate;
@end


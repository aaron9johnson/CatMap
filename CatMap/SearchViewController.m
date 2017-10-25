//
//  SearchViewController.m
//  CatMap
//
//  Created by Aaron Johnson on 2017-10-24.
//  Copyright © 2017 Aaron Johnson. All rights reserved.
//

#import "SearchViewController.h"
#import "Photo.h"

@interface SearchViewController ()
@property (weak, nonatomic) IBOutlet UITextField *postalCode;
@property NSMutableArray *photos;
@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _photos = [NSMutableArray new];
    // Do any additional setup after loading the view.
}
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    NSLog(@"Latitude = %f",[locations.lastObject coordinate].latitude );
    NSLog(@"Longitude =%f",[locations.lastObject coordinate].longitude);
    self.coordinate = [locations.lastObject coordinate];
    [self.myLocationManager stopUpdatingLocation];
    [self imagesFromFlicker:self.myTextField.text];
}
-(void)locationManager:(CLLocationManager *)manager didFailWithError: (NSError *)error {
    NSLog(@"didFailWithError: %@", error);
}
- (IBAction)myButton:(UIButton *)sender {
    if(self.mySwitch.on){
        [self.myLocationManager requestLocation];
    } else {
        CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
        [geoCoder geocodeAddressString:self.postalCode.text completionHandler:^(NSArray *placemarks, NSError *error) {
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
            self.coordinate = placemark.location.coordinate;
            [self imagesFromFlicker:self.myTextField.text];
        }];
    }
    
}
-(CLLocationManager *)myLocationManager{
    if(_myLocationManager == nil){
        self.myLocationManager = [[CLLocationManager alloc] init];
        self.myLocationManager.delegate = self;
        //[self.myLocationManger requestWhenInUseAuthorization];
        self.myLocationManager.desiredAccuracy = kCLLocationAccuracyBest;
        [self.myLocationManager startUpdatingLocation];
        
        //self.myLocationManger.distanceFilter = 500;
    }
    return _myLocationManager;
}
-(void)imagesFromFlicker:(NSString *)search{
    //https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=b9e8e163b77044fdadc7c1e29f8286c8&tags=cat&has_geo=1&format=json&nojsoncallback=1&extras=url_m&accuracy=11&lat=&lon=
    
    
//    https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=b9e8e163b77044fdadc7c1e29f8286c8&tags=cat&has_geo=1&format=json&nojsoncallback=1&extras=url_m&accuracy=11&lat=49.281840&lon=-123.108430
    
    
    //https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=b9e8e163b77044fdadc7c1e29f8286c8&tags=cat&has_geo=1&extras=url_m&format=json&nojsoncallback=1
    
    //https://api.flickr.com/services/rest/?method=flickr.photos.geo.getLocation&api_key=b9e8e163b77044fdadc7c1e29f8286c8&photo_id={photo id}&format=json&nojsoncallback=1
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=b9e8e163b77044fdadc7c1e29f8286c8&tags=%@&has_geo=1&format=json&nojsoncallback=1&extras=url_m&accuracy=11&lat=%f&lon=%f", search,self.coordinate.latitude,self.coordinate.longitude]];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    urlRequest.HTTPMethod = @"GET";
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *urlSession = [NSURLSession sessionWithConfiguration:configuration];
    NSURLSessionDataTask *dataTask = [urlSession dataTaskWithRequest:urlRequest
                                                   completionHandler:^(NSData * _Nullable data,
                                                                       NSURLResponse * _Nullable response,
                                                                       NSError * _Nullable error)
                                      {
                                          // Here we access HTTP data , Status codes, and JSON
                                          // If we don't get a 200 status code, error will not be nil
                                          if (error)
                                          {
                                              NSLog(@"Error getting data");
                                          }
                                          else
                                          {
                                              NSError *jsonError = nil;
                                              NSDictionary *readStuffDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
                                              
                                              if (jsonError)
                                              {
                                                  NSLog(@"jsonError: %@", jsonError.localizedDescription);
                                              }
                                              else
                                              {
                                                  NSLog(@"They are: %lu", (unsigned long)readStuffDict.count);
                                                  NSDictionary *temp = [readStuffDict objectForKey:@"photos"];
                                                  NSArray *temp2 = [temp objectForKey:@"photo"];
                                                  for(NSDictionary *any in temp2){
                                                      Photo *new = [Photo new];
                                                      new.url = [NSURL URLWithString:[any objectForKey:@"url_m"]];
                                                      new.title = [any objectForKey:@"title"];
                                                      new.photoId = [any objectForKey:@"id"];
                                                      [self.photos addObject:new];
                                                  }
                                                  
                                                  // Tell the main queue, to do somthing
                                                  dispatch_async(dispatch_get_main_queue(), ^{
                                                      [self done];
                                                  });
                                              }
                                          }
                                          
                                      }];
    
    [dataTask resume]; // Like saying start my request
    
    NSLog(@"view did load");
}
-(void)done{
    [self.delegate setPhotos:self.photos];
    [self.delegate setCoordinate:self.coordinate];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end

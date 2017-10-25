//
//  DetailViewController.m
//  CatMap
//
//  Created by Aaron Johnson on 2017-10-24.
//  Copyright © 2017 Aaron Johnson. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if(!_photos){
        self.title = self.photo.title;
        [self locationOfPhoto:self.photo];
    } else {
        self.title = @"All";
        for(Photo *any in self.photos){
            [self locationOfPhoto:any];
        }
    }
}
-(void)hello{
    MKCoordinateSpan span = MKCoordinateSpanMake(.5f, .5f);
    self.myMapView.region = MKCoordinateRegionMake(self.photo.coordinate, span);
    [self.myMapView addAnnotation:self.photo];
}
-(void)bye{
    MKCoordinateSpan span = MKCoordinateSpanMake(.5f, .5f);
    self.myMapView.region = MKCoordinateRegionMake(self.me.coordinate, span);
    [self.myMapView addAnnotations:self.photos];
}

-(void)locationOfPhoto:(Photo *)photo{
    //https://api.flickr.com/services/rest/?method=flickr.photos.geo.getLocation&api_key=b9e8e163b77044fdadc7c1e29f8286c8&photo_id={photo id}&format=json&nojsoncallback=1
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.flickr.com/services/rest/?method=flickr.photos.geo.getLocation&api_key=b9e8e163b77044fdadc7c1e29f8286c8&photo_id=%@&format=json&nojsoncallback=1", photo.photoId]];
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
                                                  NSDictionary *temp = [readStuffDict objectForKey:@"photo"];
                                                  NSDictionary *temp2 = [temp objectForKey:@"location"];
                                                  double latitude = [[temp2 objectForKey:@"latitude"] doubleValue];
                                                  double longitude = [[temp2 objectForKey:@"longitude"] doubleValue];
                                                  
                                                  // Tell the main queue, to do somthing
                                                                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                         photo.coordinate = CLLocationCoordinate2DMake(latitude, longitude);                                               if(!self.photos){
                                                                                                            [self hello];                                       } else if([photo isEqual: self.photos.lastObject]) {
                                                                                            [self bye];
                                                                                                            }                                          });
                                              }
                                          }
                                          
                                      }];
    
    [dataTask resume]; // Like saying start my request
}

@end

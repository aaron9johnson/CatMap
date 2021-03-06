//
//  ViewController.m
//  CatMap
//
//  Created by Aaron Johnson on 2017-10-24.
//  Copyright © 2017 Aaron Johnson. All rights reserved.
//

#import "ViewController.h"
#import "MyCollectionViewCell.h"
#import "Photo.h"
#import <MapKit/MapKit.h>
#import "DetailViewController.h"
#import "SearchViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *myCollectionView;

@end

@implementation ViewController
- (IBAction)showAll:(UIBarButtonItem *)sender {
    [self performSegueWithIdentifier:@"mySegue" sender:@"ALL"];
}
- (IBAction)search:(UIBarButtonItem *)sender {
    [self performSegueWithIdentifier:@"searchSegue" sender:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _photos = [NSMutableArray new];
    [self catsFromFlicker];
}
-(void)viewDidAppear:(BOOL)animated{
    [self.myCollectionView reloadData];
}
-(void)catsFromFlicker{
    //https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=b9e8e163b77044fdadc7c1e29f8286c8&tags=cat&has_geo=1&extras=url_m&format=json&nojsoncallback=1
    
    //https://api.flickr.com/services/rest/?method=flickr.photos.geo.getLocation&api_key=b9e8e163b77044fdadc7c1e29f8286c8&photo_id={photo id}&format=json&nojsoncallback=1
    NSURL *url = [NSURL URLWithString:@"https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=b9e8e163b77044fdadc7c1e29f8286c8&tags=cat&has_geo=1&extras=url_m&format=json&nojsoncallback=1"];
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
                                                      [self.myCollectionView reloadData];
                                                  });
                                              }
                                          }
                                          
                                      }];
    
    [dataTask resume]; // Like saying start my request
    
    NSLog(@"view did load");
}
- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    MyCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"myCell" forIndexPath:indexPath];
    
    Photo *temp = self.photos[indexPath.item];
    cell.myImageView.image = temp.image;
    cell.myLabel.text = temp.title;
    
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.photos.count;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"mySegue" sender:indexPath];
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"mySegue"]){
        DetailViewController *dVC = [segue destinationViewController];
        if([sender isKindOfClass:[NSString class]]){
            dVC.photos = self.photos;
        } else {
            NSIndexPath *indexPath = sender;
            dVC.photo = self.photos[indexPath.row];
        }
        dVC.me = self;
        
    }
    if([segue.identifier isEqualToString:@"searchSegue"]){
        SearchViewController *sVC = [segue destinationViewController];
        sVC.delegate = self;
    }
    
}


@end

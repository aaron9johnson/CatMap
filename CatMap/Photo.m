//
//  Photo.m
//  CatMap
//
//  Created by Aaron Johnson on 2017-10-24.
//  Copyright © 2017 Aaron Johnson. All rights reserved.
//

#import "Photo.h"

@implementation Photo
-(UIImage *)image{
    if(!_image){
        //get image from URL
        NSData *imageData = [[NSData alloc] initWithContentsOfURL:_url];
        _image = [UIImage imageWithData: imageData];
    }
    return _image;
}
@end

//
//  User.h
//  cookerybook
//
//  Created by hmy2015 on 15/10/11.
//  Copyright (c) 2015年 何米颖大天才. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface User : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * foodId;
@property (nonatomic, retain) NSString * albums;
@property (nonatomic, retain) NSString * tags;
@property (nonatomic, retain) NSNumber * isCollection;

@end

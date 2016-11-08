//
//  TableViewTools.h
//  NetworkingTest
//
//  Created by malizhi on 16/11/7.
//  Copyright © 2016年 LzNews. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TableViewCellStyle) {
     TableViewCellStyleOne = 1,
     TableViewCellStyleTwo = 2,
     TableViewCellStyleThree = 3,
     TableViewCellStyleFour = 4,
    
};

@interface TableViewTools : NSObject

@property (nonatomic, strong) NSMutableArray *dataList;

- (instancetype)initWithTableViewFrame:(CGRect)tableViewFrame;

@end

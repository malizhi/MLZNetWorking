//
//  TableViewTools.m
//  NetworkingTest
//
//  Created by malizhi on 16/11/7.
//  Copyright © 2016年 LzNews. All rights reserved.
//

#define kTableViewCellTypeStyle    [[dataListDict objectForKey:@"type"] integerValue]

#import "TableViewTools.h"

@interface TableViewTools()

@property (nonatomic, assign) CGRect tablevViewFrame;

@end

@implementation TableViewTools

- (void)dealloc
{
    NSLog(@"FHSubHomeTableViewTool -> dealloc");
}

- (instancetype)initWithTableViewFrame:(CGRect)tableViewFrame
{
    self = [super init];
    if (self) {
        
        _tablevViewFrame = tableViewFrame;
        
    }
    return self;
}

#pragma mark table view delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.dataList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary *dataListDict = [self.dataList objectAtIndex:section];
    NSArray *array = [dataListDict objectForKey:@"itemList"];
    return array.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dataListDict = [self.dataList objectAtIndex:indexPath.section];
    return [dataListDict[@"cellHeight"] floatValue];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    NSDictionary *dataListDict = [self.dataList objectAtIndex:section];
    return [dataListDict.allKeys containsObject:@"headerHeight"] ? [dataListDict[@"headerHeight"] floatValue]:0;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSDictionary *dataListDict = [self.dataList objectAtIndex:section];
    
    CGRect headerRect = [dataListDict.allKeys containsObject:@"headerViewRect"] ? [dataListDict[@"headerViewRect"] CGRectValue]:CGRectZero ;
    
    switch (kTableViewCellTypeStyle) {
        case TableViewCellStyleOne:
            
            break;
        case TableViewCellStyleTwo:
            
            break;
        case TableViewCellStyleThree:
            
            break;
        case TableViewCellStyleFour:
            break;
        default:
            break;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    NSDictionary *dataListDict = [self.dataList objectAtIndex:section];
    return [dataListDict.allKeys containsObject:@"footerHeight"] ? [dataListDict[@"footerHeight"] floatValue]:0;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    NSDictionary *dataListDict = [self.dataList objectAtIndex:section];
    
    CGRect footerRect = [dataListDict.allKeys containsObject:@"footerViewRect"] ? [dataListDict[@"footerViewRect"] CGRectValue]:CGRectZero ;
    
    switch (kTableViewCellTypeStyle) {
        case TableViewCellStyleOne:
            
            break;
        case TableViewCellStyleTwo:
            
            break;
        case TableViewCellStyleThree:
            
            break;
        case TableViewCellStyleFour:
            
            break;
        default:
            break;
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dataListDict = [self.dataList objectAtIndex:indexPath.section];
    switch (kTableViewCellTypeStyle) {
        case TableViewCellStyleOne:
            
            break;
        case TableViewCellStyleTwo:
            
            break;
        case TableViewCellStyleThree:
            
            break;
        case TableViewCellStyleFour:
            
            break;
        default:
            
            break;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dataListDict = [self.dataList objectAtIndex:indexPath.section];
    switch (kTableViewCellTypeStyle) {
        case TableViewCellStyleOne:
            
            break;
        case TableViewCellStyleTwo:
            
            break;
        case TableViewCellStyleThree:
            
            break;
        case TableViewCellStyleFour:
            
            break;
        default:
            break;
    }
}

@end

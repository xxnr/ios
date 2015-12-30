//
//  BSDatabaseOperation.h
//  BigStrongExtKit
//
//  Created by 董富强 on 15/9/22.
//  Copyright (c) 2015年 董富强. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface BSDatabaseOperationItem : NSObject

@property (strong, nonatomic) NSString *itemId;
@property (strong, nonatomic) id itemObject;
@property (strong, nonatomic) NSDate *createdTime;
@property (nonatomic, strong) NSString *brandName;

@end




@interface BSDatabaseOperation : NSObject



- (id)initDBWithName:(NSString *)dbName;

- (id)initWithDBWithPath:(NSString *)dbPath;

- (BOOL)createTableWithName:(NSString *)tableName;

- (BOOL)clearTable:(NSString *)tableName;

- (void)close;

///************************ Put&Get methods *******************************

- (BOOL)putObject:(id)object withId:(NSString *)objectId intoTable:(NSString *)tableName;
- (id)getObjectById:(NSString *)objectId fromTable:(NSString *)tableName;

- (BSDatabaseOperationItem *)getBSDatabaseOperationItemById:(NSString *)objectId fromTable:(NSString *)tableName;

- (NSArray *)getAllTheBrandIdGoodsWith:(NSString *)brandName fromTable:(NSString *)tableName;


- (void)putString:(NSString *)string withId:(NSString *)stringId intoTable:(NSString *)tableName;

- (NSString *)getStringById:(NSString *)stringId fromTable:(NSString *)tableName;

- (void)putNumber:(NSNumber *)number withId:(NSString *)numberId intoTable:(NSString *)tableName;

- (NSNumber *)getNumberById:(NSString *)numberId fromTable:(NSString *)tableName;

- (NSArray *)getAllItemsFromTable:(NSString *)tableName;

- (BOOL)deleteObjectById:(NSString *)objectId fromTable:(NSString *)tableName;

- (BOOL)deleteObjectsByIdArray:(NSArray *)objectIdArray fromTable:(NSString *)tableName;

- (BOOL)deleteObjectsByIdPrefix:(NSString *)objectIdPrefix fromTable:(NSString *)tableName;


@end

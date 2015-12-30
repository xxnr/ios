//
//  DatabaseManager.h
//  dongyueiOS
//
//  Created by ZSC on 15/4/28.
//
//

#import <Foundation/Foundation.h>
#import "XNRShoppingCartModel.h"
@interface DatabaseManager : NSObject

//单例
+(id)sharedInstance;

/**
 *  查询所有购物车商品
 *
 *  @return 商品模型数组
 */
- (NSArray *)queryAllGood;

/**
 *  查询某个商品
 *
 *  @param model 购物车模型数组
 *
 *  @return 某个商品数组
 */
- (NSArray *)queryGoodWithModel:(XNRShoppingCartModel *)model;

/**
 *  查询商品品牌数组
 *
 *  @param model 购物车模型数组
 *
 *  @return 商品品牌数组
 */
- (NSArray *)queryTypeGoodWithBrandName:(NSString *)brandName;

/**
 *  插入数据
 *
 *  @param model 购物车模型数组
 *
 *  @return 是否成功
 */
- (BOOL)insertShoppingCarWithModel:(XNRShoppingCartModel *)model;

/**
 *  更新购物车数据
 *
 *  @param model 购物车模型数组
 *
 *  @return 是否成功
 */
- (BOOL)updateShoppingCarWithModel:(XNRShoppingCartModel *)model;

/**
 *  清空购物车表
 *
 *  @return 是否成功
 */
-(BOOL)deleteShoppingCar;

/**
 *  删除某个商品
 *
 *  @param model 购物车模型数组
 *
 *  @return 是否成功
 */
-(BOOL)deleteShoppingCarWithModel:(XNRShoppingCartModel *)model;
/**
 *  获取购物车累加数(为了排序同时防止用户修改系统时间)
 *
 *  @return 累加数值
 */
- (NSString *)shoppingCarCount;

@end

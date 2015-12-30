//
//  DatabaseManager.m
//  dongyueiOS
//
//  Created by ZSC on 15/4/28.
//
//

#import "DatabaseManager.h"
#import "FMDatabase.h"
#import "BSDatabaseOperation.h"
#import "MJExtension.h"
@implementation DatabaseManager
{
    FMDatabase *_database;
    NSString *tableName;
    BSDatabaseOperation *store;
}

//单例
+(id)sharedInstance
{
    //此种单例创建优点
    //1. 线程安全。
    //2. 满足静态分析器的要求。
    //3. 兼容了ARC
    static DatabaseManager *dm = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dm = [[self alloc]init];
    });
    return dm;
}

//需要初始化数据库
-(id)init {
    if (self = [super init]) {
        [self initDatabase];
    }
    return self;
}

-(void)initDatabase {
    tableName = @"ShoppingCar";
    store = [[BSDatabaseOperation alloc] initDBWithName:@"xxnrData.db"];
    //创建购物车表
    [store createTableWithName:tableName];
}


//查询所有购物车商品
- (NSArray *)queryAllGood {
    NSArray *arr = [XNRShoppingCartModel objectArrayWithKeyValuesArray:[store getAllItemsFromTable:tableName]];
    NSLog(@"--->>>>>>>查询购物车所有商品：%@",arr);
    if (arr) {
        return arr;
    } else {
        return nil;
    }
}

//查询某个商品
- (NSArray *)queryGoodWithModel:(XNRShoppingCartModel *)model {
    BSDatabaseOperationItem *item = [store getBSDatabaseOperationItemById:model.goodsId fromTable:tableName];
    
    NSDictionary *dic = (NSDictionary *)item.itemObject;
    NSArray *oneItem;
    if (dic) {
        oneItem = @[[XNRShoppingCartModel objectWithKeyValues:dic]];
    } else {
        oneItem = nil;
    }
    
    NSLog(@"--->>>>>>>查询特定ID某个商品（存进数组）：%@",oneItem);
    return oneItem;
}

//查询商品品牌数组
- (NSArray *)queryTypeGoodWithBrandName:(NSString *)brandName {
    NSArray *arr =[XNRShoppingCartModel objectArrayWithKeyValuesArray:[store getAllTheBrandIdGoodsWith:brandName fromTable:tableName]];
    NSLog(@"--->>>>>>>查询某个品牌的所有商品（存进数组）：%@",arr);
    return arr;
}

//插入数据
- (BOOL)insertShoppingCarWithModel:(XNRShoppingCartModel *)model {
    NSLog(@"++++++++++新增商品:%@",model);
    NSDictionary *dic  = [model keyValues];
    return [store putObject:dic withId:model.goodsId intoTable:tableName];
}

//更新购物车数据
- (BOOL)updateShoppingCarWithModel:(XNRShoppingCartModel *)model {
    NSLog(@"++++++++++更新商品:%@",model);
    
    return [self insertShoppingCarWithModel:model];
}

//清空购物车表
-(BOOL)deleteShoppingCar {
    NSLog(@"清空数据库%@",[store clearTable:tableName]?@"成功":@"失败");
    //本地累加数清零
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"shoppingCarCount"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    return [store clearTable:tableName];
}

//删除某个商品
-(BOOL)deleteShoppingCarWithModel:(XNRShoppingCartModel *)model {
    return [store deleteObjectById:model.goodsId fromTable:tableName];
}

//获取累加数
- (NSString *)shoppingCarCount {
    NSInteger shoppingCarCount = [[NSUserDefaults standardUserDefaults] integerForKey:@"shoppingCarCount"];
    [[NSUserDefaults standardUserDefaults] setInteger:shoppingCarCount+1 forKey:@"shoppingCarCount"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    return [NSString stringWithFormat:@"%d",(int)shoppingCarCount];
}

@end

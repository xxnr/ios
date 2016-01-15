//
//  XNRBusinessLogic.h
//  xinnongreniOS
//
//  Created by xxnr on 15/11/24.
//  Copyright © 2015年 qxhiOS. All rights reserved.
//

#ifndef XNRBusinessLogic_h
#define XNRBusinessLogic_h

/**--------------------
 登录、注册、用户相关
 --------------------*/
/**
 *  1.登陆
 */
#define KUserLogin [NSString stringWithFormat:@"%@/%@",HOST,@"api/v2.0/user/login"]
/**
 *  2.注册
 */
#define KUserRegister [NSString stringWithFormat:@"%@/%@",HOST,@"api/v2.0/user/register"]
/**
 *  短信验证码
 */
#define KUserSms [NSString stringWithFormat:@"%@/%@",HOST,@"api/v2.0/sms"]
/**
 *  用户找回密码
 */
#define KUserResetpwd [NSString stringWithFormat:@"%@/%@",HOST,@"api/v2.0/user/resetpwd"]
/**
 *  获取用户信息
 */
#define KUserGet [NSString stringWithFormat:@"%@/%@",HOST,@"api/v2.0/user/get"]
/**
 *  获取用户积分
 */
#define KUserFindPointList [NSString stringWithFormat:@"%@/%@",HOST,@"api/v2.0/point/findPointList"]
/**
 *  用户重置密码
 */
#define KUserModifypwd [NSString stringWithFormat:@"%@/%@",HOST,@"api/v2.0/user/modifypwd"]
/**
 *  用户重置信息
 */
#define KUserModify [NSString stringWithFormat:@"%@/%@",HOST,@"api/v2.0/user/modify"]
/**
 *  查找是否有此用户
 */
#define KUserFindAccount [NSString stringWithFormat:@"%@/%@",HOST,@"api/v2.0/user/findAccount"]
/**
 *  获取下线列表
 */
#define KUserGetInvitee [NSString stringWithFormat:@"%@/%@",HOST,@"api/v2.0/user/getInvitee"]
/**
 *  用户绑定邀请人
 */
#define KUserBindInviter [NSString stringWithFormat:@"%@/%@",HOST,@"api/v2.0/user/bindInviter"]
/**
 *  获取被邀请客户的订单列表
 */
#define KgetInviteeOrders [NSString stringWithFormat:@"%@/%@",HOST,@"api/v2.0/user/getInviteeOrders"]

/**
 *  用户上传头像
 */
#define KUserUploadPortrait [NSString stringWithFormat:@"%@/%@",HOST,@"api/v2.0/user/uploadPortrait"]
/**
 *  公钥加密
 */
#define KUserPubkey [NSString stringWithFormat:@"%@/%@",HOST,@"api/v2.0/user/getpubkey"]
/**
 *  用户签到
 */
#define KUserSign [NSString stringWithFormat:@"%@/%@",HOST,@"api/v2.0/user/sign"]


/**--------------------
        首页
 --------------------*/
/**
 *  首页轮播图
 */
#define KHomeGetAdList [NSString stringWithFormat:@"%@/%@",HOST,@"api/v2.0/ad/getAdList"]

/**
 *  获取商品分类 get
 */
#define KHomeCategories [NSString stringWithFormat:@"%@/%@",HOST,@"api/v2.0/products/categories"]
/**
 *  获取商品的各个属性类型 get
 */
#define KHomeProducts [NSString stringWithFormat:@"%@/%@",HOST,@"api/v2.0/products"]
/**
 *  获取商品列表 get
 */
#define KHomeGetProductsListPage [NSString stringWithFormat:@"%@/%@",HOST,@"api/v2.0/product/getProductsListPage"]
/**
 *  获取商品详情信息
 */
#define KHomeGetAppProductDetails [NSString stringWithFormat:@"%@/%@",HOST,@"api/v2.0/product/getAppProductDetails"]

/**--------------------
      咨询
 --------------------*/

/**
 *  获取资讯分类
 */
#define KMessageCategories [NSString stringWithFormat:@"%@/%@",HOST,@"api/v2.0/news/categories"]
/**
 *  查找资讯
 */
#define KMessageNews [NSString stringWithFormat:@"%@/%@",HOST,@"api/v2.0/news"]
/**
 *  获取资讯
 */
#define KMessageNewid [NSString stringWithFormat:@"%@/%@",HOST,@"api/v2.0/newid"]

/**--------------------
      购物车
 --------------------*/


/**
 *  获取购物车
 */
#define KGetShoppingCart [NSString stringWithFormat:@"%@/%@",HOST,@"api/v2.0/getShoppingCart"]
/**
 *  更新购物车
 */
#define KUpdateShoppingCart [NSString stringWithFormat:@"%@/%@",HOST,@"api/v2.0/updateShoppingCart"]
/**
 *  获取购物车列表
 */
#define KGetShopCartList [NSString stringWithFormat:@"%@/%@",HOST,@"api/v2.0/shopCart/getShopCartList"]
/**
 *  修改购物车商品数量
 */
#define KchangeShopCarNum [NSString stringWithFormat:@"%@/%@",HOST,@"api/v2.0/shopCart/changeNum"]
/**
 *  添加购物车
 */
#define KAddToCart [NSString stringWithFormat:@"%@/%@",HOST,@"api/v2.0/shopCart/addToCart"]
/**
 *  根据商品ID list获取购物车列表
 */
#define KGetShoppingCartOffline [NSString stringWithFormat:@"%@/%@",HOST,@"api/v2.0/getShoppingCartOffline"]
/**--------------------
  收货地址，地理位置相关
 --------------------*/
/**
 *  获取用户收货地址
 */
#define KGetUserAddressList [NSString stringWithFormat:@"%@/%@",HOST,@"api/v2.0/user/getUserAddressList"]
/**
 *  保存用户收货地址
 */
#define KSaveUserAddress [NSString stringWithFormat:@"%@/%@",HOST,@"api/v2.0/user/saveUserAddress"]
/**
 *  更新用户收货地址
 */
#define KUpdateUserAddress [NSString stringWithFormat:@"%@/%@",HOST,@"api/v2.0/user/updateUserAddress"]
/**
 *  删除用户收货地址
 */
#define KDeleteUserAddress [NSString stringWithFormat:@"%@/%@",HOST,@"api/v2.0/user/deleteUserAddress"]
/**
 *  用户类型
 */
#define Kusertypes [NSString stringWithFormat:@"%@/%@",HOST,@"api/v2.0/usertypes"]



/**
 *  获取全国省的list
 */
#define KGetAreaList [NSString stringWithFormat:@"%@/%@",HOST,@"api/v2.0/area/getAreaList"]
/**
 *  获取全国市的list
 */
#define KGetBusinessByAreaId [NSString stringWithFormat:@"%@/%@",HOST,@"api/v2.0/businessDistrict/getBusinessByAreaId"]
/**
 *  获取全国县的list
 */
#define KGetBuildByBusiness [NSString stringWithFormat:@"%@/%@",HOST,@"api/v2.0/build/getBuildByBusiness"]
/**
 *  获取全国乡镇的list
 */
#define KGetAreaTown [NSString stringWithFormat:@"%@/%@",HOST,@"api/v2.0/area/getAreaTown"]


/**--------------------
    订单相关
 --------------------*/
/**
 *  确认订单
 */
#define KConfirmeOrder [NSString stringWithFormat:@"%@/%@",HOST,@"api/v2.0/order/confirmeOrder"]
/**
 *  获取订单列表
 */
#define KGetOderList [NSString stringWithFormat:@"%@/%@",HOST,@"api/v2.0/order/getAppOrderList"]

/**
 *  生成订单
 */
#define KAddOrder [NSString stringWithFormat:@"%@/%@",HOST,@"api/v2.0/order/addOrder"]

/**
 *  获取订单详情
 */
#define KGetOrderDetails [NSString stringWithFormat:@"%@/%@",HOST,@"api/v2.0/order/getOrderDetails"]

/**
 *  更新订单支付方式
 */
#define KUpdateOrderPaytype [NSString stringWithFormat:@"%@/%@",HOST,@"api/v2.0/order/updateOrderPaytype"]
/**
 *  银联支付获取tn等信息
 */
#define KUnionpay [NSString stringWithFormat:@"%@/%@",HOST,@"unionpay"]
/**
 *  支付宝支付
 */
#define KAlipay [NSString stringWithFormat:@"%@/%@",HOST,@"alipay"]
/**
 *  支付宝支付成功页面
 */
#define KAlipaySuccess [NSString stringWithFormat:@"%@/%@",HOST,@"alipay/success"]
/**
 *  支付宝确认
 */
#define KDynamic [NSString stringWithFormat:@"%@/%@",HOST,@"dynamic/alipay/nofity.asp"]



#endif

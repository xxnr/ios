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

//获取新农代表
#define KGetNominatedInviter [NSString stringWithFormat:@"%@/%@",HOST,@"api/v2.1/user/getNominatedInviter"]

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
/**
 *  获取用户类型列表
 */
#define Kusertypes [NSString stringWithFormat:@"%@/%@",HOST,@"api/v2.0/usertypes"]
/**
 *  提示用户更新
 */
#define KuserUpData [NSString stringWithFormat:@"%@/%@",HOST,@"api/v2.1/ISOupgrade"]

/**
 *  用户选择自提方式时获取收货人列表
 */

#define KqueryConsignees [NSString stringWithFormat:@"%@/%@",HOST,@"api/v2.2/user/queryConsignees"]
/**
 *用户选择自提方式时保存收货人
 */
#define KsaveConsignees [NSString stringWithFormat:@"%@/%@",HOST,@"api/v2.2/user/saveConsignees"]

/**--------------------
        首页
 --------------------*/
/**
 *  首页轮播图
 */
#define KHomeGetAdList [NSString stringWithFormat:@"%@/%@",HOST,@"api/v2.0/ad/getAdList"]
/**
 *  获取商品的品牌
 */
#define KBrands [NSString stringWithFormat:@"%@/%@",HOST,@"/api/v2.1/brands"]
/**
 *  获取品牌的属性
 */
#define KAttibutes [NSString stringWithFormat:@"%@/%@",HOST,@"/api/v2.1/products/attributes"]

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
#define KHomeGetProductsListPage [NSString stringWithFormat:@"%@/%@",HOST,@"api/v2.1/product/getProductsListPage"]
/**
 *  获取商品详情信息
 */
#define KHomeGetAppProductDetails [NSString stringWithFormat:@"%@/%@",HOST,@"api/v2.0/product/getAppProductDetails"]
/**
 *  获取商品的sku
 */
#define KSkuquery [NSString stringWithFormat:@"%@/%@",HOST,@"api/v2.1/SKU/attributes_and_price/query"]


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
#define KGetShopCartList [NSString stringWithFormat:@"%@/%@",HOST,@"api/v2.1/cart/getShoppingCart"]
/**
 *  修改购物车商品数量
 */
#define KchangeShopCarNum [NSString stringWithFormat:@"%@/%@",HOST,@"api/v2.1/cart/changeNum"]
/**
 *  添加购物车
 */
#define KAddToCart [NSString stringWithFormat:@"%@/%@",HOST,@"api/v2.1/cart/addToCart"]
/**
 *  根据商品ID list获取购物车列表
 */
#define KGetShoppingCartOffline [NSString stringWithFormat:@"%@/%@",HOST,@"api/v2.1/cart/getShoppingCartOffline"]
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
 * 判断用户是否在白名单
 */
#define KisInWhiteList [NSString stringWithFormat:@"%@/%@",HOST,@"api/v2.0/user/isInWhiteList"]

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

/**
 *  获取报备用户列表
 */
#define KGetQuery [NSString stringWithFormat:@"%@/%@",HOST,@"api/v2.1/potentialCustomer/query"]

/**
 *  添加用户
 
 */
#define KGetAdd [NSString stringWithFormat:@"%@/%@",HOST,@"api/v2.1/potentialCustomer/add"]
/**
 *  判断手机号是否能添加为潜在客户
 */
#define KGetIsAvailable [NSString stringWithFormat:@"%@/%@",HOST,@"api/v2.1/potentialCustomer/isAvailable"]

/**
 *  获取意向商品列表
 */
#define KGetIntentionProducts [NSString stringWithFormat:@"%@/%@",HOST,@"api/v2.1/intentionProducts"]

/**
 *  获取报备用户详情
 */
#define KGetPotentialCustomer [NSString stringWithFormat:@"%@/%@",HOST,@"api/v2.1/potentialCustomer/get"]

/**--------------------
    订单相关
 --------------------*/
/**
 *  获取配送方式
 */
#define KGetDeliveries [NSString stringWithFormat:@"%@/%@",HOST,@"api/v2.2/cart/getDeliveries"]
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
#define KAddOrder [NSString stringWithFormat:@"%@/%@",HOST,@"api/v2.1/order/addOrder"]

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
 *  线下支付
 */
#define KOfflinepay [NSString stringWithFormat:@"%@/%@",HOST,@"offlinepay"]

/**
 *   线下支付方式
 */
#define KGetOfflinePayType [NSString stringWithFormat:@"%@/%@",HOST,@"api/v2.2/getOfflinePayType"]

/**
 *  支付宝支付成功页面
 */
#define KAlipaySuccess [NSString stringWithFormat:@"%@/%@",HOST,@"alipay/success"]
/**
 *  支付宝确认
 */
#define KDynamic [NSString stringWithFormat:@"%@/%@",HOST,@"dynamic/alipay/nofity.asp"]


/**
 *  获取支付的最小额度
 */
#define KgetMinPayPrice [NSString stringWithFormat:@"%@/%@",HOST,@"api/v2.0/getMinPayPrice/"]


/**
 *  确认收货
 */
#define KconfirmSKUReceived [NSString stringWithFormat:@"%@/%@",HOST,@"api/v2.2/order/confirmSKUReceived"]
/**
 *  获取自提码
 */
#define KgetDeliveryCode [NSString stringWithFormat:@"%@/%@",HOST,@"api/v2.2/order/getDeliveryCode"]

/**
 *  获取自提点省份列表
 */
#define KgetProvince [NSString stringWithFormat:@"%@/%@",HOST,@"api/v2.2/RSC/address/province"]
/**
 *  获取自提点城市列表
 */
#define KgetCity [NSString stringWithFormat:@"%@/%@",HOST,@"api/v2.2/RSC/address/city"]
/**
 *  获取自提点县列表
 */
#define KgetCounty [NSString stringWithFormat:@"%@/%@",HOST,@"api/v2.2/RSC/address/county"]
/**
 * 获取自提点列表
 */
#define KgetRSC [NSString stringWithFormat:@"%@/%@",HOST,@"api/v2.2/RSC"]
/**
 * 获取线下支付类型
 */
#define KgetOfflinePayType [NSString stringWithFormat:@"%@/%@",HOST,@"api/v2.2/getOfflinePayType"]
/**--------------------
 RSC相关
 --------------------*/
/**
 *  填写RSC相关信息
 */
#define KRscInfoFill [NSString stringWithFormat:@"%@/%@",HOST,@"api/v2.2/RSC/info/fill"]
/**
 *  获取RSC相关 get
 */
#define KRscInfoGet [NSString stringWithFormat:@"%@/%@",HOST,@"api/v2.2/RSC/info/get"]
/**
 *  获取自提点省份列表  get
 */
#define KRscProvince [NSString stringWithFormat:@"%@/%@",HOST,@"api/v2.2/RSC/address/province"]
/**
 *  获取自提点城市列表 get
 */
#define KRscCity [NSString stringWithFormat:@"%@/%@",HOST,@"api/v2.2/RSC/address/city"]
/**
 *  获取自提点县列表 get
 */
#define KRscCounty [NSString stringWithFormat:@"%@/%@",HOST,@"api/v2.2/RSC/address/county"]
/**
 *  获取乡镇列表  get
 */
#define KRscTown [NSString stringWithFormat:@"%@/%@",HOST,@"api/v2.2/RSC/address/town"]
/**
 *  网店审核线下付款
 */
#define KRscConfirmOfflinePay [NSString stringWithFormat:@"%@/%@",HOST,@"api/v2.2/RSC/confirmOfflinePay"]
/**
 *  获取分配到RSC的订单  get
 */
#define KRscOrders [NSString stringWithFormat:@"%@/%@",HOST,@"api/v2.2/RSC/orders"]
/**
 *  网点发货
 */
#define KRscDelivering [NSString stringWithFormat:@"%@/%@",HOST,@"api/v2.2/RSC/order/deliverStatus/delivering"]
/**
 *  获取自提点列表  get
 */
#define KRsc [NSString stringWithFormat:@"%@/%@",HOST,@"api/v2.2/RSC"]
/**
 *  网点自提
 */
#define KRscSelfDelivery [NSString stringWithFormat:@"%@/%@",HOST,@"api/v2.2/RSC/order/selfDelivery"]
/**
 *  获取订单详情   get
 */
#define KRscOrderDetail [NSString stringWithFormat:@"%@/%@",HOST,@"api/v2.2/RSC/orderDetail"]

/**
 *  确认收货
 */
#define KconfirmSKUReceived [NSString stringWithFormat:@"%@/%@",HOST,@"api/v2.2/order/confirmSKUReceived"]

#endif

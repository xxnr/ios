//
//  UMSCashierPlugin.h
//  UMSCashierPlugin
//
//  Created     by Ning Gang on 14-4-28.
//  Copyright (c) 2014年 UMS. All rights reserved.


#import <Foundation/Foundation.h>

typedef enum{
    
    CouponType_NO,                 //无优惠
    CouponType_CARD,               //卡打折
    CouponType_TICKET              //券打折


}CouponType;

typedef enum{
    PayStatus_PAYSUCCESS,              //交易成功
    PayStatus_PAYFAIL,                 //交易失败
    PayStatus_PAYTIMEOUT,              //交易超时
    PayStatus_PAYCANCEL,               //交易取消
    
    PayStatus_VOIDSUCCESS,              //撤销成功
    PayStatus_VOIDFAIL,                 //撤销失败
    PayStatus_VOIDTIMEOUT,              //撤销超时
    PayStatus_VOIDCANCEL                //撤销取消
    
}PayStatus;

typedef enum{
    PreAuthType_PREAUTH,               //预授权
    PreAuthType_PREAUTHFIN,            //预授权完成
    PreAuthType_PREAUTHCANCEL,         //预授权撤销
    PreAuthType_PREAUTHFINCANCEL,      //预授权完成撤销
    
}PreAuthType;

typedef enum{
    TransactionStatus_SUCCESS,              //成功
    TransactionStatus_FAIL,                 //失败
    TransactionStatus_TIMEOUT,              //超时
    TransactionStatus_CANCEL,               //取消
    
}TransactionStatus;

typedef enum{
    
    PayType_EPOS,           //刷卡支付
    PayType_MOBILE          //POS通支付
    
}PayType;

typedef enum{
    
    SalesSlipType_AUTO,               //根据设备型号决定签购单类型
    SalesSlipType_PAPER,              //纸质签购单
    SalesSlipType_ELECTRONIC          //电子签购单
    
}SalesSlipType;

typedef enum{
    
    PrintStatus_PRINTSUCCESS,             //打印成功
    PrintStatus_PRINTFAIL,                //打印失败
    PrintStatus_NOPAPER,                   //打印机无纸
    PrintStatus_UNPRINT                   //未打印
    
}PrintStatus;
typedef enum{
    
    SignatureStatus_SUCCESS,             //打印成功
    SignatureStatus_FAIL,                //打印失败
    SignatureStatus_OUTTIME,            //超时
    SignatureStatus_UNUPLOAD            //未上送
}SignatureStatus;
typedef enum
{
    PaperResult_OK,     //小票打印成功
    PaperResult_NO_PAPER,  //缺纸
    PaperResult_FAIL     //小票打印失败
}PaperResult;

typedef enum {
    InquiryStatus_SUCCESS,  //余额查询成功
    InquiryStatus_FAIL,     //余额查询失败
    InquiryStatus_CANCEL,   //余额查询取消
    InquiryStatus_TIMEOUT   //余额查询超时
}InquiryStatus;

typedef enum {
    RealNameAuthStatus_SUCCESS, //实名认证成功
    RealNameAuthStatus_FAIL,    //实名认证失败
    RealNameAuthStatus_CANCEL,  //实名认证取消
    RealNameAuthStatus_TIMEOUT  //实名认证超时
}RealNameAuthStatus;

@protocol UMSCashierPluginDelegate <NSObject>

@optional

/*
 orderId    订单号;
 orderTime  订单时间;
 resultStatus  返回状态;
 resultInfo   错误信息;
 memo         备注
 */
//下单结果回调
-(void)onUMSBookOrderResult:(NSDictionary *)dict;

/*
 // 支付成功返回
 acqNo  收单机构号;
 amount 金额;
 batchNo    出账机构批次号;
 billsMID   出账商户号;
 billsMercName 出账商户名;
 billsTID   出账终端号;
 resultStatus    返回状态;
 resultInfo    错误信息;
 expireDate  信用卡有效期;
 issNo  发卡机构号;
 merchantId 受卡方标识码;
 operator 操作员;
 orderId 订单号;
 pAccount 银行卡号;
 refId 索引参考号;
 termId 受卡方终端标识码;
 dealDate 交易日期;
 dealTime 交易时间;
 txnType 交易类型;
 voucherNo 授权码;
 // 支付失败返回
 resultStatus    返回状态;
 resultInfo    错误信息;
 // 支付超时返回
 resultStatus    错误码;
 resultInfo    错误信息;
 // 支付取消不返回结果
 */
//支付结果回调 退货也用此回调
-(void)onPayResult:(PayStatus) payStatus PrintStatus:(PrintStatus) printStatus SignatureStatus:(SignatureStatus)uploadStatus withInfo:(NSDictionary *)dict;

/*
 orderId    订单号;
 orderState  订单状态;
 payState   支付状态
 amount   订单金额;
 serverTime    服务器时间
 bankCardId    银行卡号
 bankName      银行卡名称
 boxId         盒子号
 resultStatus    返回状态;
 resultInfo    错误信息;
 memo          备注
 */

//订单查询回调
-(void)onUMSQueryOrder:(NSDictionary *)dict;

/*
 printStatus  补发签购单状态
 msg          错误信息
 */

//补发签购单回调
-(void)onUMSSignOrder:(PrintStatus) printStatus SignatureStatus:(SignatureStatus)uploadStatus message:(NSString *)msg;


/*
 resultStatus  返回状态
 resultInfo    错误信息
 deviceId      设备号
 */
//设备激活回调
-(void)onUMSSetupDevice:(BOOL) resultStatus resultInfo:(NSString *)resultInfo withDeviceId:(NSString *)deviceId;

//打印小票回调
-(void)onUMSPrint:(PaperResult) status;

/*
 resultStatus  返回状态
 resultInfo    错误信息
 csn           CSN号
 */
//获取CSN回调
-(void)onUMSGetCSN:(BOOL)resultStatus withCSN:(NSString *)csn;

/**
 *  预授权回调(包括预授权, 预授权完成, 预授权撤销, 预授权完成撤销)
 *
 *  @param preAuthType       预授权业务类型
 *  @param transactionStatus 返回业务状态
 *  @param printStatus       打印状态
 *  @param printStatus       签购单打印状态
 *  @param dict              预授权返回信息
 */
-(void)onUMSPreAuth:(PreAuthType)preAuthType TransactionStatus:(TransactionStatus)transactionStatus PrintStatus:(PrintStatus) printStatus SignatureStatus:(SignatureStatus)uploadStatus withInfo:(NSDictionary *)dict;

/**
 *  获取SDK信息回调
 *
 *  @param dic 回调信息 environment:0测试1生产  versionName:版本号
 */
-(void)onUMSCheckCurrentEnv:(NSDictionary *)dic;


/**
 * 获取卡号回调
 */
-(void)onUMSReturnCardNum:(NSDictionary *)dic;

/**
 *  联机退货回调
 *  @param transactionStatus 返回业务状态
 *  @param printStatus       打印状态
 *  @param printStatus       签购单打印状态
 *  @param dict              联机退货返回信息
 */
-(void)onUMSRefund:(TransactionStatus)transactionStatus PrintStatus:(PrintStatus) printStatus SignatureStatus:(SignatureStatus)uploadStatus withInfo:(NSDictionary *)dict;


@end

/*=================================================================================================================================*/

@interface UMSCashierPlugin : NSObject

/**
*  设备激活
*
*  @param billsMID   出账商户号
*  @param billsTID   出账商户终端号
*  @param controller 调用接口的UIViewController
*  @param delegate   回调
*/
+(void)setupDevice:(NSString *)billsMID BillsTID:(NSString *) billsTID WithViewController:(UIViewController *)controller Delegate:(id<UMSCashierPluginDelegate>)delegate;

/**
 *  下单(已过时)
 *
 *  @param amount       金额，单位为分
 *  @param merorderId   商户订单号
 *  @param merOrderDesc 商户订单号描述
 *  @param billsMID     出账商户号
 *  @param billsTID     出账商户终端号
 *  @param operatorID   操作员号
 *  @param delegate     回调
 */
+(void)bookOrder:(NSString*)amount MerorderId:(NSString *)merorderId MerOrderDesc:(NSString *)merOrderDesc BillsMID:(NSString *)billsMID BillsTID:(NSString *) billsTID operator:(NSString *)operatorID Delegate:(id<UMSCashierPluginDelegate>)delegate;

/**
 *  订单支付(已过时)
 *
 *  @param orderId       下单后返回的订单号
 *  @param billsMID      出账商户号
 *  @param billsTID      出账商户终端号
 *  @param controller    调用接口的UIViewController
 *  @param delegate      回调
 *  @param salesSlipType 签购单类型
 *  @param payType       支付类型
 */
+(void)payOrder:(NSString *)orderId BillsMID:(NSString *)billsMID BillsTID:(NSString *) billsTID
WithViewController:(UIViewController *)controller Delegate:(id<UMSCashierPluginDelegate>)delegate SalesSlipType:(SalesSlipType) salesSlipType PayType:(PayType)payType;

/**
 *  支付(消费) (推荐使用)
 *
 *  @param amount        金额,单位为分
 *  @param merorderId    商户订单号
 *  @param merOrderDesc  商户订单号描述
 *  @param billsMID      出账商户号
 *  @param billsTID      出账商户终端号
 *  @param salesSlipType 签购单类型
 *  @param payType       支付方式
 *  @param operatorID    操作员号
 *  @param consumerPhone 消费者手机号
 *  @param memo          备注
 *  @param couponType    优惠类型
 *  @param couponNo      优惠券码
 *  @param controller    调用接口的UIViewController
 *  @param delegate      回调
 */
+(void)pay:(NSString *)amount IsShowOrderInfo:(NSString *)isShowOrderInfo MerorderId:(NSString *)merorderId MerOrderDesc:(NSString *)merOrderDesc BillsMID:(NSString *)billsMID BillsTID:(NSString *) billsTID SalesSlipType:(SalesSlipType) salesSlipType PayType:(PayType)payType OperatorID:(NSString *)operatorID ConsumerPhone:(NSString *)consumerPhone Memo:(NSString *)memo couponType:(CouponType)conponType couponNo:(NSString * )couponNo WithViewController:(UIViewController *)controller Delegate:(id<UMSCashierPluginDelegate>)delegate;

/**
 *  订单查询(已过时)
 *
 *  @param orderId  订单号
 *  @param billsMID 出账商户号
 *  @param billsTID 出账商户终端号
 *  @param delegate 回调
 */
+(void)queryOrder:(NSString *)orderId BillsMID:(NSString *)billsMID BillsTID:(NSString *) billsTID Delegate:(id<UMSCashierPluginDelegate>)delegate;

/**
 *  订单查询 (推荐使用)
 *
 *  @param orderId    银商订单号(如果有,有优先使用)
 *  @param merorderId 商户订单号
 *  @param billsMID   出账商户号
 *  @param billsTID   出账商户终端号
 *  @param delegate   回调
 */
+(void)queryOrder:(NSString *)orderId MerorderId:(NSString *)merorderId BillsMID:(NSString *)billsMID BillsTID:(NSString *) billsTID Delegate:(id<UMSCashierPluginDelegate>)delegate;

/**
 *  交易撤销 (已过时)
 *
 *  @param orderId       下单后返回的订单号
 *  @param billsMID      出账商户号
 *  @param billsTID      出账商户终端号
 *  @param controller    调用接口的UIViewController
 *  @param delegate      回调
 *  @param salesSlipType 签购单类型
 */
+(void)voidPayOrder:(NSString *)orderId BillsMID:(NSString *)billsMID BillsTID:(NSString *) billsTID
 WithViewController:(UIViewController *)controller Delegate:(id<UMSCashierPluginDelegate>)delegate SalesSlipType:(SalesSlipType) salesSlipType;

/**
 *  支付(消费)撤销 (推荐使用)
 *
 *  @param orderId       银商订单号
 *  @param merorderId    商户订单号
 *  @param billsMID      出账商户号
 *  @param billsTID      出账商户终端号
 *  @param controller    调用接口的UIViewController
 *  @param operatorID    操作员号
 *  @param memo          备注
 *  @param delegate      回调
 *  @param salesSlipType 签购单类型
 */
+(void)voidPayOrder:(NSString *)orderId MerorderId:(NSString *)merorderId BillsMID:(NSString *)billsMID BillsTID:(NSString *) billsTID
 OperatorID:(NSString *)operatorID Memo:(NSString *)memo WithViewController:(UIViewController *)controller Delegate:(id<UMSCashierPluginDelegate>)delegate SalesSlipType:(SalesSlipType) salesSlipType;

/**
 *  补发签购单
 *
 *  @param orderId       银商订单号
 *  @param billsMID      出账商户号
 *  @param billsTID      出账商户终端号
 *  @param controller    调用接口的UIViewController
 *  @param delegate      回调
 *  @param salesSlipType 签购单类型
 */
+(void)signOrder:(NSString *)orderId BillsMID:(NSString *)billsMID BillsTID:(NSString *) billsTID WithViewController:(UIViewController *)controller Delegate:(id<UMSCashierPluginDelegate>)delegate SalesSlipType:(SalesSlipType) salesSlipType;

/**
 *  商户小票打印
 *
 *  @param message    打印信息
 *  @param billsMID   出账商户号
 *  @param billsTID   出账商户终端号
 *  @param controller 调用接口的UIViewController
 *  @param delegate   回调
 */
+(void) print:(NSString *)message BillsMID:(NSString *)billsMID BillsTID:(NSString *) billsTID WithViewController:(UIViewController *)controller Delegate:(id<UMSCashierPluginDelegate>)delegate;

/**
 *  获取CSN
 *
 *  @param billsMID   出账商户号
 *  @param billsTID   出账商户终端号
 *  @param controller 调用接口的UIViewController
 *  @param delegate   回调
 */
+(void) getCSN:(NSString *)billsMID BillsTID:(NSString *)billsTID WithViewController:(UIViewController *)controller Delegate:(id<UMSCashierPluginDelegate>)delegate;

/**
 *  预授权
 *
 *  @param amount               预授权金额,单位为分
 *  @param merorderId           预授权商户订单号
 *  @param merOrderDesc         预授权商户订单描述
 *  @param billsMID             出账商户号
 *  @param billsTID             出账商户终端号
 *  @param salesSlipType        签购单类型
 *  @param payType              支付类型
 *  @param operatorID           操作员号
 *  @param consumerPhone        消费者手机号
 *  @param memo                 备注
 *  @param isSupportDebitCard   是否支持借记卡,0不支持,1支持
 *  @param controller           调用接口的UIViewController
 *  @param delegate             回调
 */
+(void) preAuth:(NSString *)amount MerorderId:(NSString *)merorderId MerOrderDesc:(NSString *)merOrderDesc BillsMID:(NSString *)billsMID BillsTID:(NSString *) billsTID SalesSlipType:(SalesSlipType) salesSlipType PayType:(PayType)payType OperatorID:(NSString *)operatorID ConsumerPhone:(NSString *)consumerPhone Memo:(NSString *)memo IsSupportDebitCard:(NSString *)isSupportDebitCard WithViewController:(UIViewController *)controller Delegate:(id<UMSCashierPluginDelegate>)delegate;

/**
 *  预授权完成
 *
 *  @param finAmount              预授权完成金额,单位为分
 *  @param merorderId             预授权完成商户订单号
 *  @param merOrderDesc           预授权完成商户订单号描述
 *  @param originOrderId          原预授权银商订单号
 *  @param originAuthNo           原预授权返回的授权码
 *  @param billsMID               出账商户号
 *  @param billsTID               出账商户终端号
 *  @param operatorID             操作员号
 *  @param memo                   备注
 *  @param controller             调用接口的UIViewController
 *  @param delegate               回调
 */
+(void)preAuthFin:(NSString *)finAmount MerorderId:(NSString *)merorderId MerOrderDesc:(NSString *)merOrderDesc OriginOrderId:(NSString *)originOrderId OriginAuthNo:(NSString *)originAuthNo BillsMID:(NSString *)billsMID BillsTID:(NSString *) billsTID OperatorID:(NSString *)operatorID ConsumerPhone:(NSString *)consumerPhone Memo:(NSString *)memo WithViewController:(UIViewController *)controller Delegate:(id<UMSCashierPluginDelegate>)delegate NeedSignPic:(BOOL)isNeedSign;

/**
 *  预授权撤销
 *
 *  @param originOrderId    原预授权银商订单号
 *  @param originMerorderId 原预授权商户订单号
 *  @param originAuthNo     原预授权返回的授权码
 *  @param billsMID         出账商户号
 *  @param billsTID         出账商户终端号
 *  @param operatorID       操作员号
 *  @param memo             备注
 *  @param controller       调用接口的UIViewController
 *  @param delegate         回调
 */
+(void)preAuthCancel:(NSString *)originOrderId OriginMerorderId:(NSString *)originMerorderId OriginAuthNo:(NSString *)originAuthNo BillsMID:(NSString *)billsMID BillsTID:(NSString *) billsTID OperatorID:(NSString *)operatorID Memo:(NSString *)memo WithViewController:(UIViewController *)controller Delegate:(id<UMSCashierPluginDelegate>)delegate;

/**
 *  预授权完成撤销
 *
 *  @param originOrderId    原预授权完成银商订单号
 *  @param originMerorderId 原预授权完成商户订单号
 *  @param originAuthNo     原预授权完成返回的授权码
 *  @param billsMID         出账商户号
 *  @param billsTID         出账商户终端号
*  @param operatorID        操作员号
 *  @param memo             备注
 *  @param controller       调用接口的UIViewController
 *  @param delegate         回调
 */
+(void)preAuthFinCancel:(NSString *)originOrderId OriginMerorderId:(NSString *)originMerorderId OriginAuthNo:(NSString *)originAuthNo BillsMID:(NSString *)billsMID BillsTID:(NSString *) billsTID OperatorID:(NSString *)operatorID Memo:(NSString *)memo WithViewController:(UIViewController *)controller Delegate:(id<UMSCashierPluginDelegate>)delegate;

/**
 *  获取SDK信息
 *
 *  @param delegate 回调
 */
+(void)checkCurrentEnv:(id<UMSCashierPluginDelegate>)delegate;


/**
 *  获取银行卡号
 *
 *  @param controller       调用接口的UIViewController
 *  @param delegate         回调
 */
+(void)getCardNum:(UIViewController *)controller
         Delegate:(id<UMSCashierPluginDelegate>)delegate;

/**
 *    联机退货
 * @param amount             退货金额，单位为分
 * @param originOrderId      原交易订单
 * @param merOrderId         商户订单号
 * @param merOrderDesc(可选)  商户订单描述
 * @param billsMID           出账商户号
 * @param billsTID           出账商户终端号
 * @param operatorId         操作员号
 * @param phoneNumber        消费者手机号
 * @param salesSlipType     签购单类型
 * @param payType           支付方式
 * @param memo              备注
 */
+(void)refund:(NSString *)amount
      OriginOrderId:(NSString *)originOrderId
         MerOrderId:(NSString *)merOrderId
       MerOrderDesc:(NSString *)merOrderDesc
           BillsMID:(NSString *)billsMID
           BillsTID:(NSString *)billsTID
         OperatorID:(NSString *)operatorId
        ConsumerPhone:(NSString *)consumerPhone
      SalesSlipType:(SalesSlipType)salesSlipType
            PayType:(PayType)payType
               Memo:(NSString *)memo
 WithViewController:(UIViewController *)controller Delegate:(id<UMSCashierPluginDelegate>)delegate;


@end

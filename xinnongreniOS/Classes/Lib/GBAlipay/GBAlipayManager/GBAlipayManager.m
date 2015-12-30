//
//  GBAlipayManager.m
//  支付宝极简支付
//
//  Created by marks on 15/6/3.
//  Copyright (c) 2015年 zhangguobing. All rights reserved.
//

#import "GBAlipayManager.h"

@implementation GBAlipayManager

static NSData *base64_decode(NSString *str){
    NSData *data = [[NSData alloc] initWithBase64EncodedString:str options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return data;
}

static NSString *base64_encode_data(NSData *data){
    data = [data base64EncodedDataWithOptions:0];
    NSString *ret = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return ret;
}

/**
 *  针对多个用户用户配置信息请求自服务器
 *
 *  @param partner            合作者身份ID
 *  @param seller             卖家支付宝账号
 *  @param tradeNO            商户网站唯一订单号
 *  @param productName        商品名称
 *  @param productDescription 商品详情
 *  @param amount             总金额
 *  @param notifyURL          服务器异步通知页面路径
 *  @param itBPay             未付款交易的超时时间          
 */
+ (void)alipayWithPartner:(NSString *)partner
                   seller:(NSString *)seller
                  tradeNO:(NSString *)tradeNO
              productName:(NSString *)productName
       productDescription:(NSString *)productDescription
                   amount:(NSString *)amount
                notifyURL:(NSString *)notifyURL
                   itBPay:(NSString *)itBPay
{
    
    
    
    
    [self alipayWithPartner:partner
                     seller:seller
                    tradeNO:tradeNO
                productName:productName
         productDescription:productDescription
                     amount:amount
                  notifyURL:notifyURL service:@"mobile.securitypay.pay" paymentType:@"1"
               inputCharset:@"UTF-8"
                     itBPay:itBPay
                 privateKey:PartnerPrivKey
                  appScheme:kAppScheme];
    
}
/**
 *  只针对单一用户数据本地写死
 *
 *  @param productName        商品名称
 *  @param amount             商品金额
 *  @param notifyURL          服务器异步通知页面路径
 *  @param productDescription 商品详情
 *  @param itBPay             未付款交易的超时时间
 */
+(void)alipayWithProductName:(NSString *)productName
                      amount:(NSString *)amount
                   notifyURL:(NSString *)notifyURL
          productDescription:(NSString *)productDescription
                      itBPay:(NSString *)itBPay;{
    
    [self alipayWithPartner:PartnerID
                     seller:SellerID
                    tradeNO:[self generateTradeNO]
                productName:productName
         productDescription:productDescription
                     amount:amount
                  notifyURL:notifyURL service:@"mobile.securitypay.pay" paymentType:@"1"
               inputCharset:@"UTF-8"
                     itBPay:itBPay
                 privateKey:PartnerPrivKey
                  appScheme:kAppScheme];
    
    
    
    
    
}

// 包含所有必要的参数
+ (void)alipayWithPartner:(NSString *)partner
                   seller:(NSString *)seller
                  tradeNO:(NSString *)tradeNO
              productName:(NSString *)productName
       productDescription:(NSString *)productDescription
                   amount:(NSString *)amount
                notifyURL:(NSString *)notifyURL
                  service:(NSString *)service
              paymentType:(NSString *)paymentType
             inputCharset:(NSString *)inputCharset
                   itBPay:(NSString *)itBPay
               privateKey:(NSString *)privateKey
                appScheme:(NSString *)appScheme {
    
    Order *order = [[Order alloc]init];
    order.partner = partner;
    order.seller = seller;
    order.tradeNO = tradeNO;
    order.productName = productName;
    order.productDescription = productDescription;
    order.amount = [NSString stringWithFormat:@"%.2f",[amount floatValue]];
    order.notifyURL = notifyURL;
    order.service = service;
    order.paymentType = paymentType;
    order.inputCharset = inputCharset;
    order.itBPay = itBPay;
    
    
    // 将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    
    // 获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循 RSA 签名规范, 并将签名字符串 base64 编码和 UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(PartnerPrivKey);
    NSLog(@"===+++++%@",signer);
    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"reslut = %@",resultDic);
        }];
        
        
    }

   

}
#pragma mark   ==============产生随机订单号==============


+(NSString *)generateTradeNO {
    static int kNumber = 15;
    
    NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    srand(time(0));
    for (int i = 0; i < kNumber; i++)
    {
        unsigned index = rand() % [sourceStr length];
        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
        [resultStr appendString:oneStr];
    }
    return resultStr;
}

+ (NSString *)encryptString:(NSString *)str publicKey:(NSString *)pubKey {
    
    NSData *data = [GBAlipayManager encryptData:[str dataUsingEncoding:NSUTF8StringEncoding] publicKey:pubKey];
    NSString *ret = base64_encode_data(data);
    return ret;
}


+ (NSData *)encryptData:(NSData *)data publicKey:(NSString *)pubKey {
    
    if(!data || !pubKey){
        return nil;
    }
    SecKeyRef keyRef = [GBAlipayManager addPublicKey:pubKey];
    if(!keyRef){
        return nil;
    }
    
    const uint8_t *srcbuf = (const uint8_t *)[data bytes];
    size_t srclen = (size_t)data.length;
    
    size_t outlen = SecKeyGetBlockSize(keyRef) * sizeof(uint8_t);
    if(srclen > outlen - 11){
        CFRelease(keyRef);
        return nil;
    }
    void *outbuf = malloc(outlen);
    
    OSStatus status = noErr;
    status = SecKeyEncrypt(keyRef,
                           kSecPaddingPKCS1,
                           srcbuf,
                           srclen,
                           outbuf,
                           &outlen
                           );
    NSData *ret = nil;
    if (status != 0) {
        //NSLog(@"SecKeyEncrypt fail. Error Code: %ld", status);
    }else{
        ret = [NSData dataWithBytes:outbuf length:outlen];
    }
    free(outbuf);
    CFRelease(keyRef);
    
    return ret;
}

+ (SecKeyRef)addPublicKey:(NSString *)key{
    NSRange spos = [key rangeOfString:@"-----BEGIN PUBLIC KEY-----"];
    NSRange epos = [key rangeOfString:@"-----END PUBLIC KEY-----"];
    if(spos.location != NSNotFound && epos.location != NSNotFound){
        NSUInteger s = spos.location + spos.length;
        NSUInteger e = epos.location;
        NSRange range = NSMakeRange(s, e-s);
        key = [key substringWithRange:range];
    }
    key = [key stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    key = [key stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    key = [key stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    key = [key stringByReplacingOccurrencesOfString:@" "  withString:@""];
    
    // This will be base64 encoded, decode it.
    NSData *data = base64_decode(key);
    data = [GBAlipayManager stripPublicKeyHeader:data];
    if(!data){
        return nil;
    }
    
    //a tag to read/write keychain storage
    NSString *tag = @"RSAUtil_PubKey";
    NSData *d_tag = [NSData dataWithBytes:[tag UTF8String] length:[tag length]];
    
    // Delete any old lingering key with the same tag
    NSMutableDictionary *publicKey = [[NSMutableDictionary alloc] init];
    [publicKey setObject:(__bridge id) kSecClassKey forKey:(__bridge id)kSecClass];
    [publicKey setObject:(__bridge id) kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
    [publicKey setObject:d_tag forKey:(__bridge id)kSecAttrApplicationTag];
    SecItemDelete((__bridge CFDictionaryRef)publicKey);
    
    // Add persistent version of the key to system keychain
    [publicKey setObject:data forKey:(__bridge id)kSecValueData];
    [publicKey setObject:(__bridge id) kSecAttrKeyClassPublic forKey:(__bridge id)
     kSecAttrKeyClass];
    [publicKey setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)
     kSecReturnPersistentRef];
    
    CFTypeRef persistKey = nil;
    OSStatus status = SecItemAdd((__bridge CFDictionaryRef)publicKey, &persistKey);
    if (persistKey != nil){
        CFRelease(persistKey);
    }
    if ((status != noErr) && (status != errSecDuplicateItem)) {
        return nil;
    }
    
    [publicKey removeObjectForKey:(__bridge id)kSecValueData];
    [publicKey removeObjectForKey:(__bridge id)kSecReturnPersistentRef];
    [publicKey setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)kSecReturnRef];
    [publicKey setObject:(__bridge id) kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
    
    // Now fetch the SecKeyRef version of the key
    SecKeyRef keyRef = nil;
    status = SecItemCopyMatching((__bridge CFDictionaryRef)publicKey, (CFTypeRef *)&keyRef);
    if(status != noErr){
        return nil;
    }
    return keyRef;
}

+ (NSData *)stripPublicKeyHeader:(NSData *)d_key{
    // Skip ASN.1 public key header
    if (d_key == nil) return(nil);
    
    unsigned long len = [d_key length];
    if (!len) return(nil);
    
    unsigned char *c_key = (unsigned char *)[d_key bytes];
    unsigned int  idx	 = 0;
    
    if (c_key[idx++] != 0x30) return(nil);
    
    if (c_key[idx] > 0x80) idx += c_key[idx] - 0x80 + 1;
    else idx++;
    
    // PKCS #1 rsaEncryption szOID_RSA_RSA
    static unsigned char seqiod[] =
    { 0x30,   0x0d, 0x06, 0x09, 0x2a, 0x86, 0x48, 0x86, 0xf7, 0x0d, 0x01, 0x01,
        0x01, 0x05, 0x00 };
    if (memcmp(&c_key[idx], seqiod, 15)) return(nil);
    
    idx += 15;
    
    if (c_key[idx++] != 0x03) return(nil);
    
    if (c_key[idx] > 0x80) idx += c_key[idx] - 0x80 + 1;
    else idx++;
    
    if (c_key[idx++] != '\0') return(nil);
    
    // Now make a new NSData from this buffer
    return([NSData dataWithBytes:&c_key[idx] length:len - idx]);
}
@end

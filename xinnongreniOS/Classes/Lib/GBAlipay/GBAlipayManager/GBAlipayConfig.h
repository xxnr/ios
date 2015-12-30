//
//  GBAlipayConfig.h
//  支付宝极简支付
//
//  Created by marks on 15/6/3.
//  Copyright (c) 2015年 zhangguobing. All rights reserved.
//

#ifndef ________GBAlipayConfig_h
#define ________GBAlipayConfig_h

#import <AlipaySDK/AlipaySDK.h>     // 导入AlipaySDK
#import "Order.h"                   // 导入订单类
#import "DataSigner.h"              // 生成signer的类
/**
 *  合作身份者id，以2088开头的16位纯数字
 */
#define PartnerID @"2088911973097354"
//#define PartnerID @"2088911839225574"

//#define PartnerID @"2088911580508812"

/**
 *  收款支付宝账号
 */
#define SellerID  @"it@xinxinnongren.com"
//#define SellerID  @"3077272878@qq.com"

//#define SellerID  @"seven@dyhoa.com"


/**
 *  安全校验码（MD5）密钥，以数字和字母组成的32位字符
 */
#define MD5_KEY @"o11oiidrjq70z8zfrvj6785b46xtpkkv"
//#define MD5_KEY @"qvkirgwkssqhxhs4t041ri4cqxdvhsxb"

//#define MD5_KEY @"pozr8s4zxk2zvitcdsh8rtwlsqipr960"

/**
 *  appSckeme:应用注册scheme,在Info.plist定义URLtypes，处理支付宝回调
 */
#define kAppScheme @"KSFCXNRAlipay2015"
//#define kAppScheme @"QXHAlipay2015"

/**
 *  支付宝服务器主动通知商户交易是否成功 网站里指定的页面 http 路径。非必需
 */
#define kNotifyURL @"http://101.200.181.247/pay/alipay/notify"
/**
 *  商户私钥，自助生成
 */
//#define PartnerPrivKey @"MIICeAIBADANBgkqhkiG9w0BAQEFAASCAmIwggJeAgEAAoGBAMBNV2F0hlXTiFrQ1QDaEhHmyAjBv0d5wMwN9KlGeWRguCplzcKdNjOlTzUpLogQPJcwhbt4RvDfSFAMn5pXpk6E1HunsvZBhTYuQooHADdzxFGIGGsF52Lwuw04zJjV8V18viZiwEWvo9BTv+RIWptoJahnyRHM0/6QVBOcB5uNAgMBAAECgYEAvY+/8j5madZSlItFXUiaBXGEgDVU9AVOCxg6tF7XLR62jHy8PvqwQmrTUKkeyFuRDsxzF6Dx9WF1LAu1jPSX5xnk+aguCpmieQjeC6+sgTfPMQqMGbpDE9aXQatd49ySRL1J8sUeTUi6Nv1jpWDtfwtuOaD3+WQLMmW5sD1T6RUCQQDwkmp1L4cZytiq3BAOyj87u+TNwz/nF+OwGiK8KJmolS8Om/XnRGb69/GE1w1ojDaBHkkK8umc+MYJe52E1bP7AkEAzKJ08OCFovyC6l+vqzMb5sPU4zT+liSaUp5jAkNuAdJf4MpfX08dMF0sRqOPnoqpEoy3Rw0oRyuaCUzSM+JQFwJAVUTAQQr4itbQFzdq5aMf6I8/mQL0mndoN5n7589IL225QSdccH1ZNuk9DMWgtgbEpt1SLHRPA1lV8DSFb3jDkwJBAKB0kjV+F8thLFYSiXA4NxyPWZJ+r1GTid5Wi1PvA4cyKjPc+0OEiWKu7FTHU4oBN+lvpRZ1XqvPqIy6S+ibACkCQQCIem2ks8cZ3RF4RWSWRjItJ+91sfnbylduU8I68uk93D1mJ+lx7YMQoHJqtGv66r2kFwZ0HBhBW2k5WqdTh9YR"
#define PartnerPrivKey @"MIICeAIBADANBgkqhkiG9w0BAQEFAASCAmIwggJeAgEAAoGBAP2cuJXfkcLYzf8ldCcppdOelA1P7U3tAxF+avSorHXBWpvmfcgAZtdTM9olsC/bief2/BsPXpbaWaIw3epiFyUsi76OMXhFl6tPUOivZ2NKM+x0PPi0YaJe1K+O9KmXTqr2UIgQ4kmwGrqN/vCmRrXZWg7+BSkFQ/cBCbgHfkZZAgMBAAECgYEAoT258bex0aLL3ZMvdRK6ln/0+z28z1WIJOAuGhz/gOKMvB/gCn+O4wnIJsLdcJ/w3uUdxgqQhfKPGFpfTPxOX5Ug/jDpp3BATpvqpzMVwsuOrP7B9X+KGB2tksksb0HpdbcOMfDWl096BylF4bE3Lq3vsuzrjk9RqgSokcBsV4ECQQD/iU0DWv/N4v6znpqMTmSQWms101vZJFkgoblJ3HU4iPa+6b2joF1Shj6ef0uOr3akQHqatte9eKB0/YTIskKJAkEA/hKGw51vIrGHhy+2/11adZf1MifYpwSwrYLMvpb+oH7ws1AzDt1e2Gn4X47QhFoPWGaWuZaviRrKIZgNasMxUQJBAPlAPrt4Jq33rUMdAFi9GoBngc2l1SBPwRQAS5CNFlXH2w5LRmv1PzIAudG2DsglxE7gifahRHyOzcxvgPaWUikCQQCShdaoS0vDY0R4pwDPJmQ7uuXSBf7A20iU2AEBzQyNPIfNsWuwn+PJxNtTKIaCPXnqDkfQQeF7nTKCyzC5qFXxAkAVh/2rl+kk+dvZYJWK6phERjAu9RB+r9Of+I8cMtpY6LzrrUxs4SpWyZNl8LbY0TBeTeG6PF+GFRmbRcdBczWx"

//#define PartnerPrivKey @"MIICdQIBADANBgkqhkiG9w0BAQEFAASCAl8wggJbAgEAAoGBAJe/ex7q+zboVHNg823dPWuDHUkyI3mP1yNJEfFXPNJ5hdjv/Nd6LJNmpo08gdjBpCBYXwrfTeH9p+Op9BDCG5klIJPeJSBUEiNvuXKAJFyLPbHTNUJBjFkV049k38ENxycZLj455nfYcH22RqBxcj6qQoiBE4OqE+JEcrNDhc51AgMBAAECgYAbbvqLNGAGJSpfUX+wtPaNoT6CJRZUu7RhJKyhvOu6AU45Uemb6vJ0E3K4xd+TmC5byp4kEQq7eGgJuIfvH6htWAlTZ0doC5T2bRuZhR37J6Fsh5Pd4BwpvY+XpTFzWwx5pHSHLmwX++MygUjbS3IqLlppd75xOpORSXqIf59pYQJBAMkmA3CwolVO47dHRIEEaNikIoNgfrurI/N6WNplT2JAleZUPPaml6d5LtayqeiXCTKKzMVesxZRwYnO2/Op5CMCQQDBIN0ponyMOUQrhkK5TTwAzgSo1+4h7L+6QqEW/JfGJi9XiWAY1DiFbIoQ8TTXu8zg40wFhJEd8IrtNE5c/4CHAkAN7Z3rXa+/7HiEJmEt9do0thjVtAbSg+U3ZM9mQAGhMguvKUIXai2yIQgHQdPWES9H2qiXOhl4gCzAmBxO4QK1AkAv09mxg+HgQBZXyQohJbVkZaDVx5PbpuvcTr/iF2/mzHIQ9Z5sx7GvqS+P/owdmQ6l6uRawXfGuFlPYRK/CS9lAkA/8nryeOVO8w5kra1gfUqMr/PQzpKWcfqWnqiImQhJoJN2iv48B9xOIg8XDV8WngThoNs6yxQA0IUC7PzcWxp6"
/**
 *  支付宝公钥
 */
#define AlipayPubKey   @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQD9nLiV35HC2M3/JXQnKaXTnpQNT+1N7QMRfmr0qKx1wVqb5n3IAGbXUzPaJbAv24nn9vwbD16W2lmiMN3qYhclLIu+jjF4RZerT1Dor2djSjPsdDz4tGGiXtSvjvSpl06q9lCIEOJJsBq6jf7wpka12VoO/gUpBUP3AQm4B35GWQIDAQAB"
//#define AlipayPubKey   @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDDI6d306Q8fIfCOaTXyiUeJHkrIvYISRcc73s3vF1ZT7XN8RNPwJxo8pWaJMmvyTn9N4HQ632qJBVHf8sxHi/fEsraprwCtzvzQETrNRwVxLO5jVmRGi60j8Ue1efIlzPXV9je9mkjzOmdssymZkh2QhUrCmZYI/FCEa3/cNMW0QIDAQAB"


#endif


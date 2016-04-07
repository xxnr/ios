//
//  XNRSpecialCell.m
//  xinnongreniOS
//
//  Created by xxnr on 15/11/27.
//  Copyright © 2015年 qxhiOS. All rights reserved.
//

#import "XNRSpecialCell.h"
#import "UIImageView+WebCache.h"

@interface XNRSpecialCell()

@property (nonatomic, weak) UIImageView *image;
@property (nonatomic, weak) UILabel *detailLabel;
@property (nonatomic, weak) UILabel *priceLabel;
@property (nonatomic, weak) UIButton *shopcarBtn;

@property (nonatomic,weak)XNRShoppingCartModel *model;


@end

@implementation XNRSpecialCell

+(instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"fercell";
    XNRSpecialCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[XNRSpecialCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = YES;
    }
    return self;
}

-(void)createUI
{
    CGFloat margin = PX_TO_PT(20);
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(PX_TO_PT(32), PX_TO_PT(20), PX_TO_PT(200), PX_TO_PT(200))];
    image.layer.borderWidth = 1.0;
    image.layer.borderColor = R_G_B_16(0xc7c7c7).CGColor;
    self.image = image;
    [self addSubview:image];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.image.frame) + PX_TO_PT(19), ScreenWidth, PX_TO_PT(2))];
    
    lineView.backgroundColor = R_G_B_16(0xc7c7c7);
    [self.contentView addSubview:lineView];
    

    
    UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.image.frame) + margin, PX_TO_PT(20), ScreenWidth - CGRectGetMaxX(self.image.frame)-PX_TO_PT(32), PX_TO_PT(100))];
    detailLabel.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
    detailLabel.textColor = R_G_B_16(0x323232);
    detailLabel.numberOfLines = 0;
    self.detailLabel = detailLabel;
    [self addSubview:detailLabel];
    
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.image.frame) + margin, CGRectGetMaxY(self.detailLabel.frame), PX_TO_PT(200), PX_TO_PT(100))];
    priceLabel.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
    priceLabel.textColor = R_G_B_16(0xff4e00);
    self.priceLabel = priceLabel;
    [self addSubview:priceLabel];
    
//    UIButton *shopcarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    shopcarBtn.frame = CGRectMake(CGRectGetMaxX(self.priceLabel.frame) + PX_TO_PT(150),CGRectGetMaxY(self.detailLabel.frame), PX_TO_PT(100), PX_TO_PT(100));
//    [shopcarBtn setImage:[UIImage imageNamed:@"icon_shoppcar"] forState:UIControlStateNormal];
//    [shopcarBtn addTarget:self action:@selector(shopcarBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    self.shopcarBtn = shopcarBtn;
//    [self addSubview:shopcarBtn];
    
}

//-(void)shopcarBtnClick
//{
//    [BMProgressView showCoverWithTarget:self color:nil isNavigation:NO];
//    if(IS_Login == YES) {
//        [KSHttpRequest post:KAddToCart parameters:@{@"goodsId":self.model.goodsId,@"userId":[DataCenter account].userid,@"quantity":@"1",@"update_by_add":@"true",@"user-agent":@"IOS-v2.0"} success:^(id result) {
//            NSLog(@"%@",result);
//            if([result[@"code"] integerValue] == 1000){
//                [UILabel showMessage:@"加入购物车成功"];
//                [BMProgressView LoadViewDisappear:self];
//            }else {
//                
//                [UILabel showMessage:result[@"message"]];
//                [BMProgressView LoadViewDisappear:self];
//
//            }
//            
//        } failure:^(NSError *error) {
//            
//            NSLog(@"%@",error);
//            
//        }];
//    } else {
////        NSMutableArray *goodsArray = [[NSMutableArray alloc] init];
////        NSDictionary *goodsId = @{@"productId":self.model.goodsId,@"count":@"1"};
////        [goodsArray addObject:goodsId];
//        [KSHttpRequest post:KGetShoppingCartOffline parameters:@{@"products":[goodsArray JSONString_Ext]} success:^(id result) {
////            if ([result[@"code"] integerValue] == 1000) {
////            [SVProgressHUD  showSuccessWithStatus:@"加入购物车成功"];
////
////            }
////            
////        } failure:^(NSError *error) {
////            
////        }];
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1*NSEC_PER_SEC), dispatch_get_main_queue(), ^{
//            BOOL b;
//            DatabaseManager *manager = [DatabaseManager sharedInstance];
//            //查询数据库是否有该商品
//            NSArray *modelArr = [manager queryGoodWithModel:self.model];
//            //数据库没有该商品(插入)
//            if (modelArr.count == 0) {
//                self.model.num = @"1";
//                self.model.timeStamp = [CommonTool timeSp];  //时间戳
//                self.model.shoppingCarCount = [manager shoppingCarCount];
//                b = [manager insertShoppingCarWithModel:self.model];
//            }
//            //数据库有该商品(更新)
//            else{
//                XNRShoppingCartModel *model = [modelArr firstObject];
//                model.num = [NSString stringWithFormat:@"%d",model.num.intValue+1];
//                model.timeStamp = [CommonTool timeSp];  // 时间戳
//                model.shoppingCarCount = [manager shoppingCarCount]; // 累加数
//                model.deposit = self.model.deposit;
//                b = [manager updateShoppingCarWithModel:model];
//            }
//            if (b) {
//                [UILabel showMessage:@"加入购物车成功"];
//                [BMProgressView LoadViewDisappear:self];
//
//            }else{
//                [UILabel showMessage:@"加入购物车失败"];
//                [BMProgressView LoadViewDisappear:self];
//            }
//        });
//    }
//
//}

-(void)setCellDataWithShoppingCartModel:(XNRShoppingCartModel *)model
{
    _model = model;

    NSString *urlStr = [NSString stringWithFormat:@"%@%@",HOST,self.model.imgUrl];
    
    if (urlStr == nil || [urlStr isEqualToString:@""]) {
        [self.image setImage:[UIImage imageNamed:@"icon_placehold"]];
    }else{
        [self.image sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"icon_loading_wrong"]];
    }


//    [self.image sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",HOST,self.model.imgUrl]] placeholderImage:[UIImage imageNamed:@"icon_placehold"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//        image = [UIImage imageNamed:@"icon_loading_wrong"];
//    }];

    self.detailLabel.text = model.goodsName;
    if ([self.model.presale integerValue] == 1) {
        self.priceLabel.textColor = R_G_B_16(0xc7c7c7);
        self.priceLabel.text = @"即将上线";
        self.shopcarBtn.hidden = YES;
    }else{
        self.priceLabel.textColor = R_G_B_16(0xff4e00);
        self.priceLabel.text = [NSString stringWithFormat:@"¥%.2f",model.unitPrice.doubleValue];
        self.shopcarBtn.hidden = NO;
    }
}

@end

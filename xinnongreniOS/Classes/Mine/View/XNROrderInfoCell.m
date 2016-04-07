//
//  XNRSubmitOrderCell.m
//  xinnongreniOS
//
//  Created by xxnr on 16/1/8.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import "XNROrderInfoCell.h"
#import "UIImageView+WebCache.h"
#import "XNRAddtionsModel.h"

@interface XNROrderInfoCell()

{
    CGFloat _totalPrice;
}

@property (nonatomic ,weak) UIView *topView;

@property (nonatomic ,weak) UIView *midView;

@property (nonatomic ,weak) UIView *bottomView;

@property (nonatomic ,weak) UIImageView *goodsImageView;

@property (nonatomic ,weak) UILabel *brandNameLabel;

@property (nonatomic ,weak) UILabel *detailLabel;

@property (nonatomic ,weak) UILabel *priceLabel;

@property (nonatomic ,weak) UILabel *depositLabel;

@property (nonatomic ,weak) UILabel *remainPriceLabel;

@property (nonatomic ,weak) UILabel *goodsTotalLabel;

@property (nonatomic ,weak) UILabel *totoalPriceLabel;

@property (nonatomic ,weak) UILabel *goodsTotalLabelMid;

@property (nonatomic ,weak) UILabel *totoalPriceLabelMid;

@property (nonatomic, weak) UILabel *numLabel;

@property (nonatomic ,weak) UIView *addtionView;

@property (nonatomic ,weak) UILabel *statusLabel;

@property (nonatomic,weak) UILabel *addtionLabel;

@property (nonatomic ,strong) XNRCheckOrderModel *model;

@end

@implementation XNROrderInfoCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createView];
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
    return  self;
}

-(void)createView{
    
    //    [self createTopView];
    //    [self createMidView];
    //    [self createBottomView];
    [_model.additions removeAllObjects];
    
}

-(void)createTopView:(XNRCheckOrderModel *)addtionsModel{
    
    UIView *topView = [[UIView  alloc] init];
    self.topView = topView;
    [self.contentView addSubview:topView];
    
    UIImageView *goodsImageView = [[UIImageView alloc] initWithFrame:CGRectMake(PX_TO_PT(32), PX_TO_PT(30), PX_TO_PT(180), PX_TO_PT(180))];
    goodsImageView.layer.borderColor = R_G_B_16(0xc7c7c7).CGColor;
    goodsImageView.layer.borderWidth = 1.0;
    self.goodsImageView = goodsImageView;
    [topView addSubview:goodsImageView];
    
    UILabel *brandNameLabel = [[UILabel alloc] init];
    brandNameLabel.textColor = R_G_B_16(0x323232);
    brandNameLabel.text = addtionsModel.productName;
    brandNameLabel.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
    brandNameLabel.numberOfLines = 2;
    
    CGSize size1 = [brandNameLabel.text boundingRectWithSize:CGSizeMake(PX_TO_PT(325), PX_TO_PT(78)) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:PX_TO_PT(32)]} context:nil].size;
    
    brandNameLabel.frame = CGRectMake(CGRectGetMaxX(goodsImageView.frame) + PX_TO_PT(20), PX_TO_PT(41), PX_TO_PT(325), size1.height);
    
    self.brandNameLabel = brandNameLabel;
    [topView addSubview:brandNameLabel];
    
    UILabel *statusLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(brandNameLabel.frame)+PX_TO_PT(10), PX_TO_PT(44), ScreenWidth - PX_TO_PT(32)-CGRectGetMaxX(brandNameLabel.frame)-PX_TO_PT(10), PX_TO_PT(28))];
    statusLabel.textAlignment = UITextAlignmentRight;
    statusLabel.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
    statusLabel.textColor = R_G_B_16(0xFE9B00);
    if ([addtionsModel.deliverStatus integerValue] == 1) {
        statusLabel.text = @"待发货";
    }
    else if ([addtionsModel.deliverStatus integerValue] == 2){
        statusLabel.text = @"配送中";
    }
    else if ([addtionsModel.deliverStatus integerValue] == 4){
        statusLabel.text = @"已到服务站";
    }
    else if ([addtionsModel.deliverStatus integerValue] == 5){
        statusLabel.text = @"已收货";
    }


    self.statusLabel = statusLabel;
    [topView addSubview:statusLabel];
    
//    UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(goodsImageView.frame) + PX_TO_PT(20), CGRectGetMaxY(brandNameLabel.frame) + PX_TO_PT(19), PX_TO_PT(325), PX_TO_PT(70))];
    UILabel *detailLabel = [[UILabel alloc]init];
    detailLabel.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
    detailLabel.textColor = R_G_B_16(0x909090);
    
    NSMutableString *displayStr = [[NSMutableString alloc] initWithString:@""];
    for (NSDictionary *subDic in addtionsModel.attributes) {
        [displayStr appendString:[NSString stringWithFormat:@"%@:%@ ",[subDic objectForKey:@"name"],[subDic objectForKey:@"value"]]];
        [displayStr appendString:@";"];
    }

    CGSize size = [displayStr boundingRectWithSize:CGSizeMake(ScreenWidth - CGRectGetMaxX(goodsImageView.frame) - PX_TO_PT(20)-PX_TO_PT(32), MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:PX_TO_PT(28)]} context:nil].size;
    
    detailLabel.frame = CGRectMake(CGRectGetMaxX(goodsImageView.frame) + PX_TO_PT(20), CGRectGetMaxY(brandNameLabel.frame) + PX_TO_PT(19), ScreenWidth - CGRectGetMaxX(goodsImageView.frame) - PX_TO_PT(20)-PX_TO_PT(32), size.height);
    detailLabel.numberOfLines = 0;
    self.detailLabel = detailLabel;
    [topView addSubview:detailLabel];
    
    CGFloat y;
    if (CGRectGetMaxY(goodsImageView.frame) > CGRectGetMaxY(detailLabel.frame)) {
        y = CGRectGetMaxY(goodsImageView.frame);
    }
    else
    {
        y = CGRectGetMaxY(detailLabel.frame);
    }
    UILabel *numLabel = [[UILabel alloc] initWithFrame:CGRectMake(PX_TO_PT(32), y + PX_TO_PT(20), ScreenWidth, PX_TO_PT(70))];
    self.numLabel = numLabel;
    numLabel.font = [UIFont systemFontOfSize:PX_TO_PT(36)];
    numLabel.textAlignment = NSTextAlignmentLeft;
    numLabel.textColor = R_G_B_16(0x323232);
    [topView addSubview:numLabel];
    
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/2, y + PX_TO_PT(20), ScreenWidth/2-PX_TO_PT(32), PX_TO_PT(70))];
    priceLabel.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
    priceLabel.textAlignment = NSTextAlignmentRight;
    priceLabel.textColor = R_G_B_16(0x323232);
    self.priceLabel = priceLabel;
    [topView addSubview:priceLabel];
    
    
    UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0,0, ScreenWidth, PX_TO_PT(1))];
    topLine.backgroundColor = R_G_B_16(0xc7c7c7);
    [topView addSubview:topLine];
    
//    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(priceLabel.frame) +PX_TO_PT(35), ScreenWidth, PX_TO_PT(1))];
//    bottomLine.backgroundColor = R_G_B_16(0xc7c7c7);
//        [topView addSubview:bottomLine];
    
    topView.frame = CGRectMake(0, 0, ScreenWidth, CGRectGetMaxY(priceLabel.frame));
    if (addtionsModel.additions.count>0) {
        
        UIView *addtionView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(topView.frame), ScreenWidth, addtionsModel.additions.count*PX_TO_PT(45))];
        self.addtionView = addtionView;
        //        addtionView.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:addtionView];
        
        for (int i = 0; i<addtionsModel.additions.count; i++) {
            UILabel *addtionLabel = [[UILabel alloc] initWithFrame:CGRectMake(PX_TO_PT(32), PX_TO_PT(45)*i, ScreenWidth-PX_TO_PT(64), PX_TO_PT(45))];
            addtionLabel.backgroundColor = R_G_B_16(0xf0f0f0);
            addtionLabel.layer.cornerRadius = 7.0;
            addtionLabel.layer.masksToBounds = YES;
            self.addtionLabel = addtionLabel;
            [addtionView addSubview:addtionLabel];
            
            NSDictionary *subDic = addtionsModel.additions[i];
            
            UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(PX_TO_PT(15), 0, ScreenWidth/2, PX_TO_PT(45))];
            nameLabel.textColor = R_G_B_16(0x909090);
            nameLabel.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
            nameLabel.textAlignment = NSTextAlignmentLeft;
            nameLabel.text = [NSString stringWithFormat:@"%@",subDic[@"name"]];
            [addtionLabel addSubview:nameLabel];
            
            UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth-PX_TO_PT(80), PX_TO_PT(45))];
            priceLabel.textColor = R_G_B_16(0x323232);
            priceLabel.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
            priceLabel.textAlignment = NSTextAlignmentRight;
            priceLabel.text = [NSString stringWithFormat:@"¥%.2f",[subDic[@"price"] doubleValue ]];
            [addtionLabel addSubview:priceLabel];
            
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(PX_TO_PT(32), CGRectGetMaxY(nameLabel.frame)*i, ScreenWidth-PX_TO_PT(64), PX_TO_PT(3))];
            lineView.backgroundColor = [UIColor whiteColor];
            [addtionView addSubview:lineView];
            

        }
        
    }
    NSNumber *num = [[NSNumber alloc]initWithFloat:self.topView.height + self.midView.height];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:num,@"key", nil];
    NSNotification *notification = [[NSNotification alloc]initWithName:@"height" object:self userInfo:dic];
    [[NSNotificationCenter defaultCenter]postNotification:notification];

}
-(void)createMidView:(XNRCheckOrderModel *)addtionsArray{
    
    if (addtionsArray.additions.count == 0) {
        UIView *midView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.topView.frame), ScreenWidth, PX_TO_PT(160))];
        self.midView = midView;
        //        midView.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:midView];
        
    }else{
        UIView *midView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.addtionView.frame)+PX_TO_PT(20), ScreenWidth, PX_TO_PT(160))];
        //        midView.backgroundColor = [UIColor redColor];
        self.midView = midView;
        [self.contentView addSubview:midView];
        
    }
    UILabel *sectionOneLabel = [[UILabel alloc] initWithFrame:CGRectMake(PX_TO_PT(32), 0, ScreenWidth/2, PX_TO_PT(80))];
    sectionOneLabel.text = @"阶段一: 订金";
    sectionOneLabel.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
    sectionOneLabel.textColor = R_G_B_16(0x323232);
    [self.midView addSubview:sectionOneLabel];
    
    UILabel *depositLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/2, 0, ScreenWidth/2-PX_TO_PT(32), PX_TO_PT(80))];
    depositLabel.textAlignment = NSTextAlignmentRight;
    depositLabel.textColor = R_G_B_16(0x323232);
    depositLabel.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
    self.depositLabel = depositLabel;
    [self.midView addSubview:depositLabel];
    
    
    UILabel *sectionTwoLabel = [[UILabel alloc] initWithFrame:CGRectMake(PX_TO_PT(32), PX_TO_PT(80), ScreenWidth/2, PX_TO_PT(80))];
    sectionTwoLabel.text = @"阶段二: 尾款";
    sectionTwoLabel.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
    sectionTwoLabel.textColor = R_G_B_16(0x323232);
    [self.midView addSubview:sectionTwoLabel];
    
    UILabel *remainPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/2, PX_TO_PT(80), ScreenWidth/2-PX_TO_PT(32), PX_TO_PT(80))];
    remainPriceLabel.textAlignment = NSTextAlignmentRight;
    remainPriceLabel.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
    remainPriceLabel.textColor = R_G_B_16(0x323232);
    self.remainPriceLabel = remainPriceLabel;
    [self.midView addSubview:remainPriceLabel];

    NSNumber *num = [[NSNumber alloc]initWithFloat:self.topView.height + self.midView.height];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:num,@"key", nil];
    NSNotification *notification = [[NSNotification alloc]initWithName:@"height" object:self userInfo:dic];
    [[NSNotificationCenter defaultCenter]postNotification:notification];
    
    for (int i = 0; i<3; i++) {
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, PX_TO_PT(80)*i, ScreenWidth, PX_TO_PT(1))];
            lineView.backgroundColor = R_G_B_16(0xc7c7c7);
            [self.midView addSubview:lineView];
        
    }
    
}

-(void)createBottomView{
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.topView.frame), ScreenWidth, PX_TO_PT(80))];
    self.bottomView = bottomView;
    [self.contentView addSubview:bottomView];
    
    UILabel *goodsTotalLabel = [[UILabel alloc] initWithFrame:CGRectMake(PX_TO_PT(32), 0, ScreenWidth/2, PX_TO_PT(80))];
    goodsTotalLabel.textColor = R_G_B_16(0x323232);
    goodsTotalLabel.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
    self.goodsTotalLabel = goodsTotalLabel;
    [bottomView addSubview:goodsTotalLabel];
    
    UILabel *totoalPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/2, 0, ScreenWidth/2 - PX_TO_PT(32), PX_TO_PT(80))];
    totoalPriceLabel.textAlignment = NSTextAlignmentRight;
    totoalPriceLabel.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
    self.totoalPriceLabel = totoalPriceLabel;
    [bottomView addSubview:totoalPriceLabel];
    
    
}

-(void)setCellDataWithModel:(XNRCheckOrderModel *)model
{
    // 把重复叠加的视图都移除一下
    [self.topView removeFromSuperview];
    [self.midView removeFromSuperview];
    [self.bottomView removeFromSuperview];
    
    _model = model;
//    if (_model.additions.count == 0) {
//        [self createTopView:nil];
//    }else
//    {
        [self createTopView:_model];
//    }
    
    if (_model.deposit && [_model.deposit doubleValue] > 0) {
        
        self.bottomView.hidden = YES;
//        if (_model.additions.count == 0) {
//            [self createMidView:nil];
//            
//        }else{
            [self createMidView:_model];
//        }
        
    }else{
        self.midView.hidden = YES;
        
    }
    
    //    }
    
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",HOST,self.model.imgs];
    //图片
//    [self.goodsImageView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"icon_loading_wrong"]];
    [self.goodsImageView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"icon_placehold"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        image = [UIImage imageNamed:@"icon_loading_wrong"];
    }];

    NSLog(@"-----------%@",self.model.productName);
    
    //商品名
    self.brandNameLabel.text = self.model.productName;
    
    NSMutableString *displayStr = [[NSMutableString alloc] initWithString:@""];
    for (NSDictionary *subDic in self.model.attributes) {
        [displayStr appendString:[NSString stringWithFormat:@"%@:%@",[subDic objectForKey:@"name"],[subDic objectForKey:@"value"]]];
        [displayStr appendString:@";"];
    }
    self.detailLabel.text = displayStr;
    
    NSString *price;
    CGFloat totalPrice = 0;
    for (NSDictionary *subDic in self.model.additions) {
        price = [NSString stringWithFormat:@"%@",[subDic objectForKey:@"price"]];
        totalPrice = totalPrice + [price doubleValue];
    }
    
    self.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",self.model.price.doubleValue];
    self.numLabel.text = [NSString stringWithFormat:@"x %@",self.model.count];
    // 订金
    self.depositLabel.text = [NSString stringWithFormat:@"￥%.2f",self.model.deposit.doubleValue*[_model.count doubleValue]];
    
    // 尾款
    self.remainPriceLabel.text = [NSString stringWithFormat:@"￥%.2f",(self.model.price.doubleValue+totalPrice - self.model.deposit.doubleValue) * [_model.count doubleValue]];
    //    // 商品件数
    //    self.goodsTotalLabel.text = [NSString stringWithFormat:@"共%@件商品",self.model.goodsCount];
    //    self.goodsTotalLabelMid.text = [NSString stringWithFormat:@"共%@件商品",self.model.goodsCount];
    //    _totalPrice = 0;
    //        // 合计
    //        if (self.model.deposit &&[self.model.deposit doubleValue] > 0) {
    //
    //            _totalPrice = _totalPrice + model.goodsCount.intValue *[[NSString stringWithFormat:@"%@",model.deposit] doubleValue];
    //
    //        }else{
    //            _totalPrice = _totalPrice + model.goodsCount.intValue*[[NSString stringWithFormat:@"%@",self.model.unitPrice] doubleValue];
    //        }
    //        NSLog(@"totalPrice === %.2f",_totalPrice);
    //
    //     // 价格合计
    //    self.totoalPriceLabel.text = [NSString stringWithFormat:@"价格合计: ￥%.2f",_totalPrice];
    //    self.totoalPriceLabelMid.text = [NSString stringWithFormat:@"价格合计: ￥%.2f",_totalPrice];
    
    //    NSMutableAttributedString *AttributedStringDeposit = [[NSMutableAttributedString alloc]initWithString:self.totoalPriceLabel.text];
    //    NSDictionary *depositStr=@{
    //
    //                               NSForegroundColorAttributeName:R_G_B_16(0xff4e00),
    ////                               NSFontAttributeName:[UIFont systemFontOfSize:PX_TO_PT(36)]
    //
    //                               };
    //
    //    [AttributedStringDeposit addAttributes:depositStr range:NSMakeRange(5,AttributedStringDeposit.length-5)];
    //
    //    [self.totoalPriceLabel setAttributedText:AttributedStringDeposit];
    //
    //    NSMutableAttributedString *AttributedStringDepositMid = [[NSMutableAttributedString alloc]initWithString:self.totoalPriceLabelMid.text];
    //    NSDictionary *depositStrMid=@{
    //
    //                               NSForegroundColorAttributeName:R_G_B_16(0xff4e00),
    ////                               NSFontAttributeName:[UIFont systemFontOfSize:PX_TO_PT(36)]
    //
    //                               };
    //
    //    [AttributedStringDepositMid addAttributes:depositStrMid range:NSMakeRange(5,AttributedStringDepositMid.length-5)];
    //    
    //    [self.totoalPriceLabelMid setAttributedText:AttributedStringDepositMid];
    
    

    
}
@end

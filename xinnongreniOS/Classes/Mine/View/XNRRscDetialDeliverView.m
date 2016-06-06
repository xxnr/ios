//
//  XNRRscDetialDeliverView.m
//  xinnongreniOS
//
//  Created by xxnr on 16/6/6.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import "XNRRscDetialDeliverView.h"
#import "XNRRscOrderModel.h"
#import "XNRRscConfirmDeliverCell.h"
#import "XNRRscDeliverFrameModel.h"
#import "XNRRscDetialTakeView.h"
#import "XNRRscOrderDetailModel.h"
@interface XNRRscDetialDeliverView()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, weak) UIView *coverView;

@property (nonatomic, weak) UIView *deliverView;

@property (nonatomic, weak) UITableView *tableView;

//@property (nonatomic, strong) XNRRscOrderModel *model;

@property (nonatomic, strong) XNRRscOrderDetailModel *detailModel;

@property (nonatomic, weak) UIButton *admireBtn;

@property (nonatomic, weak) UILabel *stateLabel;

@property (nonatomic, weak) XNRRscDetialTakeView *takeView;

@property (nonatomic, assign) NSInteger totalCount;

@property (nonatomic, assign) XNRRscDetialConfirmDeliverViewType type;

@end

@implementation XNRRscDetialDeliverView

-(XNRRscDetialTakeView *)takeView
{
    if (!_takeView) {
        XNRRscDetialTakeView *takeView = [[XNRRscDetialTakeView alloc] init];
        self.takeView = takeView;
        [self addSubview:takeView];
    }
    return _takeView;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createView];
        [self createTableView];
        [self createBottomView];
    }
    return self;
}

-(void)createBottomView
{
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, PX_TO_PT(782), ScreenWidth, PX_TO_PT(100))];
    bottomView.backgroundColor = R_G_B_16(0xffffff);
    [self.deliverView addSubview:bottomView];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, PX_TO_PT(1))];
    line.backgroundColor = R_G_B_16(0xc7c7c7);
    [bottomView addSubview:line];
    
    UIButton *admireBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    admireBtn.frame = CGRectMake(0, 0, PX_TO_PT(180), PX_TO_PT(52));
    admireBtn.center = CGPointMake(ScreenWidth/2, PX_TO_PT(50));
    [admireBtn setTitleColor:R_G_B_16(0xffffff) forState:UIControlStateNormal];
    [admireBtn setBackgroundImage:[UIImage imageWithColor_Ext:[UIColor colorFromString_Ext:@"#c7c7c7"]] forState:UIControlStateNormal];
    [admireBtn setBackgroundImage:[UIImage imageWithColor_Ext:[UIColor colorFromString_Ext:@"#fe9b00"]] forState:UIControlStateSelected];
    admireBtn.backgroundColor = R_G_B_16(0xfe9b00);
    admireBtn.layer.cornerRadius = 5.0;
    admireBtn.layer.masksToBounds = YES;
    admireBtn.titleLabel.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
    [admireBtn addTarget:self action:@selector(admireBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.admireBtn = admireBtn;
    [bottomView addSubview:admireBtn];
}

-(void)admireBtnClick
{
    if (_totalCount>0) {
        if (self.admireBtn.selected == YES) {
            [self.takeView show:_detailModel];
            [self.deliverView removeFromSuperview];
            [self.coverView removeFromSuperview];
        }else{
            [UILabel showMessage:@"您还没有选择商品哦"];
        }
    }else{
        if (self.admireBtn.selected == YES) {
            NSMutableArray *refArray = [NSMutableArray array];
            for (XNRRscSkusModel *model in _detailModel.SKUList) {
                if (model.isSelected) {
                    [refArray addObject:model.ref];
                }
            }
            NSDictionary *params = @{@"orderId":_detailModel.id,@"SKURefs":refArray,@"token":[DataCenter account].token?[DataCenter account].token:@""};
            
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            manager.requestSerializer=[AFJSONRequestSerializer serializer];// 申明请求的数据是json类型
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
            [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
            manager.requestSerializer.timeoutInterval = 10.f;
            [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
            
            [manager POST:KRscDelivering parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                id resultObj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                
                NSDictionary *resultDic;
                if ([resultObj isKindOfClass:[NSDictionary class]]) {
                    resultDic = (NSDictionary *)resultObj;
                }
                if ([resultObj[@"code"] integerValue] == 1000) {
                    [self cancel];
                    [self setWarnViewTitle:@"配送成功"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTableView" object:nil];
                    
                }else{
                    [self cancel];
                    [UILabel showMessage:resultObj[@"message"]];
                    //                    [self setWarnViewTitle:@"请稍后再试"];
                }
                
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"===%@",error);
                
            }];
        }else{
            [UILabel showMessage:@"您还没有选择商品哦"];
        }
    }
    
}

-(UIView *)setWarnViewTitle:(NSString *)titleLabel{
    
    UIView *coverView = [[UIView alloc] initWithFrame:AppKeyWindow.bounds];
    coverView.backgroundColor = [UIColor blackColor];
    coverView.alpha = 0.6;
    [AppKeyWindow addSubview:coverView];
    
    UIView *warnView = [[UIView alloc]initWithFrame:CGRectMake(PX_TO_PT(180), PX_TO_PT(450), PX_TO_PT(390), PX_TO_PT(280))];
    warnView.layer.cornerRadius = PX_TO_PT(20);
    warnView.backgroundColor = [UIColor blackColor];
    [AppKeyWindow addSubview:warnView];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(PX_TO_PT(119), PX_TO_PT(51), PX_TO_PT(121), PX_TO_PT(121))];
    imageView.image = [UIImage imageNamed:@"success"];
    [warnView addSubview:imageView];
    
    UILabel *successLabel = [[UILabel alloc]initWithFrame:CGRectMake(PX_TO_PT(129), CGRectGetMaxY(imageView.frame)+PX_TO_PT(30), PX_TO_PT(140), PX_TO_PT(30))];
    successLabel.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
    successLabel.text = titleLabel;
    successLabel.textColor = [UIColor whiteColor];
    [warnView addSubview:successLabel];
    
    [UIView animateWithDuration:2.0 animations:^{
        warnView.alpha = 0;
        coverView.alpha = 0;
    } completion:^(BOOL finished) {
        //        [coverView removeFromSuperview];
    }];
    return coverView;
}

-(void)createTableView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, PX_TO_PT(88), ScreenWidth, PX_TO_PT(694))];
    tableView.delegate = self;
    tableView.dataSource  = self;
    tableView.separatorStyle =UITableViewCellSeparatorStyleNone;
    self.tableView = tableView;
    [self.deliverView addSubview:tableView];
    
}

-(void)createView
{
    UIView *coverView = [[UIView alloc] initWithFrame:AppKeyWindow.bounds];
    [coverView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancel)]];
    coverView.backgroundColor = [UIColor blackColor];
    coverView.alpha = 0.4;
    self.coverView = coverView;
    [AppKeyWindow addSubview:coverView];
    
    UIView *deliverView = [[UIView alloc] init];
    deliverView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, PX_TO_PT(882));
    deliverView.backgroundColor = [UIColor whiteColor];
    deliverView.userInteractionEnabled = YES;
    self.deliverView = deliverView;
    [AppKeyWindow addSubview:deliverView];
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, PX_TO_PT(88))];
    headView.backgroundColor = R_G_B_16(0xfafafa);
    [deliverView addSubview:headView];
    
    UILabel *stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(PX_TO_PT(30), 0, ScreenWidth, PX_TO_PT(88))];
    stateLabel.textColor = R_G_B_16(0x323232);
    stateLabel.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
    self.stateLabel = stateLabel;
    [headView addSubview:stateLabel];
    
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth-PX_TO_PT(34)-PX_TO_PT(30), PX_TO_PT(27), PX_TO_PT(34), PX_TO_PT(34))];
    [cancelBtn setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:cancelBtn];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, PX_TO_PT(88), ScreenWidth, PX_TO_PT(1))];
    lineView.backgroundColor = R_G_B_16(0xc7c7c7);
    [headView addSubview:lineView];
}

-(void)cancelBtnClick
{
    [self cancel];
}

-(void)show:(XNRRscOrderDetailModel *)model andType:(XNRRscDetialConfirmDeliverViewType)type
{
    _type = type;
    if (_coverView == nil &&_deliverView == nil) {
        for (XNRRscSkusModel *skuModel in model.SKUList) {
            skuModel.isSelected = NO;
        }
        _totalCount = 0;
        [self createView];
        [self createTableView];
        [self createBottomView];
    }
    [model.SKUsDeliverFrame removeAllObjects];
    [self changeState:type];
    
    for (XNRRscSkusModel *skuModel in model.SKUList) {
        XNRRscDeliverFrameModel *frameModel = [[XNRRscDeliverFrameModel alloc] init];
        if ([skuModel.deliverStatus integerValue] == 4) {
            frameModel.model = skuModel;
        }
        [model.SKUsDeliverFrame addObject:frameModel];
    }
    _detailModel = model;
    
    [self.tableView reloadData];
    self.coverView.hidden = NO;
    self.deliverView.hidden  = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.deliverView.frame  =  CGRectMake(0, ScreenHeight-PX_TO_PT(882), ScreenWidth, PX_TO_PT(882));
    }];
    
}

-(void)changeState:(XNRRscDetialConfirmDeliverViewType)type
{
    if (type == isFromDetialDeliverController) {
        [self.admireBtn setTitle:@"确定" forState:UIControlStateNormal];
        self.stateLabel.text = @"开始配送";
    }else{
        [self.admireBtn setTitle:@"下一步" forState:UIControlStateNormal];
        self.stateLabel.text = @"客户自提-选择商品";
    }
}

-(void)cancel
{
    [UIView animateWithDuration:0.3 animations:^{
        self.deliverView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, 0);
    } completion:^(BOOL finished) {
        [self.deliverView removeFromSuperview];
        [self.coverView removeFromSuperview];
        //        self.coverView.hidden = YES;
    }];
}



//设置行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _detailModel.SKUsDeliverFrame.count;
}

//行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XNRRscDeliverFrameModel *frameModel = _detailModel.SKUsDeliverFrame[indexPath.row];
    return frameModel.cellHeight;
}

//cell点击方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    XNRRscSkusModel *model = _detailModel.SKUList[indexPath.row];
    if (model.isSelected == YES) {
        model.isSelected = NO;
    }else{
        model.isSelected = YES;
    }
    //    _totalCount = 0;
    if (model.isSelected) {
        self.admireBtn.selected = YES;
        _totalCount = _totalCount + model.count.integerValue;
        if (_type == isFromDetialDeliverController) {
            [self.admireBtn setTitle:[NSString stringWithFormat:@"确定(%ld)",(long)_totalCount] forState:UIControlStateSelected];
            
        }else{
            [self.admireBtn setTitle:[NSString stringWithFormat:@"下一步(%ld)",(long)_totalCount] forState:UIControlStateSelected];
            
        }
    }else{
        _totalCount = _totalCount - model.count.integerValue;
        if (_totalCount == 0) {
            self.admireBtn.selected = NO;
            [self.admireBtn setTitle:@"确定"forState:UIControlStateNormal];
        }else{
            self.admireBtn.selected = YES;
            if (_type == isFromDetialDeliverController) {
                [self.admireBtn setTitle:[NSString stringWithFormat:@"确定(%ld)",(long)_totalCount] forState:UIControlStateSelected];
                
            }else{
                [self.admireBtn setTitle:[NSString stringWithFormat:@"下一步(%ld)",(long)_totalCount] forState:UIControlStateSelected];
                
            }
            
        }
    }
    
    [self.tableView reloadData];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XNRRscConfirmDeliverCell *cell = [XNRRscConfirmDeliverCell cellWithTableView:tableView];
    XNRRscDeliverFrameModel *frameModel = _detailModel.SKUsDeliverFrame[indexPath.row];
    cell.frameModel = frameModel;
    return cell;
    
}


@end

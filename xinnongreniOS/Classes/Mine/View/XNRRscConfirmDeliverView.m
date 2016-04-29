//
//  XNRRscConfirmDeliverView.m
//  xinnongreniOS
//
//  Created by xxnr on 16/4/27.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import "XNRRscConfirmDeliverView.h"
#import "XNRRscOrderModel.h"
#import "XNRRscConfirmDeliverCell.h"
#import "XNRRscDeliverFrameModel.h"
#import "XNRRscCustomerTakeView.h"

@interface XNRRscConfirmDeliverView()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, weak) UIView *coverView;

@property (nonatomic, weak) UIView *deliverView;

@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, strong) XNRRscOrderModel *model;

@property (nonatomic, weak) UIButton *admireBtn;

@property (nonatomic, weak) UILabel *stateLabel;

@property (nonatomic, weak) XNRRscCustomerTakeView *takeView;


@end

@implementation XNRRscConfirmDeliverView


-(XNRRscCustomerTakeView *)takeView
{
    if (!_takeView) {
        XNRRscCustomerTakeView *takeView = [[XNRRscCustomerTakeView alloc] init];
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
    [admireBtn addTarget:self action:@selector(admireBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.admireBtn = admireBtn;
    [bottomView addSubview:admireBtn];
}

-(void)admireBtnClick
{
    if ([self.admireBtn.titleLabel.text isEqualToString:@"下一步"]) {
        if (self.admireBtn.selected == YES) {
            [self.takeView show:_model];
            self.deliverView.hidden = YES;
            self.coverView.hidden = YES;
        }else{
            [UILabel showMessage:@"您还没有选择商品哦"];
        }
      
    }else{
        if (self.admireBtn.selected == YES) {
            NSMutableArray *refArray = [NSMutableArray array];
            for (XNRRscSkusModel *model in _model.SKUs) {
                if (model.isSelected) {
                    [refArray addObject:model.ref];
                }
            }
            NSDictionary *params = @{@"orderId":_model._id,@"SKURefs":refArray};
            
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
                    [UILabel showMessage:resultObj[@"message"]];
                    
                }else{
                    [UILabel showMessage:resultObj[@"message"]];
                }
                
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"===%@",error);
                
            }];
        }else{
            [UILabel showMessage:@"您还没有选择商品哦"];
        }
    }

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

-(void)show:(XNRRscOrderModel *)model andType:(XNRRscConfirmDeliverViewType)type
{
    [self changeState:type];
    
    for (XNRRscSkusModel *skuModel in model.SKUs) {
        XNRRscDeliverFrameModel *frameModel = [[XNRRscDeliverFrameModel alloc] init];
        frameModel.model = skuModel;
        [model.SKUsDeliverFrame addObject:frameModel];
    }
    _model = model;
    
    [self.tableView reloadData];
    self.coverView.hidden = NO;
    self.deliverView.hidden  = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.deliverView.frame  =  CGRectMake(0, ScreenHeight-PX_TO_PT(882), ScreenWidth, PX_TO_PT(882));
    }];
    
}

-(void)changeState:(XNRRscConfirmDeliverViewType)type
{
    if (type == isFromDeliverController) {
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
        self.coverView.hidden = YES;
    }];
}



//设置行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _model.SKUs.count;
    
}

//行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XNRRscDeliverFrameModel *frameModel = _model.SKUsDeliverFrame[indexPath.row];
    return frameModel.cellHeight;
}

//cell点击方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    XNRRscSkusModel *model = _model.SKUs[indexPath.row];    
    if (model.isSelected == YES) {
        model.isSelected = NO;
    }else{
        model.isSelected = YES;
    }
    
    if (model.isSelected) {
        self.admireBtn.selected = YES;
        if ([self.admireBtn.titleLabel.text isEqualToString:@"确定"]) {
            [self.admireBtn setTitle:[NSString stringWithFormat:@"确定(%@)",model.count] forState:UIControlStateNormal];
        }
    }else{
        self.admireBtn.selected = NO;
        if ([self.admireBtn.titleLabel.text isEqualToString:[NSString stringWithFormat:@"确定(%@)",model.count]]) {
            [self.admireBtn setTitle:@"确定" forState:UIControlStateNormal];
        }

    }

    [self.tableView reloadData];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XNRRscConfirmDeliverCell *cell = [XNRRscConfirmDeliverCell cellWithTableView:tableView];
    XNRRscDeliverFrameModel *frameModel = _model.SKUsDeliverFrame[indexPath.row];
    cell.frameModel = frameModel;
    return cell;
    
}


@end

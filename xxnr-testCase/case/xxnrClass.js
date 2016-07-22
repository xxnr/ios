/**
 * Created by yangning on 16/7/12.
 */

function xxnrClass(){};

// title
xxnrClass.navigationBarTitle = function (window) {
    return window.navigationBar().name();
}
//返回按钮
xxnrClass.navBack = function (window) {
    return window.navigationBar().buttons()["top back"];
}
//首页
xxnrClass.home = function (window) {
    return{
        homeTab:function () {
            return window.tabBar().buttons()["首页"];
        },
        newsTab:function () {
            return window.tabBar().buttons()["资讯"];
        },
        shoppingCarTab:function () {
            return window.tabBar().buttons()["购物车"];
        },
        mineTab:function () {
            return window.tabBar().buttons()["我的"];
        },
        fer_special:function () {
            return window.collectionViews()[0].buttons()[5];
        },
        car_special:function () {
            return window.collectionViews()[0].buttons()[6];
        },
    }
}
//专场
xxnrClass.special = function (window) {
    return{
        cell:function () {
            return window.tableViews()[0].cells()["江淮汽车 - 第二代瑞风S3 - 2015款"];
        }
    }
}
//商品详情
xxnrClass.goodDetail = function (window) {
    return {
        addShopcar:function () {
            return window.buttons()["加入购物车"];
        },
        addShopcar_name:function () {
            return window.collectionViews()[0].cells()["2.0T 自动（6DCT）"];
        },
        addShopcar_type:function () {
            return window.collectionViews()[0].cells()["豪华智能型"];
        },
        addShopcar_color:function () {
            return window.collectionViews()[0].cells()["拉菲红"];
        },
        addShopcar_sure:function () {
            return window.buttons()["确定"];
        },
    }
}


xxnrClass.rscOrder = function (window) {
    return{
        rscOrderStaticText : function () {return window.scrollViews()[0].tableViews()[0].groups()[0].staticTexts()[0].name();},
    };
}

xxnrClass.selPayType = function (window) {
    return{
        separatePay:function () {
            return  window.buttons()["分次支付"];
        },
        goPay:function () {
            return window.buttons()["去支付"];
        }
    }
}
//选择支付方式页
function selPayType(window)
{
    separatePay = window.buttons()["分次支付"];
    goPay = window.buttons()["去支付"];
    nav_back = window.navigationBar().buttons()["top back"];
}
//支付宝
function alipay(window) {
    ALipayBack = window.scrollViews()[0].webViews()[0].links()["返回"];
    ALipayBackYes = window.scrollViews()[0].webViews()[0].links()["是"];
}

// 注册页
xxnrClass.register = function (window) {
    return {
        title:function () {
            return window.navigationBar().buttons()["注册"];
        },
        phoneNum:function () {
            return window.images()[0].textFields()[0].textFields()[0];
        },
        identifyCode:function () {
            return window.images()[0].textFields()[1].textFields()[0];
        },
        passWord:function () {
            return window.images()[0].secureTextFields()[0].secureTextFields()[0];
        },
        passWordAgain:function () {
            return window.images()[0].secureTextFields()[1].secureTextFields()[0];
        },
        identifyBtn:function () {
            return window.images()[0].buttons()["免费获取验证码"];
        },
        protocolSelectBtn:function () {
            return window.images()[0].buttons()[5];
        },
        protocolJumpBtn:function () {
           return  target.tap({x:32,y:385});

        },
        registerBtn:function () {
            return  window.images()[0].buttons()["立即注册"];
        },
        loginBtn:function () {
            return  target.tap({x:0,y:503});
        },
        alertAdmireBtn:function () {
            return window.buttons()["确定"];
        },
        alertCancelBtn:function () {
            return window.buttons()["取消"];

        },
        inputGraphCode:function(){

            return window.textFields()[0].textFields()[0];
        },
        emptyWarning:function () {
            return window.staticText()["请输入图形验证码"].value();

        },
        errorWarning:function () {
            return window.staticText()["图形验证码错误"].value();

        }

    }

}
// 忘记密码页
xxnrClass.forgetPassword = function (window) {
    return{
        title:function () {
            return window.navigationBar().buttons()["注册"];
        },
        phoneNum:function () {
            return window.images()[0].textFields()[0].textFields()[0];
        },
        identifyCode:function () {
            return window.images()[0].textFields()[1].textFields()[0];
        },
        passWord:function () {
            return window.images()[0].secureTextFields()[0].secureTextFields()[0];
        },
        passWordAgain:function () {
            return window.images()[0].secureTextFields()[1].secureTextFields()[0];
        },
        identifyBtn:function () {
            return window.images()[0].buttons()["免费获取验证码"];
        },
        registerBtn:function () {
            return  window.images()[0].buttons()["完成"];
        },
    }
}
// 购物车页
xxnrClass.shoppingCar = function (window) {
    return{
        title:function () {
            return window.navigationBar().buttons()["购物车"];
            },
        editBtn:function () {
            return window.navigationBar().buttons()["编辑"];
        },
        finishBtn:function () {
            return window.navigationBar().buttons()["完成"];
        },
        allSelectBtn:function () {
            return target.tap({x:16,y:587});
        },
        goPayBtn:function () {
            return window.buttons()["去结算"];
        },
        cancelBtn:function () {
            return window.buttons()["删除"];
        },
        brandSelectBtn:function () {
            return window.tableViews().groups()[0].buttons()["shopCar circle"];
        },
        brandName:function () {
            return window.tableViews().groups()[0].staticText()["江淮"];
        },
        goodsSelectBtn:function () {
            return window.tableViews().cells()[0].buttons()["address circle"];
        },
        minusBtn:function () {
            return window.tableViews().cells()[0].buttons()["icon minus"];
        },
        plusBtn:function () {
            return window.tableViews().cells()[0].buttons()["icon plus"];
        },
        inputCount:function () {
            return window.tableViews().cells()[0].textFields()[0].textFields()[0];
        },
        addtionsName:function () {
            return window.tableViews().cellls[0].staticText()["附加项目:改七座"];
        },
        periodOneName:function () {
            return window.tableViews().cellls[0].staticText()["阶段一:订金"];

        },
        periodTwoName:function () {
            return window.tableViews().cellls[0].staticText()["阶段二:尾款"];

        },
        goodsName:function () {
            return window.tableViews().cellls[0].staticText()["江淮汽车 - 第二代瑞风S3 - 2015款"];

        },
        attributesName:function () {
            return window.tableViews().cellls[0].staticText()["变速箱"];

        },
        price:function () {
            return window.tableViews().cellls[0].staticText()["¥ 9999.00"];
        },
        addtionsPrice:function () {
            return window.tableViews().cellls[0].staticText()["¥ 2000.00"];
        },
        deposit:function () {
            return window.tableViews().cellls[0].staticText()["¥ 3000.00"];
        },
        finalPayment:function () {
            return window.tableViews().cellls[0].staticText()["¥ 98999.00"];
        },
        price:function () {
            return window.staticText()[0].name()["合计: ¥0.00"];
        },
        alertCancel:function () {
            return window.buttons()["取消"];
        },
        alertAdmire:function () {
            return window.buttons()["确定"];
        },
        buyFertilizer:function () {
            return  window.buttons()["去买化肥"];

        },
        buyCar:function () {
            return  window.buttons()["去买汽车"];

        },
    }
}
// 我的新农人页
xxnrClass.mine = function (window) {
    return{
        loginBtn:function () {
            return window.tableViews()[0].images()[0].buttons()["登录"];
        },
        registerBtn:function () {
            return window.tableViews()[0].images()[0].buttons()["注册"];
        },
        stayPayBtn:function () {
            return window.tableViews()[0].buttons()[1];
        },
        stayDeliverBtn:function () {
            return window.tableViews()[0].buttons()[2];
        },
        stayTakeBtn:function () {
            return window.tableViews()[0].buttons()[3];
        },
        finishBtn:function () {
            return window.tableViews()[0].buttons()[4];
        },
        rscOrderBtn:function () {
            return  window.tableViews()[0].buttons()[0];

        },
        orderBtn:function () {
            return  window.tableViews()[0].buttons()[1];

        },
        integrateBtn:function () {
            return   window.tableViews()[0].cells()[0];
        },
        representBtn:function () {
            return   window.tableViews()[0].cells()[1];

        },
        phoneBtn:function () {
            return   window.tableViews()[0].cells()[2];

        },
        setBtn:function () {
            return   window.tableViews()[0].cells()[3];

        },
        alertCancel:function () {
            return   window.buttons()["取消"];
        },
        mineBtn:function () {
            return   target.doubleTap({x:0, y:64});

        },
    }
}
// 我的个人信息页
xxnrClass.mineData = function (window) {
    return{
      headIconBtn:function () {
          return
      },
        nickNameBtn:function () {
            return  window.scrollViews()[0].buttons()[1];

        },
        nameBtn:function () {
            return  window.scrollViews()[0].buttons()[2];

        },
        nameText:function () {
            return  window.scrollViews()[0].staticText()[0].name();
        },
        sexBtn:function () {
            return  window.scrollViews()[0].buttons()[3];

        },
        sexText:function () {
            return  window.scrollViews()[0].staticText()[0].name();
        },
        addressBtn:function () {
            return  window.scrollViews()[0].buttons()[4];

        },
        typeBtn:function () {
            return  window.scrollViews()[0].buttons()[5];

        },
        inputTextField:function () {
            return  window.textFields()[0].textFields()[0];

        },
        finishBtn:function () {
            return  window.buttons()["完成"];

        },
        saveBtn:function () {
            return  window.buttons()["保存"];

        },
        menBtn:function () {
           return window.buttons()[0];
        },
        womenBtn:function () {
            return window.buttons()[1];
        },
        localBtn:function () {
            return window.buttons()[0];

        },
        streetBtn:function () {
            return window.buttons()[1];
        },
        
        picksBtn:function () {
            return window.pickers()[0].wheels()[1].dragInsideWithOptions({startOffset:{x:0.38, y:0.66}, endOffset:{x:0.38, y:0.12}, duration:1.6});
        },
        addressPicks:function () {
            return window.buttons()[4];
        },
    }
}

// 我的网点

xxnrClass.rscOrders = function (window) {
        return{
            allTypeTab:function () {
                 return window.buttons()["全部"];
             },
            waitPayTab:function () {
                return window.buttons()["待付款"];
            },
            waitVerifyTab:function () {
                return window.buttons()["待审核"];

            },
            waitDeliverTab:function () {
                return window.buttons()["待配送"];

            },
            waitTakeTab:function () {
                return window.buttons()["待自提"];
            },
            orderStatus:function () {
               return window.tableViews()[0].groups()[0].name();
            },
            identifyPayBtn:function () {
                return window.scrollViews()[0].tableViews()[0].groups()["网点自提"].buttons()["审核付款"];

            },
            eposeBtn:function () {
                return window.buttons()["线下POS机"];
            },
            cashBtn:function () {
                return window.buttons()["现金"];
            },
            admireBtn:function () {
                return window.buttons()["确定"];
            },
            closeBtn:function () {
                return window.buttons()["close"];

            },
            startDeliverBtn:function () {
                return window.scrollViews()[0].tableViews()[0].groups()["配送到户"].buttons()["开始配送"];
            },

            
            
        }
}


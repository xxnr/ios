/**
 * Created by yangning on 16/7/12.
 */

function xxnrClass(){};
function delay(duration) {
    return UIATarget.localTarget().delay(duration);
}
function logMessage(message){
    return UIALogger.logMessage(message);
}
//返回按钮
xxnrClass.navBack = function (window) {
    return window.navigationBar().buttons()["top back"];
}
//标题
xxnrClass.navTitle = function (window) {
    return window.navigationBar().staticTexts()[0].value();
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
    fer_specialBtn:function () {
        return window.collectionViews()[0].buttons()[5];
    },
    car_specialBtn:function () {
        return window.collectionViews()[0].buttons()[6];
    }
    }
}
//专场
xxnrClass.special = function (window) {
    return{
    cell1:function () {
        return window.tableViews()[0].cells()["江淮汽车 - 第二代瑞风S3 - 2015款"];
    },
    cell:function (name) {
        return window.tableViews()[0].cells()[name];
    }
    }
}
//商品详情
xxnrClass.goodDetail = function (window) {
    return {
    addShoppingCarBtn:function () {
        return window.buttons()["加入购物车"];
    },
    addshoppingCar_property:function(name){
        return window.collectionViews()[0].cells()[name];
    },
    addShoppingCar_sure:function () {
        return window.buttons()["确定"];
    },
    nav_shoppingCar:function () {
        return window.navigationBar().buttons()["icon shopcar white"];
    }
        // addShopcar_name:function () {
        //     return window.collectionViews()[0].cells()["2.0T 自动（6DCT）"];
        // },
        // addShopcar_type:function () {
        //     return window.collectionViews()[0].cells()["豪华智能型"];
        // },
        // addShopcar_color:function () {
        //     return window.collectionViews()[0].cells()["拉菲红"];
        // },
        
    }
}
//购物车
xxnrClass.shoppingCar = function (window) {
    return {
    sel_Group:function (index) {
        return window.tableViews()[0].groups()[index].buttons()["shopCar circle"];
    },
    go_settle:function (index) {
        return window.buttons()[index];
    }
    }
}
//结算页
xxnrClass.submitOrder = function (window) {
    return{
    carryBtn:function () {
        return window.tableViews()[0].buttons()["网点自提"];
    },
    dispatchBtn:function () {
        return window.tableViews()[0].buttons()["配送到户"];
    },
    addressBtn:function () {
        return window.tableViews()[0].buttons()[4];
    },
    selWebsiteBtn:function () {
        if (window.tableViews()[0].buttons()["配送到户"].isVisible())
        {
            return window.tableViews()[0].buttons()[2];
        }
        logMessage("hhhhhhhhh");
        return window.tableViews()[0].buttons()[1];
    },
    selContactBtn:function () {
        if (window.tableViews()[0].buttons()["配送到户"].isVisible())
        {
            return window.tableViews()[0].buttons()[3];
        }
        return window.tableViews()[0].buttons()[2];
    },
    submitOrderBtn:function () {
        return window.buttons()[0];
    }
        
    }
}
//我的新农人页
xxnrClass.mine = function (window) {
    return {
    userOrderBtn: function(){return window.tableViews()[0].buttons()[1];},
    rscOrderBtn: function(){return window.tableViews()[0].buttons()[0];}
    };
}
//我的订单列表
xxnrClass.myorder = function (window) {
    return{
    totalTab:function () {return window.staticTexts()["全部"];},
    holdPayTab:function () {return window.staticTexts()["待付款"];},
    sendTab:function () {return window.staticTexts()["待发货"];},
    reciveTab:function () {return window.staticTexts()["待收货"];},
    commentTab:function () {return window.staticTexts()["已完成"];},
    userOrderStaticText:function (index) {
        return window.scrollViews()[0].tableViews()[0].groups()[index].staticTexts()[0].name();
    },
    userOrderId:function (index) {
        return window.scrollViews()[0].tableViews()[0].groups()[index].staticTexts()[1].name();
    },
    tableViewsgroups:function () {
        return window.scrollViews()[0].tableViews()[0].groups();
    },
    tableView:function () {
        return  window.scrollViews()[0].tableViews()[0];
    },
    userOrderCell:function (index) {
        return window.scrollViews()[0].tableViews()[0].cells()[index];
    },
    amendPayType:function (index) {
        return window.scrollViews()[0].tableViews()[0].groups()[index].buttons()["修改付款方式"];
    },
    receiveGoods:function (index) {
        return window.scrollViews()[0].tableViews()[0].groups()[index].buttons()["确认收货"];
    }
    };
}
//县级订单列表
// xxnrClass.rscorder = function (window) {
//     return{
//         totalTab:function () {return window.staticTexts()["全部"];},
//         holdPayTab:function () {return window.staticTexts()["待付款"];},
//         sendTab:function () {return window.staticTexts()["待发货"];},
//         reciveTab:function () {return window.staticTexts()["待收货"];},
//         commentTab:function () {return window.staticTexts()["已完成"];},
//         userOrderStaticText:function (index) {
//             return window.scrollViews()[0].tableViews()[0].groups()[index].staticTexts()[0].name();
//         },
//         userOrderId:function (index) {
//             return window.scrollViews()[0].tableViews()[0].groups()[index].staticTexts()[1].name();
//         },
//         tableViewsgroups:function () {
//             return window.scrollViews()[0].tableViews()[0].groups();
//         },
//         tableView:function () {
//             return  window.scrollViews()[0].tableViews()[0];
//         },
//         userOrderCell:function (index) {
//             return window.scrollViews()[0].tableViews()[0].cells()[index];
//         },
//
//     };
// }
xxnrClass.orderDetail = function (window) {
    return{
    goPay:function () {
        return window.buttons()["去付款"];
    },
    goCarry:function () {
        return window.buttons()["去自提"];
    }
    }
}//县级订单列表
xxnrClass.RSCOrder = function (window) {
    return{
    totalTab:function () {return window.buttons()["全部"];},
    holdPayTab:function () {return window.buttons()["待付款"];},
    verifyTab:function () {return window.buttons()["待审核"];},
    dispatchTab:function () {return window.buttons()["待配送"];},
    carryTab:function () {return window.buttons()["待自提"];},
    RSCOrderStaticText:function (index) {
        return window.scrollViews()[0].tableViews()[0].groups()[index].staticTexts()[0].name();
    },
    RSCOrderId:function (index) {
        return window.scrollViews()[0].tableViews()[0].groups()[index].staticTexts()[1].name();
    },
    tableViewsgroups:function () {
        return window.scrollViews()[0].tableViews()[0].groups();
    },
    tableView:function () {
        return  window.scrollViews()[0].tableViews()[0];
    },
    RSCOrderCell:function (index) {
        return window.scrollViews()[0].tableViews()[0].cells()[index];
    },
    verifyMoney:function (index) {
        return window.scrollViews()[0].tableViews()[0].groups()[index].buttons()["审核付款"];
    },
    customerCarry:function (index) {
        return window.scrollViews()[0].tableViews()[0].groups()[index].buttons()["客户自提"];
    },
    beginDispatch:function (index) {
        return window.scrollViews()[0].tableViews()[0].groups()[index].buttons()["开始配送"];
    },
    makeSureBtn:function () {
        return window.buttons()["确定"];
    },
    disPatchmakeSure:function (index) {
        return window.buttons()[index];
    },
    carryTableViewcell:function (index) {
        return window.tableViews()[0].cells()[index];
    },
    nextStepBtn:function () {
        return window.buttons()[6];
    },
    carryNumTextField:function () {
        return window.textFields()[0].textFields()[0];
    },
    completeBtn:function () {
        return target.frontMostApp().windows()[1].toolbar().buttons()["完成"];
    }
        
    };
}

//选择支付方式
xxnrClass.selPayType = function (window) {
    return{
    separatePay:function () {
        return  window.buttons()["分次支付"];
    },
    goPay:function () {
        return window.buttons()["去支付"];
    },
    nav_back:function () {
        return window.navigationBar().buttons()["top back"];
    }
    }
}
//支付宝
xxnrClass.alipay = function (window) {
    return{
    ALipayBack:function () {
        return window.scrollViews()[0].webViews()[0].links()["返回"];
    },
    ALipayBackYes:function () {
        return window.scrollViews()[0].webViews()[0].links()["是"];
    }
    }
}


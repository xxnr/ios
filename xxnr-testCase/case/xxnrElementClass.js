/**
 * Created by yangning on 16/7/12.
 */


function xxnrElementClass(){}
//延迟
function xxnrdelay(duration) {
    return UIATarget.localTarget().delay(duration);
}
//打印信息
function xxnrlogMessage(message){
    return UIALogger.logMessage(message);
}
//打印层级树
function xxnrlogEleTree(window)
{
    return window.logElementTree();
}
//返回按钮
xxnrElementClass.navBack = function (window) {
    return window.navigationBar().buttons()["top back"];
}
//标题
xxnrElementClass.navTitle = function (window) {
    return window.navigationBar().staticTexts()[0].value();
}
//tab
xxnrElementClass.tab = function (window) {
    return{
<<<<<<< HEAD
<<<<<<< HEAD
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
        }
=======
=======
>>>>>>> ynn_ios
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
    }
<<<<<<< HEAD
>>>>>>> ynn_ios
=======
>>>>>>> ynn_ios
    }
}
//首页
xxnrElementClass.home = function(window)
{
    return{
<<<<<<< HEAD
<<<<<<< HEAD
        fer_specialBtn:function () {
            return window.collectionViews()[0].buttons()[5];
        },
        car_specialBtn:function () {
            return window.collectionViews()[0].buttons()[6];
        }
=======
=======
>>>>>>> ynn_ios
    fer_specialBtn:function () {
        return window.collectionViews()[0].buttons()[5];
    },
    car_specialBtn:function () {
        return window.collectionViews()[0].buttons()[6];
    }
<<<<<<< HEAD
>>>>>>> ynn_ios
=======
>>>>>>> ynn_ios
    }
}
//专场
xxnrElementClass.special = function (window) {
    return{
<<<<<<< HEAD
<<<<<<< HEAD
        cell1:function () {
            return window.tableViews()[0].cells()["江淮汽车 - 第二代瑞风S3 - 2015款"];
        },
        cell:function (name) {
            return window.tableViews()[0].cells()[name];
        },
        cells:function () {
            return window.tableViews()[0].cells();
        },
        price:function (index) {
            return window.tableViews()[0].cells()[index].staticTexts()[1].value();
        },
        priceBtn:function () {
            return window.buttons()["价格"];
        },
        totalBtn:function () {
            return window.buttons()["综合"];
        },
        filterBtn:function () {
            return window.buttons()["筛选"];
        }
=======
=======
>>>>>>> ynn_ios
    cell1:function () {
        return window.tableViews()[0].cells()["江淮汽车 - 第二代瑞风S3 - 2015款"];
    },
    cell:function (name) {
        return window.tableViews()[0].cells()[name];
    },
    cells:function () {
        return window.tableViews()[0].cells();
    },
    price:function (index) {
        return window.tableViews()[0].cells()[index].staticTexts()[1].value();
    },
    priceBtn:function () {
        return window.buttons()["价格"];
    },
    totalBtn:function () {
        return window.buttons()["综合"];
    },
    filterBtn:function () {
        return window.buttons()["筛选"];
    }
<<<<<<< HEAD
>>>>>>> ynn_ios
=======
>>>>>>> ynn_ios
    }
}
//筛选页
xxnrElementClass.filter = function (window) {
    return {
<<<<<<< HEAD
<<<<<<< HEAD
        cell:function (index) {
            return window.collectionViews()[0].cells()[index];
        },
        cells:function () {
            return window.collectionViews()[0].cells();
        },
        makeSureBtn:function () {
            return window.buttons()["确定"];
        },
        resetBtn:function () {
            return window.buttons()["重置"];
        }
=======
=======
>>>>>>> ynn_ios
    cell:function (index) {
        return window.collectionViews()[0].cells()[index];
    },
    cells:function () {
        return window.collectionViews()[0].cells();
    },
    makeSureBtn:function () {
        return window.buttons()["确定"];
    },
    resetBtn:function () {
        return window.buttons()["重置"];
    }
<<<<<<< HEAD
>>>>>>> ynn_ios
=======
>>>>>>> ynn_ios
    }
}
//商品详情
xxnrElementClass.goodDetail = function (window) {
    return {
<<<<<<< HEAD
<<<<<<< HEAD
        purchaseBtn:function () {
            return window.buttons()["立即购买"];
        },
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

=======
=======
>>>>>>> ynn_ios
    purchaseBtn:function () {
        return window.buttons()["立即购买"];
    },
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
        
<<<<<<< HEAD
>>>>>>> ynn_ios
=======
>>>>>>> ynn_ios
    }
}
//资讯列表
xxnrElementClass.news = function (window) {
    return{
<<<<<<< HEAD
<<<<<<< HEAD
        tableView:function () {
            return window.tableViews()[0];
        },
        cells:function () {
            return window.tableViews()[0].cells();
        },
        cell:function (index) {
            return window.tableViews()[0].cells()[index];
        },
=======
=======
>>>>>>> ynn_ios
    tableView:function () {
        return window.tableViews()[0];
    },
    cells:function () {
        return window.tableViews()[0].cells();
    },
    cell:function (index) {
        return window.tableViews()[0].cells()[index];
    },
<<<<<<< HEAD
>>>>>>> ynn_ios
=======
>>>>>>> ynn_ios
    }
}
//资讯详情
xxnrElementClass.newsDetail = function (window) {
    return{
<<<<<<< HEAD
<<<<<<< HEAD
        navShare:function () {
            return window.navigationBar().buttons()[2];
        },
        WX:function () {
            return window.buttons()[0];
        },
        WXFiends:function () {
            return window.buttons()[1];
        },
        QQ:function () {
            return window.buttons()[2];
        },
        QQSpace:function () {
            return window.buttons()[3];
        }
=======
=======
>>>>>>> ynn_ios
    navShare:function () {
        return window.navigationBar().buttons()[2];
    },
    WX:function () {
        return window.buttons()[0];
    },
    WXFiends:function () {
        return window.buttons()[1];
    },
    QQ:function () {
        return window.buttons()[2];
    },
    QQSpace:function () {
        return window.buttons()[3];
    }
<<<<<<< HEAD
>>>>>>> ynn_ios
=======
>>>>>>> ynn_ios
    }
}
//购物车
xxnrElementClass.shoppingCar = function (window) {
    return {
<<<<<<< HEAD
<<<<<<< HEAD
        sel_Group:function (index) {
            return window.tableViews()[0].groups()[index].buttons()["shopCar circle"];
        },
        go_settle:function (index) {
            return window.buttons()[index];
        }
=======
=======
>>>>>>> ynn_ios
    sel_Group:function (index) {
        return window.tableViews()[0].groups()[index].buttons()["shopCar circle"];
    },
    go_settle:function (index) {
        return window.buttons()[index];
    }
<<<<<<< HEAD
>>>>>>> ynn_ios
=======
>>>>>>> ynn_ios
    }
}
//结算页
xxnrElementClass.submitOrder = function (window) {
    return{
<<<<<<< HEAD
<<<<<<< HEAD
        carryBtn:function () {
            return window.tableViews()[0].buttons()["网点自提"];
        },
        dispatchBtn:function () {
            return window.tableViews()[0].buttons()["配送到户"];
        },
        addressBtn:function () {
            return window.tableViews()[0].buttons()[4];
        },
        addressText:function () {
            return window.tableViews()[0].staticTexts()[3];
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

=======
=======
>>>>>>> ynn_ios
    carryBtn:function () {
        return window.tableViews()[0].buttons()["网点自提"];
    },
    dispatchBtn:function () {
        return window.tableViews()[0].buttons()["配送到户"];
    },
    addressBtn:function () {
        return window.tableViews()[0].buttons()[4];
    },
    addressText:function () {
        return window.tableViews()[0].staticTexts()[3];
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
        
<<<<<<< HEAD
>>>>>>> ynn_ios
=======
>>>>>>> ynn_ios
    }
}
//收货地址
xxnrElementClass.receiveAddress = function (window) {
    return{
<<<<<<< HEAD
<<<<<<< HEAD
        cells:function () {
            return window.tableViews()[0].cells();
        },
        name:function (index) {
            return window.tableViews()[0].cells()[index].staticTexts()[1];
        },
        acquiescent:function (index) {
            return window.tableViews()[0].cells()[index].staticTexts()["默认"];
        },
        editBtn:function (index) {
            return window.tableViews()[0].cells()[index].buttons()[1];
        },
        deletebtn:function (index) {
            return window.tableViews()[0].cells()[index].buttons()[2];
        },
        navAppendBtn:function () {
            return window.navigationBar().buttons()["添加"];
        },
        cancelBtn:function () {
            return window.buttons()["取消"];
        },
        makeSureBtn:function () {
            return window.buttons()[2];
        }
=======
=======
>>>>>>> ynn_ios
    cells:function () {
        return window.tableViews()[0].cells();
    },
    name:function (index) {
        return window.tableViews()[0].cells()[index].staticTexts()[1];
    },
    acquiescent:function (index) {
        return window.tableViews()[0].cells()[index].staticTexts()["默认"];
    },
    editBtn:function (index) {
        return window.tableViews()[0].cells()[index].buttons()[1];
    },
    deletebtn:function (index) {
        return window.tableViews()[0].cells()[index].buttons()[2];
    },
    navAppendBtn:function () {
        return window.navigationBar().buttons()["添加"];
    },
    cancelBtn:function () {
        return window.buttons()["取消"];
    },
    makeSureBtn:function () {
        return window.buttons()[2];
    }
<<<<<<< HEAD
>>>>>>> ynn_ios
=======
>>>>>>> ynn_ios
    }
}
//添加收货地址
xxnrElementClass.addAddress = function (window) {
    return{
<<<<<<< HEAD
<<<<<<< HEAD
        nameTextField:function () {
            return window.textFields()[0].textFields()[0];
        },
        phoneTextField:function () {
            return window.textFields()[1].textFields()[0];
        },
        cityBtn:function () {
            return window.buttons()[0];
        },
        townBtn:function () {
            return window.buttons()[1];
        },
        detailAdressTextField:function () {
            return window.textFields()[2].textFields()[0];
        },
        postCodeTextField:function () {
            return window.textFields()[3].textFields()[0];
        },
        // acquiescentBtn:function () {
        //     return
        // },
        makeSure:function () {
            return window.buttons()[3];
        },
        saveBtn:function () {
            return window.buttons()["保存"];
        },
        warning:function () {
            return window.staticTexts()[7].value();
        }
=======
=======
>>>>>>> ynn_ios
    nameTextField:function () {
        return window.textFields()[0].textFields()[0];
    },
    phoneTextField:function () {
        return window.textFields()[1].textFields()[0];
    },
    cityBtn:function () {
        return window.buttons()[0];
    },
    townBtn:function () {
        return window.buttons()[1];
    },
    detailAdressTextField:function () {
        return window.textFields()[2].textFields()[0];
    },
    postCodeTextField:function () {
        return window.textFields()[3].textFields()[0];
    },
        // acquiescentBtn:function () {
        //     return
        // },
    makeSure:function () {
        return window.buttons()[3];
    },
    saveBtn:function () {
        return window.buttons()["保存"];
    },
    warning:function () {
        return window.staticTexts()[7].value();
    }
<<<<<<< HEAD
>>>>>>> ynn_ios
=======
>>>>>>> ynn_ios
    }
}
//选择自提网点
xxnrElementClass.selWebsite = function (window) {
    return{
<<<<<<< HEAD
<<<<<<< HEAD
        proviceBtn:function () {
            return window.buttons()[0];
        },
        cityBtn:function () {
            return window.buttons()[1];
        },
        areaBtn:function () {
            return window.buttons()[2];
        },
        cityTableView:function () {
            return window.tableViews()[1];
        },
        cityCells:function () {
            return window.tableViews()[1].cells();
        },
        cityCell:function (index) {
            return window.tableViews()[1].cells()[index];
        },
        webSiteTableView:function () {
            return window.tableViews()[1];
        },
        webSiteCells: function () {
            return window.tableViews()[1].cells();
        },
        webSiteCell:function (index) {
            return window.tableViews()[1].cells()[index];
        },
        makeSureBtn:function () {
            return window.buttons()["确定"];
        }

=======
=======
>>>>>>> ynn_ios
    proviceBtn:function () {
        return window.buttons()[0];
    },
    cityBtn:function () {
        return window.buttons()[1];
    },
    areaBtn:function () {
        return window.buttons()[2];
    },
    cityTableView:function () {
        return window.tableViews()[1];
    },
    cityCells:function () {
        return window.tableViews()[1].cells();
    },
    cityCell:function (index) {
        return window.tableViews()[1].cells()[index];
    },
    webSiteTableView:function () {
        return window.tableViews()[1];
    },
    webSiteCells: function () {
        return window.tableViews()[1].cells();
    },
    webSiteCell:function (index) {
        return window.tableViews()[1].cells()[index];
    },
    makeSureBtn:function () {
        return window.buttons()["确定"];
    }
        
<<<<<<< HEAD
>>>>>>> ynn_ios
=======
>>>>>>> ynn_ios
    }
}
//选择收货人
xxnrElementClass.selContact = function (window) {
    return{
<<<<<<< HEAD
<<<<<<< HEAD
        nameTextField:function () {
            return window.textFields()[0].textFields()[0];
        },
        phoneTextField:function () {
            return window.textFields()[1].textFields()[0];
        },
        makeSureBtn:function () {
            return window.buttons()[0];
        },
        contactTableView:function () {
            return
        },
        contactCells:function () {
            return window.tableViews()[0].cells();
        },
        contactCell:function (index) {
            return window.tableViews()[0].cells()[index];
        }
=======
=======
>>>>>>> ynn_ios
    nameTextField:function () {
        return window.textFields()[0].textFields()[0];
    },
    phoneTextField:function () {
        return window.textFields()[1].textFields()[0];
    },
    makeSureBtn:function () {
        return window.buttons()[0];
    },
    contactTableView:function () {
        return
    },
    contactCells:function () {
        return window.tableViews()[0].cells();
    },
    contactCell:function (index) {
        return window.tableViews()[0].cells()[index];
    }
<<<<<<< HEAD
>>>>>>> ynn_ios
=======
>>>>>>> ynn_ios
    }
}
//我的新农人页
xxnrElementClass.mine = function (window) {
    return {
<<<<<<< HEAD
<<<<<<< HEAD
        loginBtn:function () {
            return window.tableViews()[0].images()["icon_bgView"].buttons()["登录"];
        },

        userOrderBtn: function(){
            if(window.tableViews()[0].buttons().length == 2)
            {
                return window.tableViews()[0].buttons()[1];
            }
            else
            {
                return window.tableViews()[0].buttons()[0];
            }},
        rscOrderBtn: function(){return window.tableViews()[0].buttons()[0];},
        buttons:function () {
            return window.tableViews()[0].buttons();
        },
        cell:function (index) {
            return window.tableViews()[0].cells()[index];
        }
=======
=======
>>>>>>> ynn_ios
    loginBtn:function () {
        return window.tableViews()[0].images()["icon_bgView"].buttons()["登录"];
    },
        
    userOrderBtn: function(){
        if(window.tableViews()[0].buttons().length == 2)
        {
            return window.tableViews()[0].buttons()[1];
        }
        else
        {
            return window.tableViews()[0].buttons()[0];
        }},
    rscOrderBtn: function(){return window.tableViews()[0].buttons()[0];},
    buttons:function () {
        return window.tableViews()[0].buttons();
    },
    cell:function (index) {
        return window.tableViews()[0].cells()[index];
    }
<<<<<<< HEAD
>>>>>>> ynn_ios
=======
>>>>>>> ynn_ios
    };
}

//选择支付方式
xxnrElementClass.selPayType = function (window) {
    return{
<<<<<<< HEAD
<<<<<<< HEAD
        fullPay:function () {
            return window.buttons()["全额支付"];
        },
        separatePay:function () {
            return  window.buttons()["分次支付"];
        },
        goPay:function () {
            return window.buttons()["去支付"];
        },
        alipayBtn:function () {
            return window.buttons()[4];
        },
        unionpayBtn:function () {
            return   window.buttons()[5];
        },
        offLineBtn:function () {
            return window.buttons()[6];
        }
=======
=======
>>>>>>> ynn_ios
    fullPay:function () {
        return window.buttons()["全额支付"];
    },
    separatePay:function () {
        return  window.buttons()["分次支付"];
    },
    goPay:function () {
        return window.buttons()["去支付"];
    },
    alipayBtn:function () {
        return window.buttons()[4];
    },
    unionpayBtn:function () {
        return   window.buttons()[5];
    },
    offLineBtn:function () {
        return window.buttons()[6];
    }
<<<<<<< HEAD
>>>>>>> ynn_ios
=======
>>>>>>> ynn_ios
    }
}
//支付宝
xxnrElementClass.alipay = function (window) {
    return{
<<<<<<< HEAD
<<<<<<< HEAD
        ALipayBack:function () {
            return window.scrollViews()[0].webViews()[0].links()["返回"];
        },
        ALipayBackYes:function () {
            return window.scrollViews()[0].webViews()[0].links()["是"];
        }
=======
=======
>>>>>>> ynn_ios
    ALipayBack:function () {
        return window.scrollViews()[0].webViews()[0].links()["返回"];
    },
    ALipayBackYes:function () {
        return window.scrollViews()[0].webViews()[0].links()["是"];
    }
<<<<<<< HEAD
>>>>>>> ynn_ios
=======
>>>>>>> ynn_ios
    }
}
// 银联
xxnrElementClass.unionpay = function (window) {
    return{
<<<<<<< HEAD
<<<<<<< HEAD
        UnionpayBack:function () {
            return window.buttons()[0];
        },
        UnionpayBackYes:function () {
            return window.buttons()["OK"];
        }
=======
=======
>>>>>>> ynn_ios
    UnionpayBack:function () {
        return window.buttons()[0];
    },
    UnionpayBackYes:function () {
        return window.buttons()["OK"];
    }
<<<<<<< HEAD
>>>>>>> ynn_ios
=======
>>>>>>> ynn_ios
    }
}
//登录页
xxnrElementClass.login = function (window) {
    return{
<<<<<<< HEAD
<<<<<<< HEAD
        phone:function(){
            return window.images()[0].textFields()[0].textFields()[0].value();
        },
        phoneTextField:function () {
            return window.images()[0].textFields()[0].textFields()[0];
        },
        phoneClear:function () {
            return window.images()[0].textFields()[0].buttons()["Clear text"];
        },
        password:function () {
            return window.images()[0].secureTextFields()[0].secureTextFields()[0].value();
        },
        passwordTextField:function () {
            return window.images()[0].secureTextFields()[0].secureTextFields()[0];
        },
        passwordClear:function () {
            return window.images()[0].secureTextFields()[0].buttons()["Clear text"];
        },
        loginBtn:function () {
            return window.images()[0].buttons()["确认登录"];
        },
        warningText:function () {
            return window.staticTexts()[0].value();
        },
        forgetPassword:function () {
            return window.images()[0].buttons()["忘记密码?"];
        },
        register:function () {
            return window.images()[0].buttons()[4];
        }
=======
=======
>>>>>>> ynn_ios
    phone:function(){
        return window.images()[0].textFields()[0].textFields()[0].value();
    },
    phoneTextField:function () {
        return window.images()[0].textFields()[0].textFields()[0];
    },
    phoneClear:function () {
        return window.images()[0].textFields()[0].buttons()["Clear text"];
    },
    password:function () {
        return window.images()[0].secureTextFields()[0].secureTextFields()[0].value();
    },
    passwordTextField:function () {
        return window.images()[0].secureTextFields()[0].secureTextFields()[0];
    },
    passwordClear:function () {
        return window.images()[0].secureTextFields()[0].buttons()["Clear text"];
    },
    loginBtn:function () {
        return window.images()[0].buttons()["确认登录"];
    },
    warningText:function () {
        return window.staticTexts()[0].value();
    },
    forgetPassword:function () {
        return window.images()[0].buttons()["忘记密码?"];
    },
    register:function () {
        return window.images()[0].buttons()[4];
    }
<<<<<<< HEAD
>>>>>>> ynn_ios
=======
>>>>>>> ynn_ios
    }
}

//我的订单列表
xxnrElementClass.myorder = function (window) {
    return{
<<<<<<< HEAD
<<<<<<< HEAD
        totalTab:function () {
            return window.staticTexts()["全部"];
        },
        holdPayTab:function () {
            return window.staticTexts()["待付款"];
        },
        sendTab:function () {
            return window.staticTexts()["待发货"];
        },
        reciveTab:function () {
            return window.staticTexts()["待收货"];
        },
        commentTab:function () {
            return window.staticTexts()["已完成"];
        },
        userOrderStaticText:function (index) {
            return window.scrollViews()[0].tableViews()[0].groups()[index].staticTexts()[0].name();
        },
        userOrderId:function (index) {
            return window.scrollViews()[0].tableViews()[0].groups()[index].staticTexts()[1].name();
        },
        elements:function (index) {
            return window.scrollViews()[0].tableViews()[0].elements()[index];
        },
        elementStaticText:function (index) {
            return window.scrollViews()[0].tableViews()[0].elements()[index].staticTexts()[0].name();
        },
        tableViewsgroups:function () {
            return window.scrollViews()[0].tableViews()[0].groups();
        },
        tableView:function () {
            return  window.scrollViews()[0].tableViews()[0];
        },
        userOrderCells:function () {
            return window.scrollViews()[0].tableViews()[0].cells();
        },
        userOrderCell:function (index) {
            return window.scrollViews()[0].tableViews()[0].cells()[index];
        },
        
        goPay:function (index) {
            return window.scrollViews()[0].tableViews()[0].groups()[index].buttons()["去付款"];
        },
        amendPayType:function (index) {
            return window.scrollViews()[0].tableViews()[0].groups()[index].buttons()["修改付款方式"];
        },
        seePayType:function (index) {
            return window.scrollViews()[0].tableViews()[0].groups()[index].buttons()["查看付款信息"];
        },
        receiveGoods:function (index) {
            return window.scrollViews()[0].tableViews()[0].groups()[index].buttons()["确认收货"];
        },
        noOrderStaticText:function () {
            return window.scrollViews()[0].staticTexts()[0].name();
        },
        goPayFer:function () {
            return window.scrollViews()[0].buttons()["去买化肥"];
        },
        goPayCar:function () {
            return window.scrollViews()[0].buttons()["去买汽车"];
        }
    };
}
//订单详情
xxnrElementClass.orderDetail = function (window) {
    return{
        orderId:function () {
            return window.tableViews()[0].staticTexts()[0];
        },
        orderState:function () {
            return window.tableViews()[0].staticTexts()[1];
        },
        dispatchType:function () {
            return window.tableViews()[0].staticTexts()[4];
        },
        goodsListOneIndex:function () {
            var count = window.tableViews()[0].cells().length;
            var arr;
            if (window.tableViews()[0].cells()[0].staticTexts()[1].name() == "阶段一：订金")
            {
                xxnrlogMessage("22222222222");
               return 2;
            }
            else
            {
                return 1;
            }
        },
        cells:function () {
            return window.tableViews()[0].cells();
        },
        cell:function (index) {
            return window.tableViews()[0].cells()[index];
        },
        seePayDetail:function (cell) {
            return cell.buttons()["查看详情"];
        },
        consignmentState:function (cell) {
            for (var i=0;i<cell.staticTexts().length;i++)
            {
                // xxnrlogMessage("'"+cell.staticTexts()[i].rect().size.width+"'");
                // xxnrlogMessage("'"+cell.staticTexts()[i].rect().size.height+"'");

                if(cell.staticTexts()[i].rect().size.width == 75.5 && cell.staticTexts()[i].rect().size.height == 14)
                {
                    return cell.staticTexts()[i];
                }
            }
            return nil;
        },
        goPay:function () {
            return window.buttons()["去付款"];
        },
        receiveGoods:function () {
            return window.buttons()["确认收货"];

        },
        goCarry:function () {
            return window.buttons()["去自提"];
        },
        amendPayType:function () {
            return window.buttons()["修改付款方式"];
        },
        seePayType:function () {
            return window.buttons()["查看付款信息"];
        },
        btmbutton:function () {
            return window.buttons()[0];
        }
=======
=======
>>>>>>> ynn_ios
    totalTab:function () {
        return window.staticTexts()["全部"];
    },
    holdPayTab:function () {
        return window.staticTexts()["待付款"];
    },
    sendTab:function () {
        return window.staticTexts()["待发货"];
    },
    reciveTab:function () {
        return window.staticTexts()["待收货"];
    },
    commentTab:function () {
        return window.staticTexts()["已完成"];
    },
    userOrderStaticText:function (index) {
        return window.scrollViews()[0].tableViews()[0].groups()[index].staticTexts()[0].name();
    },
    userOrderId:function (index) {
        return window.scrollViews()[0].tableViews()[0].groups()[index].staticTexts()[1].name();
    },
    elements:function (index) {
        return window.scrollViews()[0].tableViews()[0].elements()[index];
    },
    elementStaticText:function (index) {
        return window.scrollViews()[0].tableViews()[0].elements()[index].staticTexts()[0].name();
    },
    tableViewsgroups:function () {
        return window.scrollViews()[0].tableViews()[0].groups();
    },
    tableView:function () {
        return  window.scrollViews()[0].tableViews()[0];
    },
    userOrderCells:function () {
        return window.scrollViews()[0].tableViews()[0].cells();
    },
    userOrderCell:function (index) {
        return window.scrollViews()[0].tableViews()[0].cells()[index];
    },
        
    goPay:function (index) {
        return window.scrollViews()[0].tableViews()[0].groups()[index].buttons()["去付款"];
    },
    amendPayType:function (index) {
        return window.scrollViews()[0].tableViews()[0].groups()[index].buttons()["修改付款方式"];
    },
    seePayType:function (index) {
        return window.scrollViews()[0].tableViews()[0].groups()[index].buttons()["查看付款信息"];
    },
    receiveGoods:function (index) {
        return window.scrollViews()[0].tableViews()[0].groups()[index].buttons()["确认收货"];
    },
    noOrderStaticText:function () {
        return window.scrollViews()[0].staticTexts()[0].name();
    },
    goPayFer:function () {
        return window.scrollViews()[0].buttons()["去买化肥"];
    },
    goPayCar:function () {
        return window.scrollViews()[0].buttons()["去买汽车"];
    }
    };
}
var stateWidth;
var stateHeight;
//订单详情
xxnrElementClass.orderDetail = function (window) {
    return{
    orderId:function () {
        return window.tableViews()[0].staticTexts()[0];
    },
    orderState:function () {
        return window.tableViews()[0].staticTexts()[1];
    },
    dispatchType:function () {
        return window.tableViews()[0].staticTexts()[4];
    },
    goodsListOneIndex:function () {
        var count = window.tableViews()[0].cells().length;
        var arr;
        if (window.tableViews()[0].cells()[0].staticTexts()[1].name() == "阶段一：订金")
        {
            xxnrlogMessage("22222222222");
            return 2;
        }
        else
        {
            return 1;
        }
    },
    cells:function () {
        return window.tableViews()[0].cells();
    },
    cell:function (index) {
        return window.tableViews()[0].cells()[index];
    },
    seePayDetail:function (cell) {
        return cell.buttons()["查看详情"];
    },
    stateSize:function(cell)
        {
            var str = cell.staticTexts()[0];
            for (var i=1;i<cell.staticTexts().length;i++)
            {
                if(parseFloat(str.rect().origin.x) < parseFloat(cell.staticTexts()[i].rect().origin.x)){
                    str = cell.staticTexts()[i];
                }
                stateWidth = Math.round(str.rect().size.width);
                
                stateHeight = Math.round(str.rect().size.height);
            }
        },
    consignmentState:function (cell) {
        
        
        for (var i=0;i<cell.staticTexts().length;i++)
        {
            if(Math.round(cell.staticTexts()[i].rect().size.width) == stateWidth && Math.round(cell.staticTexts()[i].rect().size.height) == stateHeight)
            {
                return cell.staticTexts()[i];
            }
        }
        
        return nil;
    },
    goPay:function () {
        return window.buttons()["去付款"];
    },
    receiveGoods:function () {
        return window.buttons()["确认收货"];
        
    },
    goCarry:function () {
        return window.buttons()["去自提"];
    },
    amendPayType:function () {
        return window.buttons()["修改付款方式"];
    },
    seePayType:function () {
        return window.buttons()["查看付款信息"];
    },
    btmbutton:function () {
        return window.buttons()[0];
    }
<<<<<<< HEAD
>>>>>>> ynn_ios
=======
>>>>>>> ynn_ios
    }
}

//网点自提
xxnrElementClass.carry = function (window) {
    return {
<<<<<<< HEAD
<<<<<<< HEAD
        carryNum:function () {
           return window.tableViews()[0].staticTexts()[1];
        },
        cells:function () {
return window.tableViews()[0].cells();
        }
=======
=======
>>>>>>> ynn_ios
    carryNum:function () {
        return window.tableViews()[0].staticTexts()[1];
    },
    cells:function () {
        return window.tableViews()[0].cells();
    }
<<<<<<< HEAD
>>>>>>> ynn_ios
=======
>>>>>>> ynn_ios
    }
}
//县级订单列表
xxnrElementClass.RSCOrder = function (window) {
    return{
<<<<<<< HEAD
<<<<<<< HEAD
        totalTab:function () {
            return window.buttons()["全部"];
        },
        holdPayTab:function () {
            return window.buttons()["待付款"];
        },
        verifyTab:function () {
            return window.buttons()["待审核"];
        },
        dispatchTab:function () {
            return window.buttons()["待配送"];
        },
        carryTab:function () {
            return window.buttons()["待自提"];
        },
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

=======
=======
>>>>>>> ynn_ios
    totalTab:function () {
        return window.buttons()["全部"];
    },
    holdPayTab:function () {
        return window.buttons()["待付款"];
    },
    verifyTab:function () {
        return window.buttons()["待审核"];
    },
    dispatchTab:function () {
        return window.buttons()["待配送"];
    },
    carryTab:function () {
        return window.buttons()["待自提"];
    },
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
        
<<<<<<< HEAD
>>>>>>> ynn_ios
=======
>>>>>>> ynn_ios
    };
}

//新农代表
xxnrElementClass.xxnrRepesent = function (window) {
    return{
<<<<<<< HEAD
<<<<<<< HEAD
        myclientTab:function () {
            return window.buttons()["我的客户"];
        },
        myrepesentTab:function () {
            return window.buttons()["我的代表"];
        },
        clientRegisterTab:function () {
            return window.buttons()["客户登记"];
        }
=======
=======
>>>>>>> ynn_ios
    myclientTab:function () {
        return window.buttons()["我的客户"];
    },
    myrepesentTab:function () {
        return window.buttons()["我的代表"];
    },
    clientRegisterTab:function () {
        return window.buttons()["客户登记"];
    }
<<<<<<< HEAD
>>>>>>> ynn_ios
=======
>>>>>>> ynn_ios
    }
}
//我的客户
xxnrElementClass.xxnrRepesent_client = function (window) {
    return{
<<<<<<< HEAD
<<<<<<< HEAD
        inviteLabel:function () {
            return window.tableViews()[0].staticTexts()[0];
        },
        inviteNum:function () {
            return window.tableViews()[0].staticTexts()[0].value();
        },
        cell:function (index) {
            return window.tableViews()[0].cells()[index];
        },
        cells:function () {
            return window.tableViews()[0].cells();
        },
        isInviteFriend:function () {
            return window.staticTexts()[0].isVisible();
        }
=======
=======
>>>>>>> ynn_ios
    inviteLabel:function () {
        return window.tableViews()[0].staticTexts()[0];
    },
    inviteNum:function () {
        return window.tableViews()[0].staticTexts()[0].value();
    },
    cell:function (index) {
        return window.tableViews()[0].cells()[index];
    },
    cells:function () {
        return window.tableViews()[0].cells();
    },
    isInviteFriend:function () {
        return window.staticTexts()[0].isVisible();
    }
<<<<<<< HEAD
>>>>>>> ynn_ios
=======
>>>>>>> ynn_ios
    }
}
//客户登记
xxnrElementClass.xxnrClientRegister = function (window) {
    return{
<<<<<<< HEAD
<<<<<<< HEAD
        totalNum:function () {
            return window.staticTexts()[1].value();
        },
        todayNum:function () {
            return window.staticTexts()[2].value();
        },
        cell:function (index) {
            return window.tableViews()[1].cells()[index];
        },
        cells:function () {
            return window.tableViews()[1].cells();
        },
        addBtn:function () {
            return window.buttons()[0];
        }
=======
=======
>>>>>>> ynn_ios
    totalNum:function () {
        return window.staticTexts()[1].value();
    },
    todayNum:function () {
        return window.staticTexts()[2].value();
    },
    cell:function (index) {
        return window.tableViews()[1].cells()[index];
    },
    cells:function () {
        return window.tableViews()[1].cells();
    },
    addBtn:function () {
        return window.buttons()[0];
    }
<<<<<<< HEAD
>>>>>>> ynn_ios
=======
>>>>>>> ynn_ios
    }
}
//添加潜在客户
xxnrElementClass.addClient = function (window) {
    return{
<<<<<<< HEAD
<<<<<<< HEAD
        nameTextField:function () {
            return window.textFields()[0].textFields()[0];
        },
        phoneTextField:function () {
            return window.textFields()[1].textFields()[0];
        },
        boyBtn:function () {
            return window.buttons()[0];
        },
        girlBtn:function () {
            return window.buttons()[1];
        },
        addressBtn:function () {
            return window.buttons()[2];
        },
        streetBtn:function () {
            return window.buttons()[3];
        },
        selProBtn:function () {
            return window.buttons()[4];
        },
        saveBtn:function () {
            return window.buttons()["保存"];
        },
        warningStaticText:function (message) {
            return window.staticTexts()[message];
        }
=======
=======
>>>>>>> ynn_ios
    nameTextField:function () {
        return window.textFields()[0].textFields()[0];
    },
    phoneTextField:function () {
        return window.textFields()[1].textFields()[0];
    },
    boyBtn:function () {
        return window.buttons()[0];
    },
    girlBtn:function () {
        return window.buttons()[1];
    },
    addressBtn:function () {
        return window.buttons()[2];
    },
    streetBtn:function () {
        return window.buttons()[3];
    },
    selProBtn:function () {
        return window.buttons()[4];
    },
    saveBtn:function () {
        return window.buttons()["保存"];
    },
    warningStaticText:function (message) {
        return window.staticTexts()[message];
    }
<<<<<<< HEAD
>>>>>>> ynn_ios
=======
>>>>>>> ynn_ios
    }
}
//选择意向商品
xxnrElementClass.selPro = function (window) {
    return{
<<<<<<< HEAD
<<<<<<< HEAD
        makeSureBtn:function () {
            return window.buttons()["确定"];
        },
        tableView:function () {
            return window.tableViews()[0];
        }
=======
=======
>>>>>>> ynn_ios
    makeSureBtn:function () {
        return window.buttons()["确定"];
    },
    tableView:function () {
        return window.tableViews()[0];
    }
<<<<<<< HEAD
>>>>>>> ynn_ios
=======
>>>>>>> ynn_ios
    }
}
//客户详情
xxnrElementClass.clientDetail = function (window) {
    return{
<<<<<<< HEAD
<<<<<<< HEAD
        phone:function () {
            return window.staticTexts()[3].value();
        }
=======
    phone:function () {
        return window.staticTexts()[3].value();
    }
>>>>>>> ynn_ios
=======
    phone:function () {
        return window.staticTexts()[3].value();
    }
>>>>>>> ynn_ios
    }
}
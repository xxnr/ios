/**
 * Created by yangning on 16/7/12.
 */
var target = UIATarget.localTarget();
var window = target.frontMostApp().windows()[0];
var nav_back = window.navigationBar().buttons()["top back"];
var nav_staticText = window.navigationBar().staticTexts()[0].value();

var mine = window.tabBar().buttons()["我的"];
var home = window.tabBar().buttons()["首页"];
var news = window.tabBar().buttons()["资讯"];
var shoppingcar = window.tabBar().buttons()["购物车"];

var fer_special = window.collectionViews()[0].buttons()[5];
var car_special = window.collectionViews()[0].buttons()[6];
//网点自提
var cell = window.tableViews()[0].cells()["江淮汽车 - 第二代瑞风S3 - 2015款"];
var addShopcar = window.buttons()["加入购物车"];
var addShopcar_name = window.collectionViews()[0].cells()["2.0T 自动（6DCT）"];
var addShopcar_type = window.collectionViews()[0].cells()["豪华智能型"];
var addShopcar_color = window.collectionViews()[0].cells()["拉菲红"];
var addShopcar_sure = window.buttons()["确定"];


var userOrderBtn = window.tableViews()[0].buttons()[1];
eval(userOrderBtn);

var rscOrderBtn = window.tableViews()[0].buttons()[0];
var userOrderStaticText = window.scrollViews()[0].tableViews()[0].groups()[0].staticTexts()[0].name();
var rscOrderStaticText = window.scrollViews()[0].tableViews()[0].groups()[0].staticTexts()[0].name();
var userOrderCell0 = window.scrollViews()[0].tableViews()[0].cells()[0];


//选择支付方式
var PayMoney = window.buttons()["去付款"];
var separatePay = window.buttons()["分次支付"];
var goPay = window.buttons()["去支付"];
var ALipayBack = window.scrollViews()[0].webViews()[0].links()["返回"];
var ALipayBackYes = window.scrollViews()[0].webViews()[0].links()["是"];

//用户订单
var totalTab = window.staticTexts()["全部"];
var holdPayTab = window.staticTexts()["待付款"];
var sendTab = window.staticTexts()["待发货"];
var reciveTab = window.staticTexts()["待收货"];
var commentTab = window.staticTexts()["已完成"];


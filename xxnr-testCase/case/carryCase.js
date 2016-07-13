



/**
 * Created by yangning on 16/7/5.
 */
#import "../lib/tuneup.js"
#import "baseClass.js"
//#import "xxnrClass.js"
var target = UIATarget.localTarget();
var window = target.frontMostApp().windows()[0];
var isHoldPay = false;

Ab();

function Aa() {
    test("三个汽车订单", function () {
        target.delay(1);
        window.collectionViews()[0].buttons()[6].tap();
        window.tableViews()[0].cells()["江淮汽车 - 第二代瑞风S3 - 2015款"].tap();
        window.buttons()["加入购物车"].tap();
        window.collectionViews()[0].cells()["2.0T 自动（6DCT）"].tap();
        window.collectionViews()[0].cells()["豪华智能型"].tap();
        window.collectionViews()[0].cells()["拉菲红"].tap();
        window.buttons()["确定"].tap();
        target.delay(1);

        window.navigationBar().buttons()["top back"].tap();
        window.tableViews()[0].cells()["江淮 - 瑞风S5 - 没有市场价没有描述没有商品详情"].staticTexts()["￥240000.1"].tapWithOptions({
            tapOffset: {
                x: 0.74,
                y: 0.21
            }
        });
        window.buttons()["加入购物车"].tap();
        window.collectionViews()[0].cells()["豪华智能型"].tap();
        window.collectionViews()[0].cells()["时尚白"].tap();
        window.buttons()["确定"].tap();
        target.delay(1);
        window.navigationBar().buttons()["top back"].tap();
        target.delay(1);
        window.tableViews()[0].cells()["江淮-瑞风S2-市场价为0"].scrollToVisible();
        window.tableViews()[0].cells()["奇瑞汽车 - 艾瑞泽M7"].tap();
        window.buttons()["加入购物车"].tap();
        window.collectionViews()[0].cells()["1.8L 手动（MT）"].tap();
        window.collectionViews()[0].cells()["宽适版"].tap();
        window.collectionViews()[0].cells()["象牙白"].tap();
        window.buttons()["确定"].tap();
        target.delay(1);
        window.navigationBar().buttons()["icon shopcar white"].tap();
        window.logElementTree();

        target.delay(2);
        window.tableViews()[0].groups()[0].buttons()["shopCar circle"].tap();
        window.tableViews()[0].cells()[1].scrollToVisible();
        window.tableViews()[0].groups()[2].buttons()["shopCar circle"].tap();
        target.delay(2);

        window.buttons()["去结算(3)"].tap();

        //window.buttons()[0].tap();
        target.delay(1);

        window.tableViews()[0].buttons()[1].tap();
        window.tableViews()[1].cells()["Zhhdj"].tap();
        window.buttons()["确定"].tap();
        window.buttons()["提交订单(3)"].tap();
        target.delay(1);
        window.navigationBar().buttons()["top back"].tap();
    })
    Ab();
}
function scrollList(order_id,count) {
    

    isHoldPay = false;
    for (var i = 0; i < count - 1; i++) {
        noworderStr = window.scrollViews()[0].tableViews()[0].groups()[i * 2].staticTexts()[1].name();
        if(order_id == noworderStr.substr(5,noworderStr.length-5))
        {
            isHoldPay = true;
            break;
        }
    }
}
function judge(orderId,name) {
    var count = window.scrollViews()[0].tableViews()[0].groups().length/2;
    UIALogger.logMessage("'"+count+"'");

    scrollList(orderId,count);

    num = count - 1;
    while (count >= num) {
        if (isHoldPay == false) {
            UIALogger.logMessage("'"+num+"'");
            UIALogger.logMessage("'"+orderId+"'");

            window.scrollViews()[0].tableViews()[0].groups()[num].scrollToVisible();
            window.scrollViews()[0].tableViews()[0].dragInsideWithOptions({
                startOffset: {x: 0.49, y: 1.00},
                endOffset: {x: 0.60, y: -0.05},
                duration: 0.5
            });
            var count = window.scrollViews()[0].tableViews()[0].groups().length/2;
            scrollList(orderId,count);
            num = count-1;
            UIALogger.logMessage("no");
        }
        else
        {
            UIALogger.logMessage("yes");
            break;
        }
    }
    if (isHoldPay == false)
    {
        UIALogger.logFail("'"+name+"'没有此订单:'"+orderId+"'");
    }

}
function Ab() {
    window.tabBar().buttons()["我的"].tap();
    var carry1;
    var carry2;
    test("未支付订单--用户订单",function () {
        target.delay(3);
        window.tableViews()[0].buttons()[1].tap();
        drop(Ab);
        target.delay(1);
        window.logElementTree();
        UIALogger.logMessage("'"+window.scrollViews()[0].tableViews()[0].groups()[0].staticTexts()[0].name()+"'");
        assertEquals("待付款",window.scrollViews()[0].tableViews()[0].groups()[0].staticTexts()[0].name());

        var orderStr = window.scrollViews()[0].tableViews()[0].groups()[0].staticTexts()[1].name();
        var orderId = orderStr.substr(5,orderStr.length - 5);
        window.staticTexts()["待付款"].tapWithOptions({tapOffset: {x: 0.27, y: 0.55}});
        judge(orderId,"待付款");
         

        window.navigationBar().buttons()["top back"].tap();

    })
    test("未支付订单--县级订单",function () {
        target.delay(1);
        window.tableViews()[0].buttons()[0].tap();

        window.scrollViews()[0].tableViews()[0].logElementTree();

        assertEquals("待付款",window.scrollViews()[0].tableViews()[0].groups()[0].staticTexts()[0].name());

         
         var orderStr = window.scrollViews()[0].tableViews()[0].groups()[0].staticTexts()[1].name();
         var orderId = orderStr.substr(5,orderStr.length - 5);
         target.frontMostApp().windows()[0].buttons()["待付款"].tap();
         judge(orderId,"待付款");
         

        window.navigationBar().buttons()["top back"].tap();
    })
    test("用户支付部分定金--用户订单",function () {
        target.delay(1);
        window.tableViews()[0].buttons()[1].tap();
        drop(Ab);
        target.delay(1);
        window.scrollViews()[0].tableViews()[0].cells()[0].tap();
        target.delay(1);
        window.buttons()["去付款"].tap();
        window.buttons()["分次支付"].tap();
        window.buttons()["去支付"].tap();
        target.delay(1);
        window.scrollViews()[0].webViews()[0].links()["返回"].tap();
        window.scrollViews()[0].webViews()[0].links()["是"].tap();

        target.delay(1);
        window.navigationBar().buttons()["top back"].tap();
        window.navigationBar().buttons()["top back"].tap();
        window.staticTexts()["全部"].tapWithOptions({tapOffset:{x:0.49, y:0.78}});
        target.delay(1);
        assertEquals("部分付款",window.scrollViews()[0].tableViews()[0].groups()[0].staticTexts()[0].name());
         
         
         var orderStr = window.scrollViews()[0].tableViews()[0].groups()[0].staticTexts()[1].name();
         var orderId = orderStr.substr(5,orderStr.length - 5);
         window.staticTexts()["待付款"].tapWithOptions({tapOffset: {x: 0.27, y: 0.55}});
         judge(orderId,"待付款");
         
    })
    window.navigationBar().buttons()["top back"].tap();
    test("用户支付部分定金--县级订单",function () {
        target.delay(1);
        window.tableViews()[0].buttons()[0].tap();
        target.delay(1);
        assertEquals("待付款",window.scrollViews()[0].tableViews()[0].groups()[0].staticTexts()[0].name());
         
         var orderStr = window.scrollViews()[0].tableViews()[0].groups()[0].staticTexts()[1].name();
         var orderId = orderStr.substr(5,orderStr.length - 5);
         target.frontMostApp().windows()[0].buttons()["待付款"].tap();
         judge(orderId,"待付款");
         
    })
    window.navigationBar().buttons()["top back"].tap();
    test("用户线下支付剩余定金--用户订单",function () {
        target.delay(1);
        window.tableViews()[0].buttons()[1].tap();
        target.delay(1);
        window.scrollViews()[0].tableViews()[0].cells()[0].tap();
        target.delay(1);
        window.buttons()["去付款"].tap();
        window.buttons()[6].tap();
        window.buttons()["去支付"].tap();
        target.delay(1);
        window.navigationBar().buttons()["top back"].tap();
        target.delay(1);
        window.staticTexts()["全部"].tapWithOptions({tapOffset:{x:0.49, y:0.78}});
        target.delay(1);

        assertEquals("付款待审核",window.scrollViews()[0].tableViews()[0].groups()[0].staticTexts()[0].name());
         
         
         var orderStr = window.scrollViews()[0].tableViews()[0].groups()[0].staticTexts()[1].name();
         var orderId = orderStr.substr(5,orderStr.length - 5);
         window.staticTexts()["待付款"].tapWithOptions({tapOffset: {x: 0.27, y: 0.55}});
         judge(orderId,"待付款");
         
        window.navigationBar().buttons()["top back"].tap();
    })
    test("用户线下支付剩余定金--县级订单",function () {
        target.delay(1);
        window.tableViews()[0].buttons()[0].tap();
        target.delay(1);
        window.logElementTree();

        assertEquals("付款待审核",window.scrollViews()[0].tableViews()[0].groups()[0].staticTexts()[0].name());
        window.scrollViews()[0].tableViews()[0].groups()[1].buttons()["审核付款"].tap();
        window.buttons()["确定"].tap();
        target.delay(1);

        window.buttons()["全部"].tap();

        assertEquals("待付款",window.scrollViews()[0].tableViews()[0].groups()[0].staticTexts()[0].name());
         
         var orderStr = window.scrollViews()[0].tableViews()[0].groups()[0].staticTexts()[1].name();
         var orderId = orderStr.substr(5,orderStr.length - 5);
         target.frontMostApp().windows()[0].buttons()["待付款"].tap();
         judge(orderId,"待付款");
         
    })
    window.navigationBar().buttons()["top back"].tap();
    test("后台操作--一个汽车商品发货至服务站",function () {
        target.delay(10);
    })
    test("用户线下支付剩余尾款--用户订单",function () {
        target.delay(1);
        window.tableViews()[0].buttons()[1].tap();
        target.delay(1);
        assertEquals("部分付款",window.scrollViews()[0].tableViews()[0].groups()[0].staticTexts()[0].name());
        window.scrollViews()[0].tableViews()[0].cells()[0].tap();
        window.buttons()["去付款"].tap();
        window.buttons()[6].tap();
        window.buttons()["去支付"].tap();
        target.delay(1);
        window.navigationBar().buttons()["top back"].tap();
        target.delay(1);
        window.staticTexts()["全部"].tapWithOptions({tapOffset:{x:0.49, y:0.78}});
        target.delay(1);

        assertEquals("付款待审核",window.scrollViews()[0].tableViews()[0].groups()[0].staticTexts()[0].name());
         
         
         var orderStr = window.scrollViews()[0].tableViews()[0].groups()[0].staticTexts()[1].name();
         var orderId = orderStr.substr(5,orderStr.length - 5);
         window.staticTexts()["待付款"].tapWithOptions({tapOffset: {x: 0.27, y: 0.55}});
         judge(orderId,"待付款");
         
    })
    window.navigationBar().buttons()["top back"].tap();
    test("用户线下支付剩余尾款--县级订单",function () {
        target.delay(2);
        window.tableViews()[0].buttons()[0].tap();
        target.delay(1);

        assertEquals("付款待审核",window.scrollViews()[0].tableViews()[0].groups()[0].staticTexts()[0].name());
        window.scrollViews()[0].tableViews()[0].groups()["网点自提"].buttons()["审核付款"].tap();
        window.buttons()["确定"].tap();
        target.delay(1);

        window.buttons()["全部"].tap();
        target.delay(1);
        assertEquals("待自提",window.scrollViews()[0].tableViews()[0].groups()[0].staticTexts()[0].name());
         
         
         var orderStr = window.scrollViews()[0].tableViews()[0].groups()[0].staticTexts()[1].name();
         var orderId = orderStr.substr(5,orderStr.length - 5);
         target.frontMostApp().windows()[0].buttons()["待自提"].tap();
         judge(orderId,"待自提");
         
    })
    window.navigationBar().buttons()["top back"].tap();

    test("用户网点自提第一个商品--用户订单",function () {
        target.delay(1);
        window.tableViews()[0].buttons()[1].tap();
        target.delay(1);
        window.scrollViews()[0].tableViews()[0].cells()[0].tap();
        target.delay(1);
        window.buttons()["去自提"].tap();
        drop(Ab);
        target.delay(2);

        assertEquals("网点自提",window.navigationBar().staticTexts()[0].value());

        carry1 = window.tableViews()[0].staticTexts()[1].value();
        UIALogger.logMessage("'"+window.staticTexts()[1].value()+"'");
        window.logElementTree();
         
         
         var orderStr = window.scrollViews()[0].tableViews()[0].groups()[0].staticTexts()[1].name();
         var orderId = orderStr.substr(5,orderStr.length - 5);
         target.frontMostApp().windows()[0].staticTexts()["待收货"].tapWithOptions({tapOffset:{x:0.63, y:0.45}});
         judge(orderId,"待收货");
         

        window.navigationBar().buttons()["top back"].tap();
        window.navigationBar().buttons()["top back"].tap();
        window.navigationBar().buttons()["top back"].tap();
    })
    test("用户网点自提第一个商品--县级订单",function () {
        target.delay(1);
        window.tableViews()[0].buttons()[0].tap();
        window.scrollViews()[0].tableViews()[0].groups()[1].buttons()["客户自提"].tap();

        window.tableViews()[0].cells()[0].staticTexts()[2].tap();
        window.buttons()[6].tap();


        window.textFields()[0].textFields()[0].tap();
        window.textFields()[0].textFields()[0].setValue(carry1);
        target.frontMostApp().windows()[1].toolbar().buttons()["完成"].tap();

        window.buttons()["确定"].tap();
        target.delay(1);
        assertEquals("待自提",window.scrollViews()[0].tableViews()[0].groups()[0].staticTexts()[0].name());
         
         var orderStr = window.scrollViews()[0].tableViews()[0].groups()[0].staticTexts()[1].name();
         var orderId = orderStr.substr(5,orderStr.length - 5);
         target.frontMostApp().windows()[0].buttons()["待自提"].tap();
         judge(orderId,"待自提");
         
        window.navigationBar().buttons()["top back"].tap();
    })
    test("第一个商品自提成功,二三商品未发货",function () {
        target.delay(1);
        window.tableViews()[0].buttons()[1].tap();
        assertEquals("待自提",window.scrollViews()[0].tableViews()[0].groups()[0].staticTexts()[0].name());
    })
    test("后台操作二三商品发货",function () {
        target.delay(10);
    })
    test("去自提二三商品--用户订单",function () {
        target.delay(1);
        window.scrollViews()[0].tableViews()[0].cells()[0].tap();
        target.delay(1);
        window.buttons()["去自提"].tap();
        target.delay(1);
        assertEquals("网点自提",window.navigationBar().staticTexts()[0].value());
        carry2 = window.tableViews()[0].staticTexts()[1].value();
        window.navigationBar().buttons()["top back"].tap();
        window.navigationBar().buttons()["top back"].tap();
        window.navigationBar().buttons()["top back"].tap();
    })
    test("去自提二三商品(已完成)--县级订单",function () {
        target.delay(1);
        window.tableViews()[0].buttons()[0].tap();
        target.delay(1);
        assertEquals("待自提",window.scrollViews()[0].tableViews()[0].groups()[0].staticTexts()[0].name());
        window.scrollViews()[0].tableViews()[0].groups()["网点自提"].buttons()["客户自提"].tap();
        drop(Ab);
        window.tableViews()[0].cells()[1].tap();
        target.delay(1);
        window.tableViews()[0].cells()[2].tap();
        window.logElementTree();
        window.buttons()[6].tap();
        window.textFields()[0].textFields()[0].tap();
        window.textFields()[0].textFields()[0].setValue(carry2);
        target.frontMostApp().windows()[1].toolbar().buttons()["完成"].tap();

        window.buttons()["确定"].tap();
        target.delay(1);
        window.buttons()["全部"].tap();
        assertEquals("已完成",window.scrollViews()[0].tableViews()[0].groups()[0].staticTexts()[0].name());
         
        
        window.navigationBar().buttons()["top back"].tap();
    })
    test("自提完成",function () {
        target.delay(1);
        window.tableViews()[0].buttons()[1].tap();
        drop(Ab);
        assertEquals("已完成",window.scrollViews()[0].tableViews()[0].groups()[0].staticTexts()[0].name());
         
         var orderStr = window.scrollViews()[0].tableViews()[0].groups()[0].staticTexts()[1].name();
         var orderId = orderStr.substr(5,orderStr.length - 5);
         target.frontMostApp().windows()[0].staticTexts()["已完成"].tapWithOptions({tapOffset:{x:0.59, y:0.33}});
         judge(orderId,"已完成");

    })
}

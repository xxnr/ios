/**
 * Created by yangning on 16/7/5.
 */
#import "../lib/tuneup.js"
#import "baseClass.js"
#import "xxnrClass.js"
var target = UIATarget.localTarget();
var window = target.frontMostApp().windows()[0];
var isHoldPay = false;

Aa();

function Aa() {
    test("三个汽车订单", function () {
        delay(1);
        xxnrClass.home(window).car_specialBtn().tap();
        xxnrClass.special(window).cell("江淮汽车 - 第二代瑞风S3 - 2015款").tap();
        xxnrClass.goodDetail(window).addShoppingCarBtn().tap();
        xxnrClass.goodDetail(window).addshoppingCar_property("2.0T 自动（6DCT）").tap();
        xxnrClass.goodDetail(window).addshoppingCar_property("豪华智能型").tap();
        xxnrClass.goodDetail(window).addshoppingCar_property("拉菲红").tap();
        xxnrClass.goodDetail(window).addShoppingCar_sure().tap();
        delay(1);

        xxnrClass.navBack(window).tap();
        xxnrClass.special(window).cell("江淮 - 瑞风S5 - 没有市场价没有描述没有商品详情").staticTexts()["￥240000.1"].tapWithOptions({
            tapOffset: {
                x: 0.74,
                y: 0.21
            }
        });
        xxnrClass.goodDetail(window).addShoppingCarBtn().tap();
        xxnrClass.goodDetail(window).addshoppingCar_property("豪华智能型").tap();
        xxnrClass.goodDetail(window).addshoppingCar_property("时尚白").tap();
        xxnrClass.goodDetail(window).addShoppingCar_sure().tap();
        delay(1);
        xxnrClass.navBack(window).tap();
        delay(1);
        xxnrClass.special(window).cell("江淮-瑞风S2-市场价为0").scrollToVisible();
        xxnrClass.special(window).cell("奇瑞汽车 - 艾瑞泽M7").tap();
        xxnrClass.goodDetail(window).addShoppingCarBtn().tap();
        xxnrClass.goodDetail(window).addshoppingCar_property("1.8L 手动（MT）").tap();
        xxnrClass.goodDetail(window).addshoppingCar_property("宽适版").tap();
        xxnrClass.goodDetail(window).addshoppingCar_property("象牙白").tap();
        xxnrClass.goodDetail(window).addShoppingCar_sure().tap();
        delay(1);
        xxnrClass.goodDetail(window).nav_shoppingCar().tap();
        window.logElementTree();

        delay(2);
        xxnrClass.shoppingCar(window).sel_Group(0).tap();
        window.tableViews()[0].cells()[1].scrollToVisible();
        xxnrClass.shoppingCar(window).sel_Group(2).tap();
        delay(2);


         xxnrClass.shoppingCar(window).go_settle("去结算(3)").tap();
        // window.buttons()["去结算(3)"].tap();

        //window.buttons()[0].tap();
        delay(1);
        xxnrClass.submitOrder(window).selWebsiteBtn().tap();
        // window.tableViews()[0].buttons()[1].tap();
        window.tableViews()[1].cells()["Zhhdj"].tap();
        window.buttons()["确定"].tap();

        // window.buttons()["提交订单(3)"].tap();
        xxnrClass.submitOrder(window).submitOrderBtn().tap();
        delay(1);
        xxnrClass.navBack(window).tap();
    })
    Ab();
}
function scrollList(order_id,count) {


    isHoldPay = false;
    for (var i = 0; i < count - 1; i++) {
        noworderStr = xxnrClass.myorder(window).userOrderId(i * 2);
        if(order_id == noworderStr.substr(5,noworderStr.length-5))
        {
            isHoldPay = true;
            break;
        }
    }
}
function judge(orderId,name) {
    var count = xxnrClass.myorder(window).tableViewsgroups().length/2;
    logMessage("'"+count+"'");

    scrollList(orderId,count);

    num = count - 1;
    while (count >= num) {
        if (isHoldPay == false) {
            logMessage("'"+num+"'");
            logMessage("'"+orderId+"'");

            xxnrClass.myorder(window).tableViewsgroups()[num].scrollToVisible();
            window.scrollViews()[0].tableViews()[0].dragInsideWithOptions({
                startOffset: {x: 0.49, y: 1.00},
                endOffset: {x: 0.60, y: -0.05},
                duration: 0.5
            });
            var count = xxnrClass.myorder(window).tableViewsgroups().length/2;
            scrollList(orderId,count);
            num = count-1;
            logMessage("no");
        }
        else
        {
            logMessage("yes");
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
        delay(3);
        window.tableViews()[0].buttons()[1].tap();
        drop(Ab);
        delay(1);
        window.logElementTree();
        logMessage("'"+xxnrClass.myorder(window).userOrderStaticText(0)+"'");
        assertEquals("待付款",xxnrClass.myorder(window).userOrderStaticText(0));
    
        var orderStr = xxnrClass.myorder(window).userOrderId(0);
        var orderId = orderStr.substr(5,orderStr.length - 5);
        xxnrClass.myorder(window).holdPayTab().tapWithOptions({tapOffset: {x: 0.27, y: 0.55}});
        judge(orderId,"待付款");
    
    
        xxnrClass.navBack(window).tap();
    
    })
    test("未支付订单--县级订单",function () {
        delay(1);
        xxnrClass.mine(window).rscOrderBtn().tap();
    
        window.scrollViews()[0].tableViews()[0].logElementTree();
    
        assertEquals("待付款",xxnrClass.myorder(window).userOrderStaticText(0));
    
    
        var orderStr = xxnrClass.rscorder(window).userOrderId(0);
        var orderId = orderStr.substr(5,orderStr.length - 5);
        xxnrClass.RSCOrder(window).holdPayTab().tap();
        judge(orderId,"待付款");
    
    
        xxnrClass.navBack(window).tap();
    })
    test("用户支付部分定金--用户订单",function () {
        delay(1);
        xxnrClass.mine(window).userOrderBtn().tap();
        drop(Ab);
        delay(1);
        xxnrClass.myorder(window).userOrderCell(0).tap();
        delay(2);
        logMessage("jjjjjjj");
        window.logElementTree();
        xxnrClass.orderDetail(window).goPay().tap();
        // window.buttons()["去付款"];
        xxnrClass.selPayType(window).separatePay().tap();
        xxnrClass.selPayType(window).goPay().tap();
        delay(1);
        xxnrClass.alipay(window).ALipayBack().tap();
        xxnrClass.alipay(window).ALipayBackYes().tap();
    
        delay(1);
        xxnrClass.navBack(window).tap();
        xxnrClass.navBack(window).tap();
        xxnrClass.myorder(window).totalTab().tapWithOptions({tapOffset:{x:0.49, y:0.78}});
        delay(1);
        assertEquals("部分付款",xxnrClass.myorder(window).userOrderStaticText(0));
    
    
        var orderStr = xxnrClass.myorder(window).userOrderId(0);
        var orderId = orderStr.substr(5,orderStr.length - 5);
        xxnrClass.myorder(window).holdPayTab().tapWithOptions({tapOffset: {x: 0.27, y: 0.55}});
        judge(orderId,"待付款");
    
    })
    xxnrClass.navBack(window).tap();
    test("用户支付部分定金--县级订单",function () {
        delay(1);
        xxnrClass.mine(window).rscOrderBtn().tap();
        delay(1);
        assertEquals("待付款",xxnrClass.rscorder(window).userOrderStaticText(0));
    
        var orderStr = xxnrClass.rscorder(window).userOrderId(0);
        var orderId = orderStr.substr(5,orderStr.length - 5);
        xxnrClass.RSCOrder(window).holdPayTab().tap();
        judge(orderId,"待付款");
    
    })
    xxnrClass.navBack(window).tap();
    test("用户线下支付剩余定金--用户订单",function () {
        delay(1);
        xxnrClass.mine(window).userOrderBtn().tap();
        delay(1);
        xxnrClass.myorder(window).userOrderCell(0).tap();
        delay(1);
        xxnrClass.orderDetail(window).goPay().tap();
        window.buttons()[6].tap();
        xxnrClass.selPayType(window).goPay().tap();
        delay(1);
        xxnrClass.navBack(window).tap();
        delay(1);
        xxnrClass.myorder(window).totalTab().tapWithOptions({tapOffset:{x:0.49, y:0.78}});
        delay(1);
    
        assertEquals("付款待审核",xxnrClass.myorder(window).userOrderStaticText(0));
    
    
        var orderStr = xxnrClass.myorder(window).userOrderId(0);
        var orderId = orderStr.substr(5,orderStr.length - 5);
        xxnrClass.myorder(window).holdPayTab().tapWithOptions({tapOffset: {x: 0.27, y: 0.55}});
        judge(orderId,"待付款");
    
        xxnrClass.navBack(window).tap();
    })
    test("用户线下支付剩余定金--县级订单",function () {
        delay(1);
        xxnrClass.mine(window).rscOrderBtn().tap();
        delay(1);
        window.logElementTree();
    
        assertEquals("付款待审核",xxnrClass.rscorder(window).userOrderStaticText(0));
        xxnrClass.RSCOrder(window).verifyMoney(1).tap();
        xxnrClass.RSCOrder(window).makeSureBtn().tap();
        delay(1);
    
        xxnrClass.RSCOrder(window).totalTab().tap();
    
        assertEquals("待付款",xxnrClass.rscorder(window).userOrderStaticText(0));
    
        var orderStr = xxnrClass.rscorder(window).userOrderId(0);
        var orderId = orderStr.substr(5,orderStr.length - 5);
        xxnrClass.RSCOrder(window).holdPayTab().tap();
    
        judge(orderId,"待付款");
    
    })
    xxnrClass.navBack(window).tap();
    test("后台操作--一个汽车商品发货至服务站",function () {
        delay(10);
    })
    test("用户线下支付剩余尾款--用户订单",function () {
        delay(1);
        xxnrClass.mine(window).userOrderBtn().tap();
        delay(1);
        assertEquals("部分付款",xxnrClass.myorder(window).userOrderStaticText(0));
        xxnrClass.myorder(window).userOrderCell(0).tap();
        xxnrClass.orderDetail(window).goPay().tap();
        window.buttons()[6].tap();
        xxnrClass.selPayType(window).goPay().tap();
        delay(1);
        xxnrClass.navBack(window).tap();
        delay(1);
        xxnrClass.myorder(window).totalTab().tapWithOptions({tapOffset:{x:0.49, y:0.78}});
        delay(1);
    
        assertEquals("付款待审核",xxnrClass.myorder(window).userOrderStaticText(0));
    
    
        var orderStr = xxnrClass.myorder(window).userOrderId(0);
        var orderId = orderStr.substr(5,orderStr.length - 5);
        xxnrClass.myorder(window).holdPayTab().tapWithOptions({tapOffset: {x: 0.27, y: 0.55}});
        judge(orderId,"待付款");
    
    })
    xxnrClass.navBack(window).tap();
    test("用户线下支付剩余尾款--县级订单",function () {
        delay(2);
        xxnrClass.mine(window).rscOrderBtn().tap();
        delay(1);
    
        assertEquals("付款待审核",xxnrClass.rscorder(window).userOrderStaticText(0));
        // window.scrollViews()[0].tableViews()[0].groups()["网点自提"].buttons()["审核付款"].tap();
        xxnrClass.RSCOrder(window).verifyMoney(1).tap();
        xxnrClass.RSCOrder(window).makeSureBtn().tap();
        delay(1);
    
        xxnrClass.RSCOrder(window).totalTab().tap();
        delay(1);
        assertEquals("待自提",xxnrClass.rscorder(window).userOrderStaticText(0));
    
    
        var orderStr = xxnrClass.rscorder(window).userOrderId(0);
        var orderId = orderStr.substr(5,orderStr.length - 5);
        // target.frontMostApp().windows()[0].buttons()["待自提"].tap();
        xxnrClass.RSCOrder(window).carryTab().tap();
        judge(orderId,"待自提");
    
    })
    xxnrClass.navBack(window).tap();

    test("用户网点自提第一个商品--用户订单",function () {
        delay(1);
        xxnrClass.mine(window).userOrderBtn().tap();
        delay(1);
        xxnrClass.myorder(window).userOrderCell(0).tap();
        delay(1);
        xxnrClass.orderDetail(window).goCarry().tap();
        drop(Ab);
        delay(2);

        assertEquals("网点自提",xxnrClass.navTitle(window));

        carry1 = window.tableViews()[0].staticTexts()[1].value();
        logMessage("'"+carry1+"'");
        window.logElementTree();

        xxnrClass.navBack(window).tap();
        xxnrClass.navBack(window).tap();
        
        var orderStr = xxnrClass.myorder(window).userOrderId(0);
        var orderId = orderStr.substr(5,orderStr.length - 5);
        xxnrClass.myorder(window).reciveTab().tapWithOptions({tapOffset:{x:0.63, y:0.45}});
        judge(orderId,"待收货");


        
        xxnrClass.navBack(window).tap();
    })
    test("用户网点自提第一个商品--县级订单",function () {
        delay(1);
        xxnrClass.mine(window).rscOrderBtn().tap();
        // window.scrollViews()[0].tableViews()[0].groups()[1].buttons()["客户自提"].tap();
        xxnrClass.RSCOrder(window).customerCarry(1).tap();

        xxnrClass.RSCOrder(window).carryTableViewcell(0).tap();
        xxnrClass.RSCOrder(window).nextStepBtn().tap();


        xxnrClass.RSCOrder(window).carryNumTextField().tap();
        xxnrClass.RSCOrder(window).carryNumTextField().setValue(carry1);
        xxnrClass.RSCOrder(window).completeBtn().tap();

        xxnrClass.RSCOrder(window).makeSureBtn().tap();
        delay(1);
        assertEquals("待自提",xxnrClass.rscorder(window).userOrderStaticText(0));

        var orderStr = xxnrClass.rscorder(window).userOrderId(0);
        var orderId = orderStr.substr(5,orderStr.length - 5);
        target.frontMostApp().windows()[0].buttons()["待自提"].tap();
        judge(orderId,"待自提");

        xxnrClass.navBack(window).tap();
    })
    test("第一个商品自提成功,二三商品未发货",function () {
        delay(1);
        xxnrClass.mine(window).userOrderBtn().tap();
        assertEquals("待自提",xxnrClass.myorder(window).userOrderStaticText(0));
    })
    test("后台操作二三商品发货",function () {
        delay(10);
    })
    test("去自提二三商品--用户订单",function () {
        delay(1);
        xxnrClass.myorder(window).userOrderCell(0).tap();
        delay(1);
        xxnrClass.orderDetail(window).goCarry().tap();
        delay(1);
        assertEquals("网点自提",xxnrClass.navTitle(window));
        carry2 = window.tableViews()[0].staticTexts()[1].value();
        xxnrClass.navBack(window).tap();
        xxnrClass.navBack(window).tap();
        xxnrClass.navBack(window).tap();
    })
    test("去自提二三商品(已完成)--县级订单",function () {
        delay(1);
        xxnrClass.mine(window).rscOrderBtn().tap();
        delay(1);
        assertEquals("待自提",xxnrClass.rscorder(window).userOrderStaticText(0));
        // window.scrollViews()[0].tableViews()[0].groups()["网点自提"].buttons()["客户自提"].tap();
        xxnrClass.RSCOrder(window).customerCarry(1).tap();
        drop(Ab);
        xxnrClass.RSCOrder(window).carryTableViewcell(1).tap();
        delay(1);
        xxnrClass.RSCOrder(window).carryTableViewcell(2).tap();
        window.logElementTree();
        xxnrClass.RSCOrder(window).nextStepBtn().tap();
        xxnrClass.RSCOrder(window).carryNumTextField().tap();
        xxnrClass.RSCOrder(window).carryNumTextField().setValue(carry2);
        xxnrClass.RSCOrder(window).completeBtn().tap();

        xxnrClass.RSCOrder(window).makeSureBtn().tap();
        delay(1);
        xxnrClass.RSCOrder(window).totalTab().tap();
        assertEquals("已完成",xxnrClass.rscorder(window).userOrderStaticText(0));


        xxnrClass.navBack(window).tap();
    })
    test("自提完成",function () {
        delay(1);
        xxnrClass.mine(window).userOrderBtn().tap();
        drop(Ab);
        assertEquals("已完成",xxnrClass.myorder(window).userOrderStaticText(0));

        var orderStr = xxnrClass.myorder(window).userOrderId(0);
        var orderId = orderStr.substr(5,orderStr.length - 5);
        xxnrClass.myorder(window).commentTab().tapWithOptions({tapOffset:{x:0.59, y:0.33}});
        judge(orderId,"已完成");

    })
}

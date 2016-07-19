/**
 * Created by yangning on 16/7/5.
 */
#import "../lib/tuneup.js"
#import "baseClass.js"
#import "xxnrElementClass.js"
var target = UIATarget.localTarget();
var window = target.frontMostApp().windows()[0];
var isHoldPay = false;

Aa();

function Aa() {
    test("三个汽车订单", function () {
        xxnrdelay(1);
        xxnrElementClass.home(window).car_specialBtn().tap();
        xxnrElementClass.special(window).cell("江淮汽车 - 第二代瑞风S3 - 2015款").tap();
        xxnrElementClass.goodDetail(window).addShoppingCarBtn().tap();
        xxnrElementClass.goodDetail(window).addshoppingCar_property("2.0T 自动（6DCT）").tap();
        xxnrElementClass.goodDetail(window).addshoppingCar_property("豪华智能型").tap();
        xxnrElementClass.goodDetail(window).addshoppingCar_property("拉菲红").tap();
        xxnrElementClass.goodDetail(window).addShoppingCar_sure().tap();
        xxnrdelay(1);

        xxnrElementClass.navBack(window).tap();
        xxnrElementClass.special(window).cell("江淮 - 瑞风S5 - 没有市场价没有描述没有商品详情").staticTexts()["￥240000.1"].tapWithOptions({
            tapOffset: {
                x: 0.74,
                y: 0.21
            }
        });
        xxnrElementClass.goodDetail(window).addShoppingCarBtn().tap();
        xxnrElementClass.goodDetail(window).addshoppingCar_property("豪华智能型").tap();
        xxnrElementClass.goodDetail(window).addshoppingCar_property("时尚白").tap();
        xxnrElementClass.goodDetail(window).addShoppingCar_sure().tap();
        xxnrdelay(1);
        xxnrElementClass.navBack(window).tap();
        xxnrdelay(1);
        xxnrElementClass.special(window).cell("江淮-瑞风S2-市场价为0").scrollToVisible();
        xxnrElementClass.special(window).cell("奇瑞汽车 - 艾瑞泽M7").tap();
        xxnrElementClass.goodDetail(window).addShoppingCarBtn().tap();
        xxnrElementClass.goodDetail(window).addshoppingCar_property("1.8L 手动（MT）").tap();
        xxnrElementClass.goodDetail(window).addshoppingCar_property("宽适版").tap();
        xxnrElementClass.goodDetail(window).addshoppingCar_property("象牙白").tap();
        xxnrElementClass.goodDetail(window).addShoppingCar_sure().tap();
        xxnrdelay(1);
        xxnrElementClass.goodDetail(window).nav_shoppingCar().tap();
        window.logElementTree();

        xxnrdelay(2);
        xxnrElementClass.shoppingCar(window).sel_Group(0).tap();
        window.tableViews()[0].cells()[1].scrollToVisible();
        xxnrElementClass.shoppingCar(window).sel_Group(2).tap();
        xxnrdelay(2);


        xxnrElementClass.shoppingCar(window).go_settle("去结算(3)").tap();
        // window.buttons()["去结算(3)"].tap();

        //window.buttons()[0].tap();
        xxnrdelay(1);
        xxnrElementClass.submitOrder(window).selWebsiteBtn().tap();
        // window.tableViews()[0].buttons()[1].tap();
        window.tableViews()[1].cells()["Zhhdj"].tap();
        window.buttons()["确定"].tap();

        // window.buttons()["提交订单(3)"].tap();
        xxnrElementClass.submitOrder(window).submitOrderBtn().tap();
        xxnrdelay(1);
        xxnrElementClass.navBack(window).tap();
    })
    Ab();
}
function scrollList(order_id,count) {


    isHoldPay = false;
    for (var i = 0; i < count - 1; i++) {
        noworderStr = xxnrElementClass.myorder(window).userOrderId(i * 2);
        if(order_id == noworderStr.substr(5,noworderStr.length-5))
        {
            isHoldPay = true;
            break;
        }
    }
}
function judge(orderId,name) {
    var count = xxnrElementClass.myorder(window).tableViewsgroups().length/2;
    var num = 0;
    xxnrlogMessage("'"+count+"'");

    scrollList(orderId,count);

    while (count > num) {
        if (isHoldPay == false) {
            num = count;
            xxnrlogMessage("'"+num+"'");
            xxnrlogMessage("'"+orderId+"'");

            xxnrElementClass.myorder(window).tableViewsgroups()[num].scrollToVisible();
            window.scrollViews()[0].tableViews()[0].dragInsideWithOptions({
                startOffset: {x: 0.49, y: 1.00},
                endOffset: {x: 0.60, y: -0.05},
                duration: 0.5
            });
            count = xxnrElementClass.myorder(window).tableViewsgroups().length/2;
            scrollList(orderId,count);
            xxnrlogMessage("no");
        }
        else
        {
            xxnrlogMessage("yes");
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
        xxnrdelay(3);
        window.tableViews()[0].buttons()[1].tap();
        xxnrdelay(1);
        window.logElementTree();
        xxnrlogMessage("'"+xxnrElementClass.myorder(window).userOrderStaticText(0)+"'");
        assertEquals("待付款",xxnrElementClass.myorder(window).userOrderStaticText(0));

        var orderStr = xxnrElementClass.myorder(window).userOrderId(0);
        var orderId = orderStr.substr(5,orderStr.length - 5);
        xxnrElementClass.myorder(window).holdPayTab().tapWithOptions({tapOffset: {x: 0.27, y: 0.55}});
        judge(orderId,"待付款");


        xxnrElementClass.navBack(window).tap();

    })
    test("未支付订单--县级订单",function () {
        xxnrdelay(1);
        xxnrElementClass.mine(window).rscOrderBtn().tap();

        window.scrollViews()[0].tableViews()[0].logElementTree();

        assertEquals("待付款",xxnrElementClass.myorder(window).userOrderStaticText(0));



        xxnrElementClass.navBack(window).tap();
    })
    test("用户支付部分定金--用户订单",function () {
        xxnrdelay(1);
        xxnrElementClass.mine(window).userOrderBtn().tap();
        xxnrdelay(1);
        xxnrElementClass.myorder(window).userOrderCell(0).tap();
        xxnrdelay(2);
        xxnrlogMessage("jjjjjjj");
        window.logElementTree();
        xxnrElementClass.orderDetail(window).goPay().tap();
        // window.buttons()["去付款"];
        xxnrElementClass.selPayType(window).separatePay().tap();
        xxnrElementClass.selPayType(window).goPay().tap();
        xxnrdelay(1);
        xxnrElementClass.alipay(window).ALipayBack().tap();
        xxnrElementClass.alipay(window).ALipayBackYes().tap();

        xxnrdelay(1);
        xxnrElementClass.navBack(window).tap();
        xxnrElementClass.navBack(window).tap();
        xxnrElementClass.myorder(window).totalTab().tapWithOptions({tapOffset:{x:0.49, y:0.78}});
        xxnrdelay(1);
        assertEquals("部分付款",xxnrElementClass.myorder(window).userOrderStaticText(0));


        var orderStr = xxnrElementClass.myorder(window).userOrderId(0);
        var orderId = orderStr.substr(5,orderStr.length - 5);
        xxnrElementClass.myorder(window).holdPayTab().tapWithOptions({tapOffset: {x: 0.27, y: 0.55}});
        judge(orderId,"待付款");

    })
    xxnrElementClass.navBack(window).tap();
    test("用户支付部分定金--县级订单",function () {
        xxnrdelay(1);
        xxnrElementClass.mine(window).rscOrderBtn().tap();
        xxnrdelay(1);
        assertEquals("待付款",xxnrElementClass.RSCOrder(window).RSCOrderStaticText(0));


    })
    xxnrElementClass.navBack(window).tap();
    test("用户线下支付剩余定金--用户订单",function () {
        xxnrdelay(1);
        xxnrElementClass.mine(window).userOrderBtn().tap();
        xxnrdelay(1);
        xxnrElementClass.myorder(window).userOrderCell(0).tap();
        xxnrdelay(1);
        xxnrElementClass.orderDetail(window).goPay().tap();
        window.buttons()[6].tap();
        xxnrElementClass.selPayType(window).goPay().tap();
        xxnrdelay(1);
        xxnrElementClass.navBack(window).tap();
        xxnrdelay(1);
        xxnrElementClass.myorder(window).totalTab().tapWithOptions({tapOffset:{x:0.49, y:0.78}});
        xxnrdelay(1);

        assertEquals("付款待审核",xxnrElementClass.myorder(window).userOrderStaticText(0));


        var orderStr = xxnrElementClass.myorder(window).userOrderId(0);
        var orderId = orderStr.substr(5,orderStr.length - 5);
        xxnrElementClass.myorder(window).holdPayTab().tapWithOptions({tapOffset: {x: 0.27, y: 0.55}});
        judge(orderId,"待付款");

        xxnrElementClass.navBack(window).tap();
    })
    test("用户线下支付剩余定金--县级订单",function () {
        xxnrdelay(1);
        xxnrElementClass.mine(window).rscOrderBtn().tap();
        xxnrdelay(1);
        window.logElementTree();

        assertEquals("付款待审核",xxnrElementClass.RSCOrder(window).RSCOrderStaticText(0));
        xxnrElementClass.RSCOrder(window).verifyMoney(1).tap();
        xxnrElementClass.RSCOrder(window).makeSureBtn().tap();
        xxnrdelay(1);

        xxnrElementClass.RSCOrder(window).totalTab().tap();

        assertEquals("待付款",xxnrElementClass.RSCOrder(window).RSCOrderStaticText(0));



    })
    xxnrElementClass.navBack(window).tap();
    test("后台操作--一个汽车商品发货至服务站",function () {
        xxnrdelay(10);
    })
    test("用户线下支付剩余尾款--用户订单",function () {
        xxnrdelay(1);
        xxnrElementClass.mine(window).userOrderBtn().tap();
        xxnrdelay(1);
        assertEquals("部分付款",xxnrElementClass.myorder(window).userOrderStaticText(0));
        xxnrElementClass.myorder(window).userOrderCell(0).tap();
        xxnrElementClass.orderDetail(window).goPay().tap();
        window.buttons()[6].tap();
        xxnrElementClass.selPayType(window).goPay().tap();
        xxnrdelay(1);
        xxnrElementClass.navBack(window).tap();
        xxnrdelay(1);
        xxnrElementClass.myorder(window).totalTab().tapWithOptions({tapOffset:{x:0.49, y:0.78}});
        xxnrdelay(1);

        assertEquals("付款待审核",xxnrElementClass.myorder(window).userOrderStaticText(0));


        var orderStr = xxnrElementClass.myorder(window).userOrderId(0);
        var orderId = orderStr.substr(5,orderStr.length - 5);
        xxnrElementClass.myorder(window).holdPayTab().tapWithOptions({tapOffset: {x: 0.27, y: 0.55}});
        judge(orderId,"待付款");

    })
    xxnrElementClass.navBack(window).tap();
    test("用户线下支付剩余尾款--县级订单",function () {
        xxnrdelay(2);
        xxnrElementClass.mine(window).rscOrderBtn().tap();
        xxnrdelay(1);

        assertEquals("付款待审核",xxnrElementClass.RSCOrder(window).RSCOrderStaticText(0));
        // window.scrollViews()[0].tableViews()[0].groups()["网点自提"].buttons()["审核付款"].tap();
        xxnrElementClass.RSCOrder(window).verifyMoney(1).tap();
        xxnrElementClass.RSCOrder(window).makeSureBtn().tap();
        xxnrdelay(1);

        xxnrElementClass.RSCOrder(window).totalTab().tap();
        xxnrdelay(1);
        assertEquals("待自提",xxnrElementClass.RSCOrder(window).RSCOrderStaticText(0));



    })
    xxnrElementClass.navBack(window).tap();

    test("用户网点自提第一个商品--用户订单",function () {
        xxnrdelay(1);
        xxnrElementClass.mine(window).userOrderBtn().tap();
        xxnrdelay(1);
        xxnrElementClass.myorder(window).userOrderCell(0).tap();
        xxnrdelay(1);
        xxnrElementClass.orderDetail(window).goCarry().tap();
        xxnrdelay(2);

        assertEquals("网点自提",xxnrElementClass.navTitle(window));

        carry1 = window.tableViews()[0].staticTexts()[1].value();
        xxnrlogMessage("'"+carry1+"'");
        window.logElementTree();

        xxnrElementClass.navBack(window).tap();
        xxnrElementClass.navBack(window).tap();

        var orderStr = xxnrElementClass.myorder(window).userOrderId(0);
        var orderId = orderStr.substr(5,orderStr.length - 5);
        xxnrElementClass.myorder(window).reciveTab().tapWithOptions({tapOffset:{x:0.63, y:0.45}});
        judge(orderId,"待收货");



        xxnrElementClass.navBack(window).tap();
    })
    test("用户网点自提第一个商品--县级订单",function () {
        xxnrdelay(1);
        xxnrElementClass.mine(window).rscOrderBtn().tap();
        // window.scrollViews()[0].tableViews()[0].groups()[1].buttons()["客户自提"].tap();
        xxnrElementClass.RSCOrder(window).customerCarry(1).tap();

        xxnrElementClass.RSCOrder(window).carryTableViewcell(0).tap();
        xxnrElementClass.RSCOrder(window).nextStepBtn().tap();


        xxnrElementClass.RSCOrder(window).carryNumTextField().tap();
        xxnrElementClass.RSCOrder(window).carryNumTextField().setValue(carry1);
        xxnrElementClass.RSCOrder(window).completeBtn().tap();

        xxnrElementClass.RSCOrder(window).makeSureBtn().tap();
        xxnrdelay(1);
        assertEquals("待自提",xxnrElementClass.RSCOrder(window).RSCOrderStaticText(0));


        xxnrElementClass.navBack(window).tap();
    })
    test("第一个商品自提成功,二三商品未发货",function () {
        xxnrdelay(1);
        xxnrElementClass.mine(window).userOrderBtn().tap();
        assertEquals("待自提",xxnrElementClass.myorder(window).userOrderStaticText(0));
    })
    test("后台操作二三商品发货",function () {
        xxnrdelay(10);
    })
    test("去自提二三商品--用户订单",function () {
        xxnrdelay(1);
        xxnrElementClass.myorder(window).userOrderCell(0).tap();
        xxnrdelay(1);
        xxnrElementClass.orderDetail(window).goCarry().tap();
        xxnrdelay(1);
        assertEquals("网点自提",xxnrElementClass.navTitle(window));
        carry2 = window.tableViews()[0].staticTexts()[1].value();
        xxnrElementClass.navBack(window).tap();
        xxnrElementClass.navBack(window).tap();
        xxnrElementClass.navBack(window).tap();
    })
    test("去自提二三商品(已完成)--县级订单",function () {
        xxnrdelay(1);
        xxnrElementClass.mine(window).rscOrderBtn().tap();
        xxnrdelay(1);
        assertEquals("待自提",xxnrElementClass.RSCOrder(window).RSCOrderStaticText(0));
        xxnrElementClass.RSCOrder(window).RSCOrderStaticText(0)
        // window.scrollViews()[0].tableViews()[0].groups()["网点自提"].buttons()["客户自提"].tap();
        xxnrElementClass.RSCOrder(window).customerCarry(1).tap();
        xxnrElementClass.RSCOrder(window).carryTableViewcell(1).tap();
        xxnrdelay(1);
        xxnrElementClass.RSCOrder(window).carryTableViewcell(2).tap();
        window.logElementTree();
        xxnrElementClass.RSCOrder(window).nextStepBtn().tap();
        xxnrElementClass.RSCOrder(window).carryNumTextField().tap();
        xxnrElementClass.RSCOrder(window).carryNumTextField().setValue(carry2);
        xxnrElementClass.RSCOrder(window).completeBtn().tap();

        xxnrElementClass.RSCOrder(window).makeSureBtn().tap();
        xxnrdelay(1);
        xxnrElementClass.RSCOrder(window).totalTab().tap();
        assertEquals("已完成",xxnrElementClass.RSCOrder(window).RSCOrderStaticText(0));


        xxnrElementClass.navBack(window).tap();
    })
    test("自提完成",function () {
        xxnrdelay(1);
        xxnrElementClass.mine(window).userOrderBtn().tap();
        assertEquals("已完成",xxnrElementClass.myorder(window).userOrderStaticText(0));

        var orderStr = xxnrElementClass.myorder(window).userOrderId(0);
        var orderId = orderStr.substr(5,orderStr.length - 5);
        xxnrElementClass.myorder(window).commentTab().tapWithOptions({tapOffset:{x:0.59, y:0.33}});
        judge(orderId,"已完成");

    })
}

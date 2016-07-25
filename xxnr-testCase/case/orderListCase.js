/**
 * Created by yangning on 16/6/28.
 */
#import "../lib/tuneup.js"
#import "xxnrElementClass.js"
#import "baseClass.js"

var target = UIATarget.localTarget();
var window = target.frontMostApp().windows()[0];

xxnrElementClass.tab(window).mineTab().tap();

xxnrdelay(2);
xxnrlogEleTree(window);

test("列表页按钮的点击", function (target, app) {
    xxnrdelay(2);
xxnrElementClass.mine(window).userOrderBtn().tap();
    xxnrlogEleTree(window);
    xxnrdelay(2);
    assertEquals("我的订单", xxnrElementClass.navTitle(window));
    assertEquals(5, window.buttons().length);

    xxnrElementClass.myorder(window).holdPayTab().tapWithOptions({tapOffset: {x: 0.27, y: 0.55}});
    xxnrdelay(2);

    xxnrlogEleTree(window);

    xxnrElementClass.myorder(window).sendTab().tapWithOptions({tapOffset: {x: 0.30, y: 0.82}});

    xxnrElementClass.myorder(window).reciveTab().tapWithOptions({tapOffset: {x: 0.64, y: 0.88}});

    xxnrElementClass.myorder(window).commentTab().tapWithOptions({tapOffset: {x: 0.34, y: 0.68}});

    xxnrElementClass.navBack(window).tap();
})
if(xxnrElementClass.mine(window).buttons().length > 2) {
    test("其他按钮的点击", function () {
        xxnrElementClass.mine(window).userOrderBtn().tap();
        xxnrdelay(2);
        xxnrElementClass.navBack(window).tap();
        xxnrElementClass.mine(window).buttons()[2].tap();
        xxnrdelay(2);
        xxnrElementClass.navBack(window).tap();
        xxnrElementClass.mine(window).buttons()[3].tap();
        xxnrElementClass.navBack(window).tap();
        xxnrElementClass.mine(window).buttons()[4].tap();
        xxnrElementClass.navBack(window).tap();
    })
}
test("待付款",function () {

    xxnrdelay(2);
    xxnrElementClass.mine(window).userOrderBtn().tap();
    xxnrdelay(1);
    xxnrElementClass.myorder(window).holdPayTab().tapWithOptions({tapOffset: {x: 0.27, y: 0.55}});

    xxnrdelay(2);

    var count = xxnrElementClass.myorder(window).tableViewsgroups().length/2;
    if (count == 0)
    {
        assertEquals("您还没有订单", xxnrElementClass.myorder(window).noOrderStaticText());
        xxnrElementClass.myorder(window).goPayFer().tap();
        assertEquals("化肥", xxnrElementClass.navTitle(window));
        xxnrElementClass.navBack(window).tap();

        xxnrElementClass.myorder(window).goPayCar().tap();
        assertEquals("汽车", xxnrElementClass.navTitle(window));
        xxnrElementClass.navBack(window).tap();
    }
    else {
        if (count > 20) {
            count = 20;
        }

        xxnrlogEleTree(window);

        for (var i = 0; i < count - 1; i++) {
            UIALogger.logMessage("asss");
            assertEquals(true, xxnrElementClass.myorder(window).userOrderStaticText(i * 2) == "待付款" || xxnrElementClass.myorder(window).userOrderStaticText(i * 2) == "付款待审核"|| xxnrElementClass.myorder(window).userOrderStaticText(i * 2) == "部分付款", "待付款商品第'" + i + "'个");

            if(xxnrElementClass.myorder(window).userOrderStaticText(i * 2) == "待付款" ||xxnrElementClass.myorder(window).userOrderStaticText(i * 2) == "部分付款")
            {
                assertNotNull(xxnrElementClass.myorder(window).goPay(i*2+1));

            }
            else if ( xxnrElementClass.myorder(window).userOrderStaticText(i * 2) == "付款待审核")
            {
                assertNotNull(xxnrElementClass.myorder(window).amendPayType(i*2+1));
                assertNotNull(xxnrElementClass.myorder(window).seePayType(i*2+1));

            }
            else
            {
                UIALogger.logFail("按钮出错");
            }
        }
    }
})
test("待发货",function () {
    xxnrElementClass.myorder(window).sendTab().tapWithOptions({tapOffset:{x:0.30, y:0.82}});
    xxnrdelay(2);

    var count = xxnrElementClass.myorder(window).tableViewsgroups().length/2;
    if (count == 0)
    {
        assertEquals("您还没有订单", xxnrElementClass.myorder(window).noOrderStaticText());
        xxnrElementClass.myorder(window).goPayFer().tap();
        assertEquals("化肥", xxnrElementClass.navTitle(window));
        xxnrElementClass.navBack(window).tap();

        xxnrElementClass.myorder(window).goPayCar().tap();
        assertEquals("汽车", xxnrElementClass.navTitle(window));
        xxnrElementClass.navBack(window).tap();

    }
    else {

        if (count > 20) {
            count = 20;
        }

        for (var i = 0; i < count - 1; i++) {
            assertEquals("待发货", xxnrElementClass.myorder(window).userOrderStaticText(i * 2), "待发货商品第'" + i + "'个");

        }
    }
})
test("待收货",function () {
    xxnrElementClass.myorder(window).reciveTab().tapWithOptions({tapOffset:{x:0.64, y:0.88}});
    xxnrdelay(2);
    xxnrlogEleTree(window);
    var count = xxnrElementClass.myorder(window).tableViewsgroups().length/2;
    if (count == 0)
    {
        assertEquals("您还没有订单", xxnrElementClass.myorder(window).noOrderStaticText());
        xxnrElementClass.myorder(window).goPayFer().tap();
        assertEquals("化肥", xxnrElementClass.navTitle(window));
        xxnrElementClass.navBack(window).tap();

        xxnrElementClass.myorder(window).goPayCar().tap();
        assertEquals("汽车", xxnrElementClass.navTitle(window));
        xxnrElementClass.navBack(window).tap();
    }
    else {

        if (count > 20) {
            count = 20;
        }

        for (var i = 0; i < count - 1; i++) {
            if (i == 18) {
                UIALogger.logMessage("'" + xxnrElementClass.myorder(window).tableViewsgroups()[i * 2].staticTexts()[0].name() + "'");
            }
            if(xxnrElementClass.myorder(window).userOrderId(i).substr(0,3) == "订单号")
            {
                assertEquals(true, xxnrElementClass.myorder(window).userOrderStaticText(i) == "配送中" || xxnrElementClass.myorder(window).userOrderStaticText(i) == "待自提", "待收货商品第'" + i + "'个");

            }
        }
    }
})
test("已完成",function () {
    xxnrElementClass.myorder(window).commentTab().tapWithOptions({tapOffset:{x:0.34, y:0.68}});
    xxnrdelay(2);


    var count = xxnrElementClass.myorder(window).tableViewsgroups().length/2;
    if (count == 0)
    {
        assertEquals("您还没有订单", xxnrElementClass.myorder(window).noOrderStaticText());
        xxnrElementClass.myorder(window).goPayFer().tap();
        assertEquals("化肥", xxnrElementClass.navTitle(window));
        xxnrElementClass.navBack(window).tap();

        xxnrElementClass.myorder(window).goPayCar().tap();
        assertEquals("汽车", xxnrElementClass.navTitle(window));
        xxnrElementClass.navBack(window).tap();
    }
    else {

        if (count > 20) {
            count = 20;
        }
        UIALogger.logMessage("'" + count + "'");
        for (var i = 0; i < count - 1; i++) {
            assertEquals("已完成", xxnrElementClass.myorder(window).userOrderStaticText(i * 2), "已完成商品第'" + i + "'个");

        }
    }
})

test("滚动列表",function () {

    xxnrElementClass.myorder(window).holdPayTab().tapWithOptions({tapOffset:{x:0.27, y:0.55}});

    xxnrdelay(2);

    var count = xxnrElementClass.myorder(window).userOrderCells().length;
    var lastCount = 0;

    while(count > lastCount) {
        lastCount = count;
        xxnrElementClass.myorder(window).userOrderCell(count - 1).scrollToVisible();
        window.scrollViews()[0].tableViews()[0].dragInsideWithOptions({
            startOffset: {x: 0.49, y: 0.90},
            endOffset: {x: 0.60, y: 0.03},
            duration: 0.5
        });
        count = xxnrElementClass.myorder(window).userOrderCells().length;
    }
    xxnrElementClass.navBack(window).tap();

})


test("cell中确认收货按钮点击",function(target,app){

    xxnrElementClass.mine(window).userOrderBtn().tap();

    xxnrElementClass.myorder(window).reciveTab().tapWithOptions({tapOffset:{x:0.64, y:0.88}});
    xxnrdelay(3);
    var count = xxnrElementClass.myorder(window).tableViewsgroups().length/2;
    if(count > 0){
        UIALogger.logMessage("hhhhh");
        var name = true;

        for(var i=0;i<count;i++){

            xxnrElementClass.myorder(window).tableViewsgroups()[(i+1)*2-1].scrollToVisible();

            if(xxnrElementClass.myorder(window).tableViewsgroups()[(i+1)*2-1].buttons()[0].name() == "确认收货" && name)
            {
                name = false;
                xxnrdelay(1);

                xxnrElementClass.myorder(window).tableViewsgroups()[(i+1)*2-1].buttons()[0].tap();

                xxnrdelay(2);
                assertEquals(1,window.buttons()[5].isVisible());

                window.buttons()[5].tapWithOptions({tapOffset:{x:0.75, y:0.40}});
                window.buttons()[5].tapWithOptions({tapOffset:{x:0.56, y:0.97}});
                break;
            }
        }
    }

})


test("cell中自提按钮点击",function(target,app){
    xxnrdelay(3);

    xxnrElementClass.myorder(window).reciveTab().tapWithOptions({tapOffset:{x:0.64, y:0.88}});
    xxnrdelay(3);
    var count = xxnrElementClass.myorder(window).tableViewsgroups().length/2;
    if(count > 0){
        UIALogger.logMessage("hhhhh");
        var name = true;
        for(var i=0;i<count;i++){

            xxnrElementClass.myorder(window).tableViewsgroups()[(i+1)*2-1].scrollToVisible();

            if(xxnrElementClass.myorder(window).tableViewsgroups()[(i+1)*2-1].buttons()[0].name() == "去自提" && name)
            {

                name = false;
                xxnrdelay(5);
                xxnrElementClass.myorder(window).tableViewsgroups()[(i+1)*2-1].buttons()["去自提"].tap();
                xxnrdelay(2);
                assertEquals("网点自提",xxnrElementClass.navTitle(window));
                xxnrElementClass.navBack(window).tap();
                break;
            }
        }
    }

})



test("cell中点击去付款",function(target,app){
    xxnrdelay(3);

    xxnrElementClass.myorder(window).holdPayTab().tapWithOptions({tapOffset:{x:0.27, y:0.55}});
    xxnrdelay(3);
    var count = xxnrElementClass.myorder(window).tableViewsgroups().length/2;
    if(count > 0){
        var name = true;
        for(var i=0;i<count;i++){

            if(xxnrElementClass.myorder(window).tableViewsgroups()[(i+1)*2-1].buttons()[0].name() == "去付款" && name)
            {
                xxnrElementClass.myorder(window).tableViewsgroups()[(i+1)*2-1].scrollToVisible();

                name = false;
                xxnrElementClass.myorder(window).goPay((i+1)*2-1).tap();
                xxnrdelay(2);
                assertEquals("支付方式",xxnrElementClass.navTitle(window));
                xxnrElementClass.navBack(window).tap();
                break;
            }
        }
    }
})

test("cell中点击修改付款方式",function(target,app){
    xxnrdelay(3);

    xxnrElementClass.myorder(window).holdPayTab().tapWithOptions({tapOffset:{x:0.27, y:0.55}});
    xxnrdelay(3);
    var count = xxnrElementClass.myorder(window).tableViewsgroups().length/2;
    if(count > 0){
        var name = true;
        for(var i=0;i<count;i++){
            xxnrElementClass.myorder(window).tableViewsgroups()[(i+1)*2-1].scrollToVisible();

            if(xxnrElementClass.myorder(window).tableViewsgroups()[(i+1)*2-1].buttons()[0].name() == "修改付款方式" && name)
            {

                name = false;
                xxnrElementClass.myorder(window).amendPayType((i+1)*2-1).tap();
                xxnrdelay(2);
                if(xxnrElementClass.navTitle(window) == "支付方式")
                {
                    xxnrElementClass.navBack(window).tap();
                }
                else
                {
                    assertEquals("订单已支付",xxnrElementClass.navTitle(window));
                    xxnrElementClass.navBack(window).tap();
                }
                break;
            }
        }
    }

})

test("cell中点击查看付款详情",function(target,app){
    xxnrdelay(3);

    xxnrElementClass.myorder(window).holdPayTab().tapWithOptions({tapOffset:{x:0.27, y:0.55}});
    xxnrdelay(3);
    var count = xxnrElementClass.myorder(window).tableViewsgroups().length/2;
    if(count > 0){
        var name = true;
        for(var i=0;i<count;i++){
            xxnrElementClass.myorder(window).tableViewsgroups()[(i+1)*2-1].scrollToVisible();

            if(xxnrElementClass.myorder(window).tableViewsgroups()[(i+1)*2-1].buttons()[0].name() == "查看付款详情" && name)
            {

                name = false;
                xxnrElementClass.myorder(window).amendPayType((i+1)*2-1).tap();
                xxnrdelay(2);
                assertEquals("线下支付",xxnrElementClass.navTitle(window));
                xxnrElementClass.navBack(window).tap();
                break;
            }
        }
    }

})
test("跳转订单详情",function(target,app){
    xxnrdelay(2);

    // xxnrElementClass.myorder(window).reciveTab().tapWithOptions({tapOffset:{x:0.64, y:0.88}});

    xxnrElementClass.myorder(window).totalTab().tapWithOptions({tapOffset:{x:0.49, y:0.78}});

    xxnrdelay(2);

    xxnrlogEleTree(window);

    var count = xxnrElementClass.myorder(window).tableViewsgroups().length+xxnrElementClass.myorder(window).tableViewsgroups().length/2;
    //UIALogger.logMessage("'" + count+ "'");
    // UIALogger.logMessage("'" +count+ "'");


    var arr = [];

    for (var m = 0; m < count; m++) {

        xxnrdelay(2);
        var x = ["待付款","待发货","配送中","部分付款","付款待审核","已完成","待自提","已关闭"];


        var orderState = xxnrElementClass.myorder(window).elementStaticText(m);
        // xxnrlogMessage("'"+m+"'");

        // xxnrlogMessage("'"+xxnrElementClass.myorder(window).elementStaticText(m)+"'");

        if (!in_array(orderState,x)) {
            continue;
        }

        if (in_array(orderState, arr)) {
            continue;
        }
        else {
            arr[arr.length] = orderState;
        }

        xxnrElementClass.myorder(window).elements(m+1).scrollToVisible();

        xxnrdelay(2);

        // xxnrlogMessage("'"+xxnrElementClass.myorder(window).elementStaticText(m+1)+"'");

        xxnrElementClass.myorder(window).elements(m+1).tap();

        // xxnrlogEleTree(window);

        xxnrdelay(1);
        assertEquals("订单详情", xxnrElementClass.navTitle(window));

        test("订单详情",function () {

            xxnrlogEleTree(window);
            test("查看支付详情",function () {
                var isseeDetail = false;
                for (var i = 0; i < xxnrElementClass.orderDetail(window).cells().length; i++) {
                    if (xxnrElementClass.orderDetail(window).seePayDetail(xxnrElementClass.orderDetail(window).cell(i)).isVisible()) {
                        isseeDetail = true;
                        assertEquals("查看支付详情", xxnrElementClass.navTitle(window));
                        xxnrElementClass.navBack(window).tap();
                    }
                }
                if (isseeDetail == false)
                {
                    xxnrlogMessage("没有分次支付记录");
                }
            })

            var orderState = xxnrElementClass.orderDetail(window).orderState().name().substr(5, xxnrElementClass.orderDetail(window).orderState().name().length - 5);

            if (orderState == "待付款" || orderState == "部分付款") {
                test("待付款或部分付款", function () {
                    assertNotNull(xxnrElementClass.orderDetail(window).goPay());
                    xxnrElementClass.orderDetail(window).goPay().tap();
                    xxnrdelay(2);
                    assertEquals("支付方式", xxnrElementClass.navTitle(window));
                    xxnrElementClass.navBack(window).tap();
                })
            }
            else if (orderState == "付款待审核") {
                test("付款待审核", function () {
                    assertNotNull(xxnrElementClass.orderDetail(window).amendPayType());
                    assertNotNull(xxnrElementClass.orderDetail(window).seePayType());

                    xxnrElementClass.orderDetail(window).amendPayType().tap();
                    xxnrdelay(2);

                    assertEquals("支付方式", xxnrElementClass.navTitle(window));
                    xxnrElementClass.navBack(window).tap();

                    xxnrElementClass.orderDetail(window).seePayType().tap();
                    xxnrdelay(2);

                    assertEquals("线下支付", xxnrElementClass.navTitle(window));
                    xxnrElementClass.navBack(window).tap();
                })

            }
            else if (orderState == "待自提") {
                test("待自提", function () {
                    xxnrdelay(2);
                    var i = xxnrElementClass.orderDetail(window).goodsListOneIndex();
                    var j = i;
                    var isCarry = false;
                    var count = 0;
                    xxnrlogMessage("'"+i+"'");
                    xxnrlogMessage("'"+parseInt(xxnrElementClass.orderDetail(window).cells().length)+"'");

                    for (j; j < parseInt(xxnrElementClass.orderDetail(window).cells().length); j++) {
                        var cell = xxnrElementClass.orderDetail(window).cell(j);

                        xxnrlogEleTree(window);
                        xxnrlogMessage("'"+xxnrElementClass.orderDetail(window).consignmentState(cell).value()+"'");

                        if (xxnrElementClass.orderDetail(window).consignmentState(cell).value() == "已到服务站") {
                            count += 1;
                            isCarry = true;
                        }
                    }
                    if (isCarry == true) {

                        assertNotNull(xxnrElementClass.orderDetail(window).goCarry());
                        xxnrElementClass.orderDetail(window).goCarry().tap();
                        xxnrdelay(2);
                        assertEquals("网点自提", xxnrElementClass.navTitle(window));
                        test("网点自提商品展示是否正确", function () {

                            assertEquals(count, xxnrElementClass.carry(window).cells().length);
                        })
                        xxnrElementClass.navBack(window).tap();
                    }
                    else {
                        assertNull(xxnrElementClass.orderDetail(window).goCarry());
                    }
                })
            }
            else if (orderState == "配送中") {
                test("配送中", function () {
                    var i = xxnrElementClass.orderDetail(window).goodsListOneIndex();
                    var j = i;
                    var isdispatch = false;
                    var goodsCount = 0;

                    for (j; j < parseInt(xxnrElementClass.orderDetail(window).cells().length); j++) {
                        var cell = xxnrElementClass.orderDetail(window).cell(j);
                        xxnrlogMessage("'" + xxnrElementClass.orderDetail(window).consignmentState(cell).value() + "'");
                        if (xxnrElementClass.orderDetail(window).consignmentState(cell).value() == "配送中") {
                            goodsCount +=1;
                            isdispatch = true;
                        }
                    }

                    if (isdispatch == true) {
                        xxnrlogEleTree(window);
                        assertNotNull(xxnrElementClass.orderDetail(window).receiveGoods());
                        xxnrElementClass.orderDetail(window).receiveGoods().tap();

                        xxnrdelay(5);
                        xxnrlogEleTree(window);
                        assertEquals(1, window.buttons()[1].isVisible());

                        window.buttons()[1].tapWithOptions({tapOffset: {x: 0.75, y: 0.40}});
                        window.buttons()[1].tapWithOptions({tapOffset: {x: 0.56, y: 0.97}});

                        xxnrdelay(6);

                        var nowCount = 0;
                        if (xxnrElementClass.orderDetail(window).consignmentState(cell).value() == "配送中") {
                            nowCount +=1;
                        }
                        //验证当前页面是否刷新
                        assertEquals(nowCount,goodsCount-1,"页面刷新失败");
                    }
                    else {
                        assertNull(xxnrElementClass.orderDetail(window).receiveGoods());
                    }
                })

            }
            else {
                test("底部没有按钮", function () {
                    assertNull(xxnrElementClass.orderDetail(window).btmbutton());
                })
            }
            xxnrdelay(2);
            xxnrElementClass.navBack(window).tap();
        })
    }



    xxnrdelay(2);
    xxnrElementClass.navBack(window).tap();
})
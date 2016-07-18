/**
 * Created by yangning on 16/6/28.
 */
#import "../lib/tuneup.js"
#import "xxnrElementClass.js"

var target = UIATarget.localTarget();
var window = target.frontMostApp().windows()[0];

xxnrElementClass.tab(window).mineTab().tap();

xxnrdelay(2);
window.logElementTree();

test("列表页按钮的点击", function (target, app) {
    xxnrdelay(2);
    xxnrElementClass.mine(window).userOrderBtn().tap();
    window.logElementTree();
    xxnrdelay(2);
    assertEquals("我的订单", xxnrElementClass.navTitle(window));
    assertEquals(5, window.buttons().length);

    xxnrElementClass.myorder(window).holdPayTab().tapWithOptions({tapOffset: {x: 0.27, y: 0.55}});
    xxnrdelay(2);

    window.logElementTree();

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
    }
    else {


        if (count > 20) {
            count = 20;
        }

        window.logElementTree();
        for (var i = 0; i < count - 1; i++) {
            UIALogger.logMessage("asss");
            assertEquals(true, xxnrElementClass.myorder(window).userOrderStaticText(i * 2) == "待付款" || xxnrElementClass.myorder(window).userOrderStaticText(i * 2) == "付款待审核"|| xxnrElementClass.myorder(window).userOrderStaticText(i * 2) == "部分付款", "待付款商品第'" + i + "'个");

            // assertEquals(true, xxnrElementClass.myorder(window).tableViewsgroups()[i * 2].staticTexts()[0].name() == "待付款" || xxnrElementClass.myorder(window).tableViewsgroups()[i * 2].staticTexts()[0].name() == "付款待审核"|| xxnrElementClass.myorder(window).tableViewsgroups()[i * 2].staticTexts()[0].name() == "部分付款", "待付款商品第'" + i + "'个");
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
    }
    else {

        if (count > 20) {
            count = 20;
        }

        for (var i = 0; i < count - 1; i++) {
            assertEquals("待发货", xxnrElementClass.myorder(window).userOrderStaticText(i * 2), "待发货商品第'" + i + "'个");

            // assertEquals("待发货", xxnrElementClass.myorder(window).tableViewsgroups()[i * 2].staticTexts()[0].name(), "待发货商品第'" + i + "'个");
        }
    }
})
test("待收货",function () {
    xxnrElementClass.myorder(window).reciveTab().tapWithOptions({tapOffset:{x:0.64, y:0.88}});
    xxnrdelay(2);
    window.logElementTree();
    var count = xxnrElementClass.myorder(window).tableViewsgroups().length/2;
    if (count == 0)
    {
        assertEquals("您还没有订单", xxnrElementClass.myorder(window).noOrderStaticText());
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

                // assertEquals(true, xxnrElementClass.myorder(window).tableViewsgroups()[i].staticTexts()[0].name() == "配送中" || xxnrElementClass.myorder(window).tableViewsgroups()[i].staticTexts()[0].name() == "待自提", "待收货商品第'" + i + "'个");
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
    }
    else {

        if (count > 20) {
            count = 20;
        }
        UIALogger.logMessage("'" + count + "'");
        for (var i = 0; i < count - 1; i++) {
            assertEquals("已完成", xxnrElementClass.myorder(window).userOrderStaticText(i * 2), "已完成商品第'" + i + "'个");

            // assertEquals("已完成", xxnrElementClass.myorder(window).tableViewsgroups()[i * 2].staticTexts()[0].name(), "已完成商品第'" + i + "'个");
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

test("跳转订单详情",function(target,app){

    xxnrElementClass.mine(window).userOrderBtn().tap();

    xxnrdelay(3);

    var count = xxnrElementClass.myorder(window).userOrderCells().length;
    if(count > 0){
        xxnrElementClass.myorder(window).userOrderCell(0).tap();
        xxnrdelay(1);
        assertEquals("订单详情",xxnrElementClass.navTitle(window));
        xxnrElementClass.navBack(window).tap();
    }
})
test("cell中确认收货按钮点击",function(target,app){
    xxnrElementClass.myorder(window).reciveTab().tapWithOptions({tapOffset:{x:0.64, y:0.88}});
    xxnrdelay(3);
    var count = xxnrElementClass.myorder(window).tableViewsgroups().length/2;
    if(count > 0){
        UIALogger.logMessage("hhhhh");
        var name = true;

        for(var i=0;i<count;i++){

            if(xxnrElementClass.myorder(window).tableViewsgroups()[i].buttons()[0].name() == "确认收货" && name)
            {
                xxnrElementClass.myorder(window).tableViewsgroups()[i].scrollToVisible();
                name = false;
                // xxnrdelay(5);
                // UIALogger.logMessage("'"+xxnrElementClass.myorder(window).tableViewsgroups()[16].buttons()[0].name()+"'");
                //
                // xxnrElementClass.myorder(window).tableViewsgroups()[i].buttons()[0].tap();
                //
                //
                // xxnrdelay(2);
                // assertEquals(1,window.buttons()[5].isVisible());
                // window.logElementTree();
                //
                // window.buttons()[5].tapWithOptions({tapOffset:{x:0.75, y:0.40}});
                // window.buttons()[5].tapWithOptions({tapOffset:{x:0.56, y:0.97}});
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

            if(xxnrElementClass.myorder(window).tableViewsgroups()[i].buttons()[0].name() == "去自提" && name)
            {
                xxnrElementClass.myorder(window).tableViewsgroups()[i].scrollToVisible();

                name = false;
                // xxnrdelay(5);
                // xxnrElementClass.myorder(window).tableViewsgroups()[i].buttons()["去自提"].tap();
                // xxnrdelay(2);
                // assertEquals("网点自提",xxnrElementClass.navTitle(window));
                // xxnrElementClass.navBack(window).tap();
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

            if(xxnrElementClass.myorder(window).tableViewsgroups()[(i+1)*2-1].buttons()[0].name() == "修改付款方式" && name)
            {
                xxnrElementClass.myorder(window).tableViewsgroups()[(i+1)*2-1].scrollToVisible();

                name = false;
                xxnrElementClass.myorder(window).amendPayType((i+1)*2-1).tap();
                xxnrdelay(2);
                assertEquals("支付方式",xxnrElementClass.navTitle(window));
                xxnrElementClass.navBack(window).tap();
                break;
            }
        }
    }

})

/**
 * Created by yangning on 16/6/28.
 */
#import "../lib/tuneup.js"

var target = UIATarget.localTarget();

test("列表页按钮的点击",function (target,app) {
    target.frontMostApp().windows()[0].tabBar().buttons()["我的"].tap();
    target.delay(2);
    target.frontMostApp().windows()[0].tableViews()[0].buttons()[0].tap();
    target.frontMostApp().windows()[0].logElementTree();
    target.delay(2);
    assertEquals("我的订单",target.frontMostApp().windows()[0].navigationBar().staticTexts()[0].value());
    assertEquals(5,target.frontMostApp().windows()[0].buttons().length);

    target.frontMostApp().windows()[0].staticTexts()["待付款"].tapWithOptions({tapOffset:{x:0.27, y:0.55}});
    target.delay(2);

    target.frontMostApp().windows()[0].logElementTree();

    target.frontMostApp().windows()[0].staticTexts()["待发货"].tapWithOptions({tapOffset:{x:0.30, y:0.82}});

    target.frontMostApp().windows()[0].staticTexts()["待收货"].tapWithOptions({tapOffset:{x:0.64, y:0.88}});

    target.frontMostApp().windows()[0].staticTexts()["已完成"].tapWithOptions({tapOffset:{x:0.34, y:0.68}});

    target.frontMostApp().windows()[0].navigationBar().buttons()["top back"].tap();
})
test("其他按钮的点击",function () {
    target.frontMostApp().windows()[0].tableViews()[0].buttons()[1].tap();
    target.delay(2);
    target.frontMostApp().windows()[0].navigationBar().buttons()["top back"].tap();
    target.frontMostApp().windows()[0].tableViews()[0].buttons()[2].tap();
    target.delay(2);
    target.frontMostApp().windows()[0].navigationBar().buttons()["top back"].tap();
    target.frontMostApp().windows()[0].tableViews()[0].buttons()[3].tap();
    target.frontMostApp().windows()[0].navigationBar().buttons()["top back"].tap();
    target.frontMostApp().windows()[0].tableViews()[0].buttons()[4].tap();
    target.frontMostApp().windows()[0].navigationBar().buttons()["top back"].tap();

})
test("待付款",function () {
    target.frontMostApp().windows()[0].tableViews()[0].buttons()[1].tap();
    target.delay(2);

    var count = target.frontMostApp().windows()[0].scrollViews()[0].tableViews()[0].groups().length/2;
    if (count == 0)
    {
        assertEquals("您还没有订单", target.frontMostApp().windows()[0].scrollViews()[0].staticTexts()[0].name);
    }
    else {


        if (count > 20) {
            count = 20;
        }

        target.frontMostApp().windows()[0].logElementTree();
        for (var i = 0; i < count - 1; i++) {
            UIALogger.logMessage("asss");
            //  assertEquals("去付款",target.frontMostApp().windows()[0].scrollViews()[0].tableViews()[0].groups()[(i+1)*2-1].buttons()[0].name());
            assertEquals(true, target.frontMostApp().windows()[0].scrollViews()[0].tableViews()[0].groups()[i * 2].staticTexts()[0].name() == "待付款" || target.frontMostApp().windows()[0].scrollViews()[0].tableViews()[0].groups()[i * 2].staticTexts()[0].name() == "付款待审核", "待付款商品第'" + i + "'个");

            //   assertNotNull(target.frontMostApp().windows()[0].tableViews()[1].groups()[(i+1)*3-1].buttons()["去付款"]);
        }
    }
})
test("待发货",function () {
    target.frontMostApp().windows()[0].staticTexts()["待发货"].tapWithOptions({tapOffset:{x:0.30, y:0.82}});
    target.delay(2);

    var count = target.frontMostApp().windows()[0].scrollViews()[0].tableViews()[0].groups().length/2;
    if (count == 0)
    {
        assertEquals("您还没有订单", target.frontMostApp().windows()[0].scrollViews()[0].staticTexts()[0].name);
    }
    else {

        if (count > 20) {
            count = 20;
        }

        for (var i = 0; i < count - 1; i++) {
            assertEquals("待发货", target.frontMostApp().windows()[0].scrollViews()[0].tableViews()[0].groups()[i * 2].staticTexts()[0].name(), "待发货商品第'" + i + "'个");
            //assertNotNull(target.frontMostApp().windows()[0].tableViews()[2].groups()[i*3].staticTexts()["待发货"]);
            //assertNull(target.frontMostApp().windows()[0].tableViews()[2].groups()[(i+1)*3-1].buttons()[0]);
        }
    }
})
test("待收货",function () {
    target.frontMostApp().windows()[0].staticTexts()["待收货"].tapWithOptions({tapOffset:{x:0.64, y:0.88}});
    target.delay(2);
    target.frontMostApp().windows()[0].logElementTree();
    var count = target.frontMostApp().windows()[0].scrollViews()[0].tableViews()[0].groups().length/2;
    if (count == 0)
    {
        assertEquals("您还没有订单", target.frontMostApp().windows()[0].scrollViews()[0].staticTexts()[0].name);
    }
    else {

        if (count > 20) {
            count = 20;
        }

        for (var i = 0; i < count - 1; i++) {
            //assertEquals("去自提"||"确认收货",target.frontMostApp().windows()[0].scrollViews()[0].tableViews()[0].groups()[(i+1)*2-1].buttons()[0].name(),"待收货商品第'"+i+"'个");
            if (i == 18) {
                UIALogger.logMessage("'" + target.frontMostApp().windows()[0].scrollViews()[0].tableViews()[0].groups()[i * 2].staticTexts()[0].name() + "'");
            }

            assertEquals(true, target.frontMostApp().windows()[0].scrollViews()[0].tableViews()[0].groups()[i * 2].staticTexts()[0].name() == "配送中" || target.frontMostApp().windows()[0].scrollViews()[0].tableViews()[0].groups()[i * 2].staticTexts()[0].name() == "待自提", "待收货商品第'" + i + "'个");
        }
    }
})
test("已完成",function () {
    target.frontMostApp().windows()[0].staticTexts()["已完成"].tapWithOptions({tapOffset:{x:0.34, y:0.68}});
    target.delay(2);


    var count = target.frontMostApp().windows()[0].scrollViews()[0].tableViews()[0].groups().length/2;
    if (count == 0)
    {
        assertEquals("您还没有订单", target.frontMostApp().windows()[0].scrollViews()[0].staticTexts()[0].name);
    }
    else {

        if (count > 20) {
            count = 20;
        }
        UIALogger.logMessage("'" + count + "'");
        for (var i = 0; i < count - 1; i++) {
            assertEquals("已完成", target.frontMostApp().windows()[0].scrollViews()[0].tableViews()[0].groups()[i * 2].staticTexts()[0].name(), "已完成商品第'" + i + "'个");
        }
    }
})

test("滚动列表",function () {
    //  target.frontMostApp().windows()[0].tableViews()[0].buttons()[0].tap();
    // target.delay(5);

    //target.frontMostApp().windows()[0].staticTexts()["待收货"].tapWithOptions({tapOffset:{x:0.27, y:0.55}});
    //target.delay(5);

    var count = target.frontMostApp().windows()[0].scrollViews()[0].tableViews()[0].cells().length;
//UIALogger.logMessage("count:'"+count+"'");
    target.frontMostApp().windows()[0].scrollViews()[0].tableViews()[0].dragInsideWithOptions({startOffset:{x:0.49, y:1.00}, endOffset:{x:0.60, y:-0.05}, duration:0.5});
    target.frontMostApp().windows()[0].scrollViews()[0].tableViews()[0].dragInsideWithOptions({startOffset:{x:0.49, y:1.00}, endOffset:{x:0.60, y:0.03}, duration:0.5});
    target.frontMostApp().windows()[0].navigationBar().buttons()["top back"].tap();

})

test("跳转订单详情",function(target,app){
    target.frontMostApp().windows()[0].tableViews()[0].buttons()[0].tap();
    target.delay(3);
    var count = target.frontMostApp().windows()[0].scrollViews()[0].tableViews()[0].cells().length;
    if(count > 0){
        target.frontMostApp().windows()[0].scrollViews()[0].tableViews()[0].cells()[0].tap();
        target.delay(1);
        assertEquals("订单详情",target.frontMostApp().windows()[0].navigationBar().staticTexts()[0].value());
        target.frontMostApp().windows()[0].navigationBar().buttons()["top back"].tap();

    }

})
test("cell中确认收货按钮点击",function(target,app){
    target.frontMostApp().windows()[0].staticTexts()["待收货"].tapWithOptions({tapOffset:{x:0.64, y:0.88}});
    target.delay(3);
    var count = target.frontMostApp().windows()[0].scrollViews()[0].tableViews()[0].groups().length/2;
    if(count > 0){
        UIALogger.logMessage("hhhhh");
        var name = true;
        for(var i=0;i<count;i++){

            if(target.frontMostApp().windows()[0].scrollViews()[0].tableViews()[0].groups()[(i+1)*2-1].buttons()[0].name() == "确认收货" && name)
            {
                target.frontMostApp().windows()[0].scrollViews()[0].tableViews()[0].groups()[(i+1)*2-1].scrollToVisible();

                name = false;
                target.frontMostApp().windows()[0].scrollViews()[0].tableViews()[0].groups()[(i+1)*2-1].buttons()["确认收货"].tap();
                target.delay(2);
                assertEquals(1,target.frontMostApp().windows()[0].buttons()[5].isVisible());
                target.frontMostApp().windows()[0].logElementTree();

                target.frontMostApp().windows()[0].buttons()[5].tapWithOptions({tapOffset:{x:0.63, y:0.22}});

                break;
            }
        }
    }

})


test("cell中自提按钮点击",function(target,app){
    target.delay(3);

    target.frontMostApp().windows()[0].staticTexts()["待收货"].tapWithOptions({tapOffset:{x:0.64, y:0.88}});
    target.delay(3);
    var count = target.frontMostApp().windows()[0].scrollViews()[0].tableViews()[0].groups().length/2;
    if(count > 0){
        UIALogger.logMessage("hhhhh");
        var name = true;
        for(var i=0;i<count;i++){

            if(target.frontMostApp().windows()[0].scrollViews()[0].tableViews()[0].groups()[(i+1)*2-1].buttons()[0].name() == "去自提" && name)
            {
                target.frontMostApp().windows()[0].scrollViews()[0].tableViews()[0].groups()[(i+1)*2-1].scrollToVisible();

                name = false;
                target.delay(2);
                target.frontMostApp().windows()[0].scrollViews()[0].tableViews()[0].groups()[(i+1)*2-1].buttons()["去自提"].tap();
                target.delay(2);
                assertEquals("网点自提",target.frontMostApp().windows()[0].navigationBar().staticTexts()[0].value());
                target.frontMostApp().windows()[0].navigationBar().buttons()["top back"].tap();
                break;
            }
        }
    }

})



test("cell中点击去付款",function(target,app){
    target.delay(3);

    target.frontMostApp().windows()[0].staticTexts()["待付款"].tapWithOptions({tapOffset:{x:0.27, y:0.55}});
    target.delay(3);
    var count = target.frontMostApp().windows()[0].scrollViews()[0].tableViews()[0].groups().length/2;
    if(count > 0){
        var name = true;
        for(var i=0;i<count;i++){

            if(target.frontMostApp().windows()[0].scrollViews()[0].tableViews()[0].groups()[(i+1)*2-1].buttons()[0].name() == "去付款" && name)
            {
                target.frontMostApp().windows()[0].scrollViews()[0].tableViews()[0].groups()[(i+1)*2-1].scrollToVisible();

                name = false;
                target.frontMostApp().windows()[0].scrollViews()[0].tableViews()[0].groups()[(i+1)*2-1].buttons()["去付款"].tap();
                target.delay(2);
                assertEquals("支付方式",target.frontMostApp().windows()[0].navigationBar().staticTexts()[0].value());
                target.frontMostApp().windows()[0].navigationBar().buttons()["top back"].tap();
                break;
            }
        }
    }

})


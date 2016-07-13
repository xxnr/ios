/**
 * Created by yangning on 16/6/28.
 */
#import "../lib/tuneup.js"

var target = UIATarget.localTarget();
var window = target.frontMostApp().windows()[0];

window.tabBar().buttons()["我的"].tap(); 

target.delay(2);
window.logElementTree();
if(window.tableViews()[0].buttons().length > 1)
{
    test("用户为县级经销商",function () {
        target.delay(2);
        window.tableViews()[0].buttons()[1].tap();
        window.logElementTree();
        target.delay(2);
        assertEquals("我的订单",window.navigationBar().staticTexts()[0].value());
        assertEquals(5,window.buttons().length);

        window.staticTexts()["待付款"].tapWithOptions({tapOffset:{x:0.27, y:0.55}});
        target.delay(2);

        window.logElementTree();

        Tab.tapWithOptions({tapOffset:{x:0.30, y:0.82}});

        window.staticTexts()["待收货"].tapWithOptions({tapOffset:{x:0.64, y:0.88}});

        window.staticTexts()["已完成"].tapWithOptions({tapOffset:{x:0.34, y:0.68}});

        window.navigationBar().buttons()["top back"].tap();
    })
}
else {
    test("列表页按钮的点击", function (target, app) {
        target.delay(2);
        window.tableViews()[0].buttons()[0].tap();
        window.logElementTree();
        target.delay(2);
        assertEquals("我的订单", window.navigationBar().staticTexts()[0].value());
        assertEquals(5, window.buttons().length);

        window.staticTexts()["待付款"].tapWithOptions({tapOffset: {x: 0.27, y: 0.55}});
        target.delay(2);

        window.logElementTree();

        window.staticTexts()["待发货"].tapWithOptions({tapOffset: {x: 0.30, y: 0.82}});

        window.staticTexts()["待收货"].tapWithOptions({tapOffset: {x: 0.64, y: 0.88}});

        window.staticTexts()["已完成"].tapWithOptions({tapOffset: {x: 0.34, y: 0.68}});

        window.navigationBar().buttons()["top back"].tap();
    })
    test("其他按钮的点击", function () {
        window.tableViews()[0].buttons()[1].tap();
        target.delay(2);
        window.navigationBar().buttons()["top back"].tap();
        window.tableViews()[0].buttons()[2].tap();
        target.delay(2);
        window.navigationBar().buttons()["top back"].tap();
        window.tableViews()[0].buttons()[3].tap();
        window.navigationBar().buttons()["top back"].tap();
        window.tableViews()[0].buttons()[4].tap();
        window.navigationBar().buttons()["top back"].tap();

    })
}
test("待付款",function () {
    if(window.tableViews()[0].buttons().length > 1)
    {
        target.delay(2);
        window.tableViews()[0].buttons()[1].tap();
        target.delay(1);
        window.staticTexts()["待付款"].tapWithOptions({tapOffset: {x: 0.27, y: 0.55}});
    }
    else
    {
        target.delay(1);
        window.tableViews()[0].buttons()[1].tap();
    }
    target.delay(2);

    var count = window.scrollViews()[0].tableViews()[0].groups().length/2;
    if (count == 0)
    {
        assertEquals("您还没有订单", window.scrollViews()[0].staticTexts()[0].name);
    }
    else {


        if (count > 20) {
            count = 20;
        }

        window.logElementTree();
        for (var i = 0; i < count - 1; i++) {
            UIALogger.logMessage("asss");
            //  assertEquals("去付款",window.scrollViews()[0].tableViews()[0].groups()[(i+1)*2-1].buttons()[0].name());
            assertEquals(true, window.scrollViews()[0].tableViews()[0].groups()[i * 2].staticTexts()[0].name() == "待付款" || window.scrollViews()[0].tableViews()[0].groups()[i * 2].staticTexts()[0].name() == "付款待审核"|| window.scrollViews()[0].tableViews()[0].groups()[i * 2].staticTexts()[0].name() == "部分付款", "待付款商品第'" + i + "'个");
        }
    }
})
test("待发货",function () {
    window.staticTexts()["待发货"].tapWithOptions({tapOffset:{x:0.30, y:0.82}});
    target.delay(2);

    var count = window.scrollViews()[0].tableViews()[0].groups().length/2;
    if (count == 0)
    {
        assertEquals("您还没有订单", window.scrollViews()[0].staticTexts()[0].name);
    }
    else {

        if (count > 20) {
            count = 20;
        }

        for (var i = 0; i < count - 1; i++) {
            assertEquals("待发货", window.scrollViews()[0].tableViews()[0].groups()[i * 2].staticTexts()[0].name(), "待发货商品第'" + i + "'个");
            //assertNotNull(window.tableViews()[2].groups()[i*3].staticTexts()["待发货"]);
            //assertNull(window.tableViews()[2].groups()[(i+1)*3-1].buttons()[0]);
        }
    }
})
test("待收货",function () {
    window.staticTexts()["待收货"].tapWithOptions({tapOffset:{x:0.64, y:0.88}});
    target.delay(2);
    window.logElementTree();
    var count = window.scrollViews()[0].tableViews()[0].groups().length/2;
    if (count == 0)
    {
        assertEquals("您还没有订单", window.scrollViews()[0].staticTexts()[0].name);
    }
    else {

        if (count > 20) {
            count = 20;
        }

        for (var i = 0; i < count - 1; i++) {
            //assertEquals("去自提"||"确认收货",window.scrollViews()[0].tableViews()[0].groups()[(i+1)*2-1].buttons()[0].name(),"待收货商品第'"+i+"'个");
            if (i == 18) {
                UIALogger.logMessage("'" + window.scrollViews()[0].tableViews()[0].groups()[i * 2].staticTexts()[0].name() + "'");
            }

            assertEquals(true, window.scrollViews()[0].tableViews()[0].groups()[i * 2].staticTexts()[0].name() == "配送中" || window.scrollViews()[0].tableViews()[0].groups()[i * 2].staticTexts()[0].name() == "待自提", "待收货商品第'" + i + "'个");
        }
    }
})
test("已完成",function () {
    window.staticTexts()["已完成"].tapWithOptions({tapOffset:{x:0.34, y:0.68}});
    target.delay(2);


    var count = window.scrollViews()[0].tableViews()[0].groups().length/2;
    if (count == 0)
    {
        assertEquals("您还没有订单", window.scrollViews()[0].staticTexts()[0].name);
    }
    else {

        if (count > 20) {
            count = 20;
        }
        UIALogger.logMessage("'" + count + "'");
        for (var i = 0; i < count - 1; i++) {
            assertEquals("已完成", window.scrollViews()[0].tableViews()[0].groups()[i * 2].staticTexts()[0].name(), "已完成商品第'" + i + "'个");
        }
    }
})

test("滚动列表",function () {
    //  window.tableViews()[0].buttons()[0].tap();
    // target.delay(5);

    //window.staticTexts()["待收货"].tapWithOptions({tapOffset:{x:0.27, y:0.55}});
    //target.delay(5);

    var count = window.scrollViews()[0].tableViews()[0].cells().length;
//UIALogger.logMessage("count:'"+count+"'");
    window.scrollViews()[0].tableViews()[0].dragInsideWithOptions({startOffset:{x:0.49, y:1.00}, endOffset:{x:0.60, y:-0.05}, duration:0.5});
    window.scrollViews()[0].tableViews()[0].dragInsideWithOptions({startOffset:{x:0.49, y:1.00}, endOffset:{x:0.60, y:0.03}, duration:0.5});
    window.navigationBar().buttons()["top back"].tap();

})

test("跳转订单详情",function(target,app){
     if(window.tableViews()[0].buttons().length > 1)
     {
     window.tableViews()[0].buttons()[1].tap();
     }
     else
     {
     window.tableViews()[0].buttons()[0].tap();
     }

    target.delay(3);
    var count = window.scrollViews()[0].tableViews()[0].cells().length;
    if(count > 0){
        window.scrollViews()[0].tableViews()[0].cells()[0].tap();
        target.delay(1);
        assertEquals("订单详情",window.navigationBar().staticTexts()[0].value());
        window.navigationBar().buttons()["top back"].tap();

    }

})
test("cell中确认收货按钮点击",function(target,app){
    window.staticTexts()["待收货"].tapWithOptions({tapOffset:{x:0.64, y:0.88}});
    target.delay(3);
    var count = window.scrollViews()[0].tableViews()[0].groups().length/2;
    if(count > 0){
        UIALogger.logMessage("hhhhh");
        var name = true;
        for(var i=0;i<count;i++){

            if(window.scrollViews()[0].tableViews()[0].groups()[(i+1)*2-1].buttons()[0].name() == "确认收货" && name)
            {
                window.scrollViews()[0].tableViews()[0].groups()[(i+1)*2-1].scrollToVisible();
                name = false;
                target.delay(1);
                    
     window.scrollViews()[0].tableViews()[0].groups()[(i+1)*2-1].logElementTree();    
     
     // window.scrollViews()[0].tableViews()[0].groups()[(i+1)*2-1].buttons()[0].tap();

                //
                // target.delay(2);
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
    target.delay(3);

    window.staticTexts()["待收货"].tapWithOptions({tapOffset:{x:0.64, y:0.88}});
    target.delay(3);
    var count = window.scrollViews()[0].tableViews()[0].groups().length/2;
    if(count > 0){
        UIALogger.logMessage("hhhhh");
        var name = true;
        for(var i=0;i<count;i++){

            if(window.scrollViews()[0].tableViews()[0].groups()[(i+1)*2-1].buttons()[0].name() == "去自提" && name)
            {
                window.scrollViews()[0].tableViews()[0].groups()[(i+1)*2-1].scrollToVisible();

                name = false;
                target.delay(2);
                // window.scrollViews()[0].tableViews()[0].groups()[(i+1)*2-1].buttons()["去自提"].tap();
                // target.delay(2);
                // assertEquals("网点自提",window.navigationBar().staticTexts()[0].value());
                // window.navigationBar().buttons()["top back"].tap();
                break;
            }
        }
    }

})



test("cell中点击去付款",function(target,app){
    target.delay(3);

    window.staticTexts()["待付款"].tapWithOptions({tapOffset:{x:0.27, y:0.55}});
    target.delay(3);
    var count = window.scrollViews()[0].tableViews()[0].groups().length/2;
    if(count > 0){
        var name = true;
        for(var i=0;i<count;i++){

            if(window.scrollViews()[0].tableViews()[0].groups()[(i+1)*2-1].buttons()[0].name() == "去付款" && name)
            {
                window.scrollViews()[0].tableViews()[0].groups()[(i+1)*2-1].scrollToVisible();

                name = false;
                // window.scrollViews()[0].tableViews()[0].groups()[(i+1)*2-1].buttons()["去付款"].tap();
                // target.delay(2);
                // assertEquals("支付方式",window.navigationBar().staticTexts()[0].value());
                // window.navigationBar().buttons()["top back"].tap();
                break;
            }
        }
    }

})


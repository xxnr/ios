/**
 * Created by XXNR on 16/7/12.
 */
#import "../lib/tuneup.js"
#import "xxnrClass.js"
var target = UIATarget.localTarget();
var window = target.frontMostApp().windows()[0];

target.setDeviceOrientation(UIA_DEVICE_ORIENTATION_PORTRAIT);
xxnrClass.home(window).mineTab().tap();
test("我的网点测试",function(target,app){
xxnrClass.mine(window).rscOrderBtn().tap();
    window.logElementTree();
    test("全部测试",function(target,app){
        window.logElementTree();
        test("待付款测试",function(target,app){
            xxnrClass.rscOrders(window).waitPayTab().tap();
            assertTrue("待付款",xxnrClass.rscOrders(window).orderStatus());
            
        });

            test("待审核测试",function(target,app){

                xxnrClass.rscOrders(window).waitVerifyTab().tap();
                assertTrue("付款待审核",xxnrClass.rscOrders(window).orderStatus());


                xxnrClass.rscOrders(window).identifyPayBtn().tap();
                target.delay(2);

                window.logElementTree();


                assertTrue("审核付款",window.staticTexts()[0].value);

                xxnrClass.rscOrders(window).eposeBtn().tap();
            target.delay(1);

            xxnrClass.rscOrders(window).cashBtn().tap();
            target.delay(1);

            xxnrClass.rscOrders(window).admireBtn().tap();

            assertTrue("审核成功",window.staticTexts()[0].value);


        });
        test("待配送测试",function(target,app){
            xxnrClass.rscOrders(window).startDeliverBtn().tap();
            target.delay(1);

            window.logElementTree();

            assertTrue("开始配送",window.views()[0].label()[0].value);

            xxnrClass.rscOrders(window).cellBnt().tap();
            assertTrue("确定(1)",window.views()[0].buttons()[1].value);
            target.delay(1);

            xxnrClass.rscOrders(window).cellBnt().tap();
            assertTrue("确定",window.views()[0].buttons()[1].value);
            target.delay(1);

            xxnrClass.rscOrders(window).cellBnt().tap();
            target.delay(1);

            xxnrClass.rscOrders(window).admireBtn1().tap();
            assertTrue("配送成功",window.views()[0].staticTexts()[0].value);

        });
        test("待自提测试",function(target,app){
            xxnrClass.rscOrders(window).userTakeBtn().tap();
            assertTrue("客户自提-选择商品",window.views()[0].staticTexts()[0].value);
            window.logElementTree();

            xxnrClass.rscOrders(window).cellBnt().tap();
            assertTrue("下一步(1)",window.views()[0].buttons()[1].value);
            target.delay(1);

            xxnrClass.rscOrders(window).cellBnt().tap();
            assertTrue("下一步",window.views()[0].buttons()[1].value);
            target.delay(1);

            xxnrClass.rscOrders(window).cellBnt().tap();
            xxnrClass.rscOrders(window).nextStepBtn1().tap();
            target.delay(1);


            var deliverNumber ="123456";
            xxnrClass.rscOrders(window).inputTakeNumber().tap();
            xxnrClass.rscOrders(window).inputTakeNumber().setValue(deliverNumber);
            window.views()[0].buttons()["确定"].tap;
            var warning = window.staticTexts()[0].value();
            assertEquals("请输入自提码",warning);
            target.delay(2);


            var deliverNumber ="1234567";
            window.textFields()[0].textFields()[0].tap();
            window.textFields()[0].textFields()[0].setValue(deliverNumber);
            window.views()[0].buttons()["确定"].tap;
            var warning = window.staticTexts()[0].value();
            assertEquals("自提码错误，请重新输入",warning);
            for(var i = 0; i<2; i++){
                window.views()[0].buttons()["确定"].tap;
            }
            var warning = window.staticTexts()[0].value();
            assertEquals("您输入错误次数较多，请一分钟后再试",warning);

            target.delay(2);


            var deliverNumber ="正确的自提码";
            window.textFields()[0].textFields()[0].tap();
            window.textFields()[0].textFields()[0].setValue(deliverNumber);
            window.views()[0].buttons()["确定"].tap;
            assertTrue("自提成功",window.views()[0].staticTexts()[0].value);
        });
        test("订单详情页测试",function(target,app){
            window.scrollViews()[0].tableViews()[0].cells()[0].tap();
            assertEquals("订单详情",window.navigationBar().name());
            // 待审核按钮点击
            window.tableViews()[0].buttons()["审核付款"].tap();
            assertEquals("配送中",window.tableViews()[0].staticTexts()[2].name);
            target.delay(2);

            window.navigationBar().buttons()["top back"].tap();

            window.scrollViews()[0].tableViews()[0].cells()[0].tap();
            window.tableViews()[0].buttons()["开始配送"].tap();
            assertEquals("配送中",window.tableViews()[0].staticTexts()[2].name);
            target.delay(2);

        });


    });
});


function login() {
    window.tableViews()[0].images()["icon_bgView"].buttons()["登录"].tap();
    var phone = "18211101020";
    var password = "123456";
    window.images()[0].textFields()[0].textFields()[0].tap();
    window.images()[0].textFields()[0].setValue(phone);

    window.images()[0].logElementTree();
    window.images()[0].secureTextFields()[0].secureTextFields()[0].tap();
    window.images()[0].secureTextFields()[0].secureTextFields()[0].setValue(password);
    window.images()[0].buttons()["确认登录"].tap();

}



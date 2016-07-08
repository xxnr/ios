/**
 * Created by yangning on 16/7/7.
 */
#import "../lib/tuneup.js"

var target = UIATarget.localTarget();

test("非分阶段 选择化肥--线下支付",function () {
     target.delay(1);
     target.frontMostApp().windows()[0].collectionViews()[0].buttons()[5].tap();
     target.frontMostApp().windows()[0].tableViews()[0].tapWithOptions({tapOffset:{x:0.79, y:0.88}});
     target.frontMostApp().windows()[0].buttons()["加入购物车"].tap();
     target.frontMostApp().windows()[0].buttons()["确定"].tap();
     target.delay(1);
     target.frontMostApp().windows()[0].navigationBar().buttons()["top back"].tap();
     target.frontMostApp().windows()[0].tableViews()[0].cells()[3].scrollToVisible();
     target.frontMostApp().windows()[0].tableViews()[0].cells()["中化化肥 - 螯合肥 - 一口价且只有一个sku - 没有描述"].tap();
     target.frontMostApp().windows()[0].buttons()["加入购物车"].tap();
     target.frontMostApp().windows()[0].buttons()["确定"].tap();
     target.delay(1);
     target.frontMostApp().windows()[0].navigationBar().buttons()["icon shopcar white"].tap();
     target.delay(2);
     target.frontMostApp().windows()[0].tableViews()[0].groups()[0].buttons()["shopCar circle"].tap();
     target.frontMostApp().windows()[0].tableViews()[0].cells()[1].scrollToVisible();
     target.frontMostApp().windows()[0].tableViews()[0].groups()[2].buttons()["shopCar circle"].tap();
     target.delay(2);     
     target.frontMostApp().windows()[0].buttons()["去结算(2)"].tap();
     target.delay(1);
     target.frontMostApp().windows()[0].tableViews()[0].buttons()["配送到户"].tap();
     target.frontMostApp().windows()[0].buttons()["提交订单(2)"].tap();
     target.frontMostApp().windows()[0].buttons()[6].tap();
     target.frontMostApp().windows()[0].buttons()["去支付"].tap();
     target.delay(1);
     })
target.frontMostApp().windows()[0].navigationBar().buttons()["top back"].tap();
 target.frontMostApp().windows()[0].tabBar().buttons()["我的"].tap();
test("后台添加服务站",function () {
     target.delay(20);
     })
test("线下支付--用户订单",function () {
     target.delay(1);
     target.frontMostApp().windows()[0].tableViews()[0].buttons()[1].tap();
     target.delay(1);
     assertEquals("付款待审核",target.frontMostApp().windows()[0].scrollViews()[0].tableViews()[0].groups()[0].staticTexts()[0].name());
     })
target.frontMostApp().windows()[0].navigationBar().buttons()["top back"].tap();
test("线下支付--县级订单",function () {
     target.delay(1);
     target.frontMostApp().windows()[0].tableViews()[0].buttons()[0].tap();
     target.delay(1);
     assertEquals("付款待审核",target.frontMostApp().windows()[0].scrollViews()[0].tableViews()[0].groups()[0].staticTexts()[0].name());
     })
target.frontMostApp().windows()[0].navigationBar().buttons()["top back"].tap();
test("分次支付部分金额--用户订单",function () {
     target.delay(1);
     target.frontMostApp().windows()[0].tableViews()[0].buttons()[1].tap();
     target.delay(1);
     target.frontMostApp().windows()[0].scrollViews()[0].tableViews()[0].groups()[1].buttons()["修改付款方式"].tap();
     target.delay(1);
     target.frontMostApp().windows()[0].buttons()["分次支付"].tap();
     target.frontMostApp().windows()[0].buttons()["去支付"].tap();
     target.frontMostApp().windows()[0].scrollViews()[0].webViews()[0].links()["返回"].tap();
     target.frontMostApp().windows()[0].scrollViews()[0].webViews()[0].links()["是"].tap();
     target.delay(1);
     })
target.frontMostApp().windows()[0].navigationBar().buttons()["top back"].tap();
test("后台改变分次支付为成功支付",function () {
     target.delay(10);
     })
test("分次支付部分金额--用户订单(成功)",function () {
     target.delay(1);
     target.frontMostApp().windows()[0].staticTexts()["全部"].tapWithOptions({tapOffset:{x:0.69, y:0.10}});
     target.delay(1);
     assertEquals("部分付款",target.frontMostApp().windows()[0].scrollViews()[0].tableViews()[0].groups()[0].staticTexts()[0].name());
     })
target.frontMostApp().windows()[0].navigationBar().buttons()["top back"].tap();
test("分次支付部分金额--县级订单",function () {
     target.delay(1);
     target.frontMostApp().windows()[0].tableViews()[0].buttons()[0].tap();
     target.delay(1);
     assertEquals("待付款",target.frontMostApp().windows()[0].scrollViews()[0].tableViews()[0].groups()[0].staticTexts()[0].name());
     })        
target.frontMostApp().windows()[0].navigationBar().buttons()["top back"].tap();
test("线下支付剩余款--用户订单",function () {
     target.delay(1);
     target.frontMostApp().windows()[0].tableViews()[0].buttons()[1].tap();
     target.delay(1);
     target.frontMostApp().windows()[0].scrollViews()[0].tableViews()[0].cells()[0].tap();
     target.delay(1);
     target.frontMostApp().windows()[0].buttons()["去付款"].tap();
     target.frontMostApp().windows()[0].buttons()[6].tap();
     target.frontMostApp().windows()[0].buttons()["去支付"].tap();
     target.delay(1);
     target.frontMostApp().windows()[0].navigationBar().buttons()["top back"].tap();
     target.delay(1);
     target.frontMostApp().windows()[0].staticTexts()["全部"].tapWithOptions({tapOffset:{x:0.49, y:0.78}});
     target.delay(1);
    
     assertEquals("付款待审核",target.frontMostApp().windows()[0].scrollViews()[0].tableViews()[0].groups()[0].staticTexts()[0].name());
     })
target.frontMostApp().windows()[0].navigationBar().buttons()["top back"].tap();
test("线下支付剩余款--县级订单",function () {
     target.delay(1);
     target.frontMostApp().windows()[0].tableViews()[0].buttons()[0].tap();
     target.delay(1);
     assertEquals("付款待审核",target.frontMostApp().windows()[0].scrollViews()[0].tableViews()[0].groups()[0].staticTexts()[0].name());
     target.frontMostApp().windows()[0].scrollViews()[0].tableViews()[0].groups()[1].buttons()["审核付款"].tap();
     target.frontMostApp().windows()[0].buttons()["确定"].tap();
     target.frontMostApp().windows()[0].buttons()["全部"].tap();
     target.delay(1);
     assertEquals("待厂家发货",target.frontMostApp().windows()[0].scrollViews()[0].tableViews()[0].groups()[0].staticTexts()[0].name());
     })
test("后台操作一个化肥发货",function () {
     target.delay(15);
     })
test("一个化肥发货--县级订单",function () {
     target.delay(1);
     target.frontMostApp().windows()[0].buttons()["全部"].tap();
     target.delay(1);
     assertEquals("待配送",target.frontMostApp().windows()[0].scrollViews()[0].tableViews()[0].groups()[0].staticTexts()[0].name());
     })
target.frontMostApp().windows()[0].navigationBar().buttons()["top back"].tap();
test("一个化肥发货--用户订单",function () {
     target.delay(1);
     target.frontMostApp().windows()[0].tableViews()[0].buttons()[1].tap();
     target.delay(1);
     assertEquals("待发货",target.frontMostApp().windows()[0].scrollViews()[0].tableViews()[0].groups()[0].staticTexts()[0].name());
     })
target.frontMostApp().windows()[0].navigationBar().buttons()["top back"].tap();
test("开始配送--县级订单",function () {
     target.delay(1);
     target.frontMostApp().windows()[0].tableViews()[0].buttons()[0].tap();
     target.delay(1);
     target.frontMostApp().windows()[0].scrollViews()[0].tableViews()[0].groups()[1].buttons()["开始配送"].tap();
     target.frontMostApp().windows()[0].tableViews()[0].cells()[0].tap();
     target.frontMostApp().windows()[0].buttons()["确定(1)"].tap();
     target.frontMostApp().windows()[0].buttons()["全部"].tap();
     target.delay(1);
     assertEquals("配送中",target.frontMostApp().windows()[0].scrollViews()[0].tableViews()[0].groups()[0].staticTexts()[0].name());
     })
target.frontMostApp().windows()[0].navigationBar().buttons()["top back"].tap();
test("确认收货一个商品,另一个商品未发货--用户订单",function () {
     target.delay(1);
     target.frontMostApp().windows()[0].tableViews()[0].buttons()[1].tap();
     target.delay(1);
     assertEquals("配送中",target.frontMostApp().windows()[0].scrollViews()[0].tableViews()[0].groups()[0].staticTexts()[0].name());
     target.frontMostApp().windows()[0].scrollViews()[0].tableViews()[0].groups()[1].buttons()["确认收货"].tap();
     target.delay(2);
     target.frontMostApp().windows()[0].logElementTree();
     
     target.frontMostApp().windows()[0].buttons()[5].tapWithOptions({tapOffset:{x:0.08, y:0.37}});
     target.frontMostApp().windows()[0].buttons()[5].tapWithOptions({tapOffset:{x:0.49, y:0.96}});
     target.delay(2);

    target.frontMostApp().windows()[0].staticTexts()["全部"].tapWithOptions({tapOffset:{x:0.53, y:0.28}});
     target.delay(1);
     assertEquals("配送中",target.frontMostApp().windows()[0].scrollViews()[0].tableViews()[0].groups()[0].staticTexts()[0].name());
     })
target.frontMostApp().windows()[0].navigationBar().buttons()["top back"].tap();
test("确认收货一个商品,另一个商品未发货--县级订单",function () {
     target.delay(1);
     target.frontMostApp().windows()[0].tableViews()[0].buttons()[0].tap();
     target.delay(1);
     assertEquals("配送中",target.frontMostApp().windows()[0].scrollViews()[0].tableViews()[0].groups()[0].staticTexts()[0].name());
     })

test("后台操作另一化肥发货",function () {
     target.delay(15);
     })
test("配送另一个化肥--县级订单",function () {
     target.frontMostApp().windows()[0].buttons()["全部"].tap();
     target.delay(1);
     assertEquals("配送中",target.frontMostApp().windows()[0].scrollViews()[0].tableViews()[0].groups()[0].staticTexts()[0].name());
     target.frontMostApp().windows()[0].scrollViews()[0].tableViews()[0].groups()[1].buttons()["开始配送"].tap();
     target.frontMostApp().windows()[0].tableViews()[0].tapWithOptions({tapOffset:{x:0.49, y:0.14}});
     target.frontMostApp().windows()[0].buttons()["确定(1)"].tap();
     target.delay(1);
     assertEquals("配送中",target.frontMostApp().windows()[0].scrollViews()[0].tableViews()[0].groups()[0].staticTexts()[0].name());
     })
target.frontMostApp().windows()[0].navigationBar().buttons()["top back"].tap();
test("确认收货--用户订单(已完成)",function () {
     target.delay(1);
     target.frontMostApp().windows()[0].tableViews()[0].buttons()[1].tap();
     target.delay(1);
     assertEquals("配送中",target.frontMostApp().windows()[0].scrollViews()[0].tableViews()[0].groups()[0].staticTexts()[0].name());
     target.frontMostApp().windows()[0].scrollViews()[0].tableViews()[0].groups()[1].buttons()["确认收货"].tap();
     target.delay(1);
     target.frontMostApp().windows()[0].buttons()[5].tapWithOptions({tapOffset:{x:0.08, y:0.37}});
     target.frontMostApp().windows()[0].buttons()[5].tapWithOptions({tapOffset:{x:0.49, y:0.96}});
     target.delay(2);
     target.frontMostApp().windows()[0].staticTexts()["全部"].tapWithOptions({tapOffset:{x:0.53, y:0.28}});
     target.delay(1);
     assertEquals("已完成",target.frontMostApp().windows()[0].scrollViews()[0].tableViews()[0].groups()[0].staticTexts()[0].name());
     })
target.frontMostApp().windows()[0].navigationBar().buttons()["top back"].tap();
test("已完成--县级订单",function () {
     target.delay(1);
     target.frontMostApp().windows()[0].tableViews()[0].buttons()[0].tap();
     target.delay(1);
     assertEquals("已完成",target.frontMostApp().windows()[0].scrollViews()[0].tableViews()[0].groups()[0].staticTexts()[0].name());
     })
target.frontMostApp().windows()[0].navigationBar().buttons()["top back"].tap();

/**
 * Created by yangning on 16/7/5.
 */
#import "../lib/tuneup.js"

var target = UIATarget.localTarget();
target.frontMostApp().windows()[0].tabBar().buttons()["我的"].tap();

test("三个汽车订单",function () {
    target.delay(1);
    target.frontMostApp().windows()[0].collectionViews()[0].buttons()[6].tap();
    target.frontMostApp().windows()[0].tableViews()[0].cells()["江淮汽车 - 第二代瑞风S3 - 2015款"].tap();
    target.frontMostApp().windows()[0].buttons()["加入购物车"].tap();
    target.frontMostApp().windows()[0].collectionViews()[0].cells()["2.0T 自动（6DCT）"].tap();
    target.frontMostApp().windows()[0].collectionViews()[0].cells()["豪华智能型"].tap();
    target.frontMostApp().windows()[0].collectionViews()[0].cells()["拉菲红"].tap();
    target.frontMostApp().windows()[0].buttons()["确定"].tap();
    target.delay(1);

    target.frontMostApp().windows()[0].navigationBar().buttons()["top back"].tap();
    target.frontMostApp().windows()[0].tableViews()[0].cells()["江淮 - 瑞风S5 - 没有市场价没有描述没有商品详情"].staticTexts()["￥240000.1"].tapWithOptions({tapOffset:{x:0.74, y:0.21}});
    target.frontMostApp().windows()[0].buttons()["加入购物车"].tap();
    target.frontMostApp().windows()[0].collectionViews()[0].cells()["豪华智能型"].tap();
    target.frontMostApp().windows()[0].collectionViews()[0].cells()["时尚白"].tap();
    target.frontMostApp().windows()[0].buttons()["确定"].tap();
    target.delay(1);
    target.frontMostApp().windows()[0].navigationBar().buttons()["top back"].tap();
    target.delay(1);
    target.frontMostApp().windows()[0].tableViews()[0].cells()["江淮-瑞风S2-市场价为0"].scrollToVisible();
    target.frontMostApp().windows()[0].tableViews()[0].cells()["奇瑞汽车 - 艾瑞泽M7"].tap();
    target.frontMostApp().windows()[0].buttons()["加入购物车"].tap();
    target.frontMostApp().windows()[0].collectionViews()[0].cells()["1.8L 手动（MT）"].tap();
    target.frontMostApp().windows()[0].collectionViews()[0].cells()["宽适版"].tap();
    target.frontMostApp().windows()[0].collectionViews()[0].cells()["象牙白"].tap();
    target.frontMostApp().windows()[0].buttons()["确定"].tap();
    target.delay(1);
    target.frontMostApp().windows()[0].navigationBar().buttons()["icon shopcar white"].tap();
    target.frontMostApp().windows()[0].logElementTree();

    target.delay(2);
    target.frontMostApp().windows()[0].tableViews()[0].groups()[0].buttons()["shopCar circle"].tap();
    target.frontMostApp().windows()[0].tableViews()[0].cells()[1].scrollToVisible();
    target.frontMostApp().windows()[0].tableViews()[0].groups()[2].buttons()["shopCar circle"].tap();
    target.delay(2);

    target.frontMostApp().windows()[0].buttons()["去结算(3)"].tap();

//target.frontMostApp().windows()[0].buttons()[0].tap();
    target.delay(1);

    target.frontMostApp().windows()[0].tableViews()[0].buttons()[1].tap();
    target.frontMostApp().windows()[0].tableViews()[1].cells()["Zhhdj"].tap();
    target.frontMostApp().windows()[0].buttons()["确定"].tap();
    target.frontMostApp().windows()[0].buttons()["提交订单(3)"].tap();
    target.delay(1);
    target.frontMostApp().windows()[0].navigationBar().buttons()["top back"].tap();
})

target.frontMostApp().windows()[0].tabBar().buttons()["我的"].tap();
var carry1;
var carry2;
test("未支付订单--用户订单",function () {
    target.delay(1);
    target.frontMostApp().windows()[0].tableViews()[0].buttons()[1].tap();
    target.delay(1);
    target.frontMostApp().windows()[0].logElementTree();
    UIALogger.logMessage("'"+target.frontMostApp().windows()[0].scrollViews()[0].tableViews()[0].groups()[0].staticTexts()[0].name()+"'");
    assertEquals("待付款",target.frontMostApp().windows()[0].scrollViews()[0].tableViews()[0].groups()[0].staticTexts()[0].name());
    target.frontMostApp().windows()[0].navigationBar().buttons()["top back"].tap();

})
test("未支付订单--县级订单",function () {
    target.delay(1);
    target.frontMostApp().windows()[0].tableViews()[0].buttons()[0].tap();

    target.frontMostApp().windows()[0].scrollViews()[0].tableViews()[0].logElementTree();

    assertEquals("待付款",target.frontMostApp().windows()[0].scrollViews()[0].tableViews()[0].groups()[0].staticTexts()[0].name());
    target.frontMostApp().windows()[0].navigationBar().buttons()["top back"].tap();
})
test("用户支付部分定金--用户订单",function () {
    target.delay(1);
    target.frontMostApp().windows()[0].tableViews()[0].buttons()[1].tap();
    target.delay(1);
    target.frontMostApp().windows()[0].scrollViews()[0].tableViews()[0].cells()[0].tap();
    target.delay(1);
    target.frontMostApp().windows()[0].buttons()["去付款"].tap();
    target.frontMostApp().windows()[0].buttons()["分次支付"].tap();
    target.frontMostApp().windows()[0].buttons()["去支付"].tap();
    target.delay(1);
    target.frontMostApp().windows()[0].scrollViews()[0].webViews()[0].links()["返回"].tap();
    target.frontMostApp().windows()[0].scrollViews()[0].webViews()[0].links()["是"].tap();

    target.delay(1);
    target.frontMostApp().windows()[0].navigationBar().buttons()["top back"].tap();
    target.frontMostApp().windows()[0].navigationBar().buttons()["top back"].tap();
    target.frontMostApp().windows()[0].staticTexts()["全部"].tapWithOptions({tapOffset:{x:0.49, y:0.78}});
    target.delay(1);
    assertEquals("部分付款",target.frontMostApp().windows()[0].scrollViews()[0].tableViews()[0].groups()[0].staticTexts()[0].name());
})
target.frontMostApp().windows()[0].navigationBar().buttons()["top back"].tap();
test("用户支付部分定金--县级订单",function () {
    target.delay(1);
    target.frontMostApp().windows()[0].tableViews()[0].buttons()[0].tap();
    target.delay(1);
    assertEquals("待付款",target.frontMostApp().windows()[0].scrollViews()[0].tableViews()[0].groups()[0].staticTexts()[0].name());
})
target.frontMostApp().windows()[0].navigationBar().buttons()["top back"].tap();
test("用户线下支付剩余定金--用户订单",function () {
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
    target.frontMostApp().windows()[0].navigationBar().buttons()["top back"].tap();
})
test("用户线下支付剩余定金--县级订单",function () {
    target.delay(1);
    target.frontMostApp().windows()[0].tableViews()[0].buttons()[0].tap();
    target.delay(1);
    target.frontMostApp().windows()[0].logElementTree();

    assertEquals("付款待审核",target.frontMostApp().windows()[0].scrollViews()[0].tableViews()[0].groups()[0].staticTexts()[0].name());
    target.frontMostApp().windows()[0].scrollViews()[0].tableViews()[0].groups()[1].buttons()["审核付款"].tap();
    target.frontMostApp().windows()[0].buttons()["确定"].tap();
    target.delay(1);

    target.frontMostApp().windows()[0].buttons()["全部"].tap();

    assertEquals("待付款",target.frontMostApp().windows()[0].scrollViews()[0].tableViews()[0].groups()[0].staticTexts()[0].name());
})
target.frontMostApp().windows()[0].navigationBar().buttons()["top back"].tap();
test("后台操作--一个汽车商品发货至服务站",function () {
    target.delay(10);
})
test("用户线下支付剩余尾款--用户订单",function () {
    target.delay(1);
    target.frontMostApp().windows()[0].tableViews()[0].buttons()[1].tap();
    target.delay(1);
    assertEquals("部分付款",target.frontMostApp().windows()[0].scrollViews()[0].tableViews()[0].groups()[0].staticTexts()[0].name());
    target.frontMostApp().windows()[0].scrollViews()[0].tableViews()[0].cells()[0].tap();
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
test("用户线下支付剩余尾款--县级订单",function () {
    target.delay(2);
    target.frontMostApp().windows()[0].tableViews()[0].buttons()[0].tap();
    target.delay(1);

    assertEquals("付款待审核",target.frontMostApp().windows()[0].scrollViews()[0].tableViews()[0].groups()[0].staticTexts()[0].name());
    target.frontMostApp().windows()[0].scrollViews()[0].tableViews()[0].groups()["网点自提"].buttons()["审核付款"].tap();
    target.frontMostApp().windows()[0].buttons()["确定"].tap();
    target.delay(1);

    target.frontMostApp().windows()[0].buttons()["全部"].tap();
    target.delay(1);
    assertEquals("待自提",target.frontMostApp().windows()[0].scrollViews()[0].tableViews()[0].groups()[0].staticTexts()[0].name());
})
target.frontMostApp().windows()[0].navigationBar().buttons()["top back"].tap();

test("用户网点自提第一个商品--用户订单",function () {
    target.delay(1);
    target.frontMostApp().windows()[0].tableViews()[0].buttons()[1].tap();
    target.delay(1);
    target.frontMostApp().windows()[0].scrollViews()[0].tableViews()[0].cells()[0].tap();
    target.delay(1);
    target.frontMostApp().windows()[0].buttons()["去自提"].tap();
    target.delay(2);

    assertEquals("网点自提",target.frontMostApp().windows()[0].navigationBar().staticTexts()[0].value());

    carry1 = target.frontMostApp().windows()[0].tableViews()[0].staticTexts()[1].value();
    UIALogger.logMessage("'"+target.frontMostApp().windows()[0].staticTexts()[1].value()+"'");
    target.frontMostApp().windows()[0].logElementTree();

    target.frontMostApp().windows()[0].navigationBar().buttons()["top back"].tap();
    target.frontMostApp().windows()[0].navigationBar().buttons()["top back"].tap();
    target.frontMostApp().windows()[0].navigationBar().buttons()["top back"].tap();
})
test("用户网点自提第一个商品--县级订单",function () {
    target.delay(1);
    target.frontMostApp().windows()[0].tableViews()[0].buttons()[0].tap();
    target.frontMostApp().windows()[0].scrollViews()[0].tableViews()[0].groups()[1].buttons()["客户自提"].tap();

    target.frontMostApp().windows()[0].tableViews()[0].cells()[0].staticTexts()[2].tap();
    target.frontMostApp().windows()[0].buttons()[6].tap();


    target.frontMostApp().windows()[0].textFields()[0].textFields()[0].tap();
    target.frontMostApp().windows()[0].textFields()[0].textFields()[0].setValue(carry1);
    target.frontMostApp().windows()[1].toolbar().buttons()["完成"].tap();

    target.frontMostApp().windows()[0].buttons()["确定"].tap();
    target.delay(1);
    assertEquals("待自提",target.frontMostApp().windows()[0].scrollViews()[0].tableViews()[0].groups()[0].staticTexts()[0].name());
    target.frontMostApp().windows()[0].navigationBar().buttons()["top back"].tap();
})
test("第一个商品自提成功,二三商品未发货",function () {
    target.delay(1);
    target.frontMostApp().windows()[0].tableViews()[0].buttons()[1].tap();
    assertEquals("待自提",target.frontMostApp().windows()[0].scrollViews()[0].tableViews()[0].groups()[0].staticTexts()[0].name());
})
test("后台操作二三商品发货",function () {
    target.delay(10);
})
test("去自提二三商品--用户订单",function () {
    target.delay(1);
    target.frontMostApp().windows()[0].scrollViews()[0].tableViews()[0].cells()[0].tap();
    target.delay(1);
    target.frontMostApp().windows()[0].buttons()["去自提"].tap();
    target.delay(1);
    assertEquals("网点自提",target.frontMostApp().windows()[0].navigationBar().staticTexts()[0].value());
    carry2 = target.frontMostApp().windows()[0].tableViews()[0].staticTexts()[1].value();
    target.frontMostApp().windows()[0].navigationBar().buttons()["top back"].tap();
    target.frontMostApp().windows()[0].navigationBar().buttons()["top back"].tap();
    target.frontMostApp().windows()[0].navigationBar().buttons()["top back"].tap();
})
test("去自提二三商品(已完成)--县级订单",function () {
    target.delay(1);
    target.frontMostApp().windows()[0].tableViews()[0].buttons()[0].tap();
    target.delay(1);
    assertEquals("待自提",target.frontMostApp().windows()[0].scrollViews()[0].tableViews()[0].groups()[0].staticTexts()[0].name());
    target.frontMostApp().windows()[0].scrollViews()[0].tableViews()[0].groups()["网点自提"].buttons()["客户自提"].tap();
    target.frontMostApp().windows()[0].tableViews()[0].cells()[1].tap();
    target.delay(1);
    target.frontMostApp().windows()[0].tableViews()[0].cells()[2].tap();
    target.frontMostApp().windows()[0].logElementTree();
    target.frontMostApp().windows()[0].buttons()[6].tap();
    target.frontMostApp().windows()[0].textFields()[0].textFields()[0].tap();
    target.frontMostApp().windows()[0].textFields()[0].textFields()[0].setValue(carry2);
    target.frontMostApp().windows()[1].toolbar().buttons()["完成"].tap();

    target.frontMostApp().windows()[0].buttons()["确定"].tap();
    target.delay(1);
    target.frontMostApp().windows()[0].buttons()["全部"].tap();
    assertEquals("已完成",target.frontMostApp().windows()[0].scrollViews()[0].tableViews()[0].groups()[0].staticTexts()[0].name());
    target.frontMostApp().windows()[0].navigationBar().buttons()["top back"].tap();
})
test("自提完成",function () {
    target.delay(1);
    target.frontMostApp().windows()[0].tableViews()[0].buttons()[1].tap();
    assertEquals("已完成",target.frontMostApp().windows()[0].scrollViews()[0].tableViews()[0].groups()[0].staticTexts()[0].name());
})


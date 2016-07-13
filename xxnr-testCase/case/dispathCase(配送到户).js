/**
 * Created by yangning on 16/7/7.
 */
#import "../lib/tuneup.js"
#import "baseClass.js"
var target = UIATarget.localTarget();
var window = target.frontMostApp().windows()[0];

var isHoldPay = false;

Aa();

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

function Aa() {
     test("非分阶段 选择化肥--线下支付", function () {
          target.delay(1);
          window.collectionViews()[0].buttons()[5].tap();
          window.tableViews()[0].tapWithOptions({tapOffset: {x: 0.79, y: 0.88}});
          window.buttons()["加入购物车"].tap();
          window.buttons()["确定"].tap();
          target.delay(1);
          window.navigationBar().buttons()["top back"].tap();
          window.tableViews()[0].cells()[3].scrollToVisible();
          window.tableViews()[0].cells()["中化化肥 - 螯合肥 - 一口价且只有一个sku - 没有描述"].tap();
          window.buttons()["加入购物车"].tap();
          window.buttons()["确定"].tap();
          target.delay(1);
          window.navigationBar().buttons()["icon shopcar white"].tap();
          target.delay(2);
          window.tableViews()[0].groups()[0].buttons()["shopCar circle"].tap();
          window.tableViews()[0].cells()[1].scrollToVisible();
          window.tableViews()[0].groups()[2].buttons()["shopCar circle"].tap();
          target.delay(2);
          window.buttons()["去结算(2)"].tap();
          target.delay(1);
          window.tableViews()[0].buttons()["配送到户"].tap();
          window.buttons()["提交订单(2)"].tap();
          window.buttons()[6].tap();
          window.buttons()["去支付"].tap();
          target.delay(1);
     })
     window.navigationBar().buttons()["top back"].tap();
     Ab();
}
function Ab() {
     
     window.tabBar().buttons()["我的"].tap();
     test("后台添加服务站",function () {
          target.delay(20);
     })
     test("线下支付--用户订单",function () {
          target.delay(1);
          window.tableViews()[0].buttons()[1].tap();
          drop(Ab);
          target.delay(1);
          assertEquals("付款待审核",window.scrollViews()[0].tableViews()[0].groups()[0].staticTexts()[0].name());

          var orderStr = window.scrollViews()[0].tableViews()[0].groups()[0].staticTexts()[1].name();
          var orderId = orderStr.substr(5,orderStr.length - 5);
          window.staticTexts()["待付款"].tapWithOptions({tapOffset: {x: 0.27, y: 0.55}});
          judge(orderId,"待付款");

     })
     window.navigationBar().buttons()["top back"].tap();
     test("线下支付--县级订单",function () {
          target.delay(1);
          window.tableViews()[0].buttons()[0].tap();
          drop(Ab);
          target.delay(1);
          assertEquals("付款待审核",window.scrollViews()[0].tableViews()[0].groups()[0].staticTexts()[0].name());

          var orderStr = window.scrollViews()[0].tableViews()[0].groups()[0].staticTexts()[1].name();
          var orderId = orderStr.substr(5,orderStr.length - 5);
          target.frontMostApp().windows()[0].buttons()["待审核"].tap();
          judge(orderId,"待审核");
     })
     window.navigationBar().buttons()["top back"].tap();
     test("分次支付部分金额--用户订单",function () {
          target.delay(1);
          window.tableViews()[0].buttons()[1].tap();
          target.delay(1);
          window.scrollViews()[0].tableViews()[0].groups()[1].buttons()["修改付款方式"].tap();
          drop(Ab);
          target.delay(1);
          window.buttons()["分次支付"].tap();
          window.buttons()["去支付"].tap();
          drop(Ab);
          window.scrollViews()[0].webViews()[0].links()["返回"].tap();
          window.scrollViews()[0].webViews()[0].links()["是"].tap();
          target.delay(1);
     })
     window.navigationBar().buttons()["top back"].tap();
     test("后台改变分次支付为成功支付",function () {
          target.delay(10);
     })
     test("分次支付部分金额--用户订单(成功)",function () {
          target.delay(1);
          window.staticTexts()["全部"].tapWithOptions({tapOffset:{x:0.69, y:0.10}});
          drop(Ab);
          target.delay(1);
          assertEquals("部分付款",window.scrollViews()[0].tableViews()[0].groups()[0].staticTexts()[0].name());

          var orderStr = window.scrollViews()[0].tableViews()[0].groups()[0].staticTexts()[1].name();
          var orderId = orderStr.substr(5,orderStr.length - 5);
          window.staticTexts()["待付款"].tapWithOptions({tapOffset: {x: 0.27, y: 0.55}});
          judge(orderId,"待付款");


     })
     window.navigationBar().buttons()["top back"].tap();
     test("分次支付部分金额--县级订单",function () {
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
     test("线下支付剩余款--用户订单",function () {
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
     })
     window.navigationBar().buttons()["top back"].tap();
     test("线下支付剩余款--县级订单",function () {
          target.delay(1);
          window.tableViews()[0].buttons()[0].tap();
          target.delay(1);
          assertEquals("付款待审核",window.scrollViews()[0].tableViews()[0].groups()[0].staticTexts()[0].name());
          window.scrollViews()[0].tableViews()[0].groups()[1].buttons()["审核付款"].tap();
          drop(Ab);
          window.buttons()["确定"].tap();
          window.buttons()["全部"].tap();
          target.delay(1);
          assertEquals("待厂家发货",window.scrollViews()[0].tableViews()[0].groups()[0].staticTexts()[0].name());
     })
     test("后台操作一个化肥发货",function () {
          target.delay(15);
     })
     test("一个化肥发货--县级订单",function () {
          target.delay(1);
          window.buttons()["全部"].tap();
          target.delay(1);
          assertEquals("待配送",window.scrollViews()[0].tableViews()[0].groups()[0].staticTexts()[0].name());

          var orderStr = window.scrollViews()[0].tableViews()[0].groups()[0].staticTexts()[1].name();
          var orderId = orderStr.substr(5,orderStr.length - 5);
          target.frontMostApp().windows()[0].buttons()["待配送"].tap();
          judge(orderId,"待配送");

     })
     window.navigationBar().buttons()["top back"].tap();
     test("一个化肥发货--用户订单",function () {
          target.delay(1);
          window.tableViews()[0].buttons()[1].tap();
          target.delay(1);
          assertEquals("待发货",window.scrollViews()[0].tableViews()[0].groups()[0].staticTexts()[0].name());

          var orderStr = window.scrollViews()[0].tableViews()[0].groups()[0].staticTexts()[1].name();
          var orderId = orderStr.substr(5,orderStr.length - 5);
          window.staticTexts()["待发货"].tapWithOptions({tapOffset: {x: 0.30, y: 0.82}});
          judge(orderId,"待发货");
     })
     window.navigationBar().buttons()["top back"].tap();
     test("开始配送--县级订单",function () {
          target.delay(1);
          window.tableViews()[0].buttons()[0].tap();
          target.delay(1);
          window.scrollViews()[0].tableViews()[0].groups()[1].buttons()["开始配送"].tap();
          drop(Ab);
          window.tableViews()[0].cells()[0].tap();
          window.buttons()["确定(1)"].tap();
          drop(Ab);
          window.buttons()["全部"].tap();
          target.delay(1);
          assertEquals("配送中",window.scrollViews()[0].tableViews()[0].groups()[0].staticTexts()[0].name());
          
     })
     window.navigationBar().buttons()["top back"].tap();
     test("确认收货一个商品,另一个商品未发货--用户订单",function () {
          target.delay(1);
          window.tableViews()[0].buttons()[1].tap();
          target.delay(1);
          assertEquals("配送中",window.scrollViews()[0].tableViews()[0].groups()[0].staticTexts()[0].name());
          window.scrollViews()[0].tableViews()[0].groups()[1].buttons()["确认收货"].tap();
          drop(Ab);
          target.delay(2);
          window.logElementTree();

          window.buttons()[5].tapWithOptions({tapOffset:{x:0.08, y:0.37}});
          window.buttons()[5].tapWithOptions({tapOffset:{x:0.49, y:0.96}});
          target.delay(2);

          window.staticTexts()["全部"].tapWithOptions({tapOffset:{x:0.53, y:0.28}});
          target.delay(1);
          assertEquals("配送中",window.scrollViews()[0].tableViews()[0].groups()[0].staticTexts()[0].name());

          var orderStr = window.scrollViews()[0].tableViews()[0].groups()[0].staticTexts()[1].name();
          var orderId = orderStr.substr(5,orderStr.length - 5);
          window.staticTexts()["待收货"].tapWithOptions({tapOffset: {x: 0.64, y: 0.88}});
          judge(orderId,"待收货");

     })
     window.navigationBar().buttons()["top back"].tap();
     test("确认收货一个商品,另一个商品未发货--县级订单",function () {
          target.delay(1);
          window.tableViews()[0].buttons()[0].tap();
          target.delay(1);
          assertEquals("配送中",window.scrollViews()[0].tableViews()[0].groups()[0].staticTexts()[0].name());


          var orderStr = window.scrollViews()[0].tableViews()[0].groups()[0].staticTexts()[1].name();
          var orderId = orderStr.substr(5,orderStr.length - 5);
          target.frontMostApp().windows()[0].buttons()["待配送"].tap();
          judge(orderId,"待配送");

     })

     test("后台操作另一化肥发货",function () {
          target.delay(15);
     })
     test("配送另一个化肥--县级订单",function () {
          window.buttons()["全部"].tap();
          target.delay(1);
          assertEquals("配送中",window.scrollViews()[0].tableViews()[0].groups()[0].staticTexts()[0].name());
          window.scrollViews()[0].tableViews()[0].groups()[1].buttons()["开始配送"].tap();
          window.tableViews()[0].tapWithOptions({tapOffset:{x:0.49, y:0.14}});
          window.buttons()["确定(1)"].tap();
          target.delay(1);
          assertEquals("配送中",window.scrollViews()[0].tableViews()[0].groups()[0].staticTexts()[0].name());


     })
     window.navigationBar().buttons()["top back"].tap();
     test("确认收货--用户订单(已完成)",function () {
          target.delay(1);
          window.tableViews()[0].buttons()[1].tap();
          target.delay(1);
          assertEquals("配送中",window.scrollViews()[0].tableViews()[0].groups()[0].staticTexts()[0].name());
          window.scrollViews()[0].tableViews()[0].groups()[1].buttons()["确认收货"].tap();
          target.delay(1);
          window.buttons()[5].tapWithOptions({tapOffset:{x:0.08, y:0.37}});
          window.buttons()[5].tapWithOptions({tapOffset:{x:0.49, y:0.96}});
          target.delay(2);
          window.staticTexts()["全部"].tapWithOptions({tapOffset:{x:0.53, y:0.28}});
          target.delay(1);
          assertEquals("已完成",window.scrollViews()[0].tableViews()[0].groups()[0].staticTexts()[0].name());

          var orderStr = window.scrollViews()[0].tableViews()[0].groups()[0].staticTexts()[1].name();
          var orderId = orderStr.substr(5,orderStr.length - 5);
          window.staticTexts()["已完成"].tapWithOptions({tapOffset: {x: 0.34, y: 0.68}});
          judge(orderId,"已完成");
     })
     window.navigationBar().buttons()["top back"].tap();
     test("已完成--县级订单",function () {
          target.delay(1);
          window.tableViews()[0].buttons()[0].tap();
          drop(Ab);
          target.delay(1);
          assertEquals("已完成",window.scrollViews()[0].tableViews()[0].groups()[0].staticTexts()[0].name());
     })
     window.navigationBar().buttons()["top back"].tap();
}
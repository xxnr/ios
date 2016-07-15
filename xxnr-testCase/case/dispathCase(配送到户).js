/**
 * Created by yangning on 16/7/7.
 */
#import "../lib/tuneup.js"
#import "baseClass.js"
#import "xxnrElementClass.js"

var target = UIATarget.localTarget();
var window = target.frontMostApp().windows()[0];

var isHoldPay = false;

Aa();

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
     xxnrlogMessage("'"+count+"'");

     scrollList(orderId,count);

     num = count - 1;
     while (count >= num) {
          if (isHoldPay == false) {
               xxnrlogMessage("'"+num+"'");
               xxnrlogMessage("'"+orderId+"'");

               xxnrElementClass.myorder(window).tableViewsgroups()[num].scrollToVisible();
               window.scrollViews()[0].tableViews()[0].dragInsideWithOptions({
                    startOffset: {x: 0.49, y: 1.00},
                    endOffset: {x: 0.60, y: -0.05},
                    duration: 0.5
               });
               var count = xxnrElementClass.myorder(window).tableViewsgroups().length/2;
               scrollList(orderId,count);
               num = count-1;
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

function Aa() {
     test("非分阶段 选择化肥--线下支付", function () {
          xxnrdelay(1);
          xxnrElementClass.home(window).fer_specialBtn().tap();
          window.tableViews()[0].tapWithOptions({tapOffset: {x: 0.79, y: 0.88}});
          xxnrElementClass.goodDetail(window).addShoppingCarBtn().tap();
          xxnrElementClass.goodDetail(window).addShoppingCar_sure().tap();
          xxnrdelay(1);
           xxnrElementClass.navBack(window).tap();
          xxnrElementClass.special(window).cell(3).scrollToVisible();
          xxnrElementClass.special(window).cell("中化化肥 - 螯合肥 - 一口价且只有一个sku - 没有描述").tap();

          xxnrElementClass.goodDetail(window).addShoppingCarBtn().tap();
          xxnrElementClass.goodDetail(window).addShoppingCar_sure().tap();
          xxnrdelay(1);
          xxnrElementClass.goodDetail(window).nav_shoppingCar().tap();
          xxnrdelay(2);
          xxnrElementClass.shoppingCar(window).sel_Group(0).tap();
          window.tableViews()[0].cells()[1].scrollToVisible();
          xxnrElementClass.shoppingCar(window).sel_Group(2).tap();
          xxnrdelay(2);
          xxnrElementClass.shoppingCar(window).go_settle("去结算(2)").tap();
          xxnrdelay(1);
          xxnrElementClass.submitOrder(window).dispatchBtn().tap();
          xxnrElementClass.submitOrder(window).submitOrderBtn().tap();
          window.buttons()[6].tap();
          xxnrElementClass.selPayType(window).goPay().tap();
          xxnrdelay(1);
     })
      xxnrElementClass.navBack(window).tap();
     Ab();
}
function Ab() {
     
     window.tabBar().buttons()["我的"].tap();
     test("后台添加服务站",function () {
          xxnrdelay(20);
     })
     test("线下支付--用户订单",function () {
          xxnrdelay(1);
          xxnrElementClass.mine(window).userOrderBtn().tap();
          drop(Ab);
          xxnrdelay(1);
          assertEquals("付款待审核",xxnrElementClass.myorder(window).userOrderStaticText(0));

          var orderStr = xxnrElementClass.myorder(window).userOrderId(0);
          var orderId = orderStr.substr(5,orderStr.length - 5);
          xxnrElementClass.myorder(window).holdPayTab().tapWithOptions({tapOffset: {x: 0.27, y: 0.55}});
          judge(orderId,"待付款");

     })
      xxnrElementClass.navBack(window).tap();
     test("线下支付--县级订单",function () {
          xxnrdelay(1);
          xxnrElementClass.mine(window).rscOrderBtn().tap();
          drop(Ab);
          xxnrdelay(1);
          assertEquals("付款待审核",xxnrElementClass.RSCOrder(window).RSCOrderStaticText(0));

     })
      xxnrElementClass.navBack(window).tap();
     test("分次支付部分金额--用户订单",function () {
          xxnrdelay(1);
          xxnrElementClass.mine(window).userOrderBtn().tap();
          xxnrdelay(1);
          xxnrElementClass.myorder(window).amendPayType(1).tap();
          drop(Ab);
          xxnrdelay(1);

          xxnrElementClass.selPayType(window).separatePay().tap();
          xxnrElementClass.selPayType(window).goPay().tap();
          drop(Ab);
          xxnrElementClass.alipay(window).ALipayBack().tap();
          xxnrElementClass.alipay(window).ALipayBackYes().tap();

          xxnrdelay(1);
     })
      xxnrElementClass.navBack(window).tap();
     test("后台改变分次支付为成功支付",function () {
          xxnrdelay(10);
     })
     test("分次支付部分金额--用户订单(成功)",function () {
          xxnrdelay(1);
          xxnrElementClass.myorder(window).totalTab().tapWithOptions({tapOffset:{x:0.49, y:0.78}});
          drop(Ab);
          xxnrdelay(1);
          assertEquals("部分付款",xxnrElementClass.myorder(window).userOrderStaticText(0));

          var orderStr = xxnrElementClass.myorder(window).userOrderId(0);
          var orderId = orderStr.substr(5,orderStr.length - 5);
          xxnrElementClass.myorder(window).holdPayTab().tapWithOptions({tapOffset: {x: 0.27, y: 0.55}});
          judge(orderId,"待付款");


     })
      xxnrElementClass.navBack(window).tap();
     test("分次支付部分金额--县级订单",function () {
          xxnrdelay(1);
          xxnrElementClass.mine(window).rscOrderBtn().tap();
          xxnrdelay(1);
          assertEquals("待付款",xxnrElementClass.RSCOrder(window).RSCOrderStaticText(0));


     })
      xxnrElementClass.navBack(window).tap();
     test("线下支付剩余款--用户订单",function () {
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
     })
      xxnrElementClass.navBack(window).tap();
     test("线下支付剩余款--县级订单",function () {
          xxnrdelay(1);
          xxnrElementClass.mine(window).rscOrderBtn().tap();
          xxnrdelay(1);
          assertEquals("付款待审核",xxnrElementClass.RSCOrder(window).RSCOrderStaticText(0));
          assertEquals("付款待审核",xxnrElementClass.RSCOrder(window).RSCOrderStaticText(0));

          xxnrElementClass.RSCOrder(window).verifyMoney(1).tap();
          drop(Ab);
          xxnrElementClass.RSCOrder(window).makeSureBtn().tap();
          xxnrdelay(1);
          xxnrElementClass.RSCOrder(window).totalTab().tap();
          xxnrdelay(1);
          assertEquals("待厂家发货",xxnrElementClass.RSCOrder(window).RSCOrderStaticText(0));
     })
     test("后台操作一个化肥发货",function () {
          xxnrdelay(15);
     })
     test("一个化肥发货--县级订单",function () {
          xxnrdelay(1);
          window.buttons()["全部"].tap();
          xxnrdelay(1);
          assertEquals("待配送",xxnrElementClass.RSCOrder(window).RSCOrderStaticText(0));


     })
      xxnrElementClass.navBack(window).tap();
     test("一个化肥发货--用户订单",function () {
          xxnrdelay(1);
          xxnrElementClass.mine(window).userOrderBtn().tap();
          xxnrdelay(1);
          assertEquals("待发货",xxnrElementClass.myorder(window).userOrderStaticText(0));

          var orderStr = xxnrElementClass.myorder(window).userOrderId(0);
          var orderId = orderStr.substr(5,orderStr.length - 5);
          xxnrElementClass.myorder(window).sendTab().tapWithOptions({tapOffset: {x: 0.30, y: 0.82}});
          judge(orderId,"待发货");
     })
      xxnrElementClass.navBack(window).tap();
     test("开始配送--县级订单",function () {
          xxnrdelay(1);
          xxnrElementClass.mine(window).rscOrderBtn().tap();
          xxnrdelay(1);

          xxnrElementClass.RSCOrder(window).beginDispatch(1).tap();
          drop(Ab);
          xxnrElementClass.RSCOrder(window).carryTableViewcell(0).tap();

          xxnrElementClass.RSCOrder(window).disPatchmakeSure("确定(1)").tap();
          drop(Ab);
          xxnrElementClass.RSCOrder(window).totalTab().tap();
          xxnrdelay(1);
          assertEquals("配送中",xxnrElementClass.RSCOrder(window).RSCOrderStaticText(0));

     })
      xxnrElementClass.navBack(window).tap();
     test("确认收货一个商品,另一个商品未发货--用户订单",function () {
          xxnrdelay(1);
          xxnrElementClass.mine(window).userOrderBtn().tap();
          xxnrdelay(1);
          assertEquals("配送中",xxnrElementClass.myorder(window).userOrderStaticText(0));
          xxnrElementClass.myorder(window).receiveGoods(1).tap();
          drop(Ab);
          xxnrdelay(2);
          window.logElementTree();

          window.buttons()[5].tapWithOptions({tapOffset:{x:0.08, y:0.37}});
          window.buttons()[5].tapWithOptions({tapOffset:{x:0.49, y:0.96}});
          xxnrdelay(2);

          xxnrElementClass.myorder(window).totalTab().tapWithOptions({tapOffset:{x:0.49, y:0.78}});
          xxnrdelay(1);
          assertEquals("配送中",xxnrElementClass.myorder(window).userOrderStaticText(0));

          var orderStr = xxnrElementClass.myorder(window).userOrderId(0);
          var orderId = orderStr.substr(5,orderStr.length - 5);
          xxnrElementClass.myorder(window).reciveTab().tapWithOptions({tapOffset: {x: 0.64, y: 0.88}});
          judge(orderId,"待收货");

     })
      xxnrElementClass.navBack(window).tap();
     test("确认收货一个商品,另一个商品未发货--县级订单",function () {
          xxnrdelay(1);
          xxnrElementClass.mine(window).rscOrderBtn().tap();
          xxnrdelay(1);
          assertEquals("配送中",xxnrElementClass.RSCOrder(window).RSCOrderStaticText(0));



     })

     test("后台操作另一化肥发货",function () {
          xxnrdelay(15);
     })
     test("配送另一个化肥--县级订单",function () {
          window.buttons()["全部"].tap();
          xxnrdelay(1);
          assertEquals("配送中",xxnrElementClass.RSCOrder(window).RSCOrderStaticText(0));
          xxnrElementClass.RSCOrder(window).beginDispatch(1).tap();
          window.tableViews()[0].tapWithOptions({tapOffset:{x:0.49, y:0.14}});
          window.buttons()["确定(1)"].tap();
          xxnrdelay(1);
          assertEquals("配送中",xxnrElementClass.RSCOrder(window).RSCOrderStaticText(0));


     })
      xxnrElementClass.navBack(window).tap();
     test("确认收货--用户订单(已完成)",function () {
          xxnrdelay(1);
          xxnrElementClass.mine(window).userOrderBtn().tap();
          xxnrdelay(1);
          assertEquals("配送中",xxnrElementClass.myorder(window).userOrderStaticText(0));
          xxnrElementClass.myorder(window).receiveGoods(1).tap();
          xxnrdelay(1);
          window.buttons()[5].tapWithOptions({tapOffset:{x:0.08, y:0.37}});
          window.buttons()[5].tapWithOptions({tapOffset:{x:0.49, y:0.96}});
          xxnrdelay(2);
          xxnrElementClass.myorder(window).totalTab().tapWithOptions({tapOffset:{x:0.49, y:0.78}});
          xxnrdelay(1);
          assertEquals("已完成",xxnrElementClass.myorder(window).userOrderStaticText(0));

          var orderStr = xxnrElementClass.myorder(window).userOrderId(0);
          var orderId = orderStr.substr(5,orderStr.length - 5);
          xxnrElementClass.myorder(window).commentTab().tapWithOptions({tapOffset:{x:0.59, y:0.33}});
          judge(orderId,"已完成");
     })
      xxnrElementClass.navBack(window).tap();
     test("已完成--县级订单",function () {
          xxnrdelay(1);
          xxnrElementClass.mine(window).rscOrderBtn().tap();
          
          xxnrdelay(1);
          assertEquals("已完成",xxnrElementClass.RSCOrder(window).RSCOrderStaticText(0));
     })
      xxnrElementClass.navBack(window).tap();
}
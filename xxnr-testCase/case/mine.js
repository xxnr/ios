#import "../lib/tuneup.js"
#import "xxnrClass.js"
#import "mainClass.js"

var target = UIATarget.localTarget();         
var window = target.frontMostApp().windows()[0];
window.tabBar().buttons()["我的"].tap();    
target.delay(3);

test("我的新农人页面和其它页面之间的跳转测试",function(target,app){
     window.logElementTree();
     xxnrClass.mine(window).loginBtn().tap();
     assertEquals("登录",window.navigationBar().name());
     xxnrClass.navBack(window).tap();
     target.delay(1);

     xxnrClass.mine(window).registerBtn().tap();
     assertEquals("注册",window.navigationBar().name());
     xxnrClass.navBack(window).tap();
     target.delay(1);

     xxnrClass.mine(window).stayPayBtn().tap();
     xxnrClass.mine(window).alertCancel().tap();
     target.delay(1);

     xxnrClass.mine(window).stayDeliverBtn().tap();
     xxnrClass.mine(window).alertCancel().tap();
     target.delay(1);

     xxnrClass.mine(window).stayTakeBtn().tap();
     xxnrClass.mine(window).alertCancel().tap();
     target.delay(1);

     xxnrClass.mine(window).finishBtn().tap();
     xxnrClass.mine(window).alertCancel().tap();
     target.delay(1);

     window.tableViews()[0].images()["icon_bgView"].buttons()["登录"].tap();
     var phone = "18211101020";
     var password = "123456";
     window.images()[0].textFields()[0].textFields()[0].tap();
     window.images()[0].textFields()[0].setValue(phone);
     
     window.images()[0].logElementTree(); 
     window.images()[0].secureTextFields()[0].secureTextFields()[0].tap();
     window.images()[0].secureTextFields()[0].secureTextFields()[0].setValue(password);
     window.images()[0].buttons()["确认登录"].tap();
     target.delay(2);

     window.logElementTree();
     xxnrClass.mine(window).rscOrderBtn().tap();
     assertEquals("服务站订单",window.navigationBar().name());
     xxnrClass.navBack(window).tap();
     target.delay(1);

     xxnrClass.mine(window).orderBtn().tap();
     assertEquals("我的订单",window.navigationBar().name());
     xxnrClass.navBack(window).tap();
     target.delay(1);


     xxnrClass.mine(window).integrateBtn().tap();
     assertEquals("我的积分",window.navigationBar().name());
     xxnrClass.navBack(window).tap();
     target.delay(1);

     xxnrClass.mine(window).representBtn().tap();
     assertEquals("新农代表",window.navigationBar().name());
     xxnrClass.navBack(window).tap();
     target.delay(1);

     xxnrClass.mine(window).phoneBtn().tap();
     target.delay(1);

     xxnrClass.mine(window).setBtn().tap();
     assertEquals("设置",window.navigationBar().name());
     xxnrClass.navBack(window).tap();
     target.delay(1);

     xxnrClass.home(window).homeTab().tap();
     assertEquals("新新农人",window.navigationBar().name());
     target.delay(1);

     xxnrClass.home(window).newsTab().tap();
     assertEquals("新农资讯",window.navigationBar().name());
     target.delay(1);

     xxnrClass.home(window).shoppingCarTab().tap();
     assertEquals("购物车(16)",window.navigationBar().name());
     target.delay(1);
     
     
     });


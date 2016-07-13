#import "assertions.js"
#import "lang-ext.js"
#import "uiautomation-ext.js"
#import "screen.js"
#import "test.js"
#import "image_assertion.js"

var target = UIATarget.localTarget();         
var window = target.frontMostApp().windows()[0];
window.tabBar().buttons()["我的"].tap();    
target.delay(3);

test("我的新农人页面和其它页面之间的跳转测试",function(target,app){
     window.logElementTree();
     window.tableViews()[0].images()[0].buttons()["登录"].tap();
     window.navigationBar().buttons()["top back"].tap();
     target.delay(1);
     window.tableViews()[0].images()[0].buttons()["注册"].tap();
     window.navigationBar().buttons()["top back"].tap();
     target.delay(1);

     window.tableViews()[0].buttons()[1].tap();
     window.buttons()["取消"].tap();
     target.delay(1);

     window.tableViews()[0].buttons()[2].tap();
     window.buttons()["取消"].tap();
     target.delay(1);

     window.tableViews()[0].buttons()[3].tap();
     window.buttons()["取消"].tap();
     target.delay(1);

     window.tableViews()[0].buttons()[4].tap();
     window.buttons()["取消"].tap();
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
     window.tableViews()[0].buttons()[0].tap();
     window.navigationBar().buttons()["top back"].tap();
     assertEquals("服务站订单",window.navigationBar().name());

     target.delay(1);

     window.tableViews()[0].buttons()[1].tap();
     window.navigationBar().buttons()["top back"].tap();
     assertEquals("我的订单",window.navigationBar().name());

     target.delay(1);

     
     window.tableViews()[0].cells()[0].tap();
     window.navigationBar().buttons()["top back"].tap();
     assertEquals("我的积分",window.navigationBar().name());

     target.delay(1);

     window.tableViews()[0].cells()[1].tap();
     window.navigationBar().buttons()["top back"].tap();
     assertEquals("新农代表",window.navigationBar().name());

     target.delay(1);

     window.tableViews()[0].cells()[2].tap();
     target.delay(1);

     window.tableViews()[0].cells()[3].tap();
     window.navigationBar().buttons()["top back"].tap();
     assertEquals("设置",window.navigationBar().name());

     target.delay(1);

     window.tabBar().buttons()["首页"].tap();
     assertEquals("新新农人",window.navigationBar().name());
     target.delay(1);

     window.tabBar().buttons()["资讯"].tap();
     assertEquals("新农资讯",window.navigationBar().name());

     target.delay(1);

     window.tabBar().buttons()["购物车"].tap();

     target.delay(1);
     
     window.tabBar().buttons()["我的"].tap();
     assertEquals("我的新农人",window.navigationBar().name());

     

     });


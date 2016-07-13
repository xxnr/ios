
#import "test.js"

var target = UIATarget.localTarget();         
var window = target.frontMostApp().windows()[0];
window.tabBar().buttons()["购物车"].tap();    
target.delay(3);
test("购物车测试",function(target,app){
     window.logElementTree();
     test("商品的选择测试",function(target,app){
          // 全选
          target.tap({x:14,y:493});
          target.delay(1);
          target.tap({x:14,y:493});
          target.delay(1);
          
          // 选择品牌
          window.tableViews()[0].groups()[0].buttons()["shopCar circle"].tap();
          target.delay(1);
          window.tableViews()[0].groups()[0].buttons()["shopCar circle"].tap();
          target.delay(1);
          
          // 选择单个商品
          window.tableViews()[0].cells()[0].buttons()["address circle"].tap();
          target.delay(1);
          window.tableViews()[0].cells()[0].buttons()["address circle"].tap();
          
          });
     test("修改商品数量",function(target,app){

          var number = "9999";
          window.tableViews()[0].cells()[0].textFields()[0].tap();
          window.tableViews()[0].cells()[0].textFields()[0].setValue(number);
          window.tableViews()[0].cells()[0].buttons()["icon plus"].tap();
          target.delay(1);

          
          // window.tableViews()[0].cells()[0].buttons()["icon plus"].tap();
          var number = "9990";
          window.tableViews()[0].cells()[0].textFields()[0].tap();
          window.tableViews()[0].cells()[0].textFields()[0].setValue(number);
          target.delay(2);

          for(var i = 0; i<9; i++){
          window.tableViews()[0].cells()[0].buttons()["icon plus"].tap();
          
          }
          // var warning = window.staticTexts()[0].value();
          // assertEquals("商品个数不能大于9999",warning);         
          target.delay(1);

          var number = "10";
          window.tableViews()[0].cells()[0].textFields()[0].tap();
          window.tableViews()[0].cells()[0].textFields()[0].setValue(number);
          
          for(var i = 0; i<10; i++){
          window.tableViews()[0].cells()[0].buttons()["icon minus"].tap();
          }
          var warning = window.staticTexts()[0].value();
          assertEquals("数量不能再减少了哦",warning);         
          target.delay(1);
          
          var number = "1";
          window.tableViews()[0].cells()[0].textFields()[0].tap();
          window.tableViews()[0].cells()[0].textFields()[0].setValue(number);
          window.tableViews()[0].cells()[0].buttons()["icon minus"].tap();
          target.delay(1);

          });
    
     test("结算操作测试（未登录）",function(target,app){
          window.buttons()[0].tap();
          window.buttons()["取消"].tap();

          target.delay(1);

          window.tableViews()[0].cells()[0].buttons()["address circle"].tap();
          window.buttons()[0].tap();

          });

     test("购物车页面的跳转测试",function(target,app){
          
          window.tabBar().buttons()["首页"].tap();
          assertEquals("新新农人",window.navigationBar().name());
          
          target.delay(1);
        
          window.tabBar().buttons()["资讯"].tap();
          assertEquals("新农资讯",window.navigationBar().name());

          
          target.delay(1);
          
          window.tabBar().buttons()["我的"].tap();
          assertEquals("我的新农人",window.navigationBar().name());

          target.delay(1);
          
          
          window.tabBar().buttons()["购物车"].tap();
          
          target.delay(1);
          
          
          target.tap({x:43,y:123});
          
          window.navigationBar().buttons()["top back"].tap();
          
          target.delay(1);


          window.navigationBar().buttons()["编辑"].tap();
          
          target.delay(1);
          
          
          
          target.tap({x:14,y:493});
          
          target.delay(1);
          
          

          window.buttons()[1].tap();
          
          window.logElementTree();
          
          target.delay(1);
          
          
          window.buttons()["确定"].tap();
          
          window.logElementTree();
          
          target.delay(1);
          
          
          
          window.buttons()["去买化肥"].tap();
          assertEquals("化肥",window.navigationBar().name());

          
          window.navigationBar().buttons()["top back"].tap();
          
          target.delay(1);
          
          
          
          window.buttons()["去买汽车"].tap();
          assertEquals("汽车",window.navigationBar().name());

          window.navigationBar().buttons()["top back"].tap();
          
          });
     
     test("结算操作测试（登录）",function(target,app){
          target.delay(1);
          var target = UIATarget.localTarget();         

          window.tabBar().buttons()["我的"].tap();
          window.tableViews()[0].images()["icon_bgView"].buttons()["登录"].tap();
          var phone = "18211101020";
          var password = "123456";
          window.images()[0].textFields()[0].textFields()[0].tap();
          window.images()[0].textFields()[0].setValue(phone);
          
          window.images()[0].logElementTree(); 
          window.images()[0].secureTextFields()[0].secureTextFields()[0].tap();
          window.images()[0].secureTextFields()[0].secureTextFields()[0].setValue(password);
          window.images()[0].buttons()["确认登录"].tap();
          
          target.delay(1);
          window.tabBar().buttons()["购物车"].tap();
          
          target.delay(1);

          window.buttons()[0].tap();
          window.buttons()["取消"].tap();
          
          target.delay(1);
          
          window.tableViews()[0].cells()[0].buttons()["address circle"].tap();
          window.buttons()[0].tap();
          var warning = window.staticTexts()[0].value();
          assertEquals("请至少选择一件商品",warning);         
          
          
          });

     });
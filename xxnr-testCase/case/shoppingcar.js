#import "../lib/tuneup.js"
#import "xxnrClass.js"
#import "mainClass.js"
var target = UIATarget.localTarget();         
var window = target.frontMostApp().windows()[0];
target.delay(3);
test("购物车测试",function(target,app){
     test("商品的选择测试",function(target,app){
          xxnrClass.home(window).shoppingCarTab().tap();
          window.logElementTree();

          // 全选
          xxnrClass.shoppingCar(window).allSelectBtn().tap();
          target.delay(1);
          xxnrClass.shoppingCar(window).allSelectBtn().tap();
          target.delay(1);
          
          // 选择品牌
          xxnrClass.shoppingCar(window).brandSelectBtn().tap();
          target.delay(1);
          xxnrClass.shoppingCar(window).brandSelectBtn().tap();
          target.delay(1);
          
          // 选择单个商品
          xxnrClass.shoppingCar(window).goodsSelectBtn().tap();
          target.delay(1);
          xxnrClass.shoppingCar(window).goodsSelectBtn().tap();
          });

     test("修改商品数量",function(target,app){
          
          var number = "9990";
          xxnrClass.shoppingCar(window).inputCount().tap();
          xxnrClass.shoppingCar(window).inputCount().setValue(number);
          target.delay(1);

          for(var i = 0; i<9; i++){
               xxnrClass.shoppingCar(window).plusBtn().tap();
          }
          var toast = window.staticTexts()[0].value();
          assertEquals("商品个数不能大于9999",toast);
          target.delay(1);

          var number = "10";

          xxnrClass.shoppingCar(window).inputCount().tap();
          xxnrClass.shoppingCar(window).inputCount().setValue(number);
          
          for(var i = 0; i<10; i++){
               xxnrClass.shoppingCar(window).minusBtn().tap();
          }
          var toast = window.staticTexts()[0].value();
          assertEquals("数量不能再减少了哦",toast);
          target.delay(1);

          var number = "1";
          xxnrClass.shoppingCar(window).inputCount().tap();
          xxnrClass.shoppingCar(window).inputCount().setValue(number);
          xxnrClass.shoppingCar(window).minusBtn().tap();
          var toast = window.staticTexts()[0].value();
          assertEquals("数量不能再减少了哦",toast);
          target.delay(1);

          var number = "9998";
          xxnrClass.shoppingCar(window).inputCount().tap();
          xxnrClass.shoppingCar(window).inputCount().setValue(number);
          xxnrClass.shoppingCar(window).plusBtn().tap();
          var toast = window.staticTexts()[0].value();
          assertEquals("商品个数不能大于9999",toast);
          target.delay(1);

     });
    
     test("结算操作测试（未登录）",function(target,app){
          xxnrClass.shoppingCar(window).goPayBtn().tap();
          xxnrClass.shoppingCar(window).alertCancel().tap();
          target.delay(1);
          xxnrClass.shoppingCar(window).allSelectBtn().tap();
          xxnrClass.shoppingCar(window).goPayBtn().tap();
          xxnrClass.shoppingCar(window).alertAdmire().tap();
          assertEquals("登录",xxnrClass.navigationBarTitle(window));
          
     });

     test("购物车页面的跳转测试",function(target,app){
          xxnrClass.home(window).homeTab().tap();
          assertEquals("新新农人",xxnrClass.navigationBarTitle(window));
          target.delay(1);

          xxnrClass.home(window).newsTab().tap();
          assertEquals("新农资讯",window.navigationBar().name());
          target.delay(1);

          xxnrClass.home(window).mineTab().tap();
          assertEquals("我的新农人",window.navigationBar().name());
          target.delay(1);

          xxnrClass.home(window).shoppingCarTab().tap();
          target.delay(1);
          
          
          xxnrClass.shoppingCar(window).cellBtn().tap();
          assertEquals("商品详情",window.navigationBar().name());
          xxnrClass.navBack(window).tap();
          target.delay(1);

          xxnrClass.shoppingCar(window).editBtn().tap();
          target.delay(1);
          

          xxnrClass.shoppingCar(window).cancelBtn().tap();
          target.delay(1);
          
          xxnrClass.shoppingCar(window).alertAdmire().tap();
          window.logElementTree();
          target.delay(1);
          
          
          xxnrClass.shoppingCar(window).buyFertilizer().tap();
          assertEquals("化肥",xxnrClass.navigationBarTitle(window));
          xxnrClass.navBack(window);
          target.delay(1);


          xxnrClass.shoppingCar(window).buyCar().tap();
          assertEquals("汽车",xxnrClass.navigationBarTitle(window));
          xxnrClass.navBack(window);
          });
     
     test("结算操作测试（登录）",function(target,app){
          target.delay(1);
          var target = UIATarget.localTarget();         

          window.tabBar().buttons()["我的"].tap();
          xxnrClass().home(window).mineTab().tap();
          login(18211101020,123456);
          target.delay(1);

          xxnrClass.home(window).shoppingCarTab().tap();
          target.delay(1);


          xxnrClass.shoppingCar(window).goPayBtn().tap();
          xxnrClass.shoppingCar(window).alertCancel().tap();
          var warning = window.staticTexts()[0].value();
          assertEquals("请至少选择一件商品",warning);
          target.delay(1);
          
          xxnrClass.shoppingCar(window).allSelectBtn().tap();
          xxnrClass.shoppingCar(window).goPayBtn().tap();
          xxnrClass.shoppingCar(window).alertAdmire().tap();
          assertEquals("提交订单",xxnrClass.navigationBarTitle(window));
     });

});
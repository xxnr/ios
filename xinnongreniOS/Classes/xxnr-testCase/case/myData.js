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

test("个人资料测试",function(target,app){
     window.tableViews()[0].images()["icon_bgView"].buttons()["登录"].tap();
     target.delay(1);

     var phone = "18211101020";
     var password = "123456";
     window.images()[0].textFields()[0].textFields()[0].tap();
     window.images()[0].textFields()[0].setValue(phone);
     
     window.images()[0].logElementTree(); 
     window.images()[0].secureTextFields()[0].secureTextFields()[0].tap();
     window.images()[0].secureTextFields()[0].secureTextFields()[0].setValue(password);
     window.images()[0].buttons()["确认登录"].tap();
     target.delay(2);
     
     target.doubleTap({x:0, y:64});
     target.delay(2);
     
     test("我的头像测试",function(target,app){

          });

 
     test("我的昵称测试",function(target,app){
          window.scrollViews()[0].buttons()[1].tap();
          target.delay(2);
          
          var nickName = "哈哈哈哈";
          window.textFields()[0].textFields()[0].tap();
          window.textFields()[0].textFields()[0].setValue(nickName);
          target.delay(1);
          
          window.buttons()["完成"].tap(); 
          target.delay(2);

          
          });
     test("姓名测试",function(target,app){
          window.scrollViews()[0].buttons()[2].tap();
          target.delay(2);
          
          var nickName = "钟振华";
          window.textFields()[0].textFields()[0].tap();
          window.textFields()[0].textFields()[0].setValue(nickName);
          target.delay(1);
          
          window.buttons()["保存"].tap();           
          
          });
     test("性别测试",function(target,app){
          window.scrollViews()[0].buttons()[3].tap();
          target.delay(2);
          window.logElementTree();
          window.buttons()[1].tap();
          target.delay(1);

          
          });
     test("所在地区测试",function(target,app){
          window.scrollViews()[0].buttons()[4].tap();
          target.delay(1);
          
          window.buttons()[0].tap();
          target.delay(2);
          
          window.logElementTree();
          
          window.pickers()[0].wheels()[1].dragInsideWithOptions({startOffset:{x:0.38, y:0.66}, endOffset:{x:0.38, y:0.12}, duration:1.6});
          target.delay(1);
          
          window.buttons()[4].tap();
          
          window.buttons()[1].tap();
          target.delay(2);
          window.buttons()[4].tap();
          
          window.buttons()[2].tap();
          target.delay(2);
          
          
          });

     test("类型测试",function(target,app){
          window.scrollViews()[0].buttons()[5].tap();
          target.delay(2);
          window.pickers()[0].wheels()[0].dragInsideWithOptions({startOffset:{x:0.38, y:0.22}, endOffset:{x:0.38, y:0.12}, duration:1.6});
          window.buttons()[1].tap();
          target.delay(2);
          
          
          
          window.scrollViews()[0].buttons()[5].tap();
          target.delay(2);
          window.pickers()[0].wheels()[0].dragInsideWithOptions({startOffset:{x:0.38, y:0.33}, endOffset:{x:0.38, y:0.12}, duration:1.6});
          window.buttons()[1].tap();
          
          });
     
     test("服务站认证测试",function(target,app){
          window.scrollViews()[0].buttons()[5].tap();
          target.delay(2);
          window.pickers()[0].wheels()[0].dragInsideWithOptions({startOffset:{x:0.38, y:0.22}, endOffset:{x:0.38, y:0.12}, duration:1.6});
          window.buttons()[1].tap();
          target.delay(2);
          
          
          });



     });


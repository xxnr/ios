
#import "test.js"
#import "registerData.js"

var target = UIATarget.localTarget();         
var window = target.frontMostApp().windows()[0];

window.tabBar().buttons()["我的"].tap();

test("注册测试",function(){
     target.delay(1);
     window.tableViews()[0].images()[0].buttons()["注册"].tap();
     window.logElementTree();

     for (int i = 0; i<9; i++){
          registerTest(i);
     }
     target.delay(1);

     target.tap({x:32,y:385});
     assertEquals("用户协议",window.navigationBar().name());
     window.navigationBar().buttons()["top back"].tap();
     target.delay(1);

     target.tap({x:0,y:503});
     assertEquals("登录",window.navigationBar().name());
     window.navigationBar().buttons()["top back"].tap();


});

function registerTest(i) {
     registerData(i)
     // input phone
     window.images()[0].textFields()[0].textFields()[0].tap();
     window.images()[0].textFields()[0].textFields()[0].setValue(phone);
     window.images()[0].buttons()["免费获取验证码"].tap();
     // input identifyCode
     window.images()[0].textFields()[1].textFields()[0].tap();
     window.images()[0].textFields()[1].textFields()[0].setValue(identifyCode);
     // input password
     window.images()[0].secureTextFields()[0].secureTextFields()[0].tap();
     window.images()[0].secureTextFields()[0].secureTextFields()[0].setValue(password);
     // input passwordAgain
     window.images()[0].secureTextFields()[1].secureTextFields()[0].tap();
     window.images()[0].secureTextFields()[1].secureTextFields()[0].setValue(passWordAgain);

     window.images()[0].buttons()[5].tap();

     target.tap({x:16,y:409});
     
     var toast = window.staticTexts()[0].value();

     assertEquals(message,toast);
}








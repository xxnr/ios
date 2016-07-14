
#import "test.js"
#import "data.js"

var target = UIATarget.localTarget();         
var window = target.frontMostApp().windows()[0];
window.tabBar().buttons()["我的"].tap();    
target.delay(3);
test("忘记密码测试",function(){
     window.tableViews()[0].images()[0].buttons()["登录"].tap();
     window.images()[0].buttons()["忘记密码?"].tap(); 
     window.logElementTree();
     for (var i=0;i<9;i++) {
          forgetPwd(i);   
     }
});

function forgetPwd(i) {
     forgetPwdData(i);
     window.images()[0].textFields()[0].textFields()[0].tap();
     window.images()[0].textFields()[0].textFields()[0].setValue(phone);

     window.images()[0].buttons()["免费获取验证码"].tap();

     window.images()[0].textFields()[1].textFields()[0].tap();
     window.images()[0].textFields()[1].textFields()[0].setValue(identifyCode);

     window.images()[0].secureTextFields()[0].secureTextFields()[0].tap();
     window.images()[0].secureTextFields()[0].secureTextFields()[0].setValue(password);

     window.images()[0].secureTextFields()[1].secureTextFields()[0].tap();
     window.images()[0].secureTextFields()[1].secureTextFields()[0].setValue(passWordAgain);

     target.tap({x:16,y:409});
     var toast = window.staticTexts()[0].value();
     assertEquals(message,toast);
}




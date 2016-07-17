
#import "test.js"
#import "data.js"
#import"xxnrClass"
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
     xxnrClass().forgetPwd(window).phoneNum().tap();
     xxnrClass().forgetPwd(window).phoneNum().setvalue(phone);
     xxnrClass().forgetPwd(window).identifyBtn().tap();

     xxnrClass().forgetPwd(window).identifyCode().tap();
     xxnrClass().forgetPwd(window).identifyCode().setvalue(identifyCode);

     xxnrClass().forgetPwd(window).passWord().tap();
     xxnrClass().forgetPwd(window).passWord().setvalue(password);

     xxnrClass().forgetPwd(window).passWordAgain().tap();
     xxnrClass().forgetPwd(window).passWordAgain().setvalue(passWordAgain);

     xxnrClass().forgetPwd(window).registerBtn().tap();

     var toast = window.staticTexts()[0].value();
     assertEquals(message,toast);
}




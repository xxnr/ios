
#import "../lib/tuneup.js"
#import "data.js"
#import "xxnrClass.js"
var target = UIATarget.localTarget();         
var window = target.frontMostApp().windows()[0];
target.delay(3);
test("忘记密码测试",function(){
     xxnrClass.home(window).mineTab.tap();
     xxnrClass.mine(window).loginBtn.tap();
     window.images()[0].buttons()["忘记密码?"].tap(); 
     window.logElementTree();
     for (var i=0;i<9;i++) {
          forgetPwd(i);   
     }
});

function forgetPwd(i) {
     forgetPwdData(i);
     xxnrClass.forgetPassword(window).phoneNum().tap();
     xxnrClass.forgetPassword(window).phoneNum().setValue(phone);
     xxnrClass.forgetPassword(window).identifyBtn().tap();

     xxnrClass.forgetPassword(window).identifyCode().tap();
     xxnrClass.forgetPassword(window).identifyCode().setValue(identifyCode);

     xxnrClass.forgetPassword(window).passWord().tap();
     xxnrClass.forgetPassword(window).passWord().setValue(password);

     xxnrClass.forgetPassword(window).passWordAgain().tap();
     xxnrClass.forgetPassword(window).passWordAgain().setValue(passWordAgain);

     xxnrClass.forgetPassword(window).registerBtn().tap();

     var toast = window.staticTexts()[0].value();
     assertEquals(message,toast);
}





#import "test.js"
#import "data.js"
#import "xxnrClass.js"

var target = UIATarget.localTarget();         
var window = target.frontMostApp().windows()[0];

window.tabBar().buttons()["我的"].tap();

test("注册测试",function(){
     target.delay(1);
     window.tableViews()[0].images()[0].buttons()["注册"].tap();
     window.logElementTree();

     for (var i = 0; i<9; i++){
          registerTest(i);
     }
     target.delay(1);

     xxnrClass().register(window).protocolJumpBtn().tap();
     assertEquals("用户协议",xxnrClass().register(window).navigationBarTitle());
     xxnrClass().register(window).navBack().tap();
     target.delay(1);

     xxnrClass().register(window).loginBtn().tap();
     assertEquals("登录",xxnrClass().register(window).navigationBarTitle());
     xxnrClass().register(window).navBack().tap();

});

function registerTest(i) {
     registerData(i);
     // input phone
     xxnrClass().register(window).phoneNum().tap();
     xxnrClass().register(window).phoneNum().setValue(phone);
     xxnrClass().identifyBtn(window).tap();

     // input identifyCode
     xxnrClass().register(window).identifyCode().tap();
     xxnrClass().register(window).identifyCode().setvalue(identifyCode);


     // input password
     xxnrClass().register(window).passWord().tap();
     xxnrClass().register(window).passWord().setvalue(password);

     //  input passwordAgain
     xxnrClass().register(window).passWordAgain().tap();
     xxnrClass().register(window).passWordAgain().setvalue(passWordAgain);

     xxnrClass().register(window).protocolSelectBtn().tap();
     xxnrClass().register(window).registerBtn().tap();

     var toast = window.staticTexts()[0].value();
     assertEquals(message,toast);
}








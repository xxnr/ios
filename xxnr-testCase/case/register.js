#import "../lib/tuneup.js"
#import "data.js"
#import "xxnrClass.js"

var target = UIATarget.localTarget();         
var window = target.frontMostApp().windows()[0];

test("注册测试",function(){
     target.delay(1);
    xxnrClass.home(window).mineTab().tap();
    xxnrClass.mine(window).registerBtn().tap();
     window.logElementTree();

     for (var i = 0; i<9; i++){
          registerTest(i);
     }
     target.delay(1);

     xxnrClass.register(window).protocolJumpBtn().tap();
     assertEquals("用户协议",xxnrClass.register(window).navigationBarTitle());
     xxnrClass.register(window).navBack().tap();
     target.delay(1);

     xxnrClass.register(window).loginBtn().tap();
     assertEquals("登录",xxnrClass.register(window).navigationBarTitle());
     xxnrClass.register(window).navBack().tap();

});

function registerTest(i) {
     registerData(i);
     // input phone
     xxnrClass.register(window).phoneNum().tap();
     xxnrClass.register(window).phoneNum().setValue(phone);
     xxnrClass.register(window).identifyBtn().tap();
    target.delay(2);
    window.logElementTree();
    if (i == 3){
        xxnrClass.register(window).alertAdmireBtn().tap();
        target.delay(2);
        window.logElementTree();
        assertEquals("请输入图形验证码",xxnrClass.register(window).emptyWarning());
        target.delay(2);

        xxnrClass.register(window).inputGraphCode().tap();
        xxnrClass.register(window).inputGraphCode().setValue(1234);
        xxnrClass.register(window).alertAdmireBtn().tap();
        assertEquals("图形验证码错误",xxnrClass.register(window).emptyWarning());

        xxnrClass.register(window).alertCancelBtn().tap();

    }
  
    var toast = window.staticTexts()[0].value();
    if ( toast != "安全验证"){
        assertEquals(message,toast);
    }

     // input identifyCode
     xxnrClass.register(window).identifyCode().tap();
     xxnrClass.register(window).identifyCode().setValue(identifyCode);


     // input password
     xxnrClass.register(window).passWord().tap();
     xxnrClass.register(window).passWord().setValue(password);

     //  input passwordAgain
     xxnrClass.register(window).passWordAgain().tap();
     xxnrClass.register(window).passWordAgain().setValue(passWordAgain);

    if(i==8){
        xxnrClass.register(window).protocolSelectBtn().tap();
    }
    
     xxnrClass.register(window).registerBtn().tap();
    
    if(i==2){
        var toast = window.staticTexts()[0].value();
        if ( toast != "安全验证"){
            assertEquals(Toast,toast);
        }
    }else{
        var toast = window.staticTexts()[0].value();
        if ( toast != "安全验证"){
            assertEquals(message,toast);
        }    
    }

}








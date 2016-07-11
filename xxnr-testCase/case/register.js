#import "assertions.js"
#import "lang-ext.js"
#import "uiautomation-ext.js"
#import "screen.js"
#import "test.js"
#import "image_assertion.js"

var target = UIATarget.localTarget();         
var window = target.frontMostApp().windows()[0];

target.setDeviceOrientation(UIA_DEVICE_ORIENTATION_PORTRAIT);
window.tabBar().buttons()["我的"].tap();

test("注册测试",function(target,app){
     target.delay(1);
    window.tableViews()[0].images()[0].buttons()["注册"].tap();
     window.logElementTree();
     
     test("未填写手机号",function(target,app){
          target.delay(1);
          window.images()[0].textFields()[0].textFields()[0].value();
          window.images()[0].buttons()["立即注册"].tap();
          var warning = window.staticTexts()[0].value();
          assertEquals("请输入手机号",warning);           
       });
     
     test("手机号格式错误",function(target,app){
          target.delay(1);
          var phoneText = "1821q10102x";
          window.images()[0].textFields()[0].textFields()[0].tap();
          window.images()[0].textFields()[0].textFields()[0].setValue(phoneText);  
          window.images()[0].buttons()["免费获取验证码"].tap();
          var warning = window.staticTexts()[0].value();
          assertEquals("手机号格式错误",warning);     
          });
     
     test("手机号已注册",function(target,app){
          target.delay(1);
          window.images()[0].textFields()[0].buttons()["Clear text"].tap();
          var phoneText = "18211101020";
          window.images()[0].textFields()[0].textFields()[0].tap();
          window.images()[0].textFields()[0].textFields()[0].setValue(phoneText);
          window.images()[0].buttons()["免费获取验证码"].tap();
          var warning = window.staticTexts()[0].value();
          assertEquals("该手机号已注册，请重新输入",warning);     
          });
     
     test("未填写验证码",function(target,app){
          target.delay(1);
          window.images()[0].textFields()[1].textFields()[0].value();
          window.images()[0].buttons()["立即注册"].tap();
          var warning = window.staticTexts()[0].value();
          assertEquals("请输入验证码",warning);     

          });
     test("未填写密码",function(target,app){
          window.logElementTree();

          target.delay(1);
          var identifyText = "123456";
          window.images()[0].textFields()[1].textFields()[0].tap();
          window.images()[0].textFields()[1].textFields()[0].setValue(identifyText);

          window.images()[0].secureTextFields()[0].secureTextFields()[0].value();
          target.tap({x:16,y:409});
          var warning = window.staticTexts()[0].value();
          assertEquals("请输入密码",warning);     


          });
     test("未填写确认密码",function(target,app){
          target.delay(1);
          var pwdText = "123567";
          window.images()[0].secureTextFields()[0].secureTextFields()[0].tap();
          window.images()[0].secureTextFields()[0].secureTextFields()[0].setValue(pwdText);
          window.images()[0].secureTextFields()[1].secureTextFields()[0].value();
          target.tap({x:16,y:409});
          var warning = window.staticTexts()[0].value();
          assertEquals("请输入确认密码",warning);     


          });
     
     test("密码(确认密码)不小6位",function(target,app){
          target.delay(1);
          var phoneText = "18211101020";
          var identifyText = "123456";
          var pwdText = "123";
          var pwdEnsureText = "123";
          window.images()[0].textFields()[0].textFields()[0].tap();
          window.images()[0].textFields()[0].textFields()[0].setValue(phoneText);
          
          window.images()[0].textFields()[1].textFields()[0].tap();
          window.images()[0].textFields()[1].textFields()[0].setValue(identifyText);
          
          window.images()[0].secureTextFields()[0].secureTextFields()[0].tap();
          window.images()[0].secureTextFields()[0].secureTextFields()[0].setValue(pwdText);

          window.images()[0].secureTextFields()[1].secureTextFields()[0].tap();
          window.images()[0].secureTextFields()[1].secureTextFields()[0].setValue(pwdEnsureText);
          target.tap({x:16,y:409});
          var warning = window.staticTexts()[0].value();
          assertEquals("密码需不小于6位",warning);     


          });
     
     test("密码和确认密码不一致",function(target,app){
          target.delay(1);
          var phoneText = "18211101020";
          var identifyText = "123456";
          var pwdText = "123";
          var pwdEnsureText = "12334";
          window.images()[0].textFields()[0].textFields()[0].tap();
          window.images()[0].textFields()[0].textFields()[0].setValue(phoneText);
          
          window.images()[0].textFields()[1].textFields()[0].tap();
          window.images()[0].textFields()[1].textFields()[0].setValue(identifyText);
          
          window.images()[0].secureTextFields()[0].secureTextFields()[0].tap();
          window.images()[0].secureTextFields()[0].secureTextFields()[0].setValue(pwdText);
          
          window.images()[0].secureTextFields()[1].secureTextFields()[0].tap();
          window.images()[0].secureTextFields()[1].secureTextFields()[0].setValue(pwdEnsureText);
          target.tap({x:16,y:409});
          var warning = window.staticTexts()[0].value();
          assertEquals("两次密码输入不一致，请重新输入",warning);     


          });
     
         
     test("去掉勾选用户协议",function(target,app){
          target.delay(1);
          var phoneText = "18211101020";
          var identifyText = "123456";
          var pwdText = "123456";
          var pwdEnsureText = "123456";
          window.images()[0].textFields()[0].textFields()[0].tap();
          window.images()[0].textFields()[0].textFields()[0].setValue(phoneText);
          
          window.images()[0].textFields()[1].textFields()[0].tap();
          window.images()[0].textFields()[1].textFields()[0].setValue(identifyText);
          
          window.images()[0].secureTextFields()[0].secureTextFields()[0].tap();
          window.images()[0].secureTextFields()[0].secureTextFields()[0].setValue(pwdText);
          
          window.images()[0].secureTextFields()[1].secureTextFields()[0].tap();
          window.images()[0].secureTextFields()[1].secureTextFields()[0].setValue(pwdEnsureText);

          window.images()[0].buttons()[5].tap();
          target.tap({x:16,y:409});
          var warning = window.staticTexts()[0].value();
          assertEquals("请同意网站使用协议",warning);     


          });
     
     test("打开新新农人网站使用协议",function(target,app){
          target.delay(1);
          target.tap({x:32,y:385});
          assertEquals("用户协议",window.navigationBar().name());
          window.navigationBar().buttons()["top back"].tap();

          });
     
     test("已有账号？登录",function(target,app){
          target.delay(1);

          target.tap({x:0,y:503});
          target.delay(1);
          assertEquals("登录",window.navigationBar().name());

          window.navigationBar().buttons()["top back"].tap();
          
          });

     
     var warning = window.staticTexts()[0].value();
     
     if(warning == "请输入手机号"){
     
        assertEquals("手机号为空",warning,"手机号为空提醒"); 
     
     }else if(warning == "该手机号已注册，请重新输入"){
     
        assertEquals("该手机号已注册",warning,"该手机号已注册提醒"); 
     
     }else if(warning == "请输入正确的手机号"){
     
        assertEquals("请输入正确的手机号",warning,"请输入正确的手机号提醒"); 
     
     }else if(warning == "请输入验证码"){
     
     assertEquals("请输入验证码",warning,"请输入验证码提醒"); 
     
     }else if(warning == "请输入密码"){
     
     assertEquals("请输入密码",warning,"请输入密码提醒");
     
     }else if(warning == "请输入确认密码"){
     
     assertEquals("请输入确认密码",warning,"请输入确认密码提醒"); 

     }else if(warning == "密码需不小于6位"){
     
     assertEquals("密码长度需不小于6位",warning,"密码长度需不小于6位提醒"); 
     
     }else if(warning == "两次密码输入不一致，请重新输入"){
     
     assertEquals("两次密码输入不一致，请重新输入",warning,"两次密码输入不一致，请重新输入提醒"); 
     
     }else if(warning == "请同意网站使用协议"){
     
     assertEquals("您需要同意注册协议才可继续注册哦~",warning,"您需要同意注册协议才可继续注册哦~提醒"); 
     }
});








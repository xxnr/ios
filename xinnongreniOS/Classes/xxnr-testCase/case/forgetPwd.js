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
test("忘记密码测试",function(target,app){
     window.tableViews()[0].images()[0].buttons()["登录"].tap();
     window.images()[0].buttons()["忘记密码?"].tap(); 
     window.logElementTree();
     test("未填写手机号",function(target,app){
          target.delay(1);
          window.images()[0].textFields()[0].textFields()[0].value();
          window.images()[0].buttons()["完成"].tap();
          var warning = window.staticTexts()[0].value();
            assertEquals("请输入手机号",warning);           
          });
     test("手机号格式错误",function(target,app){
          target.delay(1);
          var phoneText = "1821q10102x";
          window.images()[0].textFields()[0].textFields()[0].tap();
          window.images()[0].textFields()[0].textFields()[0].setValue(phoneText);          window.images()[0].buttons()["免费获取验证码"].tap();
          var warning = window.staticTexts()[0].value();
          assertEquals("手机号格式错误",warning);     
          });
     
     test("手机号未注册",function(target,app){
          target.delay(1);
          var phoneText = "18727358921";
          window.images()[0].textFields()[0].textFields()[0].tap();
          window.images()[0].textFields()[0].textFields()[0].setValue(phoneText);          window.images()[0].buttons()["免费获取验证码"].tap();
          var warning = window.staticTexts()[0].value();
          assertEquals("该手机号未注册，请重新输入",warning);     
          });
     test("未填写验证码",function(target,app){
          target.delay(1);
          var phoneText = "18211101020";
          window.images()[0].textFields()[0].textFields()[0].tap();
          window.images()[0].textFields()[0].textFields()[0].setValue(phoneText);     
          window.images()[0].textFields()[1].textFields()[0].value();
          target.tap({x:16,y:409});
          var warning = window.staticTexts()[0].value();
          assertEquals("请输入验证码",warning);     

          // window.images()[0].buttons()["完成"].tap();
          });
     
     test("未填写密码",function(target,app){
          target.delay(1);
          var identifyText = "123456";
          window.images()[0].textFields()[1].textFields()[0].tap();
          window.images()[0].textFields()[1].textFields()[0].setValue(identifyText);
          
          window.images()[0].secureTextFields()[0].secureTextFields()[0].value();
          target.tap({x:16,y:409});
          var warning = window.staticTexts()[0].value();
          assertEquals("请输入密码",warning);     

          // window.images()[0].buttons()["完成"].tap();
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

         //  window.images()[0].buttons()["完成"].tap();
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

         //  window.images()[0].buttons()["完成"].tap();
          });
     
     test("密码和确认密码不一致",function(target,app){
          target.delay(3);
          var phoneText = "18211101020";
          var identifyText = "123456";
          var pwdText = "123456";
          var pwdEnsureText = "1233456";
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

          // window.images()[0].buttons()["完成"].tap();
          });
     test("验证码错误",function(target,app){
          target.delay(1);
          var phoneText = "18211101020";
          var identifyText = "895634";
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
          target.tap({x:16,y:409});
          // var warning = window.staticTexts()[0].value();
          // assertEquals("请输入手机号",warning);     

         //  window.images()[0].buttons()["完成"].tap();
          });
     
     var warning = window.staticTexts()[0].value();
     if(warning == "请输入手机号"){
     
     assertEquals("手机号为空",warning,"手机号为空提醒"); 
     
     }else if(warning == "手机号格式错误"){
     
     assertEquals("手机号格式错误",warning,"手机号格式错误提醒"); 
     
     }else if(warning == "请输入正确的手机号"){
     
     assertEquals("您输入的手机号未注册，请核对后重新输入",warning,"手机号未注册提醒"); 
     
     }else if(warning == "请输入验证码"){
     
     assertEquals("请输入验证码",warning,"请输入验证码提醒"); 
     
     }else if(warning == "请输入密码"){
     
     assertEquals("请输入密码",warning,"请输入密码提醒");
     
     }else if(warning == "请输入确认密码"){
     
     assertEquals("请输入确认密码",warning,"请输入确认密码提醒"); 
     
     }else if(warning == "密码长度需不小于6位"){
     
     assertEquals("密码长度需不小于6位",warning,"密码长度需不小于6位提醒"); 
     
     }else if(warning == "两次密码输入不一致，请重新输入"){
     
     assertEquals("两次密码输入不一致，请重新输入",warning,"两次密码输入不一致，请重新输入提醒"); 
     
     }

     });




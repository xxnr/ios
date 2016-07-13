/**
 * Created by yangning on 16/6/20.
 */

// #import "assertions.js"
// #import "lang-ext.js"
// #import "uiautomation-ext.js"
// #import "screen.js"
// #import "test.js"
// #import "image_assertion.js"
#import "../lib/tuneup.js"
// #import "baseClass.js"

var target = UIATarget.localTarget();
var window = target.frontMostApp().windows()[0];
window.logElementTree();

UIATarget.onAlert = function onAlert(alert){
    var title = alert.name();
    UIALogger.logWarning("'"+title+"'");
    alert.buttons()["取消"].tap();
    return true;
}

target.delay(2);
window.logElementTree();
window.tabBar().buttons()["我的"].tap();
target.delay(3);

var phone;
var password;
function phoneAndPassword(i){
    switch (i)
    {
        case 1:
            phone = "11112223456";
            password = "1234567";
            break;
        case 2:
            phone = "18790674259";
            password = "1234567";
            break;
        case 3:
            phone = "18790674259";
            password = "";
            break;
        case 4:
            phone = "";
            password = "1234567";
            break;
        case 5:
            phone = "18711111111";
            password = "1234567";
            break;
        case 6:
            phone = "17718439071";
            password = "1234567";
            break;
    }

}
function judgelogn() {
    test("登录测试",function(target,app){

        target.delay(2);
        window.images()[0].logElementTree();
        if(window.images()[0].textFields()[0].textFields()[0].value() != "请输入您的手机号")
        {
            window.images()[0].textFields()[0].buttons()["Clear text"].tap();
        }
        if(window.images()[0].secureTextFields()[0].secureTextFields()[0].value() != "请输入您的密码")
        {
            window.images()[0].secureTextFields()[0].buttons()["Clear text"].tap();
        }

        window.images()[0].textFields()[0].textFields()[0].tap();
        window.images()[0].textFields()[0].setValue(phone);

        window.images()[0].logElementTree();
        window.images()[0].secureTextFields()[0].secureTextFields()[0].tap();
        window.images()[0].secureTextFields()[0].secureTextFields()[0].setValue(password);
        window.images()[0].buttons()["确认登录"].tap();
        // logn(phone,password);


        test("账号密码测试",function(target,app){


            var warning = window.staticTexts()[0].value();

            if(warning && window.navigationBar().staticTexts()[0].value() == "登录")
            {
                UIALogger.logMessage("登录页提示 '"+warning+"'");

                if(window.images()[0].textFields()[0].textFields()[0].value() == "请输入您的手机号")
                {
                    assertEquals("请输入手机号",warning,"用户名不能为空提醒");
                }
                else if(window.images()[0].secureTextFields()[0].secureTextFields()[0].value() == "请输入您的密码")
                {
                    assertEquals("请输入密码",warning,"密码不能为空提醒");

                }

                else if(warning == "请输入正确的手机号")
                {
                    UIALogger.logMessage("手机格式错误qqq");
                    assertEquals("手机格式错误",warning,"手机号格式出错提醒hhh");
                }
                else if(warning == "密码错误")
                {
                    assertEquals("密码错误",warning,"密码出错提醒");
                }
                else if(warning == "账号不存在")
                {
                    assertEquals("账号不存在",warning,"账号不存在提醒");
                }
                else
                {
                    UIALogger.logFail("登录页面提示有问题: '"+ warning +"'");
                }

                target.delay(1);
            }
            else
            {
                target.delay(1);
                window.logElementTree();
                var navTitle = window.navigationBar().staticTexts()[0].value();
                assertTrue(navTitle == "完善个人资料" || navTitle == "我的新农人","登录按钮跳转有问题");

                if(navTitle == "完善个人资料")
                {
                    window.buttons()["跳过"].tap();
                    target.delay(1);
                    UIALogger.logMessage("'"+window.navigationBar().staticTexts()[0].value()+"'");
                    assertTrue(window.navigationBar().staticTexts()[0].value() == "我的新农人","完善个人资料页点击“跳过”按钮跳转有误");

                }
                else(navTitle == "我的新农人")
                {

                }
            }
        });
    });
}
function logn() {
    window.tableViews()[0].images()["icon_bgView"].buttons()["登录"].tap();

    test("忘记密码？",function(target,app){
        target.delay(1);
        window.images()[0].buttons()["忘记密码?"].tap();
        window.navigationBar().buttons()["top back"].tap();
    });
    test("立即注册",function(target,app){
        target.delay(1);
        window.images()[0].buttons()[4].tap();
        window.navigationBar().buttons()["top back"].tap();
    });
    for (var i=1;i<7;i++)
    {
        phoneAndPassword(i);
        judgelogn();
    }
}

if(window.tableViews()[0].images()["icon_bgView"].buttons()[0].name() == "登录")
{
    logn();
}
else
{
    window.tableViews()[0].images()["icon_bgView"].staticTexts()[1].tap();
    target.delay(2);
    window.scrollViews()[0].buttons()["退出登录"].tap();
    target.delay(1);
    target.frontMostApp().actionSheet().collectionViews()[0].cells()["退出当前账号"].buttons()["退出当前账号"].tap();
    target.delay(2);
    logn();

}



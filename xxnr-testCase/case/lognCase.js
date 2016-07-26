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
#import "baseClass.js"

var target = UIATarget.localTarget();
var window = target.frontMostApp().windows()[0];
xxnrlogEleTree(window);

UIATarget.onAlert = function onAlert(alert){
    var title = alert.name();
    UIALogger.logWarning("'"+title+"'");
    alert.buttons()["取消"].tap();
    return true;
}

xxnrdelay(2);
xxnrlogEleTree(window);
xxnrElementClass.tab(window).mineTab().tap();
xxnrdelay(3);

var phone;
var password;
var message;
function phoneAndPassword(i){
    switch (i)
    {
        case 1:
            phone = "11112223456";
            password = "1234567";
            message ="请输入正确的手机号";
            break;
        case 2:
            phone = "18790674259";
            password = "1234567";
            message ="密码错误，请重新输入";

            break;
        case 3:
            phone = "18790674259";
            password = "";
            message ="请输入密码";

            break;
        case 4:
            phone = "";
            password = "1234567";
            message ="请输入手机号";

            break;
        case 5:
            phone = "18711111111";
            password = "1234567";
            message ="该手机号未注册，请重新输入";

            break;
        case 6:
            phone = "17718439071";
            password = "1234567";
            message ="登录成功";

            break;
    }

}
function judgelogn() {
    test("登录测试",function(target,app){
        drop_logn(phone,password,message);
       
    });
}
function logn() {
    xxnrElementClass.mine(window).loginBtn().tap();

    test("忘记密码？",function(target,app){
        xxnrdelay(1);
        xxnrElementClass.login(window).forgetPassword().tap();
        xxnrElementClass.navBack(window).tap();
    });
    test("立即注册",function(target,app){
        xxnrdelay(1);
        xxnrElementClass.login(window).register().tap();
        xxnrElementClass.navBack(window).tap();
    });

    for (var i=1;i<7;i++)
    {
        test("测试登录",function () {
            phoneAndPassword(i);
            judgelogn();
        })
    }
}

if(window.tableViews()[0].images()["icon_bgView"].buttons()[0].name() == "登录")
{
    logn();
}
else
{
    window.tableViews()[0].images()["icon_bgView"].staticTexts()[1].tap();
    xxnrdelay(2);
    window.scrollViews()[0].buttons()["退出登录"].tap();
    xxnrdelay(1);
    target.frontMostApp().actionSheet().collectionViews()[0].cells()["退出当前账号"].buttons()["退出当前账号"].tap();
    xxnrdelay(2);
    logn();

}



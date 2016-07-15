/**
 * Created by yangning on 16/6/27.
 */
#import "../lib/tuneup.js"

#import "xxnrElementClass.js"

var errorformatPhone = "11100002334";
var rightPhone = "18790674259";


var target = UIATarget.localTarget();
var window = target.frontMostApp().windows()[0];

function drop_logn(phone,password,message) {
    test("账号密码测试",function(target,app) {

        xxnrdelay(2);
        window.images()[0].logElementTree();
        if (xxnrElementClass.login(window).phone() != "请输入您的手机号") {
            xxnrElementClass.login(window).phoneClear().tap();
        }
        if (xxnrElementClass.login(window).password() != "请输入您的密码") {
            xxnrElementClass.login(window).passwordClear().tap();
        }

        xxnrElementClass.login(window).phoneTextField().tap();
        xxnrElementClass.login(window).phoneTextField().setValue(phone);

        window.images()[0].logElementTree();
        xxnrElementClass.login(window).passwordTextField().tap();
        xxnrElementClass.login(window).passwordTextField().setValue(password);
        xxnrElementClass.login(window).loginBtn().tap();

        var warning = xxnrElementClass.login(window).warningText();

        if (warning && window.navigationBar().staticTexts()[0].value() == "登录") {
            assertEquals(message, warning, "登录出错提醒");
        }

        else if (warning == " 登录成功") {
            var navTitle = window.navigationBar().staticTexts()[0].value();

            if (navTitle == "完善个人资料") {
                window.buttons()["跳过"].tap();
                xxnrdelay(1);
            }
        }
    })
}  
// function drop(method) {
//     if (target.frontMostApp().windows()[0].staticTexts()["您已在其他地方登录"].value() == "您已在其他地方登录")
//     {
//         xxnrdelay(2);
//         assertEquals("登录",window.navigationBar().staticTexts()[0].value());
//         drop_logn("18790674259","123456");
//         method();
//     }
// }
/**
 * Created by yangning on 16/6/27.
 */

var errorformatPhone = "11100002334";
var rightPhone = "18790674259";


var target = UIATarget.localTarget();
var window = target.frontMostApp().windows()[0];

function drop_logn(phone,password,message) {
    test("账号密码测试",function(target,app) {

        target.delay(2);
        window.images()[0].logElementTree();
        if (window.images()[0].textFields()[0].textFields()[0].value() != "请输入您的手机号") {
            window.images()[0].textFields()[0].buttons()["Clear text"].tap();
        }
        if (window.images()[0].secureTextFields()[0].secureTextFields()[0].value() != "请输入您的密码") {
            window.images()[0].secureTextFields()[0].buttons()["Clear text"].tap();
        }

        window.images()[0].textFields()[0].textFields()[0].tap();
        window.images()[0].textFields()[0].setValue(phone);

        window.images()[0].logElementTree();
        window.images()[0].secureTextFields()[0].secureTextFields()[0].tap();
        window.images()[0].secureTextFields()[0].secureTextFields()[0].setValue(password);
        window.images()[0].buttons()["确认登录"].tap();

        var warning = window.staticTexts()[0].value();

        if (warning && window.navigationBar().staticTexts()[0].value() == "登录") {
            assertEquals(message, warning, "登录出错提醒");
        }

        else if (warning == " 登录成功") {
            var navTitle = window.navigationBar().staticTexts()[0].value();

            if (navTitle == "完善个人资料") {
                window.buttons()["跳过"].tap();
                target.delay(1);
            }
        }
    })
}  
function drop(method) {
    if (target.frontMostApp().windows()[0].staticTexts()["您已在其他地方登录"].value() == "您已在其他地方登录")
    {
        target.delay(2);
        assertEquals("登录",window.navigationBar().staticTexts()[0].value());
        drop_logn("18790674259","123456");
        method();
    }
}
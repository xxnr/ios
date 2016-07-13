/**
 * Created by yangning on 16/6/27.
 */

 var errorformatPhone = "11100002334";
 var rightPhone = "18790674259";



var logn = function(phone,password){
    
    test("账号密码测试",function(target,app){


        var warning = window.staticTexts()[0].value();

        if(warning && window.navigationBar().staticTexts()[0].value() == "登录")
        {
            UIALogger.logMessage("登录页提示 '"+warning+"'");

            if(warning == "手机格式错误")
            {
                UIALogger.logMessage("手机格式错误qqq");
                assertEquals("手机格式错误",warning,"手机号格式出错提醒hhh");
            }
            else if(warning == "密码错误")
            {
                // target.frontMostApp().windows()[0].logElementTree();
                assertEquals("密码错误",warning,"手机号格式出错提醒");
            }
            else if(warning == "密码不能为空")
            {
                assertEquals("密码不能为空",warning,"密码不能为空");
            }
            else if(warning == "用户名不能为空")
            {
                assertEquals("用户名不能为空",warning,"用户名不能为空提醒");
            }
            else if(warning == "账号不存在")
            {
                assertEquals("账号不存在",warning,"账号不存在提醒");
            }
            else
            {
                UIALogger.logFail("登录页面提示有问题: '"+ warning +"'");
            }
}
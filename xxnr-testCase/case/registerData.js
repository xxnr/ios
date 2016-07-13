/**
 * Created by XXNR on 16/7/13.
 */






function login() {
    
    
}

var phone;
var identifyCode;
var password;
var passWordAgain;
var message;
function registerData(i) {
    switch (i)
    {
        case 0:
            phone = "";
            identifyCode = "";
            password = "";
            passWordAgain = "";
            message = "请输入手机号";
            break;
        case 1:
            phone = "12345673456";
            identifyCode = "";
            password = "";
            passWordAgain = "";
            message = "请输入正确的手机号";
            break;
        case 2:
            phone = "18211101020";
            identifyCode = "";
            password = "";
            passWordAgain = "";
            message = "该手机号已注册,请重新输入";
            break;
        case 3:
            phone = "18211105655";
            identifyCode = "";
            password = "";
            passWordAgain = "";
            message = "请输入验证码";
            break;
        case 4:
            phone = "18211101020";
            identifyCode = "123456";
            password = "";
            passWordAgain = "";
            message = "请输入密码";

            break;
        case 5:
            phone = "18211101020";
            identifyCode = "123456";
            password = "1234567";
            passWordAgain = "";
            message = "请输入确认密码";
            break;
        case 6:
            phone = "18211101020";
            identifyCode = "123456";
            password = "123";
            passWordAgain = "123";
            message = "密码需不小于6位";
            break;
        case 7:
            phone = "18211101020";
            identifyCode = "123456";
            password = "1234567";
            passWordAgain = "123456";
            message = "两次密码输入不一致，请重新输入";
            break;
        case 8:
            phone = "18211101020";
            identifyCode = "123456";
            password = "123456";
            passWordAgain = "123456";
            message = "请同意网站使用协议";
            break;
    }
}

function forgetPwdData(i) {
    switch (i)
    {
        case 0:
            phone = "";
            identifyCode = "";
            password = "";
            passWordAgain = "";
            message = "请输入手机号";
            break;
        case 1:
            phone = "12345673456";
            identifyCode = "";
            password = "";
            passWordAgain = "";
            message = "请输入正确的手机号";
            break;
        case 2:
            phone = "18211101024";
            identifyCode = "";
            password = "";
            passWordAgain = "";
            message = "该手机号未注册,请重新输入";
            break;
        case 3:
            phone = "18211105655";
            identifyCode = "";
            password = "";
            passWordAgain = "";
            message = "请输入验证码";
            break;
        case 4:
            phone = "18211101020";
            identifyCode = "123456";
            password = "";
            passWordAgain = "";
            message = "请输入密码";

            break;
        case 5:
            phone = "18211101020";
            identifyCode = "123456";
            password = "1234567";
            passWordAgain = "";
            message = "请输入确认密码";
            break;
        case 6:
            phone = "18211101020";
            identifyCode = "123456";
            password = "123";
            passWordAgain = "123";
            message = "密码需不小于6位";
            break;
        case 7:
            phone = "18211101020";
            identifyCode = "123456";
            password = "1234567";
            passWordAgain = "123456";
            message = "两次密码输入不一致，请重新输入";
            break;
        case 8:
            phone = "18211101020";
            identifyCode = "123456";
            password = "123456";
            passWordAgain = "123456";
            message = "验证码输入错误";
            break;
    }

}
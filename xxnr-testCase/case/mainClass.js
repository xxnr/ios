/**
 * Created by XXNR on 16/7/18.
 */


function login(phone,password) {
    window.tableViews()[0].images()["icon_bgView"].buttons()["登录"].tap();
    
    window.images()[0].textFields()[0].textFields()[0].tap();
    window.images()[0].textFields()[0].setValue(phone);

    window.images()[0].secureTextFields()[0].secureTextFields()[0].tap();
    window.images()[0].secureTextFields()[0].secureTextFields()[0].setValue(password);
    window.images()[0].buttons()["确认登录"].tap();
    target.delay(2);


}

/**
 * Created by yangning on 16/6/22.
 */

//#import "assertions.js"
//#import "lang-ext.js"
//#import "uiautomation-ext.js"
//#import "screen.js"
//#import "test.js"
//#import "image_assertion.js"

// for (var i=0;i<2;i++){
//     while(!target.frontMostApp().windows()[0].navigationBar().staticTexts()[0].value() == "新新农人")
//     {
//         UIALogger.logMessage("skjslkfjajf");
//         target.frontMostApp().windows()[0].navigationBar().buttons()["top back"].tap();
//     }
//     account(i);
// }
//function account(number) {


var errorformatPhone = "11100002334";

var rightPhone = "188";
for (var i = 0; i < 8; i++) {
    var random = Math.floor(Math.random() * 10).toString();

    rightPhone = rightPhone + random;
}


var num = 1;
var target = UIATarget.localTarget();
var window = target.frontMostApp().windows()[0];


window.collectionViews()[0].buttons()[5].tap();
window.tableViews()[0].cells()[1].tap();
window.buttons()["立即购买"].tap();
window.buttons()["确定"].tap();

// target.frontMostApp().windows()[0].collectionViews()[0].buttons()[5].tap();
// target.frontMostApp().windows()[0].tableViews()[0].tapWithOptions({tapOffset:{x:0.43, y:0.93}});
// target.frontMostApp().windows()[0].buttons()["立即购买"].tap();
// target.frontMostApp().windows()[0].buttons()["确定"].tap();


if (window.tableViews()[0].buttons()["配送到户"].isVisible()) {
    num = 0;
    test("配送到户", function (target, app) {
        target.delay(2);
        window.tableViews()[0].buttons()["配送到户"].tap();
        target.delay(1);
        //window.buttons()[0].tap();
        target.delay(1);

        var address = window.tableViews()[0].staticTexts()[3].value();

        UIALogger.logMessage("'" + address + "'");
        window.tableViews()[0].buttons()[4].tap();
        target.delay(1);
        var selAddress;
        if (window.tableViews()[0].cells().length > 0) {
            selAddress = window.tableViews()[0].cells()[0].staticTexts()[1].value();
            for (var i = 0; i < window.tableViews()[0].cells().length; i++) {
                if (window.tableViews()[0].cells()[i].staticTexts()["默认"]) {
                    selAddress = window.tableViews()[0].cells()[i].staticTexts()[1].value();
                    break;
                }
            }
            assertTrue(address == selAddress, "显示地址出错");
        }
        window.navigationBar().buttons()["添加"].tap();
        target.delay(1);
        assertEquals("添加收货地址", window.navigationBar().staticTexts()[0].value(), "跳转添加收货地址失败");
        window.navigationBar().buttons()["top back"].tap();

        if (window.tableViews()[0].cells().length > 0) {
            window.tableViews()[0].cells()[0].buttons()[1].tap();
            target.delay(1);
            assertEquals("编辑收货地址", window.navigationBar().staticTexts()[0].value(), "跳转编辑收货地址失败");
            window.navigationBar().buttons()["top back"].tap();

            window.tableViews()[0].cells()[0].buttons()[2].tap();
            target.delay(1);
            window.buttons()["取消"].tap();

            window.tableViews()[0].cells()[0].buttons()[2].tap();
            target.delay(1);
            window.buttons()[2].doubleTap();
        }

        target.delay(3);

        var cellCount = 0;
        cellCount = window.tableViews()[0].cells().length;
        window.navigationBar().buttons()["添加"].tap();

        test("收件人姓名为空",function () {
            window.textFields()[1].textFields()[0].tap();
            window.textFields()[1].textFields()[0].setValue("18933334444");
            window.buttons()[0].tap();
            window.pickers()[0].wheels()[1].scrollToVisible();
            window.pickers()[0].wheels()[2].scrollToVisible();
            window.buttons()[3].tap();
            window.buttons()[1].tap();
            window.pickers()[0].wheels()[0].scrollToVisible();
            window.buttons()[3].tap();

            window.textFields()[2].textFields()[0].tap();
            window.textFields()[2].textFields()[0].setValue("详细地址");
            window.logElementTree();
            window.buttons()["保存"].tap();
            assertEquals("请填写收件人姓名",window.staticTexts()[7].value());

        })
        test("手机号为空",function () {
            window.textFields()[0].textFields()[0].tap();
            window.textFields()[0].textFields()[0].setValue("hh");

            window.textFields()[1].textFields()[0].tap();
            window.textFields()[1].textFields()[0].setValue("");
            window.buttons()["保存"].tap();
            window.logElementTree();
            assertEquals("请填写收件人手机号",window.staticTexts()[7].value());

        })

        test("手机号格式错误",function () {
            window.textFields()[1].textFields()[0].tap();
            window.textFields()[1].textFields()[0].setValue("111111");
            window.buttons()["保存"].tap();
            window.logElementTree();
            assertEquals("请填写正确的手机号",window.staticTexts()[7].value());
        })
        test("详细地址为空",function () {
            window.textFields()[1].textFields()[0].tap();
            window.textFields()[1].textFields()[0].setValue("18899992222");
            window.textFields()[2].textFields()[0].tap();
            window.textFields()[2].textFields()[0].setValue("");
            window.buttons()["保存"].tap();
            assertEquals("请填写详细地址",window.staticTexts()[7].value());
        })
        test("信息完善",function () {
            window.textFields()[2].textFields()[0].tap();
            window.textFields()[2].textFields()[0].setValue("豫苑路天明城");
            window.buttons()["保存"].tap();

            target.delay(1);
            UIALogger.logMessage("cellCount:'" + cellCount + "'");
            UIALogger.logMessage("window.tableViews()[0].cells().length:'" + window.tableViews()[0].cells().length + "'");

            assertTrue(window.tableViews()[0].cells().length == cellCount + 1, "保存没有成功");

            window.navigationBar().buttons()["top back"].tap();
        })


    });
}
test("网点自提", function (target, app) {
    target.delay(2);
    window.tableViews()[0].buttons()["网点自提"].tap();
    UIALogger.logMessage("dddddd:'" + window.tableViews()[0].buttons()[2] + "'");

    window.buttons()[0].tap();
    window.logElementTree();

    test("选择自提网点", function () {
        target.delay(2);
        window.tableViews()[0].buttons()[2 - num].tap();
        target.delay(1);
        window.logElementTree();
        target.delay(1);

        test("区的不可选", function () {
            window.buttons()[0].tap();
            window.buttons()[1].tap();
            target.delay(2);
            target.frontMostApp().windows()[0].tableViews()[1].tapWithOptions({tapOffset: {x: 0.30, y: 0.04}});

            assertEquals(0, window.buttons()[2].isEnabled());
        })

        test("区的可选", function () {
            window.buttons()[0].tap();
            window.buttons()[1].tap();
            if (window.tableViews()[0].cells().length > 1) {
                target.delay(2);
                target.frontMostApp().windows()[0].tableViews()[1].tapWithOptions({tapOffset: {x: 0.50, y: 0.10}});
            }

            assertEquals(1, window.buttons()[2].isEnabled());
        })

        test("选择一个网点", function () {

            target.frontMostApp().windows()[0].buttons()["确定"].tap();
            assertEquals("选择自提网点", window.navigationBar().staticTexts()[0].value());

            var count = window.tableViews()[1].cells().length;
            if (count > 0) {
                target.frontMostApp().windows()[0].tableViews()[1].dragInsideWithOptions({
                    startOffset: {
                        x: 0.49,
                        y: 0.0
                    }, endOffset: {x: 0.60, y: 0.70}, duration: 1.0
                });
                target.frontMostApp().windows()[0].tableViews()[1].cells()[0].tap();
                target.frontMostApp().windows()[0].buttons()["确定"].tap();
            }
        })


    })


    test("填写收货人信息", function () {
        window.tableViews()[0].buttons()[3 - num].tap();
        target.delay(1);

        window.buttons()[0].tap();
        window.logElementTree();
        assertEquals("选择收货人", window.navigationBar().staticTexts()[0].value());

        window.textFields()[0].textFields()[0].setValue("haha");
        window.buttons()[0].tap();
        assertEquals("选择收货人", window.navigationBar().staticTexts()[0].value());

        window.textFields()[0].textFields()[0].setValue("haha");
        window.textFields()[1].textFields()[0].setValue(errorformatPhone);
        window.buttons()[0].tap();
        assertEquals("选择收货人", window.navigationBar().staticTexts()[0].value());

        window.textFields()[1].textFields()[0].setValue(rightPhone);
        window.buttons()[0].tap();
        target.delay(2);
        assertEquals("提交订单", window.navigationBar().staticTexts()[0].value());
    })

    test("已注册的用户", function () {
        window.tableViews()[0].buttons()[3 - num].tap();

        window.textFields()[0].textFields()[0].setValue("haha");
        window.textFields()[1].textFields()[0].setValue(rightPhone);
        window.buttons()[0].tap();
        assertEquals("选择收货人", window.navigationBar().staticTexts()[0].value());
    })


    test("选择历史收货人", function () {
        target.delay(2);
        var count = window.tableViews()[0].cells().length;

        for (var i = 0; i < 3; i++) {
            target.delay(2);
            window.tableViews()[0].cells()[i].tap();
            assertEquals("提交订单", window.navigationBar().staticTexts()[0].value());
            window.tableViews()[0].buttons()[3 - num].tap();
        }
        window.navigationBar().buttons()["top back"].tap();
    })

    window.buttons()[0].tap();
    target.delay(2);
    window.logElementTree();
});


/**
 * Created by yangning on 16/6/22.
 */


//#import "assertions.js"
//#import "lang-ext.js"
//#import "uiautomation-ext.js"
//#import "screen.js"
//#import "test.js"
//#import "image_assertion.js"


#import "baseClass.js"


var errorformatPhone = "11100002334";

var rightPhone = "188";
for (var i = 0; i < 8; i++) {
    var random = Math.floor(Math.random() * 10).toString();

    rightPhone = rightPhone + random;
}

var target = UIATarget.localTarget();
var window = target.frontMostApp().windows()[0];

Aa();

function Aa() {
    xxnrdelay(2);
    xxnrElementClass.home(window).fer_specialBtn().tap();
    xxnrElementClass.special(window).cell(1).tap();
    xxnrElementClass.goodDetail(window).purchaseBtn().tap();
    xxnrElementClass.goodDetail(window).addShoppingCar_sure().tap();
    

    if (xxnrElementClass.submitOrder(window).dispatchBtn().isVisible()) {
        test("配送到户", function (target, app) {
            xxnrdelay(2);
            xxnrElementClass.submitOrder(window).dispatchBtn().tap();
            xxnrdelay(1);
            //window.buttons()[0].tap();
            xxnrdelay(1);

            var address = xxnrElementClass.submitOrder(window).addressText().value();
            xxnrlogMessage("'" + address + "'");
            xxnrElementClass.submitOrder(window).addressBtn().tap();
            xxnrdelay(1);
            var selAddress;
            if (xxnrElementClass.receiveAddress(window).cells().length > 0) {
                selAddress = xxnrElementClass.receiveAddress(window).name(0).value();
                for (var i = 0; i < xxnrElementClass.receiveAddress(window).cells()　.length; i++) {
                    if (xxnrElementClass.receiveAddress(window).acquiescent(0)) {
                        selAddress = xxnrElementClass.receiveAddress(window).name(i).value();
                        break;
                    }
                }
                assertTrue(address == selAddress, "显示地址出错");
            }
            window.navigationBar().buttons()["添加"].tap();
            xxnrdelay(1);
            assertEquals("添加收货地址", xxnrElementClass.navTitle(window), "跳转添加收货地址失败");
            xxnrElementClass.navBack(window).tap();

            if (xxnrElementClass.receiveAddress(window).cells()　.length > 0) {
                xxnrElementClass.receiveAddress(window).editBtn(0).tap();
                xxnrdelay(1);
                assertEquals("编辑收货地址", xxnrElementClass.navTitle(window), "跳转编辑收货地址失败");
                xxnrElementClass.navBack(window).tap();

                xxnrElementClass.receiveAddress(window).deletebtn(0).tap();
                xxnrdelay(1);

                xxnrElementClass.receiveAddress(window).cancelBtn().tap();
                xxnrdelay(1);

                xxnrElementClass.receiveAddress(window).deletebtn(0).tap();

                xxnrdelay(1);
                xxnrElementClass.receiveAddress(window).makeSureBtn().doubleTap();
            }

            xxnrdelay(3);

            var cellCount = 0;
            cellCount = xxnrElementClass.receiveAddress(window).cells().length;
            xxnrElementClass.receiveAddress(window).navAppendBtn().tap();

            test("收件人姓名为空", function () {
                xxnrElementClass.addAddress(window).phoneTextField().tap();
                xxnrElementClass.addAddress(window).phoneTextField().setValue("18933334444");
                xxnrElementClass.addAddress(window).cityBtn().tap();
                window.pickers()[0].wheels()[1].scrollToVisible();
                window.pickers()[0].wheels()[2].scrollToVisible();
                xxnrElementClass.addAddress(window).makeSure().tap();
                xxnrElementClass.addAddress(window).townBtn().tap();
                window.pickers()[0].wheels()[0].scrollToVisible();
                xxnrElementClass.addAddress(window).makeSure().tap();

                xxnrElementClass.addAddress(window).detailAdressTextField().tap();
                xxnrElementClass.addAddress(window).detailAdressTextField().setValue("详细地址");
                xxnrlogEleTree(window);
                xxnrElementClass.addAddress(window).saveBtn().tap();
                assertEquals("请填写收件人姓名", xxnrElementClass.addAddress(window).warning());

            })
            test("手机号为空", function () {
                xxnrElementClass.addAddress(window).nameTextField().tap();
                xxnrElementClass.addAddress(window).nameTextField().setValue("hh");

                xxnrElementClass.addAddress(window).phoneTextField().tap();
                xxnrElementClass.addAddress(window).phoneTextField().setValue("");
                xxnrElementClass.addAddress(window).saveBtn().tap();
                xxnrlogEleTree(window);
                assertEquals("请填写收件人手机号", xxnrElementClass.addAddress(window).warning());

            })

            test("手机号格式错误", function () {
                xxnrElementClass.addAddress(window).phoneTextField().tap();
                xxnrElementClass.addAddress(window).phoneTextField().setValue("111111");
                xxnrElementClass.addAddress(window).saveBtn().tap();
                xxnrlogEleTree(window);
                assertEquals("请填写正确的手机号", xxnrElementClass.addAddress(window).warning());
            })
            test("详细地址为空", function () {
                xxnrElementClass.addAddress(window).phoneTextField().tap();
                xxnrElementClass.addAddress(window).phoneTextField().setValue("18899992222");
                xxnrElementClass.addAddress(window).detailAdressTextField().tap();
                xxnrElementClass.addAddress(window).detailAdressTextField().setValue("");
                xxnrElementClass.addAddress(window).saveBtn().tap();
                assertEquals("请填写详细地址", xxnrElementClass.addAddress(window).warning());
            })
            test("信息完善", function () {
                xxnrElementClass.addAddress(window).detailAdressTextField().tap();
                xxnrElementClass.addAddress(window).detailAdressTextField().setValue("豫苑路天明城");
                xxnrElementClass.addAddress(window).saveBtn().tap();

                xxnrdelay(1);
                xxnrlogMessage("cellCount:'" + cellCount + "'");
                xxnrlogMessage("window.tableViews()[0].cells().length:'" + window.tableViews()[0].cells().length + "'");

                assertTrue(xxnrElementClass.receiveAddress(window).cells().length == cellCount + 1, "保存没有成功");

                xxnrdelay(1);
                xxnrElementClass.navBack(window).tap();
            })


        });
    }
        
    
    test("网点自提", function (target, app) {
        xxnrdelay(2);
        xxnrElementClass.submitOrder(window).carryBtn().tap();

        xxnrlogEleTree(window);

        test("选择自提网点", function () {
            xxnrdelay(2);
            xxnrElementClass.submitOrder(window).selWebsiteBtn().tap();
            xxnrdelay(1);
            xxnrlogEleTree(window);
            xxnrdelay(1);

            test("区的不可选", function () {

                // window.buttons()[0].tap();
                // window.buttons()[1].tap();
                // xxnrdelay(2);
                // // window.tableViews()[1].tapWithOptions({tapOffset: {x: 0.30, y: 0.04}});

                assertEquals(0, xxnrElementClass.selWebsite(window).areaBtn().isEnabled());

            })

            test("区的可选", function () {
                xxnrElementClass.selWebsite(window).proviceBtn().tap();
                xxnrElementClass.selWebsite(window).cityBtn().tap();
                xxnrdelay(2);
                
                if (xxnrElementClass.selWebsite(window).cityCells().length > 1) {
                    xxnrdelay(2);
                    window.tableViews()[1].tapWithOptions({tapOffset: {x: 0.50, y: 0.10}});
                }

                assertEquals(1, xxnrElementClass.selWebsite(window).areaBtn().isEnabled());
            })

            test("选择一个网点", function () {

                xxnrElementClass.selWebsite(window).makeSureBtn().tap();
                assertEquals("选择自提网点", xxnrElementClass.navTitle(window));

                var count = xxnrElementClass.selWebsite(window).webSiteCells().length;
                if (count > 0) {
                    xxnrElementClass.selWebsite(window).webSiteTableView().dragInsideWithOptions({
                        startOffset: {
                            x: 0.49,
                            y: 0.0
                        }, endOffset: {x: 0.60, y: 0.70}, duration: 1.0
                    });
                    xxnrElementClass.selWebsite(window).webSiteCell(0).tap();
                    xxnrElementClass.selWebsite(window).makeSureBtn().tap();
                }
            })


        })


        test("填写收货人信息", function () {
            xxnrElementClass.submitOrder(window).selContactBtn().tap();
            xxnrdelay(1);

            xxnrElementClass.selContact(window).makeSureBtn().tap();
            xxnrElementClass.selContact(window).makeSureBtn().tap();
            xxnrlogEleTree(window);
            assertEquals("选择收货人", xxnrElementClass.navTitle(window));

            xxnrElementClass.selContact(window).nameTextField().setValue("haha");
            xxnrElementClass.selContact(window).makeSureBtn().tap();
            assertEquals("选择收货人", xxnrElementClass.navTitle(window));

            xxnrElementClass.selContact(window).nameTextField().setValue("haha");
            xxnrElementClass.selContact(window).phoneTextField().setValue(errorformatPhone);
            xxnrElementClass.selContact(window).makeSureBtn().tap();
            assertEquals("选择收货人", xxnrElementClass.navTitle(window));

            xxnrElementClass.selContact(window).phoneTextField().setValue(rightPhone);
            xxnrElementClass.selContact(window).makeSureBtn().tap();
            xxnrdelay(2);
            assertEquals("提交订单", xxnrElementClass.navTitle(window));
        })

        test("已注册的用户", function () {
            xxnrElementClass.submitOrder(window).selContactBtn().tap();

            xxnrElementClass.selContact(window).nameTextField().setValue("haha");
            xxnrElementClass.selContact(window).phoneTextField().setValue(rightPhone);
            xxnrElementClass.selContact(window).makeSureBtn().tap();
            assertEquals("选择收货人", xxnrElementClass.navTitle(window));
        })


        test("选择历史收货人", function () {
            xxnrdelay(2);
            var count = xxnrElementClass.selContact(window).contactCells().length;

            for (var i = 0; i < 3; i++) {
                xxnrdelay(2);
                xxnrElementClass.selContact(window).contactCell(i).tap();
                assertEquals("提交订单", xxnrElementClass.navTitle(window));
                xxnrElementClass.submitOrder(window).selContactBtn().tap();
            }
            xxnrElementClass.navBack(window).tap();
        })
        
        xxnrElementClass.submitOrder(window).submitOrderBtn().tap();
        xxnrdelay(2);
        xxnrlogEleTree(window);
    });

}

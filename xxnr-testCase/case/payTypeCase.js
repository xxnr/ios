/**
 * Created by yangning on 16/6/24.
 */

//#import "../lib/tuneup.js"

var target = UIATarget.localTarget();
// target.delay(2);
// target.frontMostApp().windows()[0].tabBar().buttons()["购物车"].tap();
// target.frontMostApp().windows()[0].staticTexts()["合计: ￥0.00"].tapWithOptions({tapOffset:{x:0.08, y:0.48}});
//
// target.frontMostApp().windows()[0].buttons()["去结算(2)"].tap();
// target.delay(2);
// target.frontMostApp().windows()[0].logElementTree();
// target.frontMostApp().windows()[0].tableViews()[0].buttons()[2].tap();
// target.frontMostApp().windows()[0].tableViews()[1].cells()[0].tap();
// target.frontMostApp().windows()[0].buttons()["确定"].tap();
//
// target.frontMostApp().windows()[0].buttons()[0].tap();


var holdMoney_num;
var fullMoney_num;
var splitMoney_num;
var detailMoney_num;
var extentMoney_num;
test("是否拆分订单",function () {
    target.delay(2);

    if (target.frontMostApp().windows()[0].navigationBar().staticTexts()[0].value() == "选择支付订单")
    {
        UIALogger.logMessage("kajds;fajkfd");
        target.frontMostApp().windows()[0].logElementTree();
        assertEquals(2,target.frontMostApp().windows()[0].buttons().length);
        target.frontMostApp().windows()[0].buttons()[0].tap();
        target.delay(2);
        assertEquals("支付方式",target.frontMostApp().windows()[0].navigationBar().staticTexts()[0].value());
    }
})
test("全额支付",function (target,app) {
    target.delay(2);

    target.frontMostApp().windows()[0].collectionViews()[0].buttons()[5].tap();
    target.frontMostApp().windows()[0].tableViews()[0].tapWithOptions({tapOffset:{x:0.43, y:0.93}});
    target.frontMostApp().windows()[0].buttons()["立即购买"].tap();
    target.frontMostApp().windows()[0].buttons()["确定"].tap();
    target.frontMostApp().windows()[0].tableViews()[0].buttons()[2].tap();
    target.frontMostApp().windows()[0].tableViews()[1].cells()[0].tap();
    target.frontMostApp().windows()[0].buttons()["确定"].tap();
    target.frontMostApp().windows()[0].buttons()["提交订单(1)"].tap();
    target.delay(2);
    target.frontMostApp().windows()[0].logElementTree();
    target.frontMostApp().windows()[0].buttons()["全额支付"].tap();
    assertEquals(1,target.frontMostApp().windows()[0].buttons()[6].isVisible());
})
test("分次支付",function () {
    target.frontMostApp().windows()[0].buttons()["分次支付"].tap();

    assertEquals(0,target.frontMostApp().windows()[0].buttons()[6].isVisible());
})
test("再次点击全额支付",function () {
    target.frontMostApp().windows()[0].buttons()["全额支付"].tap();
    assertEquals(1,target.frontMostApp().windows()[0].buttons()[6].isVisible());
})

test("全额支付金额显示",function () {
    target.frontMostApp().windows()[0].buttons()["全额支付"].tap();

    var holdMoneyStr = target.frontMostApp().windows()[0].staticTexts()[1].value();
    var holdMoney = holdMoneyStr.substr(5,holdMoneyStr.length-6);
    holdMoney_num = parseFloat(holdMoney);

    var fullMoneyStr = target.frontMostApp().windows()[0].staticTexts()[5].value();
    var fullMoney = fullMoneyStr.substr(1,fullMoneyStr.length-1);
    fullMoney_num = parseFloat(fullMoney);
    assertEquals(holdMoney_num,fullMoney_num,"全额支付显示金额有误");
})
test("分次支付金额显示",function () {
    target.frontMostApp().windows()[0].buttons()["分次支付"].tap();

    var detailMoneyStr = target.frontMostApp().windows()[0].staticTexts()[7].value();
    var detailMoney = detailMoneyStr.substr(19,detailMoneyStr.length-30);
    detailMoney_num = parseFloat(detailMoney);

    var splitMoneyStr = target.frontMostApp().windows()[0].staticTexts()[6].value();
    var splitMoney = splitMoneyStr.substr(1,splitMoneyStr.length-1);
    splitMoney_num = parseFloat(splitMoney);
    if (holdMoney_num > detailMoney_num){
        assertEquals(detailMoney_num,splitMoney_num,"分次支付显示金额有误,应显示'"+detailMoney_num+"'");
    }
    else
    {
        assertEquals(holdMoney_num,splitMoney_num,"分次支付显示金额有误,应显示'"+holdMoney_num+"'");
    }
})
test("分次支付加减按钮显示",function () {
    if (holdMoney_num <= detailMoney_num)
    {
        assertEquals(0,target.frontMostApp().windows()[0].buttons()[2].isEnabled());
        assertEquals(0,target.frontMostApp().windows()[0].buttons()[3].isEnabled());
    }
    else if (holdMoney_num > detailMoney_num && splitMoney_num == detailMoney_num)
    {
        assertEquals(0,target.frontMostApp().windows()[0].buttons()[2].isEnabled());
        assertEquals(1,target.frontMostApp().windows()[0].buttons()[3].isEnabled());
    }
    else if (holdMoney_num > splitMoney_num && splitMoney_num > detailMoney_num)
    {
        assertEquals(1,target.frontMostApp().windows()[0].buttons()[2].isEnabled());
        assertEquals(1,target.frontMostApp().windows()[0].buttons()[3].isEnabled());
    }
    else if (holdMoney_num <= splitMoney_num)
    {
        assertEquals(1,target.frontMostApp().windows()[0].buttons()[2].isEnabled());
        assertEquals(0,target.frontMostApp().windows()[0].buttons()[3].isEnabled());
    }
})
test("分次支付加号按钮操作",function () {

    var extentStr = target.frontMostApp().windows()[0].staticTexts()[7].value();
    var extentMoney = extentStr.substr(10,3);
    extentMoney_num = parseFloat(extentMoney);

    while (target.frontMostApp().windows()[0].buttons()[3].isEnabled() == 1) {
        target.frontMostApp().windows()[0].buttons()[3].tap();

        target.delay(1);

        var nowsplitMoneyStr = target.frontMostApp().windows()[0].staticTexts()[6].value();
        var nowsplitMoney = nowsplitMoneyStr.substr(1,nowsplitMoneyStr.length-1);
        var nowsplitMoney_num = parseFloat(nowsplitMoney);

        UIALogger.logMessage("'"+extentMoney_num+"'");

        UIALogger.logMessage("'"+parseFloat(splitMoney_num+extentMoney_num)+"'");
        UIALogger.logMessage("'"+holdMoney_num+"'");

        if (parseFloat(splitMoney_num+extentMoney_num)<holdMoney_num) {
            UIALogger.logMessage("if");

            assertEquals(parseFloat(splitMoney_num+extentMoney_num).toFixed(2), nowsplitMoney_num);
        }
        else
        {
            UIALogger.logMessage("else");

            target.delay(2);
            assertEquals(holdMoney_num, nowsplitMoney_num);
            assertEquals(0,target.frontMostApp().windows()[0].buttons()[3].isEnabled());
        }
        splitMoney_num = nowsplitMoney_num;
    }
})

test("分次支付按钮减号操作",function () {

    var splitMoneyStr = target.frontMostApp().windows()[0].staticTexts()[6].value();
    var splitMoney = splitMoneyStr.substr(1,splitMoneyStr.length-1);
    splitMoney_num = parseFloat(splitMoney);

    while (target.frontMostApp().windows()[0].buttons()[2].isEnabled() == 1) {
        target.frontMostApp().windows()[0].buttons()[2].tap();

        target.delay(1);

        var nowsplitMoneyStr = target.frontMostApp().windows()[0].staticTexts()[6].value();
        var nowsplitMoney = nowsplitMoneyStr.substr(1,nowsplitMoneyStr.length-1);
        var nowsplitMoney_num = parseFloat(nowsplitMoney);

        UIALogger.logMessage("'"+splitMoney_num+"'");

        UIALogger.logMessage("'"+extentMoney_num+"'");
        UIALogger.logMessage("'"+parseFloat(parseFloat(splitMoney_num)-parseFloat(extentMoney_num))+"'");

        if (parseFloat(splitMoney_num-extentMoney_num)>detailMoney_num) {
            assertEquals(parseFloat(splitMoney_num-extentMoney_num).toFixed(2), nowsplitMoney_num);
        }
        else
        {
            target.delay(2);
            assertEquals(detailMoney_num, nowsplitMoney_num);
            assertEquals(0,target.frontMostApp().windows()[0].buttons()[2].isEnabled());
        }
        splitMoney_num = nowsplitMoney_num;

    }

})
test("选择支付方式",function () {
    target.frontMostApp().windows()[0].buttons()["全额支付"].tap();

    target.frontMostApp().windows()[0].buttons()[5].tap();
    target.frontMostApp().windows()[0].buttons()[6].tap();
    target.frontMostApp().windows()[0].buttons()[4].tap();

    target.frontMostApp().windows()[0].buttons()[6].tap();
    target.delay(1);
    target.frontMostApp().windows()[0].buttons()["去支付"].tap();
    target.delay(2);
    assertEquals("线下支付",target.frontMostApp().windows()[0].navigationBar().staticTexts()[0].value());


})
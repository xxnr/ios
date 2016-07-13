/**
 * Created by yangning on 16/6/28.
 */

#import "../lib/tuneup.js"

var errorformatPhone = "11100002334";
var rightPhone = "18790674259";
var addPhone = "188";
for(var i=0;i<8;i++)
{
    var num = Math.floor(Math.random()*10).toString();

    addPhone = addPhone + num;
}
UIALogger.logMessage("'"+addPhone+"'");

var register;

var target = UIATarget.localTarget();
var window = target.frontMostApp().windows()[0];


test("新农代表tab的点击",function(){
    window.tabBar().buttons()["我的"].tap();
    window.tableViews()[0].cells()[1].tap();

    window.buttons()["我的代表"].tap();
    target.delay(2);

    if (window.buttons()["客户登记"])
    {
        window.buttons()["客户登记"].tap();
    }
})
test("我的客户 下拉刷新",function(){
    target.delay(2);
    window.buttons()["我的客户"].tap();
    target.delay(2);

    window.buttons()["我的客户"].dragInsideWithOptions({startOffset:{x:0.74, y:-3.54}, endOffset:{x:0.83, y:0.99}});
    target.delay(2);
    var label = window.tableViews()[0].staticTexts()[0].value();
    var numStr = label.substr(3,label.length-6);

    var num = parseInt(numStr);
    var count = window.tableViews()[0].cells().length;
    assertEquals(num,count);
})
test("我的客户  上滑加载",function(){
    //target.dragFromToForDuration({x:209.00, y:487.50}, {x:237.50, y:21.00}, 1.4);

    if (window.tableViews()[0].cells().length > 0)
    {
        var label = window.tableViews()[0].staticTexts()[0].value();
        var numStr = label.substr(3,label.length-6);

        var num = parseInt(numStr);
        var count = Math.floor(num/10);

        UIALogger.logMessage("'"+count+"'");

        for (var i=0;i<count;i++)
        {
            target.dragFromToForDuration({x:209.00, y:487.50}, {x:237.50, y:21.00}, 1.4);
            target.dragFromToForDuration({x:209.00, y:487.50}, {x:237.50, y:21.00}, 1.4);

            target.delay(2);
            window.tableViews()[0].visibleCells()[0].tap();
            target.delay(2);
            window.logElementTree();
            window.navigationBar().buttons()["top back"].tap();
        }
    }
})

test("我的客户 邀请好友数",function(){

    if (window.tableViews()[0].cells().length > 0)
    {
        window.logElementTree();
        var label = window.tableViews()[0].staticTexts()[0].value();
        var numStr = label.substr(3,label.length-6);

        var num = parseFloat(numStr);
        var count = window.tableViews()[0].cells().length;
        assertEquals(num,count);
        UIALogger.logMessage("'"+window.staticTexts()[0].isVisible()+"'");
        assertEquals(0,window.staticTexts()[0].isVisible());
    }
    else
    {
        assertEquals(1,window.staticTexts()[0].isVisible());
    }

})
test("我的客户 客户详情",function(){
    window.buttons()["我的客户"].tap();
    if (window.tableViews()[0].cells().length > 0){
        window.tableViews()[0].cells()[1].tap();
        target.delay(2);
        assertEquals("客户订单",window.navigationBar().staticTexts()[0].value());
        window.navigationBar().buttons()["top back"].tap();
        window.tableViews()[0].cells()[2].tap();
        target.delay(2);
        assertEquals("客户订单",window.navigationBar().staticTexts()[0].value());
        window.navigationBar().buttons()["top back"].tap();
    }

})

test("我的代表",function () {
    window.buttons()["我的代表"].tap();
    target.delay(2);
    window.logElementTree();
    if (window.buttons()["添加"].isVisible())
    {
        UIALogger.logMessage("没有添加新农代表");
    }
    else
    {
        UIALogger.logMessage("有新农代表");
    }
})
if (window.buttons()["客户登记"])
{
    test("客户登记 查看客户详情",function () {
        window.buttons()["客户登记"].tap();
        target.delay(2);
        window.logElementTree();

        if (window.tableViews()[1].cells().length > 0)
        {
            var label = window.staticTexts()[1].value();
            var numStr = label.substr(3,label.length-6);

            var num = parseInt(numStr);
            var count = Math.floor(num/10);
            for (var i=0;i<count;i++)
            {
                target.dragFromToForDuration({x:255.00, y:442.00}, {x:261.50, y:70.50}, 0.6);
                target.dragFromToForDuration({x:255.00, y:442.00}, {x:261.50, y:70.50}, 0.6);

                target.delay(2);
                window.tableViews()[1].visibleCells()[1].tap();
                target.delay(2);
                window.logElementTree();

                register = window.staticTexts()[3].value();
                window.logElementTree();
                window.navigationBar().buttons()["top back"].tap();
            }
        }
    })

    test("客户登记 显示与实际数量",function () {
        if (window.tableViews()[1].cells().length > 0)
        {
            window.logElementTree();
            var label = window.staticTexts()[1].value();
            var numStr = label.substr(3,label.length-6);

            var num = parseFloat(numStr);
            var count = window.tableViews()[1].cells().length;
            assertEquals(num,count);
        }
    })
    test("客户登记  今日添加",function () {
        var label = window.staticTexts()[2].value();
        var numStr = label.substr(6,label.length-7);
        var num = parseInt(numStr);
        if (num > 0){
            assertEquals(1,window.buttons()[0].isEnabled());
        }
        else
        {
            assertEquals(0,window.buttons()[0].isEnabled());
        }
    })
    test("添加潜在客户",function () {

        var oldcells = window.tableViews()[1].cells().length;

        var totallabel = window.staticTexts()[1].value();
        var totalnumStr = totallabel.substr(3,totallabel.length-6);
        var totalnum = parseFloat(totalnumStr);

        var todaylabel = window.staticTexts()[2].value();
        var todaynumStr = todaylabel.substr(6,todaylabel.length-7);
        var todaynum = parseFloat(todaynumStr);

        UIALogger.logMessage("'"+register+"'");

        window.buttons()[0].tap();
        test("没有信息",function () {
            window.buttons()["保存"].tap();
            window.logElementTree();

            assertNotNull(window.staticTexts()["请完善信息"]);
        })
        test("没有选择城市",function () {
            window.logElementTree();

            window.textFields()[0].textFields()[0].tap();
            window.textFields()[0].textFields()[0].setValue("na");

            window.textFields()[1].textFields()[0].tap();
            window.textFields()[1].textFields()[0].setValue(rightPhone);
            window.logElementTree();

            window.buttons()[1].tap();
            window.buttons()[0].tap();


            window.buttons()[4].tap();
            window.tableViews()[0].tapWithOptions({tapOffset:{x:0.47, y:0.05}});
            window.buttons()["确定"].tap();

            window.buttons()["保存"].tap();
            assertNotNull(window.staticTexts()["请完善信息"]);
        })
        test("没有意向商品" ,function () {
            window.buttons()[2].tap();
            window.pickers()[0].wheels()[1].tapWithOptions({tapOffset:{x:0.81, y:0.34}});
            window.pickers()[0].wheels()[2].tapWithOptions({tapOffset:{x:0.44, y:0.49}});
            window.buttons()["确定"].tap();

            window.buttons()[3].tap();
            window.pickers()[0].wheels()[0].tapWithOptions({tapOffset:{x:0.65, y:0.52}});
            target.delay(1);
            window.buttons()["确定"].tap();

            window.buttons()[4].tap();
            window.tableViews()[0].tapWithOptions({tapOffset:{x:0.47, y:0.05}});
            window.buttons()["确定"].tap();

            window.buttons()["保存"].tap();
            assertNotNull(window.staticTexts()["请完善信息"]);
        })
        test("没有手机号" ,function () {
            window.buttons()[4].tap();
            window.tableViews()[0].tapWithOptions({tapOffset:{x:0.47, y:0.05}});
            window.buttons()["确定"].tap();
            window.textFields()[1].textFields()[0].tap();
            window.textFields()[1].textFields()[0].setValue("");
            window.buttons()["保存"].tap();
            assertNotNull(window.staticTexts()["请完善信息"]);
        })
        test("手机号格式错误" ,function () {
            window.textFields()[1].textFields()[0].tap();
            window.textFields()[1].textFields()[0].setValue(errorformatPhone);
            window.buttons()["保存"].tap();
            assertNotNull(window.staticTexts()["请输入正确的手机号"]);
        })
        test("手机号已登记过" ,function () {
            window.textFields()[1].textFields()[0].tap();
            window.textFields()[1].textFields()[0].setValue(register);
            window.buttons()["保存"].tap();
            assertNotNull(window.staticTexts()["该客户资料已经登记过"]);
        })
        test("信息完整" ,function () {
            window.textFields()[1].textFields()[0].tap();
            window.textFields()[1].textFields()[0].setValue(addPhone);
            window.buttons()["保存"].tap();

            target.delay(2);
            assertEquals("新农代表",window.navigationBar().staticTexts()[0].value());
            var newtotallabel = window.staticTexts()[1].value();
            var newtotalnumStr = newtotallabel.substr(3,newtotallabel.length-6);
            var newtotalnum = parseFloat(newtotalnumStr);

            var newtodaylabel = window.staticTexts()[2].value();
            var newtodaynumStr = newtodaylabel.substr(6,newtodaylabel.length-7);
            var newtodaynum = parseFloat(newtodaynumStr);

            //assertEquals(oldcells+1,window.tableViews()[1].cells().length);
            assertEquals(newtotalnum-1,totalnum);
            assertEquals(newtodaynum+1,todaynum);
        })
    })
}

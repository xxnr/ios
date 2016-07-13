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

test("新农代表tab的点击",function(){
    target.frontMostApp().windows()[0].tabBar().buttons()["我的"].tap();
    target.frontMostApp().windows()[0].tableViews()[0].cells()[1].tap();

    target.frontMostApp().windows()[0].buttons()["我的代表"].tap();
    target.delay(2);

    if (target.frontMostApp().windows()[0].buttons()["客户登记"])
    {
        target.frontMostApp().windows()[0].buttons()["客户登记"].tap();
    }
})
test("我的客户 下拉刷新",function(){
    target.delay(2);
    target.frontMostApp().windows()[0].buttons()["我的客户"].tap();
    target.delay(2);

    target.frontMostApp().windows()[0].buttons()["我的客户"].dragInsideWithOptions({startOffset:{x:0.74, y:-3.54}, endOffset:{x:0.83, y:0.99}});
    target.delay(2);
    var label = target.frontMostApp().windows()[0].tableViews()[0].staticTexts()[0].value();
    var numStr = label.substr(3,label.length-6);

    var num = parseInt(numStr);
    var count = target.frontMostApp().windows()[0].tableViews()[0].cells().length;
    assertEquals(num,count);
})
test("我的客户  上滑加载",function(){
    //target.dragFromToForDuration({x:209.00, y:487.50}, {x:237.50, y:21.00}, 1.4);

    if (target.frontMostApp().windows()[0].tableViews()[0].cells().length > 0)
    {
        var label = target.frontMostApp().windows()[0].tableViews()[0].staticTexts()[0].value();
        var numStr = label.substr(3,label.length-6);

        var num = parseInt(numStr);
        var count = Math.floor(num/10);

        UIALogger.logMessage("'"+count+"'");

        for (var i=0;i<count;i++)
        {
            target.dragFromToForDuration({x:209.00, y:487.50}, {x:237.50, y:21.00}, 1.4);
            target.dragFromToForDuration({x:209.00, y:487.50}, {x:237.50, y:21.00}, 1.4);

            target.delay(2);
            target.frontMostApp().windows()[0].tableViews()[0].visibleCells()[0].tap();
            target.delay(2);
            target.frontMostApp().windows()[0].logElementTree();
            target.frontMostApp().windows()[0].navigationBar().buttons()["top back"].tap();
        }
    }
})

test("我的客户 邀请好友数",function(){

    if (target.frontMostApp().windows()[0].tableViews()[0].cells().length > 0)
    {
        target.frontMostApp().windows()[0].logElementTree();
        var label = target.frontMostApp().windows()[0].tableViews()[0].staticTexts()[0].value();
        var numStr = label.substr(3,label.length-6);

        var num = parseFloat(numStr);
        var count = target.frontMostApp().windows()[0].tableViews()[0].cells().length;
        assertEquals(num,count);
        UIALogger.logMessage("'"+target.frontMostApp().windows()[0].staticTexts()[0].isVisible()+"'");
        assertEquals(0,target.frontMostApp().windows()[0].staticTexts()[0].isVisible());
    }
    else
    {
        assertEquals(1,target.frontMostApp().windows()[0].staticTexts()[0].isVisible());
    }

})
test("我的客户 客户详情",function(){
    target.frontMostApp().windows()[0].buttons()["我的客户"].tap();
    if (target.frontMostApp().windows()[0].tableViews()[0].cells().length > 0){
        target.frontMostApp().windows()[0].tableViews()[0].cells()[1].tap();
        target.delay(2);
        assertEquals("客户订单",target.frontMostApp().windows()[0].navigationBar().staticTexts()[0].value());
        target.frontMostApp().windows()[0].navigationBar().buttons()["top back"].tap();
        target.frontMostApp().windows()[0].tableViews()[0].cells()[2].tap();
        target.delay(2);
        assertEquals("客户订单",target.frontMostApp().windows()[0].navigationBar().staticTexts()[0].value());
        target.frontMostApp().windows()[0].navigationBar().buttons()["top back"].tap();
    }

})

test("我的代表",function () {
    target.frontMostApp().windows()[0].buttons()["我的代表"].tap();
    target.delay(2);
    target.frontMostApp().windows()[0].logElementTree();
    if (target.frontMostApp().windows()[0].buttons()["添加"].isVisible())
    {
        UIALogger.logMessage("没有添加新农代表");
    }
    else
    {
        UIALogger.logMessage("有新农代表");
    }
})
if (target.frontMostApp().windows()[0].buttons()["客户登记"])
{
    test("客户登记 查看客户详情",function () {
        target.frontMostApp().windows()[0].buttons()["客户登记"].tap();
        target.delay(2);
        target.frontMostApp().windows()[0].logElementTree();

        if (target.frontMostApp().windows()[0].tableViews()[1].cells().length > 0)
        {
            var label = target.frontMostApp().windows()[0].staticTexts()[1].value();
            var numStr = label.substr(3,label.length-6);

            var num = parseInt(numStr);
            var count = Math.floor(num/10);
            for (var i=0;i<count;i++)
            {
                target.dragFromToForDuration({x:255.00, y:442.00}, {x:261.50, y:70.50}, 0.6);
                target.dragFromToForDuration({x:255.00, y:442.00}, {x:261.50, y:70.50}, 0.6);

                target.delay(2);
                target.frontMostApp().windows()[0].tableViews()[1].visibleCells()[1].tap();
                target.delay(2);
                target.frontMostApp().windows()[0].logElementTree();

                register = target.frontMostApp().windows()[0].staticTexts()[3].value();
                target.frontMostApp().windows()[0].logElementTree();
                target.frontMostApp().windows()[0].navigationBar().buttons()["top back"].tap();
            }
        }
    })

    test("客户登记 显示与实际数量",function () {
        if (target.frontMostApp().windows()[0].tableViews()[1].cells().length > 0)
        {
            target.frontMostApp().windows()[0].logElementTree();
            var label = target.frontMostApp().windows()[0].staticTexts()[1].value();
            var numStr = label.substr(3,label.length-6);

            var num = parseFloat(numStr);
            var count = target.frontMostApp().windows()[0].tableViews()[1].cells().length;
            assertEquals(num,count);
        }
    })
    test("客户登记  今日添加",function () {
        var label = target.frontMostApp().windows()[0].staticTexts()[2].value();
        var numStr = label.substr(6,label.length-7);
        var num = parseInt(numStr);
        if (num > 0){
            assertEquals(1,target.frontMostApp().windows()[0].buttons()[0].isEnabled());
        }
        else
        {
            assertEquals(0,target.frontMostApp().windows()[0].buttons()[0].isEnabled());
        }
    })
    test("添加潜在客户",function () {

        var oldcells = target.frontMostApp().windows()[0].tableViews()[1].cells().length;

        var totallabel = target.frontMostApp().windows()[0].staticTexts()[1].value();
        var totalnumStr = totallabel.substr(3,totallabel.length-6);
        var totalnum = parseFloat(totalnumStr);

        var todaylabel = target.frontMostApp().windows()[0].staticTexts()[2].value();
        var todaynumStr = todaylabel.substr(6,todaylabel.length-7);
        var todaynum = parseFloat(todaynumStr);

        UIALogger.logMessage("'"+register+"'");

        target.frontMostApp().windows()[0].buttons()[0].tap();
        test("没有信息",function () {
            target.frontMostApp().windows()[0].buttons()["保存"].tap();
            target.frontMostApp().windows()[0].logElementTree();

            assertNotNull(target.frontMostApp().windows()[0].staticTexts()["请完善信息"]);
        })
        test("没有选择城市",function () {
            target.frontMostApp().windows()[0].logElementTree();

            target.frontMostApp().windows()[0].textFields()[0].textFields()[0].tap();
            target.frontMostApp().windows()[0].textFields()[0].textFields()[0].setValue("na");

            target.frontMostApp().windows()[0].textFields()[1].textFields()[0].tap();
            target.frontMostApp().windows()[0].textFields()[1].textFields()[0].setValue(rightPhone);
            target.frontMostApp().windows()[0].logElementTree();

            target.frontMostApp().windows()[0].buttons()[1].tap();
            target.frontMostApp().windows()[0].buttons()[0].tap();


            target.frontMostApp().windows()[0].buttons()[4].tap();
            target.frontMostApp().windows()[0].tableViews()[0].tapWithOptions({tapOffset:{x:0.47, y:0.05}});
            target.frontMostApp().windows()[0].buttons()["确定"].tap();

            target.frontMostApp().windows()[0].buttons()["保存"].tap();
            assertNotNull(target.frontMostApp().windows()[0].staticTexts()["请完善信息"]);
        })
        test("没有意向商品" ,function () {
            target.frontMostApp().windows()[0].buttons()[2].tap();
            target.frontMostApp().windows()[0].pickers()[0].wheels()[1].tapWithOptions({tapOffset:{x:0.81, y:0.34}});
            target.frontMostApp().windows()[0].pickers()[0].wheels()[2].tapWithOptions({tapOffset:{x:0.44, y:0.49}});
            target.frontMostApp().windows()[0].buttons()["确定"].tap();

            target.frontMostApp().windows()[0].buttons()[3].tap();
            target.frontMostApp().windows()[0].pickers()[0].wheels()[0].tapWithOptions({tapOffset:{x:0.65, y:0.52}});
            target.delay(1);
            target.frontMostApp().windows()[0].buttons()["确定"].tap();

            target.frontMostApp().windows()[0].buttons()[4].tap();
            target.frontMostApp().windows()[0].tableViews()[0].tapWithOptions({tapOffset:{x:0.47, y:0.05}});
            target.frontMostApp().windows()[0].buttons()["确定"].tap();

            target.frontMostApp().windows()[0].buttons()["保存"].tap();
            assertNotNull(target.frontMostApp().windows()[0].staticTexts()["请完善信息"]);
        })
        test("没有手机号" ,function () {
            target.frontMostApp().windows()[0].buttons()[4].tap();
            target.frontMostApp().windows()[0].tableViews()[0].tapWithOptions({tapOffset:{x:0.47, y:0.05}});
            target.frontMostApp().windows()[0].buttons()["确定"].tap();
            target.frontMostApp().windows()[0].textFields()[1].textFields()[0].tap();
            target.frontMostApp().windows()[0].textFields()[1].textFields()[0].setValue("");
            target.frontMostApp().windows()[0].buttons()["保存"].tap();
            assertNotNull(target.frontMostApp().windows()[0].staticTexts()["请完善信息"]);
        })
        test("手机号格式错误" ,function () {
            target.frontMostApp().windows()[0].textFields()[1].textFields()[0].tap();
            target.frontMostApp().windows()[0].textFields()[1].textFields()[0].setValue(errorformatPhone);
            target.frontMostApp().windows()[0].buttons()["保存"].tap();
            assertNotNull(target.frontMostApp().windows()[0].staticTexts()["请输入正确的手机号"]);
        })
        test("手机号已登记过" ,function () {
            target.frontMostApp().windows()[0].textFields()[1].textFields()[0].tap();
            target.frontMostApp().windows()[0].textFields()[1].textFields()[0].setValue(register);
            target.frontMostApp().windows()[0].buttons()["保存"].tap();
            assertNotNull(target.frontMostApp().windows()[0].staticTexts()["该客户资料已经登记过"]);
        })
        test("信息完整" ,function () {
            target.frontMostApp().windows()[0].textFields()[1].textFields()[0].tap();
            target.frontMostApp().windows()[0].textFields()[1].textFields()[0].setValue(addPhone);
            target.frontMostApp().windows()[0].buttons()["保存"].tap();

            target.delay(2);
            assertEquals("新农代表",target.frontMostApp().windows()[0].navigationBar().staticTexts()[0].value());
            var newtotallabel = target.frontMostApp().windows()[0].staticTexts()[1].value();
            var newtotalnumStr = newtotallabel.substr(3,newtotallabel.length-6);
            var newtotalnum = parseFloat(newtotalnumStr);

            var newtodaylabel = target.frontMostApp().windows()[0].staticTexts()[2].value();
            var newtodaynumStr = newtodaylabel.substr(6,newtodaylabel.length-7);
            var newtodaynum = parseFloat(newtodaynumStr);

            //assertEquals(oldcells+1,target.frontMostApp().windows()[0].tableViews()[1].cells().length);
            assertEquals(newtotalnum-1,totalnum);
            assertEquals(newtodaynum+1,todaynum);
        })
    })
}

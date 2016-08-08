/**
 * Created by yangning on 16/6/28.
 */

#import "../lib/tuneup.js"
#import "xxnrElementClass.js"

var errorformatPhone = "11100002334";
var addPhone = "188";

for(var i=0;i<8;i++)
{
    var num = Math.floor(Math.random()*10).toString();

    addPhone = addPhone + num;
}
xxnrlogMessage("'"+addPhone+"'");
var register;

var target = UIATarget.localTarget();
var window = target.frontMostApp().windows()[0];


test("新农代表tab的点击",function(){
    xxnrElementClass.tab(window).mineTab().tap();
    xxnrElementClass.mine(window).cell(1).tap();

    xxnrElementClass.xxnrRepesent(window).myrepesentTab().tap();
    xxnrdelay(2);

    if (xxnrElementClass.xxnrRepesent(window).clientRegisterTab().isVisible())
    {
        xxnrElementClass.xxnrRepesent(window).clientRegisterTab().tap();
    }
})
test("我的客户 下拉刷新",function(){
    xxnrdelay(2);
    xxnrElementClass.xxnrRepesent(window).myclientTab().tap();
    xxnrdelay(2);
    if (xxnrElementClass.xxnrRepesent_client(window).inviteLabel().isVisible()) {
        xxnrElementClass.xxnrRepesent(window).myclientTab().dragInsideWithOptions({
            startOffset: {x: 0.74, y: -3.54},
            endOffset: {x: 0.83, y: 0.99}
        });
        xxnrdelay(2);
        var label = xxnrElementClass.xxnrRepesent_client(window).inviteNum();
        var numStr = label.substr(3, label.length - 6);

        var num = parseInt(numStr);
        var count = xxnrElementClass.xxnrRepesent_client(window).cells().length;
        assertEquals(num, count);
    }
})
test("我的客户  上滑加载",function(){
    if (xxnrElementClass.xxnrRepesent_client(window).cells().length > 0)
    {
        var label = xxnrElementClass.xxnrRepesent_client(window).inviteNum();
        var numStr = label.substr(3,label.length-6);

        var num = parseInt(numStr);
        var count = Math.floor(num/10);

        xxnrlogMessage("'"+count+"'");

        for (var i=0;i<=count;i++)
        {
            target.dragFromToForDuration({x:209.00, y:487.50}, {x:237.50, y:21.00}, 1.4);
            target.dragFromToForDuration({x:209.00, y:487.50}, {x:237.50, y:21.00}, 1.4);

            xxnrdelay(2);
            window.tableViews()[0].visibleCells()[0].tap();
            xxnrdelay(2);
            xxnrlogEleTree(window);
            xxnrElementClass.navBack(window).tap();
        }
    }
})

test("我的客户 邀请好友数",function(){

    if (xxnrElementClass.xxnrRepesent_client(window).cells().length > 0)
    {
        xxnrlogEleTree(window);
        var label = xxnrElementClass.xxnrRepesent_client(window).inviteNum();
        var numStr = label.substr(3,label.length-6);

        var num = parseFloat(numStr);
        var count = xxnrElementClass.xxnrRepesent_client(window).cells().length;
        assertEquals(num,count);
        xxnrlogMessage("'"+xxnrElementClass.xxnrRepesent_client(window).isInviteFriend()+"'");
        assertEquals(0,xxnrElementClass.xxnrRepesent_client(window).isInviteFriend());
    }
    else
    {
        assertEquals(1,xxnrElementClass.xxnrRepesent_client(window).isInviteFriend());
    }

})
test("我的客户 客户详情",function(){
    xxnrElementClass.xxnrRepesent(window).myclientTab().tap();
    if (xxnrElementClass.xxnrRepesent_client(window).cells().length > 0){
        xxnrElementClass.xxnrRepesent_client(window).cell(1).tap();
        xxnrdelay(2);
        assertEquals("客户订单",xxnrElementClass.navTitle(window));
        xxnrElementClass.navBack(window).tap();
        xxnrElementClass.xxnrRepesent_client(window).cell(2).tap();
        xxnrdelay(2);
        assertEquals("客户订单",xxnrElementClass.navTitle(window));
        xxnrElementClass.navBack(window).tap();
    }

})

test("我的代表",function () {
    xxnrElementClass.xxnrRepesent(window).myrepesentTab().tap();
    xxnrdelay(2);
    xxnrlogEleTree(window);
    if (window.buttons()["添加"].isVisible())
    {
        xxnrlogMessage("没有添加新农代表");
    }
    else
    {
        xxnrlogMessage("有新农代表");
    }
})
if (xxnrElementClass.xxnrRepesent(window).clientRegisterTab().isVisible())
{
    test("客户登记 滚动列表&查看客户详情",function () {
        xxnrElementClass.xxnrRepesent(window).clientRegisterTab().tap();
        xxnrdelay(2);
        xxnrlogEleTree(window);

        if (xxnrElementClass.xxnrClientRegister(window).cells().length > 0)
        {
            var label = xxnrElementClass.xxnrClientRegister(window).totalNum();
            var numStr = label.substr(3,label.length-6);

            var num = parseInt(numStr);
            var count = Math.floor(num/10);
            for (var i=0;i<count;i++)
            {
                target.dragFromToForDuration({x:255.00, y:442.00}, {x:261.50, y:70.50}, 0.6);
                target.dragFromToForDuration({x:255.00, y:442.00}, {x:261.50, y:70.50}, 0.6);

                xxnrdelay(2);
                window.tableViews()[1].visibleCells()[1].tap();
                xxnrdelay(2);
                xxnrlogEleTree(window);

                register = xxnrElementClass.clientDetail(window).phone();
                xxnrlogEleTree(window);
                xxnrElementClass.navBack(window).tap();
            }
        }
    })

    test("客户登记 显示与实际数量",function () {
        if (xxnrElementClass.xxnrClientRegister(window).cells().length > 0)
        {
            xxnrlogEleTree(window);
            var label = xxnrElementClass.xxnrClientRegister(window).totalNum();
            var numStr = label.substr(3,label.length-6);

            var num = parseFloat(numStr);
            var count = xxnrElementClass.xxnrClientRegister(window).cells().length;
            assertEquals(num,count);
        }
    })
    test("客户登记  今日添加",function () {
        var label = xxnrElementClass.xxnrClientRegister(window).todayNum();
        var numStr = label.substr(6,label.length-7);
        var num = parseInt(numStr);
        if (num > 0){
            assertEquals(1,xxnrElementClass.xxnrClientRegister(window).addBtn().isEnabled());
        }
        else
        {
            assertEquals(0,xxnrElementClass.xxnrClientRegister(window).addBtn().isEnabled());
        }
    })
    test("添加潜在客户",function () {
        var oldcells = xxnrElementClass.xxnrClientRegister(window).cells().length;

        var totallabel = xxnrElementClass.xxnrClientRegister(window).totalNum();
        var totalnumStr = totallabel.substr(3,totallabel.length-6);
        var totalnum = parseFloat(totalnumStr);

        var todaylabel = xxnrElementClass.xxnrClientRegister(window).todayNum();
        var todaynumStr = todaylabel.substr(6,todaylabel.length-7);
        var todaynum = parseFloat(todaynumStr);

        xxnrlogMessage("'"+register+"'");

        xxnrElementClass.xxnrClientRegister(window).addBtn().tap();
        test("没有信息",function () {
            xxnrElementClass.addClient(window).saveBtn().tap();
            xxnrlogEleTree(window);

            assertNotNull(xxnrElementClass.addClient(window).warningStaticText("请完善信息"));
        })

        test("没有选择城市",function () {
            xxnrlogEleTree(window);

            xxnrElementClass.addClient(window).nameTextField().tap();
            xxnrElementClass.addClient(window).nameTextField().setValue("na");

            xxnrElementClass.addClient(window).phoneTextField().tap();
            xxnrElementClass.addClient(window).phoneTextField().setValue(addPhone);
            xxnrlogEleTree(window);

            xxnrElementClass.addClient(window).girlBtn().tap();
            xxnrElementClass.addClient(window).boyBtn().tap();

            xxnrElementClass.addClient(window).selProBtn().tap();
            xxnrElementClass.selPro(window).tableView().tapWithOptions({tapOffset:{x:0.47, y:0.05}});
            xxnrElementClass.selPro(window).makeSureBtn().tap();

            xxnrElementClass.addClient(window).saveBtn().tap();
            assertNotNull(xxnrElementClass.addClient(window).warningStaticText("请完善信息"));
        })
        test("没有意向商品" ,function () {
            xxnrElementClass.addClient(window).addressBtn().tap();
            window.pickers()[0   ].wheels()[1].tapWithOptions({tapOffset:{x:0.81, y:0.34}});
            window.pickers()[0].wheels()[2].tapWithOptions({tapOffset:{x:0.44, y:0.49}});
            xxnrElementClass.selPro(window).makeSureBtn().tap();

            xxnrElementClass.addClient(window).streetBtn().tap();
            window.pickers()[0].wheels()[0].tapWithOptions({tapOffset:{x:0.65, y:0.52}});
            xxnrdelay(1);
            xxnrElementClass.selPro(window).makeSureBtn().tap();

            xxnrElementClass.addClient(window).selProBtn().tap();
            xxnrElementClass.selPro(window).tableView().tapWithOptions({tapOffset:{x:0.47, y:0.05}});
            xxnrElementClass.selPro(window).makeSureBtn().tap();

            xxnrElementClass.addClient(window).saveBtn().tap();
            assertNotNull(xxnrElementClass.addClient(window).warningStaticText("请完善信息"));
        })
        test("没有手机号" ,function () {
            xxnrElementClass.addClient(window).selProBtn().tap();
            xxnrElementClass.selPro(window).tableView().tapWithOptions({tapOffset:{x:0.47, y:0.05}});
            xxnrElementClass.selPro(window).makeSureBtn().tap();
            xxnrElementClass.addClient(window).phoneTextField().tap();
            xxnrElementClass.addClient(window).phoneTextField().setValue("");
            xxnrElementClass.addClient(window).saveBtn().tap();
            assertNotNull(xxnrElementClass.addClient(window).warningStaticText("请完善信息"));
        })
        test("手机号格式错误" ,function () {
            xxnrElementClass.addClient(window).phoneTextField().tap();
            xxnrElementClass.addClient(window).phoneTextField().setValue(errorformatPhone);
            xxnrElementClass.addClient(window).saveBtn().tap();
            assertNotNull(xxnrElementClass.addClient(window).warningStaticText("请输入正确的手机号"));
        })
        test("手机号已登记过" ,function () {
            xxnrElementClass.addClient(window).phoneTextField().tap();
            xxnrElementClass.addClient(window).phoneTextField().setValue(register);
            xxnrElementClass.addClient(window).saveBtn().tap();
            assertNotNull(xxnrElementClass.addClient(window).warningStaticText("该客户资料已经登记过"));
        })
        test("信息完整" ,function () {
            xxnrElementClass.addClient(window).phoneTextField().tap();
            xxnrElementClass.addClient(window).phoneTextField().setValue(addPhone);
            xxnrElementClass.addClient(window).saveBtn().tap();

            xxnrdelay(2);
            assertEquals("新农代表",xxnrElementClass.navTitle(window));
            var newtotallabel = xxnrElementClass.xxnrClientRegister(window).totalNum();
            var newtotalnumStr = newtotallabel.substr(3,newtotallabel.length-6);
            var newtotalnum = parseFloat(newtotalnumStr);

            var newtodaylabel = xxnrElementClass.xxnrClientRegister(window).todayNum();
            var newtodaynumStr = newtodaylabel.substr(6,newtodaylabel.length-7);
            var newtodaynum = parseFloat(newtodaynumStr);

            assertEquals(newtotalnum-1,totalnum);
            assertEquals(newtodaynum+1,todaynum);
        })
    })


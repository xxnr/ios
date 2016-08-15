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
// test("我的客户 下拉刷新",function(){
//     xxnrdelay(2);
//     xxnrElementClass.xxnrRepesent(window).myclientTab().tap();
//     xxnrdelay(2);
//     if (xxnrElementClass.xxnrRepesent_client(window).inviteLabel().isVisible()) {
//         xxnrElementClass.xxnrRepesent(window).myclientTab().dragInsideWithOptions({
//             startOffset: {x: 0.74, y: -3.54},
//             endOffset: {x: 0.83, y: 0.99}
//         });
//         xxnrdelay(2);
//         var label = xxnrElementClass.xxnrRepesent_client(window).inviteNum();
//         var numStr = label.substr(3, label.length - 6);
//
//         var num = parseInt(numStr);
//         var count = xxnrElementClass.xxnrRepesent_client(window).cells().length;
//         assertEquals(num, count);
//     }
// })
// test("我的客户  上滑加载",function(){
//     if (xxnrElementClass.xxnrRepesent_client(window).cells().length > 0)
//     {
//         var label = xxnrElementClass.xxnrRepesent_client(window).inviteNum();
//         var numStr = label.substr(3,label.length-6);
//
//         var num = parseInt(numStr);
//         var count = Math.floor(num/10);
//
//         xxnrlogMessage("'"+count+"'");
//
//         for (var i=0;i<=count;i++)
//         {
//             target.dragFromToForDuration({x:209.00, y:487.50}, {x:237.50, y:21.00}, 1.4);
//             target.dragFromToForDuration({x:209.00, y:487.50}, {x:237.50, y:21.00}, 1.4);
//
//             xxnrdelay(2);
//             window.tableViews()[0].visibleCells()[0].tap();
//             xxnrdelay(2);
//             xxnrlogEleTree(window);
//             xxnrElementClass.navBack(window).tap();
//         }
//     }
// })


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
        test("选择意向商品" ,function(){

        })
        }
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

    test("搜索用户",function(){
//        target.frontMostApp().navigationBar().buttons()["search "].tap();
        xxnrElementClass.xxnrRepesent_client(window).search().tap();
        assertNotNull(xxnrElementClass.xxnrSearchUser(window).buttons()["取消"]);
        assertEquals("Empty list",xxnrElementClass.xxnrSearchUser(window).tableView().name());

        xxnrElementClass.xxnrSearchUser(window).searchTextField().setValue("H");
        if(xxnrElementClass.xxnrSearchUser(window).cells().length>0)
        {
            xxnrElementClass.xxnrSearchUser(window).cell(0).tap();
            assertEquals("客户订单" || "客户详情",xxnrElementClass.navTitle());
            xxnrElementClass.navBack().tap();
        }

        xxnrElementClass.xxnrSearchUser(window).ClearTextBtn().tap();
        assertEquals("Empty list",xxnrElementClass.xxnrSearchUser(window).tableView().name());

        var text = "Hh";
        xxnrElementClass.xxnrSearchUser(window).searchTextField().setValue(text);
        for(var i=0;i<xxnrElementClass.xxnrSearchUser(window).cells().length;i++)
        {
            var name = xxnrElementClass.xxnrSearchUser(window).cell(i).staticTexts()[0].name();
            assertNotEquals(-1,text.indexOf(name));

        }

             xxnrElementClass.xxnrSearchUser(window).cells(0).tap();
             assertEquals("客户订单" || "客户详情",xxnrElementClass.navTitle());

             xxnrElementClass.navBack().tap();


        target.frontMostApp().navigationBar().buttons()["取消"].tap();
    })


    target.frontMostApp().tabBar().buttons()["我的"].tap();

target.frontMostApp().mainWindow().tableViews()[0].tap();
    xxnrlogMessage("hahahahahaha");
    xxnrlogEleTree(window);
    //assertEquals(xxnrElementClass.xxnrRepesent_client(window).inviteNum(),xxnrElementClass.xxnrRepesent_client(window).cells().length);

    target.frontMostApp().mainWindow().tableViews()[0].elements()[2].tapWithOptions({tapOffset:{x:0.63, y:0.49}});
    target.frontMostApp().mainWindow().tableViews()[0].elements()[2].tapWithOptions({tapOffset:{x:0.77, y:0.53}});
    target.frontMostApp().mainWindow().tableViews()[0].elements()[2].tapWithOptions({tapOffset:{x:0.70, y:0.50}});
    xxnrlogEleTree(window);

    target.frontMostApp().mainWindow().buttons()["我的代表"].tap();
    target.frontMostApp().mainWindow().buttons()["客户登记"].tap();
    target.frontMostApp().mainWindow().tableViews()[1].cells()[3].tap();
    target.frontMostApp().navigationBar().buttons()["top back"].tap();

    target.frontMostApp().navigationBar().buttons()["search "].tap();
    target.frontMostApp().mainWindow().tableViews()[0].cells()["Qqqqqqqqqqqq"].tap();
    target.frontMostApp().navigationBar().buttons()["top back"].tap();
    target.frontMostApp().navigationBar().buttons()["取消"].tap();
    target.frontMostApp().mainWindow().buttons()["我的客户"].tap();
    target.frontMostApp().mainWindow().buttons()["我的代表"].tap();
   target.frontMostApp().mainWindow().buttons()["客户登记"].tap();
    target.frontMostApp().mainWindow().tableViews()[1].buttons()[0].tap();
    target.frontMostApp().mainWindow().buttons()[4].tap();
    target.frontMostApp().navigationBar().buttons()["top back"].tap();
    target.frontMostApp().mainWindow().textViews()[0].staticTexts()["请填写备注信息（30字以内）"].tapWithOptions({tapOffset:{x:0.06, y:0.97}});
    target.frontMostApp().navigationBar().tap();
    target.frontMostApp().mainWindow().tableViews()[1].cells()["Ad"].scrollToVisible();
    target.frontMostApp().statusBar().elements()["4:50 PM"].dragInsideWithOptions({startOffset:{x:1.74, y:23.27}, endOffset:{x:1.79, y:0.03}});



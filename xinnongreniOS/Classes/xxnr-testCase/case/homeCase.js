/**
 * Created by yangning on 16/6/21.
 */

// #import "assertions.js"
// #import "lang-ext.js"
// #import "uiautomation-ext.js"
// #import "screen.js"
// #import "test.js"
// #import "image_assertion.js"

#import "../lib/tuneup.js"

var target = UIATarget.localTarget();
var window = target.frontMostApp().windows()[0];
test("首页",function(target,app){
     target.frontMostApp().windows()[0].logElementTree();

     test("点击tab跳转",function(target,app){
          window.tabBar().buttons()[1].tap();
          target.delay(1);
          assertTrue(window.navigationBar().staticTexts()[0].name() == "新农资讯","跳转新农资讯页失败");

          window.tabBar().buttons()[2].tap();
          target.delay(1);
          window.logElementTree();
          assertTrue(window.navigationBar().buttons()[1].name() == "编辑","跳转购物车页失败");

          window.tabBar().buttons()[3].tap();
          target.delay(1);
          assertTrue(window.navigationBar().staticTexts()[0].name() == "我的新农人","跳转我的新农人失败");
     });
     test("首页部分测试",function(target,app){
          window.tabBar().buttons()[0].tap();
          target.delay(1);
          target.frontMostApp().windows()[0].collectionViews()[0].dragInsideWithOptions({startOffset:{x:0.68, y:0.31}, endOffset:{x:0.28, y:0.10}, duration:1.0});
          target.frontMostApp().windows()[0].collectionViews()[0].dragInsideWithOptions({startOffset:{x:0.92, y:0.30}, endOffset:{x:0.04, y:0.09}, duration:1.0});


          target.frontMostApp().windows()[0].navigationBar().buttons()["sign"].tap();
          target.delay(1);

          target.frontMostApp().windows()[0].logElementTree();
          target.delay(1);
          var sign = window.staticTexts()[1].value();
          if(window.buttons()[2].name())
          {
               window.buttons()[3].tap();
               target.delay(1);
               assertTrue(window.navigationBar().staticTexts()[0].value() == "登录","跳转登录页面失败");
               window.navigationBar().buttons()["top back"].tap();
          }
          else if(sign == "您今日已签到成功，明天再来呦！")
          {
               UIALogger.logMessage("您今日已签到成功，明天再来呦");

          }
          else if(window.images()[0])
          {
               UIALogger.logMessage("签到成功");
          }
          else
          {
               UIALogger.logFail("签到提示出错 :'"+sign+"'");
          }

          target.delay(1);
          target.frontMostApp().windows()[0].collectionViews()[0].buttons()[5].tap();
          target.delay(1);
          target.frontMostApp().windows()[0].logElementTree();
          assertTrue(target.frontMostApp().windows()[0].navigationBar().staticTexts()[0].name() == "化肥","点击化肥专场跳转失败");
          target.frontMostApp().windows()[0].navigationBar().buttons()["top back"].tap();
          target.frontMostApp().windows()[0].collectionViews()[0].buttons()[6].tap();
          target.delay(1);
          assertTrue(target.frontMostApp().windows()[0].navigationBar().staticTexts()[0].name() == "汽车","点击汽车专场跳转失败");
          target.frontMostApp().windows()[0].navigationBar().buttons()["top back"].tap();
          target.frontMostApp().windows()[0].collectionViews()[0].buttons()[7].tap();
          target.delay(1);
          assertTrue(target.frontMostApp().windows()[0].navigationBar().staticTexts()[0].name() == "汽车","点击汽车专场跳转失败");
          target.frontMostApp().windows()[0].navigationBar().buttons()["top back"].tap();

          target.delay(1);
          target.frontMostApp().windows()[0].collectionViews()[0].cells()["江淮汽车 - 第二代瑞风S3 - 2015款"].scrollToVisible();
          target.frontMostApp().windows()[0].collectionViews()[0].cells()["奇瑞汽车 - 艾瑞泽M7"].scrollToVisible();
          target.frontMostApp().windows()[0].collectionViews()[0].buttons()[8].tap();
          target.delay(1);
          assertTrue(target.frontMostApp().windows()[0].navigationBar().staticTexts()[0].name() == "化肥","点击化肥专场跳转失败");
          target.frontMostApp().windows()[0].navigationBar().buttons()["top back"].tap();

          target.frontMostApp().windows()[0].collectionViews()[0].cells()["江淮汽车 - 第二代瑞风S3 - 2015款"].scrollToVisible();
          target.frontMostApp().windows()[0].collectionViews()[0].cells()["奇瑞汽车 - 艾瑞泽M7"].scrollToVisible();

          target.frontMostApp().windows()[0].collectionViews()[0].cells()["奇瑞汽车 - 艾瑞泽M7"].tap();
          target.delay(1);
          target.frontMostApp().windows()[0].scrollViews()[0].tableViews()[0].dragInsideWithOptions({startOffset:{x:0.80, y:0.21}, endOffset:{x:0.10, y:0.18}});
          target.delay(1);
          target.frontMostApp().windows()[0].scrollViews()[0].tableViews()[0].dragInsideWithOptions({startOffset:{x:0.80, y:0.21}, endOffset:{x:0.10, y:0.18}});
          target.delay(1);
          target.frontMostApp().windows()[0].scrollViews()[0].tableViews()[0].dragInsideWithOptions({startOffset:{x:0.80, y:0.21}, endOffset:{x:0.10, y:0.18}});
          target.delay(1);
          target.frontMostApp().windows()[0].scrollViews()[0].tableViews()[0].dragInsideWithOptions({startOffset:{x:0.80, y:0.21}, endOffset:{x:0.10, y:0.18}});

          target.delay(1);
          target.frontMostApp().windows()[0].scrollViews()[0].tableViews()[0].cells()[0].scrollToVisible();
          target.delay(1);

          target.frontMostApp().windows()[0].buttons()["立即购买"].tap();
          target.frontMostApp().windows()[0].collectionViews()[0].cells()[0].tap();
          target.frontMostApp().windows()[0].collectionViews()[0].cells()[2].tap();
          target.frontMostApp().windows()[0].buttons()["确定"].tap();
          target.frontMostApp().windows()[0].logElementTree();
          target.delay(1);
          UIALogger.logMessage("'"+target.frontMostApp().windows()[0].staticTexts()[3].value()+"'");
          assertTrue(target.frontMostApp().windows()[0].staticTexts()[3].value() == "请选择商品信息","选择商品属性页提示出错");
          target.frontMostApp().windows()[0].collectionViews()[0].cells()[5].tap();
          target.frontMostApp().windows()[0].buttons()["确定"].tap();
          window.logElementTree();
          if(window.buttons()[4].name() == "确定")
          {
               window.buttons()[3].tap();
               target.delay(1);
               target.frontMostApp().windows()[0].buttons()["确定"].tap();
               target.delay(1);
               window.buttons()[4].tap();
               target.delay(1);
               assertTrue(window.navigationBar().staticTexts()[0].value() == "登录","跳转登录页失败");
          }
          else
          {
               assertTrue(window.navigationBar().staticTexts()[0].value() == "提交订单","跳转提交订单失败");

               target.delay(1);
               target.frontMostApp().windows()[0].navigationBar().buttons()["top back"].tap();
               target.delay(1);
               target.frontMostApp().windows()[0].buttons()["加入购物车"].tap();
               target.frontMostApp().windows()[0].buttons()["确定"].tap();
               target.frontMostApp().windows()[0].logElementTree();
               UIALogger.logMessage("'"+target.frontMostApp().windows()[0].staticTexts()[1].value()+"'");
               assertTrue(target.frontMostApp().windows()[0].staticTexts()[1].value() == "加入购物车成功","加入购物车提示出错");

               target.frontMostApp().windows()[0].navigationBar().buttons()[2].tap();
               assertTrue(target.frontMostApp().windows()[0].tabBars()[0].selectedButton().name() == "购物车","跳转购物车页面失败");
          }
     });
});
    
   
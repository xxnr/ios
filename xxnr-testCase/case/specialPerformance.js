/**
 * Created by yangning on 16/6/23.
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
window.logElementTree();
test("专场测试",function(target,app){
     target.delay(2);
     window.collectionViews()[0].buttons()[6].tap();
     target.delay(1);
     target.frontMostApp().windows()[0].tableViews()[0].dragInsideWithOptions({startOffset:{x:0.49, y:0.0}, endOffset:{x:0.60, y:0.70}, duration:1.0});
     target.delay(1);
     window.tableViews()[0].cells()[3].staticTexts()[0].scrollToVisible();
     target.delay(1);
     window.tableViews()[0].cells()[1].staticTexts()[0].scrollToVisible();
     target.delay(1);
     window.tableViews()[0].cells()[5].staticTexts()[0].scrollToVisible();

     //  for(var i=0;i<window.tableViews()[0].cells().length;i++)
     // {
     //window.tableViews()[0].cells()[i].tap();
     //target.delay(1);
     //window.navigationBar().buttons()["top back"].tap();
     //target.delay(1);
     //}
     test("价格排序测试",function(target,app){
          window.buttons()["价格"].tap();
          window.logElementTree();

          target.delay(1);
          var lastPrice = 0;
          for(var i=0;i<window.tableViews()[0].cells().length;i++)
          {
               var detailStr = window.tableViews()[0].cells()[i].staticTexts()[1].value();
               var priceStr =  detailStr.substr(1,detailStr.length-1);
               var price = parseFloat(priceStr);

               UIALogger.logMessage("升序：'"+lastPrice+"'");
               UIALogger.logMessage("'"+price+"'");

               assertTrue(price > lastPrice,"价格升序排序有误");
               lastPrice = price;
          }

          window.buttons()["价格"].tap();
          target.delay(1);

          var desPrice = 0;
          for(var i=0;i<window.tableViews()[0].cells().length;i++)
          {
               var detailStr = window.tableViews()[0].cells()[i].staticTexts()[1].value();
               var priceStr =  detailStr.substr(1,detailStr.length-1);
               var price = parseFloat(priceStr);

               UIALogger.logMessage("降序：'"+desPrice+"'");
               UIALogger.logMessage("'"+price+"'");

               assertTrue(price < desPrice,"价格升序排序有误");
               desPrice = price;
          }

     });
     test("筛选测试",function(target,app){
          window.buttons()["筛选"].tap();
          assertTrue(window.collectionViews()[0],"筛选页");
          window.navigationBar().buttons()["top back"].tap();

          window.collectionViews()[0].buttons()[6].tap();
          window.buttons()["筛选"].tap();
          window.buttons()["筛选"].tap();
          assertNotNull(window.tableViews()[0],"tableView没找到");

          window.buttons()["筛选"].tap();
          window.buttons()["重置"].tap();
          window.collectionViews()[0].cells()[0].tap();
          target.delay(2);
          assertNotNull(window.collectionViews()[0].staticTexts()[3],"选择品牌加载共有属性失败");

          for(var i=0;i<window.collectionViews()[0].cells().length;i++)
          {
               window.logElementTree();
               //if(window.collectionViews()[0].cells()[i].staticTexts()[0].rect().origin.y>window.collectionViews()[0].staticTexts()[j].rect().origin.y)
               //{
               window.buttons()["重置"].tap();
               window.collectionViews()[0].cells()[i].tap();
               target.delay(1);
               window.buttons()["确定"].tap();
               target.delay(1);
               window.buttons()["筛选"].tap();
               // }
          }
          target.delay(1);

          window.collectionViews()[0].cells()[0].tap();
          window.collectionViews()[0].cells()["SUV"].tap();
          window.collectionViews()[0].cells()["7万元以上"].tap();
          window.buttons()["确定"].tap();


          window.buttons()["综合"].tap();

     });

});

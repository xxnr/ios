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
#import "xxnrElementClass.js"

var target = UIATarget.localTarget();
var window = target.frontMostApp().windows()[0];

xxnrlogEleTree(window);
test("专场测试",function(target,app){
     xxnrdelay(2);
     xxnrElementClass.home(window).car_specialBtn().tap();
     xxnrdelay(1);
     window.tableViews()[0].dragInsideWithOptions({startOffset:{x:0.49, y:0.0}, endOffset:{x:0.60, y:0.70}, duration:1.0});
     xxnrdelay(1);
     
     xxnrElementClass.special(window).cell(3).scrollToVisible();
     xxnrdelay(1);
     xxnrElementClass.special(window).cell(1).scrollToVisible();
     xxnrdelay(1);
     xxnrElementClass.special(window).cell(5).scrollToVisible();
     
     test("价格排序测试",function(target,app){
         xxnrElementClass.special(window).priceBtn().tap();
          xxnrlogEleTree(window);

          xxnrdelay(1);
          var lastPrice = 0;
          for(var i=0;i<xxnrElementClass.special(window).cells().length;i++)
          {
               var detailStr = xxnrElementClass.special(window).price(i);
               var priceStr =  detailStr.substr(1,detailStr.length-1);
               var price = parseFloat(priceStr);

               xxnrlogMessage("升序：'"+lastPrice+"'");
               xxnrlogMessage("'"+price+"'");

               assertTrue(price > lastPrice,"价格升序排序有误");
               lastPrice = price;
          }

         xxnrElementClass.special(window).priceBtn().tap();
          xxnrdelay(1);

          var desPrice = 0;
          for(var i=0;i<xxnrElementClass.special(window).cells().length;i++)
          {
               var detailStr = xxnrElementClass.special(window).price(i);
               var priceStr =  detailStr.substr(1,detailStr.length-1);
               var price = parseFloat(priceStr);

               xxnrlogMessage("降序：'"+desPrice+"'");
               xxnrlogMessage("'"+price+"'");

               assertTrue(price < desPrice,"价格降序排序有误");
               desPrice = price;
          }

     });
     test("筛选测试",function(target,app){
          xxnrElementClass.special(window).filterBtn().tap();
          assertTrue(window.collectionViews()[0],"筛选页");
          xxnrElementClass.navBack(window).tap();

          xxnrElementClass.home(window).car_specialBtn().tap();
          xxnrElementClass.special(window).filterBtn().tap();
          xxnrElementClass.special(window).filterBtn().tap();
          assertNotNull(window.tableViews()[0],"tableView没找到");

          xxnrElementClass.special(window).filterBtn().tap();
          xxnrElementClass.filter(window).resetBtn().tap();
          xxnrElementClass.filter(window).cell(0).tap();
          xxnrdelay(2);
          assertNotNull(window.collectionViews()[0].staticTexts()[3],"选择品牌加载共有属性失败");

          for(var i=0;i<xxnrElementClass.filter(window).cells().length;i++)
          {
               xxnrlogEleTree(window);
               //if(xxnrElementClass.filter(window).cell(i).staticTexts()[0].rect().origin.y>window.collectionViews()[0].staticTexts()[j].rect().origin.y)
               //{
               xxnrElementClass.filter(window).resetBtn().tap();
               xxnrElementClass.filter(window).cell(i).tap();
               xxnrdelay(1);
               xxnrElementClass.filter(window).makeSureBtn().tap();
               xxnrdelay(1);
               xxnrElementClass.special(window).filterBtn().tap();
               // }
          }
          xxnrdelay(1);

          xxnrElementClass.filter(window).cell(0).tap();
          xxnrElementClass.filter(window).cell("SUV").tap();
          xxnrElementClass.filter(window).cell("7万元以上").tap();
          xxnrElementClass.filter(window).makeSureBtn().tap();
          
          xxnrElementClass.special(window).totalBtn().tap();

     });

});

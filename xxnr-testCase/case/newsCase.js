/**
 * Created by yangning on 16/6/23.
 * */
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

test("资讯详情",function(target,app){
     xxnrElementClass.tab(window).newsTab().tap();
     xxnrdelay(2);
     
    xxnrElementClass.news(window).cell(1).tap();
     xxnrdelay(1);

     xxnrElementClass.newsDetail(window).navShare().tap();
     assertEquals(true,xxnrElementClass.newsDetail(window).WX().isVisible()&&xxnrElementClass.newsDetail(window).WXFiends().isVisible()&&xxnrElementClass.newsDetail(window).QQ().isVisible()&&xxnrElementClass.newsDetail(window).QQSpace().isVisible());
     
     // xxnrElementClass.newsDetail(window).WX().tap();
     // xxnrElementClass.newsDetail(window).WXFiends().tap();
     // xxnrElementClass.newsDetail(window).QQ().tap();
     // xxnrElementClass.newsDetail(window).QQSpace().tap();
     xxnrElementClass.navBack(window).tap();
     xxnrElementClass.navBack(window).tap();

});
test("滚动列表",function () {
     xxnrdelay(1);

     var count = xxnrElementClass.news(window).cells().length;
     var lastCount = 0;

     while(count > lastCount) {
          lastCount = count;
          xxnrElementClass.news(window).cell(count - 1).scrollToVisible();
          window.tableViews()[0].dragInsideWithOptions({
               startOffset: {x: 0.49, y: 0.90},
               endOffset: {x: 0.60, y: 0.03},
               duration: 0.5
          });
     xxnrdelay(1);

          count = xxnrElementClass.news(window).cells().length;
     }

})
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

test("资讯模块测试",function(target,app){
     xxnrElementClass.tab(window).newsTab().tap();
     xxnrdelay(2);
     
     xxnrElementClass.news(window).tableView().dragInsideWithOptions({startOffset:{x:0.49, y:0.0}, endOffset:{x:0.60, y:0.70}, duration:1.0});

     xxnrdelay(1);
     xxnrElementClass.news(window).tableView().dragInsideWithOptions({startOffset:{x:0.42, y:0.71}, endOffset:{x:0.53, y:0.00}, duration:2.0});
     xxnrElementClass.news(window).tableView().dragInsideWithOptions({startOffset:{x:0.49, y:0.73}, endOffset:{x:0.60, y:0.03}, duration:1.0});
     xxnrdelay(1);
     xxnrElementClass.news(window).tableView().tapWithOptions({tapOffset:{x:0.50, y:0.12}});
     xxnrdelay(1);

     xxnrElementClass.newsDetail(window).navShare().tap();
     xxnrElementClass.newsDetail(window).WX().tap();
     xxnrElementClass.newsDetail(window).WXFiends().tap();
     xxnrElementClass.newsDetail(window).QQ().tap();
     xxnrElementClass.newsDetail(window).QQSpace().tap();

});
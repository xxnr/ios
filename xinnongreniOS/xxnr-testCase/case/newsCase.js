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


test("资讯模块测试",function(target,app){
     target.frontMostApp().windows()[0].tabBar().buttons()["资讯"].tap();

     target.frontMostApp().windows()[0].tableViews()[0].dragInsideWithOptions({startOffset:{x:0.49, y:0.0}, endOffset:{x:0.60, y:0.70}, duration:1.0});

     target.delay(1);
     target.frontMostApp().windows()[0].tableViews()[0].dragInsideWithOptions({startOffset:{x:0.42, y:0.71}, endOffset:{x:0.53, y:0.00}, duration:2.0});
     target.frontMostApp().windows()[0].tableViews()[0].dragInsideWithOptions({startOffset:{x:0.49, y:0.73}, endOffset:{x:0.60, y:0.03}, duration:1.0});
     target.delay(1);
     target.frontMostApp().windows()[0].tableViews()[0].tapWithOptions({tapOffset:{x:0.50, y:0.12}});
     target.delay(1);
     target.frontMostApp().windows()[0].navigationBar().buttons()[2].tap();
     target.frontMostApp().windows()[0].buttons()[0].tap();
     target.frontMostApp().windows()[0].buttons()[1].tap();
     target.frontMostApp().windows()[0].buttons()[2].tap();
     target.frontMostApp().windows()[0].buttons()[3].tap();
});
#import "test.js"
#import "data.js"
#import "xxnrClass.js"
#import "mainClass.js"
var target = UIATarget.localTarget();         
var window = target.frontMostApp().windows()[0];
window.tabBar().buttons()["我的"].tap();    
target.delay(3);

test("个人资料测试",function(target,app){

     login(18211101020,123456);
     xxnrClass().mine(window).mineBtn().tap();
     target.delay(2);
     
     test("我的头像测试",function(target,app){

          });

     test("我的昵称测试",function(target,app){
          xxnrClass().mineData(window).nickNameBtn().tap();
          target.delay(2);
          
          var nickName = "哈哈哈哈";
          xxnrClass().mineData(window).inputTextField().tap();
          xxnrClass().mineData(window).inputTextField().setValue(nickName);
          xxnrClass().mineData(window).finishBtn().tap();
          target.delay(2);

          });
     test("姓名测试",function(target,app){
          xxnrClass().mineData(window).nameBtn().tap();
          target.delay(2);
          
          var name = "钟振华";
          xxnrClass().mineData(window).inputTextField().tap();
          xxnrClass().mineData(window).inputTextField().setValue(name);
          target.delay(2);
          
          xxnrClass().mineData(window).saveBtn().tap();

          });

     test("性别测试",function(target,app){
          xxnrClass().mineData(window).sexBtn().tap();
          target.delay(2);
          xxnrClass().mineData(window).menBtn().tap();
          target.delay(1);

          
          });
     test("所在地区测试",function(target,app){
          xxnrClass().mineData(window).addressBtn().tap();
          target.delay(1);
          xxnrClass().mineData(window).localBtn().tap();
          target.delay(2);
          xxnrClass().mineData(window).picksBtn().tap();
          target.delay(1);
          xxnrClass().mineData(window).addressPicks().tap();


          xxnrClass().mineData(window).streetBtn().tap();
          target.delay(2);

          xxnrClass().mineData(window).addressPicks().tap();
          xxnrClass().mineData(window).saveBtn().tap();
          target.delay(2);
          
          });

     test("类型测试",function(target,app){
          xxnrClass().mineData(window).typeBtn().tap();
          target.delay(2);
          window.pickers()[0].wheels()[0].dragInsideWithOptions({startOffset:{x:0.38, y:0.22}, endOffset:{x:0.38, y:0.12}, duration:1.6});
          window.buttons()[1].tap();
          target.delay(2);

          xxnrClass().mineData(window).typeBtn().tap();
          target.delay(2);
          window.pickers()[0].wheels()[0].dragInsideWithOptions({startOffset:{x:0.38, y:0.33}, endOffset:{x:0.38, y:0.12}, duration:1.6});
          window.buttons()[1].tap();
          
          });
     
     test("服务站认证测试",function(target,app){
          window.scrollViews()[0].buttons()[5].tap();
          target.delay(2);
          window.pickers()[0].wheels()[0].dragInsideWithOptions({startOffset:{x:0.38, y:0.22}, endOffset:{x:0.38, y:0.12}, duration:1.6});
          window.buttons()[1].tap();
          target.delay(2);

          });
     });


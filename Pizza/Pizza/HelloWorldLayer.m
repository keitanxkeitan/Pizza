//
//  HelloWorldLayer.m
//  Pizza
//
//  Created by 筒井 啓太 on 13/03/04.
//  Copyright 東京工業大学 2013. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"

// フィールドのサイズ
const int kFieldSize = 5;
// 宝石のスプライトファイル名
NSString * const kGemSpriteFilename[kGemTypeNum] = {
  nil,
  @"niku.png",
  @"yasai.png",
};
// 宝石のスプライトの１辺の長さ
const float kGemSideLength = 60.f;
// フィールドの左の位置
const float kFieldLeftPos = 10.f;
// フィールドの上の位置
const float kFieldTopPos = 310.f;

@interface HelloWorldLayer()
-(void)dumpField;
-(void)calcNewField;
-(void)resetGem;
-(void)updateField;
@end

#pragma mark - HelloWorldLayer

// HelloWorldLayer implementation
@implementation HelloWorldLayer

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init]) ) {
		
		numPerType_ = 3;
    
    [self updateField];
    
    [NSTimer scheduledTimerWithTimeInterval:8.f
                                     target:self
                                   selector:@selector(updateField)
                                   userInfo:nil
                                    repeats:YES];
    
    self.isTouchEnabled = YES;
	}
	return self;
}

-(void) registerWithTouchDispatcher
{
	[[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
  return YES;
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
	CGPoint location = [self convertTouchToNodeSpace: touch];
  
  int row = (kFieldTopPos - location.y) / kGemSideLength;
  int col = (location.x - kFieldLeftPos) / kGemSideLength;
  
  if (currField_[row][col] == kGemTypeEmpty) {
    return;
  }
  
  id actionTo = [CCScaleTo actionWithDuration:0.1f scale:1.25f];
  [gems_[row][col] runAction:actionTo];
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}

// フィールド情報を出力する。
-(void)dumpField
{
  for (int row = 0; row < kFieldSize; ++row) {
    for (int col = 0; col < kFieldSize; ++col) {
      NSLog(@"%d ", currField_[row][col]);
    }
    NSLog(@"¥n");
  }
}

// 新しいフィールド情報を計算する。今のフィールド情報は１個前のフィールド情報に保持する。
-(void)calcNewField
{
  for (int row = 0; row < kFieldSize; ++row) {
    for (int col = 0; col < kFieldSize; ++col) {
      prevField_[row][col] = currField_[row][col];
    }
  }
  
  enum GemType newField[kFieldSize * kFieldSize];
  
  memset(newField, 0, sizeof(newField));
  
  int i = 0;
  for (int type = kGemTypeNiku; type < kGemTypeNum; ++type) {
    for (int num = 0; num < numPerType_; ++num) {
      newField[i++] = type;
    }
  }

  for (int i = 0; i < (kFieldSize * kFieldSize); ++i) {
    int j = rand() % ((kFieldSize * kFieldSize) - i);
    int temp = newField[i];
    newField[i] = newField[j];
    newField[j] = temp;
  }
  
  i = 0;
  for (int row = 0; row < kFieldSize; ++row) {
    for (int col = 0; col < kFieldSize; ++col) {
      currField_[row][col] = newField[i++];
    }
  }
}

-(void)resetGem
{
  for (int row = 0; row < kFieldSize; ++row) {
    for (int col = 0; col < kFieldSize; ++col) {
      if (prevField_[row][col] != kGemTypeEmpty) {
        [gems_[row][col] removeFromParentAndCleanup:YES];
      }
    }
  }
  
  for (int row = 0; row < kFieldSize; ++row) {
    for (int col = 0; col < kFieldSize; ++col) {
      enum GemType type = currField_[row][col];

      if (type == kGemTypeEmpty) {
        continue;
      }
      
      CCSprite *gem = [CCSprite spriteWithFile:kGemSpriteFilename[type]];
      gem.position = ccp(kFieldLeftPos + (kGemSideLength / 2) + kGemSideLength * col,
                         kFieldTopPos - (kGemSideLength / 2) - kGemSideLength * row);
      [self addChild:gem];
      gems_[row][col] = gem;
    }
  }
}

-(void)updateField
{
  [self calcNewField];
  [self resetGem];
}

#pragma mark GameKit delegate

-(void) achievementViewControllerDidFinish:(GKAchievementViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}

-(void) leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}
@end

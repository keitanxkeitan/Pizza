//
//  HelloWorldLayer.h
//  Pizza
//
//  Created by 筒井 啓太 on 13/03/04.
//  Copyright 東京工業大学 2013. All rights reserved.
//


#import <GameKit/GameKit.h>

// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"

#import "CCTouchDispatcher.h"

enum GemType {
  kGemTypeEmpty,
  kGemTypeNiku,
  kGemTypeYasai,
  kGemTypeNum,
};

// HelloWorldLayer
@interface HelloWorldLayer : CCLayer <GKAchievementViewControllerDelegate, GKLeaderboardViewControllerDelegate>
{
  enum GemType currField_[5][5];
  enum GemType prevField_[5][5];
  CCSprite *gems_[5][5];
  int numPerType_;
}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

@end

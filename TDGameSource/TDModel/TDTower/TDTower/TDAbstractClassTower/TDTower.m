//
//  TDTower.m
//  TowerDefense
//
//  Created by dRumyankov on 5/17/16.
//  Copyright © 2016 Apportable. All rights reserved.
//

#import "TDTower.h"
#import "TDTowerBuilder.h"
#import "TDBuildProcessIndicator.h"
#import "TDTowerBuilder.h"
#import "CCNode+CoordHelpers.h"
#import "TDContainer.h"


@interface TDTower()

@property TDBuildProcessIndicator *progressBuild;
@property TDTowerBuilder *builder;

@end

@implementation TDTower

@synthesize damageRadius = radiusSprite_;
@synthesize delegate = delegate_;
@synthesize position = position_;

- (id)initWithPoint:(CGPoint)buildPoint{
    if(self = [super init]){
        position_ = buildPoint;
        
        _builder = [[TDTowerBuilder alloc] init];
        _builder.buildPosition = position_;
        _isReadyToFire = YES;
    }
    
    return self;
}

- (id)initWithJSONObject:(TDTowerJSON *)tower inPoint:(CGPoint)buildPoint{
    if(self = [super init]){
        position_ = buildPoint;
        
        towerSprite_ = [CCSprite spriteWithImageNamed: tower.fileNameTowerSprite];
        
        upgradeLevel_ = 1;
        typeTower_ = tower.typeTower;
        damage_ = tower.damage;
        cost_ = tower.cost;
        power_ = tower.power;
        speedBullet_ = tower.speedBullet;
        coolDown_ = tower.coolDown;
        radius_ = tower.radius;
        
        _builder = [[TDTowerBuilder alloc] init];
        _builder.buildPosition = position_;
        _isReadyToFire = YES;
    }
    return self;
}

- (void)buildTower{
    _builder.delegate = delegate_;
    
    [NSTimer scheduledTimerWithTimeInterval:[_builder run] target:self selector:@selector(towerIsReady) userInfo:nil repeats:NO];
}

- (NSInteger)valueCost{
    return cost_;
}

- (NSInteger)valuePower{
    return power_;
}

- (TypeItem)typeTower{
    return typeTower_;
}

- (NSInteger)upgradeLevel{
    return upgradeLevel_;
}

- (void)upgradeTower:(TDTowerJSON *)tower{
    
    [towerSprite_ removeFromParent];
    towerSprite_ = [CCSprite spriteWithImageNamed:tower.fileNameTowerSprite];
    [self updateSkin];
    
    [delegate_ addChild:towerSprite_ z:1];
    
    typeTower_ = tower.typeTower;
    damage_ = tower.damage;
    power_ = tower.power;
    cost_ = tower.cost;
    speedBullet_ = tower.speedBullet;
    coolDown_ = tower.coolDown;
    
    radius_ = tower.radius;
    [self setSizeRadius];
    [self setRadiusOnCenter];
    
    upgradeLevel_++;
}

- (void)setSizeRadius{
    radiusSprite_.scaleX = (radiusSprite_.contentSize.width + radius_)/radiusSprite_.contentSize.width;
    radiusSprite_.scaleY = (radiusSprite_.contentSize.height + radius_)/radiusSprite_.contentSize.height;
}

- (void)setRadiusOnCenter{
    CGPoint center = position_;
    
    CGRect tower = [towerSprite_ worldBoundingBox];
    CGRect rad = [radiusSprite_ worldBoundingBox];
    
    CGFloat dx = rad.size.width/2 - tower.size.width/2;
    CGFloat dy = rad.size.height/2 - tower.size.height/2;
    
    center.y -= dy;
    center.x -= dx;
    
    radiusSprite_.position = center;
    radiusSprite_.anchorPoint = CGPointZero;
}

- (void)updateSkin{
    [towerSprite_ sizeToCustomFit:[[TDContainer sharedContainer] mapLevel].tileSize];
    towerSprite_.anchorPoint = CGPointZero;
    towerSprite_.position = position_;
}

- (void)towerIsReady{
    radiusSprite_ = [CCSprite spriteWithImageNamed:@"td_path_element.png"];
    
    [delegate_ addChild:radiusSprite_ z:1];
    
    [radiusSprite_ sizeToCustomFit:[[TDContainer sharedContainer] mapLevel].tileSize];
    
    [self updateSkin];
    
    [self setSizeRadius];
    
    [self setRadiusOnCenter];
    
    [radiusSprite_ setOpacity:0.0f];
    //[radiusSprite_ setOpacity: 0.85f];
    
    [delegate_ addChild:towerSprite_ z:1];
}

- (TDBulletCharacter)fire{
    TDBulletCharacter bulletCharacteristic;
    
    bulletCharacteristic.damage = damage_;
    bulletCharacteristic.speed = speedBullet_;
    
//    NSLog(@"position x:%f y:%f", position_.x, position_.y);
//    
//    NSLog(@"%@ fire", self);
//    
    _isReadyToFire = NO;
    
    [NSTimer scheduledTimerWithTimeInterval:coolDown_ target:self selector:@selector(endCoolDown) userInfo:nil repeats:NO];
    
    return bulletCharacteristic;
}

- (void)endCoolDown{
    _isReadyToFire = YES;
}

@end

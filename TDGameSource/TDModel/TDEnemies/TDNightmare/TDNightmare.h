//
//  TDNightmare.h
//  Test
//
//  Created by dRumyankov on 7/29/16.
//  Copyright © 2016 Apportable. All rights reserved.
//

#import "TDEnemy.h"

@interface TDNightmare : TDEnemy

- (id)initWithRespawnPoint:(CGPoint)respawnPoint delegate:(id)delegate;

@end

//
//  SimulateAnnealTSP.h
//  Recommender
//
//  Created by Benson Yang on 11/6/13.
//  Copyright (c) 2013 Benson. All rights reserved.
//
// 使用模拟退火解决TSP

#import <Foundation/Foundation.h>

@interface SimulateAnnealTSP : NSObject

/*
 @distance 二维数组，存放邻接矩阵
 @size 矩阵大小
 */
+(void) simulateAnneal:(const int [][20])distance withSize:(int)size;


// 因为结点数不多，若size小于10可考虑用枚举的方式求出最优解
+(void) enumTSP:(const int [][20])distance withSize:(int)size;

@end

//
//  AliyunRecordViewController.h
//  AliyunVideo
//
//  Created by dangshuai on 17/3/6.
//  Copyright (C) 2010-2017 Alibaba Group Holding Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AliyunMediaConfig.h"

@protocol AliyunRecordViewControllerDelegate <NSObject>

- (void)exitRecord;
- (void)recoderFinish:(UIViewController *)vc videopath:(NSString *)videoPath;
- (void)recordViewShowLibrary:(UIViewController *)vc;

@end

@interface AliyunRecordViewController : UIViewController
@property (nonatomic, strong) AliyunMediaConfig *quVideo;
@property (nonatomic, weak) id<AliyunRecordViewControllerDelegate> delegate;
@property (nonatomic, strong) AliyunIRecorder *recorder;

//音乐
@property (nonatomic,assign) NSInteger musicId;
@property (nonatomic,copy) NSString *musicPath;
@property (nonatomic,assign) NSInteger musicType;

//挑战
@property (nonatomic,assign) NSInteger challengeId;
@property (nonatomic,copy) NSString *challengeName;

@property (nonatomic,assign) float startTime;
@property (nonatomic,assign) float duration;

    
/* 摄像头方向 */
@property (nonatomic, assign) BOOL isCameraBack;
/* 闪光灯模式 */
@property (nonatomic, assign) AliyunIRecorderTorchMode torchMode;
/* 美颜状态 */
@property (nonatomic, assign) BOOL beautifyStatus;
/* 设置美颜度 [0,100] */
@property (nonatomic, assign) int beautifyValue;
/* 下一步是否跳转编辑界面 */
@property (nonatomic, assign) BOOL isSkipEditVC;

@end

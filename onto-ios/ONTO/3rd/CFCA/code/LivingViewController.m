//
//  LivingViewController.m
//  LivingApp
//
//  Created by junyufr on 2017/4/1.
//  Copyright © 2017年 junyufr.com. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "LivingViewController.h"
#import "LivingVideoView.h"
#import "LivingControlModel.h"
#import "FaceModuleHead.h"
#import "LivingModel.h"
#import "LivingActionImageView.h"
#import "LivingProgressBar.h"
#import "SelfieControlModel.h"

#define BYTE unsigned char

#define RGB2GRAY(r,g,b) ((((b)*117 + (g)*601 + (r)*306) >> 10) & 255)


//返回的是哪种调用
#define GET_HINT                    ((feature & 1)   > 0)
#define GET_TARGET_OPERATION_COUNT  ((feature & 2)   > 0)
#define GET_TARGET_OPERATION_ACTION ((feature & 4)   > 0)
#define ACTION_CHECK_COMPLETED      ((feature & 8)   > 0)
#define GET_TOTAL_SUCCESS_COUNT     ((feature & 16)  > 0)
#define GET_TOTAL_FAIL_COUNT        ((feature & 32)  > 0)
#define GET_COUNT_CLOCK_TIME        ((feature & 64)  > 0)
#define GET_DONE_OPERATION_COUNT    ((feature & 128) > 0)
#define GET_DONE_OPERATION_RANGE    ((feature & 256) > 0)
#define IS_FINISH_BODY_CHECK        ((feature & 512) > 0)



// 内部调试处理回调
typedef void(^JYDebugCall)(id some);



@interface LivingViewController ()<AVCaptureVideoDataOutputSampleBufferDelegate,JYActionDelegate>{
    //    AVCaptureDevicePosition _devicePosition;
    LivingVideoView* _videoView;
    
    BOOL _libInited; // 是否已经调用 JYInit();
    BOOL _libSelfPhotoSetted; // 是否已经调用 setSelfPhotoJpgBuffer()
    int _libLastError;
    BOOL _frameProcessing;//是否正在进行环境
    
    int videoWidth;
    int videoHeight;
    
    JYDebugCall _debugGrayImage;
    NSData* _jpgData;
    NSDate* _dateEnter; // 进入时间
    
    NSArray *_actionInfos;
    BOOL _isLastHint;
}



@property (nonatomic,strong)LivingControlModel *model;

@property (nonatomic) AVCaptureSession* session;
@property (nonatomic) dispatch_queue_t sessionQueue; //线程
@property (nonatomic) AVCaptureDeviceInput *videoDeviceInput;//输入流对象
@property (nonatomic) AVCaptureStillImageOutput *stillImageOutput;//照片输出流
@property (nonatomic) AVCaptureVideoDataOutput *videoDataOutput;//获取实时数据流（视频音频）

@property (nonatomic,weak)UILabel *textLabel;//提示语



@property (nonatomic,strong)NSTimer *timer;

@property (nonatomic ,strong)NSTimer *time;//不要提示


@property (nonatomic, weak) LivingActionImageView* actionImageView;
@property (nonatomic, weak) LivingProgressBar* progressBar;//进度条
@property (nonatomic, weak) UILabel* actionLabel;
@property (nonatomic, weak) UIImageView* faceFrameImageView;


@property (nonatomic ,strong)AVAudioPlayer* player; //语音提示

@property (nonatomic ,assign) bool lastSuccess;     //记录上次

@property (nonatomic ,assign) bool waiting;     //等待跳转中

@property (nonatomic, strong) AVAudioPlayer* successPlayer;    //成功的语音
@property (nonatomic, strong) AVAudioPlayer* failPlayer;       //失败的语音
@property (nonatomic, strong) AVAudioPlayer* anearPlayer;       //请靠近摄像头声音
@property (nonatomic, strong) AVAudioPlayer* frontPlayer;       //请正对摄像头声音
@property (nonatomic, strong) AVAudioPlayer* tickPlayer;        //咔咔声音


@property (nonatomic, weak) UILabel *actionL;
@property (nonatomic, weak) UIButton *backButton;//返回按钮

@end

@implementation LivingViewController




- (void)viewDidLoad {
    [super viewDidLoad];
    
    _model = [[LivingControlModel alloc] init];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    //顶部
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,20)];
    topView.backgroundColor = [UIColor colorWithRed:17/255.0 green:115/255.0 blue:191/255.0 alpha:1];
    [self.view addSubview:topView];
    
    //标题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 60)];
    titleLabel.textAlignment = NSTextAlignmentCenter;//居中显示
    titleLabel.text = [_model getTitleTxt];
    [titleLabel setTextColor:[UIColor whiteColor]];
    titleLabel.backgroundColor = [UIColor colorWithRed:17/255.0 green:115/255.0 blue:191/255.0 alpha:1];
    titleLabel.font = [UIFont systemFontOfSize:20];
    [self.view addSubview:titleLabel];
    
    self.videoView.frame = CGRectMake(50+15, 80+20+24+40-5 ,self.view.frame.size.width-100-40+10 , (self.view.frame.size.width-100-40+10)/60*77);
    [self.view addSubview:self.videoView];
    
    //提示label
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,self.videoView.frame.size.height + self.videoView.frame.origin.y +10 , self.view.frame.size.width, 40)];
    textLabel.font = [UIFont systemFontOfSize:15];
    textLabel.textColor = [UIColor blackColor];
    textLabel.textAlignment = NSTextAlignmentCenter;//居中显示
    [self.view addSubview:textLabel];
    self.textLabel = textLabel;
    
    [self start];
    
    //人脸框
    UIImageView *faceFrameImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"face_frame"]];
    faceFrameImageView.frame = CGRectMake((self.view.frame.size.width - (self.videoView.frame.size.height/640 *480))/2,self.videoView.frame.origin.y+(((((self.view.frame.size.width-140)/60)*77)-(((self.view.frame.size.width-140)/22.26)*24.38))/2),self.view.frame.size.width-140,((self.view.frame.size.width-140)/22.26)*24.38);//人脸框大小
    
    [self.view addSubview:faceFrameImageView];
    
    
    //返回键
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 60, 60)];
    [backButton setImage:[UIImage imageNamed:@"BackWhite"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(onBack) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:backButton];
    
    self.backButton = backButton;

    [self initSelf];
}


-(void)initSelf
{
    self.successPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[self URLForResource:@"cmd_succeeded" withExtension:@"wav"] error:nil];
    
    self.failPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[self URLForResource:@"cmd_failed" withExtension:@"wav"] error:nil];
    
    self.anearPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[self URLForResource:@"anear" withExtension:@"wav"] error:nil];
    
    self.frontPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[self URLForResource:@"cmd_front" withExtension:@"wav"] error:nil];
    
    [self.successPlayer prepareToPlay];
    [self.failPlayer prepareToPlay];
    [self.anearPlayer prepareToPlay];
    [self.frontPlayer prepareToPlay];

    self.tickPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[self URLForResource:@"tick" withExtension:@"wav"] error:nil];
    
    [self.tickPlayer prepareToPlay];

    // 初始化动作类型对应的标题与动画帧数据
    _actionInfos = @[
                     [[LivingModel alloc] init],
                     [LivingModel actionNamed:@"头向左转" images:nil],
                     [LivingModel actionNamed:@"头向右转" images:nil],
                     [LivingModel actionNamed:@"请抬头" images:@[[UIImage imageNamed:@"action_head_normal"], [UIImage imageNamed:@"action_head_start"]] sound:@"cmd_top"],
                     [LivingModel actionNamed:@"低头" images:nil],
                     [LivingModel actionNamed:@"请张嘴" images:@[[UIImage imageNamed:@"action_mouse_normal"], [UIImage imageNamed:@"action_mouse_open"]] sound:@"cmd_mouth"],
                     [LivingModel actionNamed:@"请眨眼" images:@[[UIImage imageNamed:@"action_eyes_normal"], [UIImage imageNamed:@"action_eyes_closed"]] sound:@"cmd_eye"],
                     [LivingModel actionNamed:@"摇头" images:nil sound:@"cmd_shanke"]
                     ];
    
    UILabel* actionLabel = [[UILabel alloc] init];
    actionLabel.textColor = [UIColor colorWithRed:.027 green:.533 blue:.792 alpha:1];
    actionLabel.textAlignment = NSTextAlignmentCenter;
    actionLabel.frame = CGRectMake(0, 88, self.view.frame.size.width, 40);
    
    LivingProgressBar* progressBar = [[LivingProgressBar alloc] init];
    //设置位置在videoView的 8/10
    progressBar.frame = CGRectMake(self.view.frame.size.width - 50 , self.videoView.frame.origin.y + (self.videoView.frame.size.height/10) , 46, self.videoView.frame.size.height/10*8);
    progressBar.currentValue = 0;
    
    LivingActionImageView* actionImageView = [[LivingActionImageView alloc] init];
    actionImageView.backgroundColor = [UIColor clearColor];
    
    CGFloat videoViewBottom = (self.videoView.frame.size.height + self.videoView.frame.origin.y);
    actionImageView.frame = CGRectMake(self.view.frame.size.width/2 - self.videoView.frame.size.width/4 , (self.view.frame.size.height - videoViewBottom - self.videoView.frame.size.width/2)/2 + videoViewBottom,self.videoView.frame.size.width/2,self.videoView.frame.size.width/2);
    
    [self.view addSubview:actionLabel];
    [self.view addSubview:progressBar];
    [self.view addSubview:actionImageView];
    
    self.actionLabel = actionLabel;

    self.progressBar = progressBar;
    self.actionImageView = actionImageView;
    
    _player =nil;
    _lastSuccess = YES;
    _waiting = NO;
}


-(NSURL*)URLForResource:(NSString*)name withExtension:(NSString*)extension
{
    
    NSURL *bundleUrl = [[NSBundle mainBundle] bundleURL];
    NSBundle* resourceBundle = [NSBundle bundleWithURL:bundleUrl];
    return [resourceBundle URLForResource:name withExtension:extension];
}

//点击返回
-(void)onBack
{
    [_model setLivingArray:nil];
    [_model setPackagedDat:nil];
    
    [self stop];

    [self dismissViewControllerAnimated:NO completion:nil];
}



-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.textLabel.text = @"";
    
    //延迟2秒,环境检测的线刷过一次后开始检测
    if (!_timer) {
        NSTimer *timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(beginLiving) userInfo:nil repeats:NO];
        self.timer = timer;
    }
    NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
    [runLoop addTimer:self.timer forMode:NSRunLoopCommonModes];
}

-(void)beginLiving
{
    [self.timer invalidate];
    self.timer = nil;
    
    [self libInit];
    
}

//返回视频的控件
-(LivingVideoView *)videoView
{
    if (_videoView == nil)
    {
        [self setVideoView:[[LivingVideoView alloc] init]];
    }
    
    return _videoView;
}


-(void)setVideoView:(LivingVideoView *)videoView
{
    _videoView = videoView;
    _videoView.session = _session;
}


//获取一个适用方向的媒体设备
- (AVCaptureDevice *)deviceWithMediaType:(NSString *)mediaType preferringPosition:(AVCaptureDevicePosition)position
{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:mediaType];
    AVCaptureDevice *captureDevice = [devices firstObject];
    
    for (AVCaptureDevice *device in devices)
    {
        if ([device position] == position)
        {
            captureDevice = device;
            break;
        }
    }
    return captureDevice;
}

//开始运行
-(void)start {
    
    if (_session == nil)//如果输入输出为空
    {
        _session = [AVCaptureSession new];//创建一个输入输出赋值给自己
        [self initSession];//
        return;
    }
    
    if (self.videoView == nil)
    {
        [self setVideoView:[[LivingVideoView alloc] init]];
        
    }
    
    if (self.videoView != nil)
    {
        [self.videoView setSession:_session];
    }
    
    if (!self.session.isRunning)
    {
        [self.session startRunning];
    }
}



//设置输入输出流
-(void)initSession
{
    dispatch_queue_t sessionQueue = dispatch_queue_create("session queue", DISPATCH_QUEUE_SERIAL);//创建一个GCD队列
    [self setSessionQueue:sessionQueue];
    
    dispatch_async(sessionQueue, ^{//在队列中运行
        
        //        [self setBackgroundRecordingID:UIBackgroundTaskInvalid];//后台运行
        
        [self.session beginConfiguration];//开始配置输入输出
        
        [_session setSessionPreset:AVCaptureSessionPreset640x480];//设置摄像头的图片质量
        
        //        [self addObserver:self forKeyPath:@"sessionRunningAndDeviceAuthorized" options:(NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew) context:ICP_SessionRunningAndDeviceAuthorizedContext];//观察者
        
        //        [self addObserver:self forKeyPath:@"stillImageOutput.capturingStillImage" options:(NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew) context:ICP_CapturingStillImageContext];
        
        NSError *error = nil;
        
        AVCaptureDevice *videoDevice = [self deviceWithMediaType:AVMediaTypeVideo preferringPosition:AVCaptureDevicePositionFront];//获取摄像头的媒体设备的方向
        
        AVCaptureDeviceInput *videoDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:&error];//创建摄像头的输入流
        
        if (error)
        {
            NSLog(@"初始化视频输入设备失败\n%@", [error localizedDescription]);
        }
        
        if ([_session canAddInput:videoDeviceInput])//如果可以添加输入流到输入输出
        {
            [_session addInput:videoDeviceInput];//添加输入流
            [self setVideoDeviceInput:videoDeviceInput];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                //[[(AVCaptureVideoPreviewLayer *)[[self videoView] layer] connection] setVideoOrientation:(AVCaptureVideoOrientation)[[UIApplication sharedApplication] statusBarOrientation]];
                [[(AVCaptureVideoPreviewLayer *)[[self videoView] layer] connection] setVideoOrientation:AVCaptureVideoOrientationPortrait];
            });
        }
        
        AVCaptureStillImageOutput *stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
        if ([_session canAddOutput:stillImageOutput])
        {
            [stillImageOutput setOutputSettings:@{AVVideoCodecKey : AVVideoCodecJPEG}];//设置输出流的视频解码和输出图片格式
            [_session addOutput:stillImageOutput];//添加图片输出到输入输出流
            [self setStillImageOutput:stillImageOutput];
        }
        
        
        AVCaptureVideoDataOutput *dataOutput = [[AVCaptureVideoDataOutput alloc] init];//创建视频输出流
        dataOutput.alwaysDiscardsLateVideoFrames = YES;//设置丢弃迟缓的视频
        if ([_session canAddOutput:dataOutput])//如果可以添加到输入输出流
        {
            dispatch_queue_t queue = dispatch_queue_create("outputQueue", NULL);//获取输出流的线程
            [dataOutput setSampleBufferDelegate:self queue:queue];//设置视频输出流的代理和运行的线程
            [dataOutput setVideoSettings:@{(id)kCVPixelBufferPixelFormatTypeKey:[NSNumber numberWithInt: kCVPixelFormatType_32BGRA]}];
            
            if ( [_session canAddOutput:dataOutput] )//如果能加入输入输出流
            {
                [_session addOutput:dataOutput];//添加到输入输出流
                
                AVCaptureConnection* videoDataConnection = [dataOutput connectionWithMediaType:AVMediaTypeVideo];//设置输出的格式为视频
                
                if (videoDataConnection.isVideoOrientationSupported)
                {
                    [videoDataConnection setVideoOrientation:AVCaptureVideoOrientationPortrait];
                    //[videoDataConnection setVideoOrientation:AVCaptureVideoOrientationLandscapeRight];
                }
                
                [self setVideoDataOutput:dataOutput];//将适配输出流赋值给自己
            }
        } else
        {
            NSLog(@"未知错误，无法加入视频数据输出处理器。");
        }
        
        [self.session commitConfiguration];//提交配置（配置设置完毕，启用）
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self start];//到主线程中，开始运行
        });
    });
}

// 调用库初始化方法
-(BOOL) libInit
{
    [self libUnInit];
    
    if (_libInited)
    {
        return YES;
    }
    
    int result = JYInit();
    _libLastError = result;
    _libInited = (result >= 0);
    if (_libInited)
    {
        //设置图片数量
        setOFPhotoNum([_model getPictureNumber]+1);
        
        //获取次数
        NSString *actionNumber = [[NSUserDefaults standardUserDefaults] objectForKey:@"actionNumber"];
        int number = 0;
        if ([actionNumber  isEqual: @"1"]) {
            number = 1;
        }
        else if ([actionNumber  isEqual: @"2"]) {
            number = 2;
        }
        else if ([actionNumber  isEqual: @"3"] || [actionNumber  isEqual: @""] || actionNumber == nil) {
            number = 3;
        }
        
        //获取难度
        NSString *actionDifficulty = [[NSUserDefaults standardUserDefaults] objectForKey:@"actionDifficulty"];
        enum eActionDifficulty_External difficulty = eAD_External_Normal;
        if ([actionDifficulty  isEqual: @"1"]) {
            difficulty = eAD_External_Easy;
        }
        else if ([actionDifficulty  isEqual: @"2"] || [actionDifficulty  isEqual: @""] || actionDifficulty == nil) {
            difficulty = eAD_External_Normal;
        }
        else if ([actionDifficulty  isEqual: @"3"]) {
            difficulty = eAD_External_Hard;
        }
        
        //获取动作
        NSString *actionSelectOne = [[NSUserDefaults standardUserDefaults] objectForKey:@"actionSelectOne"];//获取
        NSString *actionSelectTwo = [[NSUserDefaults standardUserDefaults] objectForKey:@"actionSelectTwo"];//获取
        NSString *actionSelectThree = [[NSUserDefaults standardUserDefaults] objectForKey:@"actionSelectThree"];//获取
        
        
        enum eActionType_External iActionType = eAT_External_None;
        if ([actionSelectOne  isEqual: @"YES"] || actionSelectOne == nil) {
            iActionType |= (int)eAT_External_EYE;
        }
        if ([actionSelectTwo  isEqual: @"YES"] || actionSelectTwo == nil) {
            iActionType |= (int)eAT_External_MOUTH;
        }
        if ([actionSelectThree  isEqual: @"YES"] || actionSelectThree == nil) {
            iActionType |= (int)eAT_External_HEAD_TOP;
        }
        if (iActionType == eAT_External_None) {
            iActionType = eAT_External_EYE|eAT_External_MOUTH|eAT_External_HEAD_TOP;
        }
        setCfg(iActionType, number, difficulty);
        
        
    } else
    {
        if (result == -1) {
            //过期通知
            [[NSNotificationCenter defaultCenter] postNotificationName:@"initError" object:self];
        }
        NSLog(@"** 错误 ** 库已过期(code:%d)", _libLastError);
    }
    return _libInited;
}

// 调用库反初始化方法
-(BOOL) libUnInit
{
    if (!_libInited)
    {
        return YES;
    }
    
    _libLastError = JYUnInit();
    
    if (_libLastError >= 0){
    } else
    {
        NSLog(@"** 错误 ** 内核库释放失败(code:%d)", _libLastError);
    }
    
    return _libInited = _libLastError < 0;
}


//代理方法，获取帧数据
-(void) captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{
    
    if (!_libInited )
    {
        return;
    }
    
    if ( _frameProcessing)  //如果正在获取帧数据，返回
    {
        return;
    }
    
    _frameProcessing = YES; //设为正在获取的状态
    
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);// 为媒体数据设置一个buf的Video图像缓存对象
    
    CVPixelBufferLockBaseAddress(imageBuffer, 0);// 锁定buf的基地址
    
    SInputGrayBufInfo *pGrayBufInfo = [self createGrayBufInfo:imageBuffer];// 从buf生成灰度值信息的结构体
    
    
    size_t dataSize = CVPixelBufferGetDataSize(imageBuffer);// 得到buf的大小
    
    void *baseAddress = CVPixelBufferGetBaseAddress(imageBuffer);// 得到指向buf指针
    
    if (_debugGrayImage)
    {
        _debugGrayImage([self createGrayImage:pGrayBufInfo]);
    }
    

    SScrImgInfo srcImgInfo;//创建一个帧图结构体
    srcImgInfo.iBufSize = (int)dataSize;//将buf大小传入结构体
    srcImgInfo.pSrcImgBuf = (unsigned char*)baseAddress;//将图片的指针传入结构体
    int feature = putFeatureBuf(pGrayBufInfo, &srcImgInfo);//将灰度值结构体和帧图结构体传给.a文件
    
    if (feature > 0) {//如果成功
        dispatch_async(dispatch_get_main_queue(), ^{//到主线程
            [self setFeature:feature];//将检查结果传递到代理
        });
    }
    CVPixelBufferUnlockBaseAddress(imageBuffer, 0);
    
    _frameProcessing = NO;
}


-(void)actionFinishCompleted:(BOOL)success
{
    _waiting = YES;
    
    if (success == NO) {
        [_model setPackagedDat:nil];
        [_model setLivingArray:nil];
    }
    
    //延迟1秒,无法点击返回按钮
    self.backButton.userInteractionEnabled = NO;
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 *NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self stop];//这一句
        //跳转的回调
            if([_delegate respondsToSelector:@selector(livingInspectOk:)])
        {
            
            [_delegate livingInspectOk:self];
            self.backButton.userInteractionEnabled = YES;
            
            NSLog(@"%@:数组",[_model getLivingArray]);
        }
        _waiting = NO;
    });
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self stop];
}


//调用.a中的各种检测方法，并传递到代理
-(void) setFeature:(int)feature
{
    if (GET_HINT)
    {
        int hit = getHintMsg();//接收提示语

        [self responseHintMsg:hit];//给代理传递 信息提示
    }
    if (GET_TARGET_OPERATION_COUNT)
    {
        int count = getTargetOperationCount();//接收需要执行指令次数

        [self requestActionCount:count];//给代理传递 需要执行指令的次数
    }
    if (GET_TARGET_OPERATION_ACTION)
    {
        int iAction = getTargetOperationAction();//接收需要执行指令动作

        [self requestActionType:iAction];//给代理传递 需要执行的指令动作
        
    }
    if (ACTION_CHECK_COMPLETED)
    {

        [self actionCheckCompleted:iSOperationSuccess() == 0];//接收执行指令成功还是失败
        
    }
    if (GET_TOTAL_SUCCESS_COUNT)
    {

//        [self responseTotalSuccessCount:getTotalSuccessCount()];// 给代理传递 总成功次数
        
    }
    if (GET_TOTAL_FAIL_COUNT)
    {

//        [self responseTotalFailCount:getTotalFailCount()];//给代理传递 总失败次数
    }
    if (GET_COUNT_CLOCK_TIME)
    {

        [self responseClockTime:getCountClockTime()];//给代理传递 可用时间
    }
    if (GET_DONE_OPERATION_COUNT)
    {
//        [self responseDoneOperationCount:getDoneOperationCount()];//给代理传递 接收动作完成的次数
    }
    if (GET_DONE_OPERATION_RANGE)
    {
        [self responseDoneOperationRange:getDoneOperationRange()];//给代理传递 接收某个动作完成幅度（在创建对象的类中实现方法即可接收到传递的对象）
    }
    if (IS_FINISH_BODY_CHECK)
    {
        int result = iSFinishBodyCheck();//获取到是否完成活体检测
        switch (result)
        {
            case 0://如果为0，代表通过检测
                [self buildResult:YES];
                [self actionFinishCompleted:YES];//通过代理，传递 最终检测状态为YES
                break;
            case 1:
                [self buildResult:NO];
                [self actionFinishCompleted:NO];//通过代理，传递 最终检测状态为NO
                break;
            default:
                break;
        }
    }
}

-(void)requestActionCount:(int)actionCount
{
}

-(void)stop {
    if (_session)
    {
        [_session stopRunning];
    }
    [self libUnInit];
    
    _jpgData = nil;
    _libSelfPhotoSetted = NO;
    
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    
    if (self.time) {
        [self.time invalidate];
        self.time = nil;
    }
}


-(void)actionCheckCompleted:(BOOL)success
{
    
    if (_waiting == YES)//处于等待跳转中时。不发出声音
    {
        return;
    }
    
    if (success == NO&&_lastSuccess == YES)
    {
        
        [self vibrate];//震动
        [self.failPlayer play];//调用失败的语音
        if (self.time!= nil)
        {
            [self.time invalidate];
            self.time = nil;
        }
    }
    if (success == YES)
    {
        [self vibrate];//震动
        [self.successPlayer play];//调用成功的语音
        
        [self.time invalidate];
    }
    _lastSuccess = success;
}

- (void)vibrate
{
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

// 接收动作
-(void)requestActionType:(int)actionType
{
    LivingModel *actionInfo = [_actionInfos objectAtIndex:actionType];
    if (actionInfo)
    {
        //修改字颜色和内容
        [self setActionLabel:actionInfo.name withColor:[UIColor colorWithRed:.027 green:.533 blue:.792 alpha:1]];
        [self.actionImageView setImages:actionInfo.images];

        if (actionInfo.soundPlayer)
        {
            [actionInfo.soundPlayer play];
            _lastSuccess = YES;
            
            _player = actionInfo.soundPlayer;
            
            NSTimer *time = [NSTimer timerWithTimeInterval:5.0 target:self selector:@selector(playerVioce) userInfo:nil repeats:YES];
            
            self.time = time;
            
            NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
            
            [runLoop addTimer:time forMode:NSRunLoopCommonModes];
        }

    } else
    {
        [self setActionLabel:nil withColor: [UIColor colorWithRed:.027 green:.533 blue:.792 alpha:1]];
        [self.actionImageView setImages: nil];
    }
    _isLastHint = NO;
}

-(void)playerVioce
{
    [_player play];//不调用再次提示
        
    [self.time invalidate];
}


-(void)responseActionRange:(int)actionRange
{
}

-(void)responseClockTime:(int)time
{
    NSString *str = [[NSUserDefaults standardUserDefaults] objectForKey:@"switchTick"];
    if ([str  isEqual:@"NO"])
    {
        return;
    }else
    {
        [self.tickPlayer play];//咔咔声音播放
    }
}

-(void)responseDoneOperationRange:(int)range
{
    
    self.progressBar.currentValue = range;
}


-(UILabel *)actionL
{
    if (_actionL== nil)
    {
        UILabel *actionL = [[UILabel alloc] init];
        
        actionL.frame = _actionLabel.frame;
        
        [self.view addSubview:actionL];
        
        _actionL = actionL;
        
        _actionL.textAlignment = NSTextAlignmentCenter;//居中显示
        
        _actionL.alpha = 0;
    }
    return _actionL;
}

-(void)responseHintMsg:(int)hint
{
    if (_waiting == YES)//处于等待跳转，不提示
    {
        return;
    }
    
    switch (hint)
    {
        case 1: // 请按提示指令操作
            _isLastHint = YES;
            [self setActionLabel:@"请按提示指令操作" withColor: [UIColor colorWithRed:.027 green:.533 blue:.792 alpha:1]];
            break;
        case 2: // 未按提示操作，本次识别失败
            _isLastHint = YES;
            [self setActionLabel:@"未按提示操作，本次识别失败" withColor: [UIColor redColor]];
            [self.time invalidate];
            self.time = nil;
            break;
        case 3: // 请正对摄像头
            _isLastHint = YES;
            [self setActionLabel:@"请正对摄像头" withColor: [UIColor redColor]];
            [self.time invalidate];
            self.time = nil;
            [self.frontPlayer play];
            self.actionL.text = @"请正对摄像头";
            self.actionL.textColor = [UIColor redColor];
            [self actionLAlpha];
            
            break;
        case 4: // 请靠近摄像头
            _isLastHint = YES;
            [self setActionLabel:@"请靠近摄像头" withColor: [UIColor redColor]];
            [self.time invalidate];
            self.time = nil;
            [self.anearPlayer play];
            self.actionL.text = @"请靠近摄像头";
            self.actionL.textColor = [UIColor redColor];
            [self actionLAlpha];
            
            break;
        case 5: // 检测到多张人脸，重新开始
            _isLastHint = YES;
            [self setActionLabel:@"检测到多张人脸，重新开始" withColor: [UIColor redColor]];
            [self.time invalidate];
            self.time = nil;
            break;
        case 6: // 无人
            _isLastHint = YES;
            
            [self setActionLabel:@"无人" withColor:[UIColor redColor]];
            [self.time invalidate];
            self.time = nil;
            self.actionL.text = @"无人";
            self.actionL.textColor = [UIColor redColor];
            
            [self actionLAlpha];
            
            break;
        case 7: // 超时，本次识别失败
            _isLastHint = YES;
            [self setActionLabel:@"超时，本次识别失败" withColor: [UIColor redColor]];
            [self.time invalidate];
            self.time = nil;
            break;
            
        default:
            if (!_isLastHint)
            {
                return;
            }
            [self setActionLabel:nil withColor: [UIColor colorWithRed:.027 green:.533 blue:.792 alpha:1]];
            break;
    }
}

-(void)actionLAlpha
{
    [UIView animateWithDuration:0.2 animations:^{
        self.actionL.alpha = 1;
    } completion:^(BOOL finished)
     {
         [UIView animateWithDuration:0.7 animations:^{
             self.actionL.alpha = 0;
         }];
     }];
}


-(void)setActionLabel:(NSString*)label withColor:(UIColor*)textColor
{
    self.actionLabel.text = label;
    self.actionLabel.textColor = textColor;
}


-(void)buildResult:(BOOL)success
{
    _model.success = success;//设置模型中的值 是否通过本地检测
    
    if (success)//如果通过检测
    {
        
        SelfieControlModel *mode = [[SelfieControlModel alloc] init];
        
        
        //设置自拍照
        setSelfPhotoJpgBuffer((unsigned char *)[mode getData].bytes , (int)[mode getData].length);
        
        
        
        int nums = getOFPhotoNum();//从.a得到采集到的最优人脸照片个数
        NSMutableArray *photos = [NSMutableArray array];//创建可变数组
        
        for (int i=0 ; i<nums ; i++)
        {
            
            int iSize = getSrcImgBufferSize(i);//得到第i个最优人脸照片对应的大小
            unsigned char *pOut = (unsigned char *)malloc(iSize);//申请空间
            getSrcImgBuffer(i, pOut);//获取第i张最优人脸照的到pOut的空间中
            
            // 生成JPG图片
            CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();//创建RGB的空间
            CGContextRef context = CGBitmapContextCreate(pOut, videoWidth, videoHeight, 8,
                                                         videoWidth * 4, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);//生成位图
            CGImageRef quartzImage = CGBitmapContextCreateImage(context);//生成ref照片
            UIImage *image = [UIImage imageWithCGImage:quartzImage];//ref转image
            
            if (videoWidth > videoHeight)
            {
                image = [self imageOrientation:image rotation:UIImageOrientationRight];//图片转向
                
            }
            
            [photos addObject:image];//将图片添加到数组
            
            // 处理接口数据
            NSData *jpgData = UIImageJPEGRepresentation(image, 0.6); //将图片转jpeg并压缩
            
            CGImageRelease(quartzImage);//删除ref照片
            
            setPhotoJpgBuffer(i, (unsigned char*)jpgData.bytes, (int)jpgData.length);//将jpg照片设置到.a文件的第i张最优人脸照中
            if (pOut)
            {
                free(pOut);// 释放最优人脸照空间
                pOut = NULL;
            }
            
        }
        int iCSize = getDataBufferSize();// 获取data buffer的大小
        unsigned char *pData = (unsigned char *)malloc(iCSize); //申请空间
        getDataBuffer(pData);//获取data包
        
        NSData *data = [NSData dataWithBytes:pData length:iCSize];
        
        [_model setPackagedDat:[NSData dataWithBytes:pData length:iCSize]];
        [_model setLivingArray:photos];//保存抓拍照数组
        
    }
}

- (UIImage *)imageOrientation:(UIImage *)image rotation:(UIImageOrientation)orientation
{
    long double rotate = 0.0;
    CGRect rect;
    float translateX = 0;
    float translateY = 0;
    float scaleX = 1.0;
    float scaleY = 1.0;
    
    switch (orientation)
    {
        case UIImageOrientationLeft:
            rotate = M_PI_2;
            rect = CGRectMake(0, 0, image.size.height, image.size.width);
            translateX = 0;
            translateY = -rect.size.width;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;
        case UIImageOrientationRight:
            rotate = 3 * M_PI_2;
            rect = CGRectMake(0, 0, image.size.height, image.size.width);
            translateX = -rect.size.height;
            translateY = 0;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;
        case UIImageOrientationDown:
            rotate = M_PI;
            rect = CGRectMake(0, 0, image.size.width, image.size.height);
            translateX = -rect.size.width;
            translateY = -rect.size.height;
            break;
        default:
            rotate = 0.0;
            rect = CGRectMake(0, 0, image.size.width, image.size.height);
            translateX = 0;
            translateY = 0;
            break;
    }
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    //做CTM变换
    CGContextTranslateCTM(context, 0.0, rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextRotateCTM(context, rotate);
    CGContextTranslateCTM(context, translateX, translateY);
    
    CGContextScaleCTM(context, scaleX, scaleY);
    //绘制图片
    CGContextDrawImage(context, CGRectMake(0, 0, rect.size.width, rect.size.height), image.CGImage);
    
    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return newPic;
}




// 从buf生成灰度值信息的结构体
-(SInputGrayBufInfo*)createGrayBufInfo:(CVImageBufferRef)imageBuffer
{
    static SInputGrayBufInfo *pGrayBufInfo = NULL;//创建灰度值的结构体，包括灰度值,图片宽，高
    void *baseAddress = CVPixelBufferGetBaseAddress(imageBuffer);// 锁定buf的基地址
    unsigned char *grayBuffer = [self grayBuffer];//获取灰度值
    size_t width = CVPixelBufferGetWidth(imageBuffer);//获取宽度
    size_t height = CVPixelBufferGetHeight(imageBuffer);//获取高度
    
    
    videoWidth = (int)width;
    videoHeight = (int)height;
    
    //reference_convert(grayBuffer, (unsigned char *)baseAddress, (int)(width * height));
    
    [self convertGrayBuffer:grayBuffer byBGRABuffer:(BYTE*)baseAddress width:&width height:&height];
    
    if(pGrayBufInfo == NULL)//如果结构体为NULL
    {
        pGrayBufInfo = (SInputGrayBufInfo *)malloc(sizeof(SInputGrayBufInfo));//申请空间
    }
    pGrayBufInfo->pGrayBuf = grayBuffer;//给结构体赋值
    pGrayBufInfo->iWidth = (int)width;
    pGrayBufInfo->iHeight = (int)height;
    return pGrayBufInfo;//返回结构体
}

-(void)convertGrayBuffer:(BYTE*)grayBuffer byBGRABuffer:(BYTE*)colorBuffer width:(size_t*)w height:(size_t*)h {
    if ( 0 == colorBuffer )
        return;
    if ( 0 == grayBuffer )
        return;
    BYTE b,g,r;//三个数,
    if (*w > *h) {//如果宽大于高
        // 需要旋转 90 度
        for (size_t y = 0; y < *h; y++)
        {
            for (size_t x = 0; x < *w; x++)
            {
                b = *colorBuffer++;
                g = *colorBuffer++;
                r = *colorBuffer++;
                colorBuffer++;
                *(grayBuffer + x*(*h) + y) = RGB2GRAY(r,g,b);
            }
        }
        size_t t = *w;
        *w = *h;
        *h = t;
    } else {
        size_t size = *w * *h;
        for (size_t i = 0; i<size; i++) {
            b = *colorBuffer++;
            g = *colorBuffer++;
            r = *colorBuffer++;
            colorBuffer++;
            
            *grayBuffer++ = RGB2GRAY(r,g,b);
        }
    }
}

//申请一块内存，并返回一个char *指针指向这片内存
-(unsigned char*) grayBuffer
{
    static unsigned char *_grayBuffer; // 灰度值缓存
    if (_grayBuffer == NULL)//如果buf为空
    {
        size_t size = sizeof(unsigned char) * 4000 * 4000;//获取char＊4000*4000的大小
        _grayBuffer = (unsigned char*)malloc(size);//申请空间
        memset(_grayBuffer, 0, size);//将这块内存置0
    }
    return _grayBuffer;//返回这个内存指针
}

// 从视频帧生成JPEG图片数据
-(NSData*)createJpgData:(CVImageBufferRef)imageBuffer
{
    return UIImageJPEGRepresentation([self createImage:imageBuffer], 0.6);//调用上面一个从视频生成照片的方法，然后压缩并转为JPEG格式，并返回
}
// 从视频帧生成图片（彩色）
-(UIImage*)createImage:(CVImageBufferRef)imageBuffer
{
    void *baseAddress = CVPixelBufferGetBaseAddress(imageBuffer);// 锁定buf的基地址
    
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);//得到buf的行字节数
    
    size_t width = CVPixelBufferGetWidth(imageBuffer);// 得到buf的宽
    
    size_t height = CVPixelBufferGetHeight(imageBuffer);// 得到buf的高
    
    
    // 创建一个依赖于设备的RGB颜色空间
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    // 用缓存的数据创建一个位图格式的图形上下文对象
    CGContextRef context = CGBitmapContextCreate(baseAddress, width, height, 8,
                                                 bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    
    // 根据这个位图context中的像素数据创建一个CGimage对象
    CGImageRef quartzImage = CGBitmapContextCreateImage(context);
    
    // 释放context和颜色空间
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    //CGimage转UIimage
    UIImage *image = [UIImage imageWithCGImage:quartzImage scale:1.0f orientation:UIImageOrientationRight];
    
    // 释放CGimage对象
    CGImageRelease(quartzImage);
    
    //返回UIimage对象
    return image;
}


// 利用灰度图结构体，生成黑白图片
-(UIImage*)createGrayImage:(SInputGrayBufInfo*)pInfo
{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();//
    CGContextRef context = CGBitmapContextCreate(pInfo->pGrayBuf, pInfo->iWidth, pInfo->iHeight, 8, pInfo->iWidth, colorSpace, 0);
    CGImageRef image = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    return [UIImage imageWithCGImage:image];
}


@end

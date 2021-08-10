//
//  SelfieViewController.m
//  SelfieApp
//
//  Created by junyufr on 2017/4/1.
//  Copyright © 2017年 junyufr.com. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "SelfieViewController.h"
#import "SelfieVideoView.h"
#import "FaceModuleHead.h"
#import "SelfieControlModel.h"
#import "SLControlModel.h"
#import "LivingViewController.h"




#define BYTE unsigned char

#define RGB2GRAY(r,g,b) ((((b)*117 + (g)*601 + (r)*306) >> 10) & 255)

// 自拍检测回调函数
typedef void (^JYCheckSelfPhotoBlock)(int photoType);
// 内部调试处理回调
typedef void(^JYDebugCall)(id some);


@interface SelfieViewController ()<AVCaptureVideoDataOutputSampleBufferDelegate,LivingControlDelegate>{
//    AVCaptureDevicePosition _devicePosition;
    SelfieVideoView* _videoView;
    
    
    JYCheckSelfPhotoBlock _selfPhotoChecked;//自拍检测的回调
    BOOL _libInited; // 是否已经调用 JYInit();
    BOOL _libSelfPhotoSetted; // 是否已经调用 setSelfPhotoJpgBuffer()
    int _libLastError;
    BOOL _frameProcessing;//是否正在进行环境
    NSDate *_lastTickTime;
    
    int videoWidth;
    int videoHeight;
    
    JYDebugCall _debugGrayImage;
    NSData* _jpgData;
    NSDate* _dateEnter; // 进入时间
    BOOL _animing;//扫描线
}


@property (nonatomic,strong)SelfieControlModel *model;

@property (nonatomic) AVCaptureSession* session;
@property (nonatomic) dispatch_queue_t sessionQueue; //线程
@property (nonatomic) AVCaptureDeviceInput *videoDeviceInput;//输入流对象
@property (nonatomic) AVCaptureStillImageOutput *stillImageOutput;//照片输出流
@property (nonatomic) AVCaptureVideoDataOutput *videoDataOutput;//获取实时数据流（视频音频）

@property (nonatomic,weak)UILabel *textLabel;//提示语

@property (nonatomic, strong)AVAudioPlayer* dingPlayer;//跳转活体检测的声音

@property (nonatomic, weak) UIImageView* scanlineImageView;//扫描线
@property (nonatomic, weak) UIView* scanlineClipView;//扫描线View

@property (nonatomic,strong)NSTimer *timer;



@end

@implementation SelfieViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    _model = [[SelfieControlModel alloc] init];
    
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
    
    self.videoView.frame = [_model getVideoFrame];
    [self.view addSubview:self.videoView];
    
    //提示label
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,self.videoView.frame.size.height + self.videoView.frame.origin.y +10 , self.view.frame.size.width, 40)];
    textLabel.font = [UIFont systemFontOfSize:15];
    textLabel.textColor = [UIColor blackColor];
    textLabel.textAlignment = NSTextAlignmentCenter;//居中显示
    [self.view addSubview:textLabel];
    self.textLabel = textLabel;
    
    
    //扫描线
    UIView *scanlineClipView = [UIView new];
    scanlineClipView.clipsToBounds = YES;
    
    UIImageView *scanlineImageView = [[UIImageView alloc] init];
    scanlineImageView.image = [UIImage imageNamed:@"scanline3"];
    scanlineImageView.clipsToBounds = YES;
    
    self.scanlineClipView = scanlineClipView;
    self.scanlineImageView = scanlineImageView;
    
    self.scanlineClipView.frame =  CGRectMake((self.view.frame.size.width - (self.videoView.frame.size.height/640 *480))/2,self.videoView.frame.origin.y,self.videoView.frame.size.height/640 *480,self.videoView.frame.size.height);//扫描线大View
    self.scanlineImageView.frame = CGRectMake(0,0,scanlineClipView.frame.size.width,scanlineClipView.frame.size.height);//扫描线宽高
    [scanlineClipView addSubview:scanlineImageView];
    
    [self.view addSubview:scanlineClipView];
    
    //人脸框
    UIImageView *faceFrameImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"face_frame"]];
    faceFrameImageView.frame = CGRectMake(scanlineClipView.frame.origin.x,scanlineClipView.frame.origin.y+(((((self.view.frame.size.width-140)/60)*77)-(((self.view.frame.size.width-140)/22.26)*24.38))/2),self.view.frame.size.width-140,((self.view.frame.size.width-140)/22.26)*24.38);//人脸框大小
    
    [self.view addSubview:faceFrameImageView];
    
    
    //返回键
    UIButton *reButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 60, 60)];
    [reButton setImage:[UIImage imageNamed:@"BackWhite"] forState:UIControlStateNormal];
    [reButton addTarget:self action:@selector(onBack) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:reButton];
    
    self.dingPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[self URLForResource:@"ding" withExtension:@"mp3"] error:nil];
    
    [self.dingPlayer prepareToPlay];//叮声音准备
}


-(NSBundle*) bundle
{

    NSURL *bundleUrl = [[NSBundle mainBundle] bundleURL];
    NSBundle* jyResourceBundle = [NSBundle bundleWithURL:bundleUrl];
    
    return jyResourceBundle;
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    

}

-(NSURL*)URLForResource:(NSString*)name withExtension:(NSString*)extension
{
    return [[self bundle] URLForResource:name withExtension:extension];
}


//点击返回
-(void)onBack
{
    //回调
    if([_delegate respondsToSelector:@selector(selfieTouchBack:)])
    {
        [_model setMySelfie:nil];
        
        [self stop];

        [_delegate selfieTouchBack:self];
    }
//    [self.navigationController popViewControllerAnimated:YES];
}


-(void)updatePhotoType:(int)photoType
{
    switch (photoType)
    {
        case eCSPT_OK:
            [self setStatusText:@"环境正常" success:YES];
            break;
        case eCSPT_Small:
            [self setStatusText:@"人脸过小，请近距离拍照" success:NO];
            break;
        case eCSPT_Pose:
            [self setStatusText:@"人脸姿态不正确，请对准摄像头" success:NO];
            break;
        case eCSPT_Biased:
            [self setStatusText:@"人脸位置不正确，请对准头像框" success:NO];
            break;
        case eCSPT_MoreFace:
            [self setStatusText:@"检测到多张人脸，只能拍取单个人脸" success:NO];
            break;
        case eCSPT_NoFace:
            [self setStatusText:@"检测人脸失败，请对准头像框" success:NO];
            break;
        case eCSPT_Positive:
            [self setStatusText:@"人脸位置不正确，请对准头像框" success:NO];
            break;
        case eCSPT_Dusky:
            [self setStatusText:@"光线昏暗" success:NO];
            break;
        case eCSPT_Sidelight:
            [self setStatusText:@"侧面光线过强" success:NO];
            break;
        default:
            [self setStatusText:@"环境错误，请重新开始" success:NO];//返回的-2
            break;
    }
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    [self startScanlineAnim];
    
    
    self.textLabel.text = @"";
    
    //延迟2秒,环境检测的线刷过一次后开始检测
    [self start];
    
    if (!_timer) {
        NSTimer *timer = [NSTimer timerWithTimeInterval:2.0 target:self selector:@selector(beginSelfie) userInfo:nil repeats:NO];
        self.timer = timer;
    }
    NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
    [runLoop addTimer:self.timer forMode:NSRunLoopCommonModes];
}

-(void)beginSelfie
{
    [self.timer invalidate];
    self.timer = nil;
    
    //开始活体检测
    [self beginCheckSelfPhoto:^(int photoType) {
        
        [self updatePhotoType:photoType];
    }];
}

-(void)setStatusText:(NSString*)text success:(BOOL)success
{
    //修改文字
    self.textLabel.textColor = success ? [UIColor colorWithRed:.027 green:.533 blue:.792 alpha:1] : [UIColor redColor];
    self.textLabel.text = text;
    
    if (success)
    {

        // 按需要停留一定时间后进入下一步
        NSTimeInterval useInterval = [[NSDate date] timeIntervalSinceDate:_dateEnter];
        if (useInterval < 3 - 1) {
            useInterval = 3 - useInterval;
        }else
        {
            useInterval = 1;
        }
        
        //进入过渡
        [self.dingPlayer play];//检测到人脸 叮一声
        
        if (!_tmpImageview) {
            _tmpImageview = [[UIImageView alloc] init];
            UILabel *tmpLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-100, self.view.frame.size.height/2-80, 200, 50)];
            tmpLabel.textAlignment = NSTextAlignmentCenter;//居中显示
            tmpLabel.textColor = [UIColor whiteColor];
            tmpLabel.font = [UIFont systemFontOfSize:20];
            tmpLabel.text = @"即将活体检测";
            [_tmpImageview addSubview:tmpLabel];
        }
        _tmpImageview.contentMode = UIViewContentModeScaleAspectFit;
        _tmpImageview.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        _tmpImageview.backgroundColor = [UIColor blackColor];
        _tmpImageview.alpha = 0.5;
        [self.view addSubview:_tmpImageview];
        
        //载入旋转
        if (!_testActivityIndicator) {
            _testActivityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        }
        
        _testActivityIndicator.center = self.view.center;//设置中心
        [self.view addSubview:_testActivityIndicator];
        _testActivityIndicator.color = [UIColor yellowColor]; // 改变颜色
        [_testActivityIndicator startAnimating]; // 开始旋转
        self.view.userInteractionEnabled = NO;
        
        _animing = NO;
        [self stop];
        
        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(toLiving) userInfo:nil repeats:NO];
    }
}


-(void)toLiving
{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [_testActivityIndicator stopAnimating]; // 结束旋转
        [_testActivityIndicator setHidesWhenStopped:YES]; //当旋转结束时隐藏
        [_tmpImageview removeFromSuperview];
        _tmpImageview = nil;
        self.view.userInteractionEnabled = YES;
        
        
        
        SLControlModel *SLModel = [[SLControlModel alloc] init];
        
        //进入活体检测控制器
        LivingViewController *LivingVC = [[LivingViewController alloc] init];
        
        LivingVC.delegate = SLModel;
        
        //跳转
        [self presentViewController:LivingVC animated:NO completion:nil];
        
    });
}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self stop];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


//返回视频的控件
-(SelfieVideoView *)videoView
{
    if (_videoView == nil)
    {
        [self setVideoView:[[SelfieVideoView alloc] init]];
    }
    
    return _videoView;
}


-(void)setVideoView:(SelfieVideoView *)videoView
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


////设置配置
//-(void)setDevicePosition:(AVCaptureDevicePosition)devicePosition
//{
//    if (_devicePosition != devicePosition)
//    {
//        _devicePosition = devicePosition;
//        
//        if (_session.isRunning)//如果正在运行
//        {
//            [_session beginConfiguration];//开始配置输入输出
//        }
//        
//        if (_videoDeviceInput)//如果存在
//        {
//            [_session removeInput:_videoDeviceInput];//删除
//        }
//        NSError *error;
//        
//        AVCaptureDevice *videoDevice = [self deviceWithMediaType:AVMediaTypeVideo preferringPosition:_devicePosition];//获取摄像头的媒体设备的方向
//        
//        AVCaptureDeviceInput *videoDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:&error];//创建适应方向的摄像头的输入流对象
//        
//        if (error)
//        {
//            NSLog(@"切换视频输入设备失败\n%@", [error localizedDescription]);
//        }
//        
//        if ([_session canAddInput:videoDeviceInput])//如果可以将输入流对象添加到输入输出流
//        {
//            [_session addInput:videoDeviceInput];//添加输入流
//            
//            [self setVideoDeviceInput:videoDeviceInput];
//        }
//        if (_session.isRunning)//如果输入输出在运行
//        {
//            [_session commitConfiguration];//提交配置（配置设置完毕，启用）
//        }
//    }
//}


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
        [self setVideoView:[[SelfieVideoView alloc] init]];
        
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



-(void)beginCheckSelfPhoto:(JYCheckSelfPhotoBlock)result
{
    [self libInit];
    
    _selfPhotoChecked = result;
    _libSelfPhotoSetted = NO;
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
//        StyleModelOnly *styleM = [[StyleModelOnly alloc] init];
        
//        setOFPhotoNum([styleM getPictureNumber]+1);
        
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
//    self.mode.libInit = 1;//调用反初始化后，设为1
    
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
    
    if (_selfPhotoChecked == nil) {
        return;
    }
    
    if ( _frameProcessing)  //如果正在获取帧数据，返回
    {
        return;
    }
    
    _frameProcessing = YES; //设为正在获取的状态
    
    NSDate *now = [NSDate date];//生成一个当下的时间
    
    if (_lastTickTime && [now timeIntervalSinceDate:_lastTickTime] < 1)//如果代理指针指向空，并且最后一个时间不为空，并且最后一个时间到现在的时间差值小于1秒
    {
        _frameProcessing = NO;//设置为不在获取的状态
        return;
    }
    _lastTickTime = now;// 设置最后一个时间为现在的时间
    
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);// 为媒体数据设置一个buf的Video图像缓存对象
    
    
    CVPixelBufferLockBaseAddress(imageBuffer, 0);// 锁定buf的基地址
    
//    void *baseAddress = CVPixelBufferGetBaseAddress(imageBuffer);// 得到指向buf指针
    
//    size_t dataSize = CVPixelBufferGetDataSize(imageBuffer);// 得到buf的大小
    
    SInputGrayBufInfo *pGrayBufInfo = [self createGrayBufInfo:imageBuffer];// 从buf生成灰度值信息的结构体
    
    if (_debugGrayImage)
    {
        _debugGrayImage([self createGrayImage:pGrayBufInfo]);
    }
    
    if (_selfPhotoChecked && !_libSelfPhotoSetted) {
        if(!_libInited)
        {
            //如果没有初始化就初始化
            [self libInit];
        }
        
        int result = checkSelfPhotoGrayBuffer(pGrayBufInfo);//检测自拍照上的人脸是否满足要求，是.a中的方法
        
        if (result<0)
        {
            //如果环境错误就反初始化再初始化
            [self libUnInit];
            
            [self libInit];
        }
        
        if(result == eCSPT_OK)//如果经过检测，人脸满足要求
        {
            NSData *jpgData = [self createJpgData:imageBuffer];//从视频帧生成JEPG的图片data
            
            [_model setData:[jpgData copy]];
            
            if((_libLastError = setSelfPhotoJpgBuffer((unsigned char *)jpgData.bytes , (int)jpgData.length)) == 0) {//如果设置自拍照的图片buf成功
                dispatch_async(dispatch_get_main_queue(), ^{//到主线程中
                    _libSelfPhotoSetted = YES;//就设置成已经调用setSelfPhotoJpgBuffer()
                    _jpgData = jpgData;//将自拍照的data赋值给自己                    
                    
                    [_model setMySelfie:[UIImage imageWithCGImage:[[UIImage imageWithData:jpgData] CGImage] scale:1.0 orientation:UIImageOrientationUp]];//赋值自拍照
                });
            } else
            {
                NSLog(@"** 错误 ** 调用 setSelfPhotoJpgBuffer 失败。 code: %d", _libLastError);
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{//到主线程中
            if(_selfPhotoChecked){
                
                _selfPhotoChecked(result);
            }
        });
    }
    CVPixelBufferUnlockBaseAddress(imageBuffer, 0);
    
    _frameProcessing = NO;
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
        //        size_t size = sizeof(unsigned char) * 640 * 480;
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


-(void)stop {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (_session)
        {
            [_session stopRunning];
        }
        [self libUnInit];
        
        _jpgData = nil;
        _libSelfPhotoSetted = NO;
        
        _animing = NO;
        
        if (self.timer) {
            [self.timer invalidate];
            self.timer = nil;
        }
    });
}



//动画
-(void)scanlineAnim
{
    self.scanlineImageView.transform = CGAffineTransformMakeTranslation(0, -self.videoView.frame.size.height);
    [UIView animateWithDuration:1.2 animations:^{
        self.scanlineImageView.transform = CGAffineTransformMakeTranslation(0, self.videoView.frame.size.height);
    } completion:^(BOOL finished)
     {
         if (_animing)
         {
             
             [self scanlineAnim];
         }
     }];
}
//开始动画
-(void)startScanlineAnim
{
    
    _animing = YES;
    [self scanlineAnim];
}



@end

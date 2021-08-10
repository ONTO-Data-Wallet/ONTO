//
//  STLivenessController.m
//  STLivenessController
//
//  Created by sluin on 15/12/4.
//  Copyright © 2015年 SunLin. All rights reserved.
//

#import "STLivenessController.h"
#import "STLivenessDetector.h"
#import "STLivenessCommon.h"
#import "UIView+STLayout.h"
#import "STNumberLabel.h"
#import "STStartAndStopIndicatorView.h"

@interface STLivenessController () <STLivenessDetectorDelegate, AVCaptureVideoDataOutputSampleBufferDelegate> {
    NSArray *_detectionArr;
    NSMutableArray *_previousSecondTimestamps;
}

@property (copy, nonatomic) NSString *bundlePathStr;

@property (weak, nonatomic) id<STLivenessControllerDelegate> controllerDelegate;

@property (weak, nonatomic) id<STLivenessDetectorDelegate> delegate;

@property (strong, nonatomic) UIImageView *imageMaskView;
@property (strong, nonatomic) UIImage *imageMask;
@property (strong, nonatomic) UIView *blackMaskView;

@property (strong, nonatomic) UIView *stepBackGroundView;
@property (strong, nonatomic) UIView *stepBGViewBGView;

@property (strong, nonatomic) UIImageView *imageAnimationBGView;
@property (strong, nonatomic) UIImageView *imageAnimationView;

@property (strong, nonatomic) UILabel *trackerPromptLabel;

@property (strong, nonatomic) UILabel *countDownLable;

@property (strong, nonatomic) UILabel *promptLabel;

@property (strong, nonatomic) UIButton *soundButton;

@property (assign, nonatomic) CGFloat currentPlayerVolume;

@property (strong, nonatomic) UIButton *backButton;

@property (strong, nonatomic) AVAudioPlayer *blinkAudioPlayer;
@property (strong, nonatomic) AVAudioPlayer *mouthAudioPlayer;
@property (strong, nonatomic) AVAudioPlayer *nodAudioPlayer;
@property (strong, nonatomic) AVAudioPlayer *yawAudioPlayer;
@property (strong, nonatomic) AVAudioPlayer *currentAudioPlayer;

@property (strong, nonatomic) NSArray *arrMouthImages;
@property (strong, nonatomic) NSArray *arrYawImages;
@property (strong, nonatomic) NSArray *arrPitchImages;
@property (strong, nonatomic) NSArray *arrBlinkImages;

@property (strong, nonatomic) AVCaptureDeviceInput *deviceInput;
@property (strong, nonatomic) AVCaptureVideoDataOutput *dataOutput;
@property (strong, nonatomic) AVCaptureSession *session;
@property (strong, nonatomic) AVCaptureDevice *deviceFront;
@property (assign, nonatomic) CGRect previewframe;

@property (assign, nonatomic) BOOL isShowCountDownView;

@property (assign, nonatomic) BOOL is3_5InchScreen;

@property (assign, nonatomic) BOOL isCameraPermission;

@property (nonatomic, copy) NSString *resourcesBundlePathStr;

@property (strong, nonatomic) UIImage *imageSoundOn;

@property (strong, nonatomic) UIImage *imageSoundOff;

@property (strong, nonatomic) NSOperationQueue *mainQueue;

@property (strong, nonatomic) NSTimer *timer;

@property (nonatomic, assign) CFAbsoluteTime lastUpdateTime;

@end

@implementation STLivenessController

- (instancetype)init {
    NSLog(@" ╔—————————————————————— WARNING —————————————————————╗");
    NSLog(@" | [[STLivenessController alloc] init] is not allowed |");
    NSLog(@" |     Please use  \"initWithApiKey\" , thanks !    |");
    NSLog(@" ╚————————————————————————————————————————————————————╝");
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

#pragma - mark -
#pragma - mark Public method

- (instancetype)initWithApiKey:(NSString *)apiKeyStr
                     apiSecret:(NSString *)apiSecretStr
                   setDelegate:(id<STLivenessDetectorDelegate, STLivenessControllerDelegate>)delegate
             detectionSequence:(NSArray *)detectionArr {
    self = [super init];

    if (self) {
        if (!detectionArr) {
            NSLog(@" ╔———————————— WARNING ————————————╗");
            NSLog(@" |                                 |");
            NSLog(@" |  Please set detection sequence !|");
            NSLog(@" |                                 |");
            NSLog(@" ╚—————————————————————————————————╝");
        } else {
            // 资源路径
            _bundlePathStr = [[NSBundle mainBundle] pathForResource:@"st_liveness_resource" ofType:@"bundle"];
            // 模型路径
            NSString *modelPathStr = [NSString
                pathWithComponents:@[self.bundlePathStr, @"model", @"SenseID_Composite_General_Liveness.model"]];
            // 授权文件路径
            NSString *financeLicensePathStr =
                [[NSBundle mainBundle] pathForResource:@"SenseID_Liveness_Interactive" ofType:@"lic"];

            _previewframe = CGRectMake(0, 0, kSTScreenWidth, kSTScreenHeight);

            double prepareCenterX = kSTScreenWidth / 2.0;
            double prepareCenterY = kSTScreenHeight / 2.0;
            double prepareRadius = kSTScreenWidth / 3;
            _detector = [[STLivenessDetector alloc] initWithModelPath:modelPathStr
                                                   financeLicensePath:financeLicensePathStr
                                                               apiKey:apiKeyStr
                                                            apiSecret:apiSecretStr
                                                          setDelegate:self
                                                    detectionSequence:detectionArr
                                                            isTracker:YES];
            [self setPrepareCenterPoint:CGPointMake(prepareCenterX, prepareCenterY)
                          prepareRadius:prepareRadius
                           previewframe:self.previewframe];
        }
        _isVoicePrompt = YES;

        _currentPlayerVolume = 0.8;

        _detectionArr = [detectionArr mutableCopy];

        _previousSecondTimestamps = [[NSMutableArray alloc] init];

        _imageSoundOn = [self imageWithFullFileName:@"st_sound_on.png"];
        _imageSoundOff = [self imageWithFullFileName:@"st_sound_off.png"];

        if (_delegate != delegate) {
            _delegate = delegate;
            _controllerDelegate = delegate;
        }
        _mainQueue = [NSOperationQueue mainQueue];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(willResignActive)
                                                     name:UIApplicationWillResignActiveNotification
                                                   object:nil];
    }
    return self;
}

- (void)setIsVoicePrompt:(BOOL)isVoicePrompt {
    _isVoicePrompt = isVoicePrompt;
    [self setPlayerVolume];
}
- (void)setPrepareCenterPoint:(CGPoint)point prepareRadius:(CGFloat)radius previewframe:(CGRect)previewframe {
    [self.detector setPrepareCenterPoint:point prepareRadius:radius previewframe:previewframe];
}
+ (NSString *)getVersion {
    return [STLivenessDetector getVersion];
}

#pragma - mark -
#pragma - mark Life Cycle

- (void)loadView {
    [super loadView];

    self.is3_5InchScreen = (kSTScreenHeight == 480);

    [self setupUI];

    [self displayViewsIfRunning:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
#if !TARGET_IPHONE_SIMULATOR

    BOOL bSetupCaptureSession = [self setupCaptureSession];

    if (!bSetupCaptureSession) {
        return;
    }
    [self setupAudio];
#endif
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.detector && self.session && self.dataOutput && ![self.session isRunning]) {
        [self.session startRunning];
    }
    [self cameraStart];
}

- (void)dealloc {
    if (_session) {
        [_session beginConfiguration];
        [_session removeOutput:_dataOutput];
        [_session removeInput:_deviceInput];
        [_session commitConfiguration];

        if ([_session isRunning]) {
            [_session stopRunning];
        }
    }

    if ([_currentAudioPlayer isPlaying]) {
        [_currentAudioPlayer stop];
    }

    if ([_imageAnimationView isAnimating]) {
        [_imageAnimationView stopAnimating];
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma - mark -
#pragma - mark Private Methods_

- (void)willResignActive {
    [self clearStepViewAndStopSoundInvalidateTimer];
    [self displayViewsIfRunning:NO];

    if (self.controllerDelegate &&
        [self.controllerDelegate respondsToSelector:@selector(livenessControllerDeveiceError:)] &&
        self.isCameraPermission) {
        [self.mainQueue addOperationWithBlock:^{
            [self.controllerDelegate livenessControllerDeveiceError:STIDLiveness_WILL_RESIGN_ACTIVE];
        }];
    }

    [STStartAndStopIndicatorView sharedIndicatorStopAnimate];

}
- (void)setupUI {
    self.view.backgroundColor = [UIColor blackColor];

    self.imageMask = [self imageWithFullFileName:self.is3_5InchScreen ? @"st_mask_s.png" : @"st_mask_b.png"];

    UIImage *imageMouth1 = [self imageWithFullFileName:@"st_mouth1.png"];
    UIImage *imageMouth2 = [self imageWithFullFileName:@"st_mouth2.png"];

    UIImage *imagePitch1 = [self imageWithFullFileName:@"st_pitch1.png"];
    UIImage *imagePitch2 = [self imageWithFullFileName:@"st_pitch2.png"];
    UIImage *imagePitch3 = [self imageWithFullFileName:@"st_pitch3.png"];
    UIImage *imagePitch4 = [self imageWithFullFileName:@"st_pitch4.png"];
    UIImage *imagePitch5 = [self imageWithFullFileName:@"st_pitch5.png"];

    UIImage *imageBlink1 = [self imageWithFullFileName:@"st_blink1.png"];
    UIImage *imageBlink2 = [self imageWithFullFileName:@"st_blink2.png"];

    UIImage *imageYaw1 = [self imageWithFullFileName:@"st_yaw1.png"];
    UIImage *imageYaw2 = [self imageWithFullFileName:@"st_yaw2.png"];
    UIImage *imageYaw3 = [self imageWithFullFileName:@"st_yaw3.png"];
    UIImage *imageYaw4 = [self imageWithFullFileName:@"st_yaw4.png"];
    UIImage *imageYaw5 = [self imageWithFullFileName:@"st_yaw5.png"];

    if (imageMouth1 && imageMouth2) {
        self.arrMouthImages = @[imageMouth1, imageMouth2];
    }
    if (imagePitch1 && imagePitch2 && imagePitch3 && imagePitch4 && imagePitch5) {
        self.arrPitchImages =
            @[imagePitch1, imagePitch2, imagePitch3, imagePitch4, imagePitch5, imagePitch4, imagePitch3, imagePitch2];
    }
    if (imageBlink1 && imageBlink2) {
        self.arrBlinkImages = @[imageBlink1, imageBlink2];
    }

    if (imageYaw1 && imageYaw2 && imageYaw3 && imageYaw4 && imageYaw5) {
        self.arrYawImages = @[imageYaw1, imageYaw2, imageYaw3, imageYaw4, imageYaw5, imageYaw4, imageYaw3, imageYaw2];
    }
    self.imageMaskView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kSTScreenWidth, kSTScreenHeight)];
    self.imageMaskView.image = self.imageMask;
    self.imageMaskView.userInteractionEnabled = YES;
    self.imageMaskView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:self.imageMaskView];

    self.blackMaskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSTScreenWidth, kSTScreenHeight)];
    self.blackMaskView.backgroundColor = [UIColor blackColor];
    self.blackMaskView.alpha = 0.3;
    [self.imageMaskView addSubview:self.blackMaskView];

    self.stepBackGroundView =
        [[UIView alloc] initWithFrame:self.is3_5InchScreen ?
                            CGRectMake(0, 0, _detectionArr.count * 16.0 + (_detectionArr.count - 1) * 8.0, 16.0) :
                            CGRectMake(0, 0, _detectionArr.count * 20.0 + (_detectionArr.count - 1) * 10.0, 20.0)];
    self.stepBackGroundView.backgroundColor = [UIColor clearColor];
    self.stepBackGroundView.hidden = YES;
    self.stepBackGroundView.stCenterX = kSTScreenWidth / 2.0;
    self.stepBackGroundView.stBottom = self.imageMaskView.stBottom - 20;
    self.stepBackGroundView.userInteractionEnabled = NO;

    self.stepBGViewBGView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                     0,
                                                                     self.stepBackGroundView.frame.size.width + 6.0,
                                                                     self.stepBackGroundView.frame.size.height + 6.0)];
    self.stepBGViewBGView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    self.stepBGViewBGView.layer.cornerRadius = self.stepBGViewBGView.frame.size.height / 2.0;
    self.stepBGViewBGView.center = self.stepBackGroundView.center;
    self.stepBGViewBGView.hidden = YES;
    [self.imageMaskView addSubview:self.stepBGViewBGView];
    [self.imageMaskView addSubview:self.stepBackGroundView];

    for (int i = 0; i < _detectionArr.count; i++) {
        STNumberLabel *lblStepNumber =
            [[STNumberLabel alloc] initWithFrame:self.is3_5InchScreen ? CGRectMake(i * 20.0 + i * 4.0, 0, 16.0, 16.0) :
                                                                        CGRectMake(i * 25.0 + i * 5.0, 0, 20.0, 20.0)
                                          number:i + 1];
        lblStepNumber.tag = i + kSTViewTagBase;
        [self.stepBackGroundView addSubview:lblStepNumber];
    }

    // ------动画
    self.imageAnimationBGView =
        [[UIImageView alloc] initWithFrame:self.is3_5InchScreen ? CGRectMake(0, 0, kSTScreenWidth, 130.0) :
                                                                  CGRectMake(0, 0, kSTScreenWidth, 150.0)];
    self.imageAnimationBGView.stBottom = self.stepBGViewBGView.stTop - 16.0;
    [self.imageMaskView addSubview:self.imageAnimationBGView];

    CGFloat fAnimationViewWidth = self.is3_5InchScreen ? 80.0 : 100.0;

    self.imageAnimationView = [[UIImageView alloc] initWithFrame:CGRectMake((kSTScreenWidth - fAnimationViewWidth) / 2,
                                                                            0,
                                                                            fAnimationViewWidth,
                                                                            fAnimationViewWidth)];
    self.imageAnimationView.stY = self.imageAnimationBGView.stHeight - self.imageAnimationView.stHeight + 10;
    self.imageAnimationView.animationDuration = 2.0f;
    self.imageAnimationView.layer.cornerRadius = self.imageAnimationView.frame.size.width / 2;
    self.imageAnimationView.backgroundColor = kSTColorWithRGB(0xC8C8C8);
    [self.imageAnimationBGView addSubview:self.imageAnimationView];

    // ------倒计时
    float fLabelCountDownWidth = self.is3_5InchScreen ? 36.0 : 45.0;
    self.countDownLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, fLabelCountDownWidth, fLabelCountDownWidth)];
    self.countDownLable.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    self.countDownLable.textColor = [UIColor whiteColor];
    self.countDownLable.stRight = self.imageMaskView.stWidth * 0.85;
    self.countDownLable.stCenterY = self.imageAnimationView.stCenterY + self.imageAnimationBGView.stTop;
    self.countDownLable.layer.cornerRadius = fLabelCountDownWidth / 2.0f;
    self.countDownLable.clipsToBounds = YES;
    self.countDownLable.adjustsFontSizeToFitWidth = YES;
    self.countDownLable.font = [UIFont systemFontOfSize:fLabelCountDownWidth / 2.0f];
    self.countDownLable.textAlignment = NSTextAlignmentCenter;
    self.countDownLable.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    [self.imageMaskView addSubview:self.countDownLable];

    // ------提示文字
    self.promptLabel =
        [[UILabel alloc] initWithFrame:self.is3_5InchScreen ? CGRectMake(0, 0, 90, 30.0) : CGRectMake(0, 0, 90, 38.0)];
    self.promptLabel.center = CGPointMake(self.imageAnimationView.stCenterX, self.imageAnimationView.stTop - 14.0 - 10);
    self.promptLabel.font = [UIFont systemFontOfSize:self.is3_5InchScreen ? 15.0 : 20];
    self.promptLabel.textAlignment = NSTextAlignmentCenter;
    self.promptLabel.textColor = [UIColor whiteColor];
    self.promptLabel.layer.cornerRadius = self.promptLabel.stHeight / 2.0;
    self.promptLabel.layer.masksToBounds = YES;
    self.promptLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    [self.imageAnimationBGView addSubview:self.promptLabel];

    // ------tracker提示文字
    self.trackerPromptLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kSTScreenWidth, 38.0)];
    self.trackerPromptLabel.center = CGPointMake(self.imageAnimationView.stCenterX, self.imageAnimationView.stTop);
    self.trackerPromptLabel.font = [UIFont systemFontOfSize:self.is3_5InchScreen ? 15.0 : 20.0];
    self.trackerPromptLabel.textAlignment = NSTextAlignmentCenter;
    self.trackerPromptLabel.textColor = [UIColor whiteColor];
    self.trackerPromptLabel.text = @"请正对手机";

    [self.imageAnimationBGView addSubview:self.trackerPromptLabel];

    // ------语音按钮
    UIButton *soundButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [soundButton setFrame:self.is3_5InchScreen ? CGRectMake(kSTScreenWidth - 50, 30, 30, 30) :
                                                 CGRectMake(kSTScreenWidth - 58, 30, 38, 38)];
    [soundButton setImage:self.isVoicePrompt ? self.imageSoundOn : self.imageSoundOff forState:UIControlStateNormal];
    [soundButton addTarget:self action:@selector(onsoundButton) forControlEvents:UIControlEventTouchUpInside];
    [self.imageMaskView addSubview:soundButton];
    self.soundButton = soundButton;

    // ------返回按钮
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];

    [backButton setFrame:self.is3_5InchScreen ? CGRectMake(20, 30, 30, 30) : CGRectMake(20, 30, 38, 38)];
    [backButton setImage:[self imageWithFullFileName:@"st_scan_back.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(onbackButton) forControlEvents:UIControlEventTouchUpInside];
    [self.imageMaskView addSubview:backButton];
    self.backButton = backButton;
}

- (void)setupAudio {
    NSString *blinkPathStr = [self audioPathWithFullFileName:@"st_notice_blink.mp3"];
    self.blinkAudioPlayer =
        [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:blinkPathStr] error:nil];
    self.blinkAudioPlayer.volume = self.currentPlayerVolume;
    self.blinkAudioPlayer.numberOfLoops = -1;
    [self.blinkAudioPlayer prepareToPlay];

    NSString *mouthPathStr = [self audioPathWithFullFileName:@"st_notice_mouth.mp3"];
    self.mouthAudioPlayer =
        [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:mouthPathStr] error:nil];
    self.mouthAudioPlayer.volume = self.currentPlayerVolume;
    self.mouthAudioPlayer.numberOfLoops = -1;
    [self.mouthAudioPlayer prepareToPlay];

    NSString *nodPathStr = [self audioPathWithFullFileName:@"st_notice_nod.mp3"];
    self.nodAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:nodPathStr] error:nil];
    self.nodAudioPlayer.volume = self.currentPlayerVolume;
    self.nodAudioPlayer.numberOfLoops = -1;
    [self.nodAudioPlayer prepareToPlay];

    NSString *yawPathStr = [self audioPathWithFullFileName:@"st_notice_yaw.mp3"];
    self.yawAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:yawPathStr] error:nil];
    self.yawAudioPlayer.volume = self.currentPlayerVolume;
    self.yawAudioPlayer.numberOfLoops = -1;
    [self.yawAudioPlayer prepareToPlay];
}

- (BOOL)setupCaptureSession {
#if !TARGET_IPHONE_SIMULATOR

    self.session = [[AVCaptureSession alloc] init];
    // iPhone 4S, +
    self.session.sessionPreset = AVCaptureSessionPreset640x480;

    AVCaptureVideoPreviewLayer *captureVideoPreviewLayer =
        [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];

    captureVideoPreviewLayer.frame = self.previewframe;
    [captureVideoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];

    [self.view.layer addSublayer:captureVideoPreviewLayer];
    [self.view bringSubviewToFront:self.blackMaskView];
    [self.view bringSubviewToFront:self.imageMaskView];

    NSArray *devices = [AVCaptureDevice devices];
    for (AVCaptureDevice *device in devices) {
        if ([device hasMediaType:AVMediaTypeVideo] && [device position] == AVCaptureDevicePositionFront) {
            self.deviceFront = device;
        }
    }

    int frameRate;
    CMTime frameDuration = kCMTimeInvalid;

    frameRate = 30;
    frameDuration = CMTimeMake(1, frameRate);

    NSError *error = nil;
    if ([self.deviceFront lockForConfiguration:&error]) {
        self.deviceFront.activeVideoMaxFrameDuration = frameDuration;
        self.deviceFront.activeVideoMinFrameDuration = frameDuration;
        [self.deviceFront unlockForConfiguration];
    }

    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:self.deviceFront error:&error];
    self.deviceInput = input;

    self.dataOutput = [[AVCaptureVideoDataOutput alloc] init];

    [self.dataOutput setAlwaysDiscardsLateVideoFrames:YES];

    //视频的格式只能为kCVPixelFormatType_32BGRA
    [self.dataOutput
        setVideoSettings:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:kCVPixelFormatType_32BGRA]
                                                     forKey:(id) kCVPixelBufferPixelFormatTypeKey]];

    dispatch_queue_t queueBuffer = dispatch_queue_create("LIVENESS_BUFFER_QUEUE", NULL);

    [self.dataOutput setSampleBufferDelegate:self queue:queueBuffer];

    [self.session beginConfiguration];

    if ([self.session canAddOutput:self.dataOutput]) {
        [self.session addOutput:self.dataOutput];
    }
    if ([self.session canAddInput:input]) {
        [self.session addInput:input];
    }

    [self.session commitConfiguration];
#endif

    return YES;
}

- (UIImage *)imageWithFullFileName:(NSString *)fileNameStr {
    NSString *filePathStr = [NSString pathWithComponents:@[self.bundlePathStr, @"images", fileNameStr]];

    return [UIImage imageWithContentsOfFile:filePathStr];
}

- (NSString *)audioPathWithFullFileName:(NSString *)fileNameStr {
    NSString *filePathStr = [NSString pathWithComponents:@[self.bundlePathStr, @"sounds", fileNameStr]];
    return filePathStr;
}

- (void)displayViewsIfRunning:(BOOL)bRunning {
    self.blackMaskView.hidden = bRunning;
    self.imageAnimationView.hidden = !bRunning;
    self.promptLabel.hidden = !bRunning;
    self.stepBackGroundView.hidden = !bRunning;
    self.stepBGViewBGView.hidden = !bRunning;
    self.countDownLable.hidden = self.isShowCountDownView ? !bRunning : YES;
    self.trackerPromptLabel.hidden = bRunning;
    self.trackerPromptLabel.text = @"";
}
- (void)showPromptWithDetectionType:(STIDLivenessFaceDetectionType)iType detectionIndex:(NSInteger)index {
    if (self.currentAudioPlayer) {
        [self stopAudioPlayer];
    }

    STNumberLabel *lblNumber = [self.stepBackGroundView viewWithTag:kSTViewTagBase + index];
    lblNumber.isHighlight = YES;

    if ([self.imageAnimationView isAnimating]) {
        [self.imageAnimationView stopAnimating];
    }

    CATransition *transion = [CATransition animation];
    transion.type = @"push";
    transion.subtype = @"fromRight";
    transion.duration = 0.5f;
    transion.removedOnCompletion = YES;
    [self.imageAnimationBGView.layer addAnimation:transion forKey:nil];

    switch (iType) {
        case STIDLiveness_YAW: {
            self.promptLabel.text = @"请缓慢摇头";
            self.promptLabel.stWidth = 140;
            self.promptLabel.stX = (kSTScreenWidth - self.promptLabel.stWidth) / 2.0;
            self.imageAnimationView.animationDuration = 2.0f;
            self.imageAnimationView.animationImages = self.arrYawImages;
            self.currentAudioPlayer = self.yawAudioPlayer;
            break;
        }

        case STIDLiveness_BLINK: {
            self.promptLabel.text = @"请眨眼";
            self.promptLabel.stWidth = 90;
            self.promptLabel.stX = (kSTScreenWidth - self.promptLabel.stWidth) / 2.0;
            self.imageAnimationView.animationDuration = 1.0f;
            self.imageAnimationView.animationImages = self.arrBlinkImages;
            self.currentAudioPlayer = self.blinkAudioPlayer;
            break;
        }

        case STIDLiveness_MOUTH: {
            self.promptLabel.text = @"请张嘴，随后合拢";
            self.promptLabel.stWidth = 200;
            self.promptLabel.stX = (kSTScreenWidth - self.promptLabel.stWidth) / 2.0;
            self.imageAnimationView.animationDuration = 1.0f;
            self.imageAnimationView.animationImages = self.arrMouthImages;
            self.currentAudioPlayer = self.mouthAudioPlayer;
            break;
        }
        case STIDLiveness_NOD: {
            self.promptLabel.text = @"请上下点头";
            self.promptLabel.stWidth = 140;
            self.promptLabel.stX = (kSTScreenWidth - self.promptLabel.stWidth) / 2.0;
            self.imageAnimationView.animationDuration = 2.0f;
            self.imageAnimationView.animationImages = self.arrPitchImages;
            self.currentAudioPlayer = self.nodAudioPlayer;
            break;
        }
    }

    if (![self.imageAnimationView isAnimating]) {
        [self.imageAnimationView startAnimating];
    }

    if (self.currentAudioPlayer) {
        [self stopAudioPlayer];
        [self.currentAudioPlayer play];
    }
}

- (void)stopAudioPlayer {
    if ([self.currentAudioPlayer isPlaying]) {
        self.currentAudioPlayer.currentTime = 0;
        [self.currentAudioPlayer stop];
    }
}

- (void)clearStepViewAndStopSoundInvalidateTimer {
    if (self.currentAudioPlayer) {
        [self stopAudioPlayer];
    }
    for (STNumberLabel *lblNumber in self.stepBackGroundView.subviews) {
        lblNumber.isHighlight = NO;
    }
    if ([self.timer isValid]) {
        [self.timer invalidate];
    }
}

- (void)setPlayerVolume {
    [self.soundButton setImage:self.isVoicePrompt ? self.imageSoundOn : self.imageSoundOff
                      forState:UIControlStateNormal];

    self.currentPlayerVolume = self.isVoicePrompt ? 0.8 : 0;

    self.blinkAudioPlayer.volume = self.currentPlayerVolume;
    self.mouthAudioPlayer.volume = self.currentPlayerVolume;
    self.nodAudioPlayer.volume = self.currentPlayerVolume;
    self.yawAudioPlayer.volume = self.currentPlayerVolume;
}

- (void)cameraStart {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];

    switch (authStatus) {
        case AVAuthorizationStatusNotDetermined: {
            [AVCaptureDevice
                requestAccessForMediaType:AVMediaTypeVideo
                        completionHandler:^(BOOL granted) {
                            if (granted) {
                                self.isCameraPermission = YES;

                            } else {
                                if (self.controllerDelegate &&
                                    [self.controllerDelegate
                                        respondsToSelector:@selector(livenessControllerDeveiceError:)]) {
                                    [self.mainQueue addOperationWithBlock:^{
                                        [self.controllerDelegate livenessControllerDeveiceError:STIDLiveness_E_CAMERA];
                                    }];
                                }
                            }
                        }];
            break;
        }
        case AVAuthorizationStatusAuthorized: {
            self.isCameraPermission = YES;
            break;
        }
        case AVAuthorizationStatusDenied:
        case AVAuthorizationStatusRestricted: {
            if (self.controllerDelegate &&
                [self.controllerDelegate respondsToSelector:@selector(livenessControllerDeveiceError:)]) {
                [self.mainQueue addOperationWithBlock:^{
                    [self.controllerDelegate livenessControllerDeveiceError:STIDLiveness_E_CAMERA];
                }];
            }
            break;
        }
    }
}

#pragma - mark -
#pragma - mark Event Response

- (void)onbackButton {
    self.isCameraPermission = NO;
    [self.detector cancelDetection];
}
- (void)onsoundButton {
    self.isVoicePrompt = !self.isVoicePrompt;

    [self setPlayerVolume];
}

#pragma - mark -
#pragma - mark AVCaptureVideoDataOutputSampleBufferDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput //! OCLINT
    didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
           fromConnection:(AVCaptureConnection *)connection { //! OCLINT
    CMTime timestamp = CMSampleBufferGetPresentationTimeStamp(sampleBuffer);

    if (self.delegate && [self.delegate respondsToSelector:@selector(videoFrameRate:)]) {
        [self.delegate videoFrameRate:[self calculateFramerateAtTimestamp:timestamp]];
    }
    if (self.isCameraPermission && self.detector) {
        [self.detector trackAndDetectWithCMSampleBuffer:sampleBuffer
                                         faceOrientaion:STIDLiveness_FACE_LEFT
                                        isVideoMirrored:connection.isVideoMirrored];
    }
}

- (int)calculateFramerateAtTimestamp:(CMTime)timestamp {
    [_previousSecondTimestamps addObject:[NSValue valueWithCMTime:timestamp]];

    CMTime oneSecond = CMTimeMake(1, 1);
    CMTime oneSecondAgo = CMTimeSubtract(timestamp, oneSecond);

    while (CMTIME_COMPARE_INLINE([_previousSecondTimestamps[0] CMTimeValue], <, oneSecondAgo)) {
        [_previousSecondTimestamps removeObjectAtIndex:0];
    }

    if ([_previousSecondTimestamps count] > 1) {
        const Float64 duration = CMTimeGetSeconds(CMTimeSubtract([[_previousSecondTimestamps lastObject] CMTimeValue],
                                                                 [_previousSecondTimestamps[0] CMTimeValue]));
        const float newRate = (float) ([_previousSecondTimestamps count] - 1) / duration;
        return (int) roundf(newRate);
    }
    return 0;
}

#pragma - mark -
#pragma - mark STLivenessDetectorDelegate

- (void)livenessFaceRect:(CGRect)rect {
    if (self.delegate && [self.delegate respondsToSelector:@selector(livenessFaceRect:)]) {
        [self.mainQueue addOperationWithBlock:^{
            [self.delegate livenessFaceRect:rect];
        }];
    }
}

- (void)livenessTimeDidPast:(CGFloat)past duration:(CGFloat)duration {
    if (duration != 0) {
        self.countDownLable.text = [NSString stringWithFormat:@"%@", @((NSInteger)(duration - past))];
    }
}
- (void)livenessTrackerSuccessed {
    self.trackerPromptLabel.text = @"";

    if (self.session && [self.session isRunning] && self.detector) {
        self.imageMaskView.image =
            [self imageWithFullFileName:self.is3_5InchScreen ? @"st_mask_green_s.png" : @"st_mask_green_b.png"];

        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.5
                                                      target:self
                                                    selector:@selector(startDetection)
                                                    userInfo:nil
                                                     repeats:YES];
    }
}
- (void)startDetection {
    self.imageMaskView.image = [self imageWithFullFileName:self.is3_5InchScreen ? @"st_mask_s.png" : @"st_mask_b.png"];
    self.isShowCountDownView = [self.detector timeOutDuration] > 0 ? YES : NO; //! OCLINT
    [self.detector startDetection];
}
- (void)livenessTrackerDistanceStatus:(STIDLivenessFaceDistanceStatus)distanceStatus
                          boundStatus:(STIDLivenessFaceBoundStatus)boundStatus
                            faceModel:(STLivenessFace *)faceModel {
    CFAbsoluteTime currentTime = CFAbsoluteTimeGetCurrent() * 1000;

    if ((currentTime - self.lastUpdateTime) > 300) {
        if (faceModel.isFaceOcclusion) {
            self.trackerPromptLabel.text = [self faceOcclusionStringWithFaceModel:faceModel];
        } else if (distanceStatus == STIDLiveness_FACE_TOO_FAR) {
            self.trackerPromptLabel.text = @"请移动手机靠近面部";
        } else if (distanceStatus == STIDLiveness_FACE_TOO_CLOSE) {
            self.trackerPromptLabel.text = @"请移动手机远离面部";
        } else if (distanceStatus == STIDLiveness_DISTANCE_FACE_NORMAL && boundStatus == STIDLiveness_FACE_IN_BOUNDE) {
            self.trackerPromptLabel.text = @"准备开始检测";

        } else {
            self.trackerPromptLabel.text = @"请将人脸移入框内";
        }
        self.lastUpdateTime = CFAbsoluteTimeGetCurrent() * 1000;
    }
}

- (NSString *)faceOcclusionStringWithFaceModel:(STLivenessFace *)face {
    NSMutableString *tempStr = [[NSMutableString alloc] init];

    if (face.browOcclusionStatus == STIDLiveness_OCCLUSION) {
        [tempStr appendFormat:@"眉毛、"];
    }
    if (face.eyeOcclusionStatus == STIDLiveness_OCCLUSION) {
        [tempStr appendFormat:@"眼睛、"];
    }
    if (face.noseOcclusionStatus == STIDLiveness_OCCLUSION) {
        [tempStr appendFormat:@"鼻子、"];
    }
    if (face.mouthOcclusionStatus == STIDLiveness_OCCLUSION) {
        [tempStr appendFormat:@"嘴巴"];
    }
    NSString *theLast = [tempStr substringFromIndex:[tempStr length] - 1];
    if ([theLast isEqualToString:@"、"]) {
        tempStr = (NSMutableString *) [tempStr substringToIndex:([tempStr length] - 1)];
    }
    return [NSString stringWithFormat:@"请正对手机，去除%@遮挡", tempStr];
}
- (void)livenessDidStartDetectionWithDetectionType:(STIDLivenessFaceDetectionType)detectionType
                                    detectionIndex:(NSInteger)detectionIndex {
    [self displayViewsIfRunning:YES];
    [self showPromptWithDetectionType:detectionType detectionIndex:detectionIndex];

    if (self.delegate &&
        [self.delegate respondsToSelector:@selector(livenessDidStartDetectionWithDetectionType:detectionIndex:)]) {
        [self.mainQueue addOperationWithBlock:^{
            [self.delegate livenessDidStartDetectionWithDetectionType:detectionType detectionIndex:detectionIndex];
        }];
    }
}


- (void)livenessOnlineBegin {
    [self clearStepViewAndStopSoundInvalidateTimer];
    [self displayViewsIfRunning:NO];
    [STStartAndStopIndicatorView sharedIndicatorStartAnimate];
}
- (void)livenessDidSuccessfulGetProtobufId:(NSString *)protobufId
                              protobufData:(NSData *)protobufData
                                 requestId:(NSString *)requestId
                                    images:(NSArray *)imageArr {
    [self clearStepViewAndStopSoundInvalidateTimer];
    [self displayViewsIfRunning:NO];

    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if (self.delegate &&
        [self.delegate
            respondsToSelector:@selector(livenessDidSuccessfulGetProtobufId:protobufData:requestId:images:)]) {
        [self.mainQueue addOperationWithBlock:^{
            [self.delegate livenessDidSuccessfulGetProtobufId:protobufId
                                                 protobufData:protobufData
                                                    requestId:requestId
                                                       images:imageArr];
        }];
    }
    [STStartAndStopIndicatorView sharedIndicatorStopAnimate];
}
- (void)livenessDidFailWithLivenessResult:(STIDLivenessResult)livenessResult
                                faceError:(STIDLivenessFaceError)faceError
                             protobufData:(NSData *)protobufData
                                requestId:(NSString *)requestId
                                   images:(NSArray *)imageArr {
    [self clearStepViewAndStopSoundInvalidateTimer];
    [self displayViewsIfRunning:NO];

    if (self.delegate &&
        [self.delegate
            respondsToSelector:@selector(livenessDidFailWithLivenessResult:faceError:protobufData:requestId:images:)]) {
        [self.mainQueue addOperationWithBlock:^{
            [self.delegate livenessDidFailWithLivenessResult:livenessResult
                                                   faceError:faceError
                                                protobufData:protobufData
                                                   requestId:requestId
                                                      images:imageArr];
        }];
    }
    [STStartAndStopIndicatorView sharedIndicatorStopAnimate];
}

- (void)livenessDidCancel {
    [self clearStepViewAndStopSoundInvalidateTimer];
    [self displayViewsIfRunning:NO];

    if (self.delegate && [self.delegate respondsToSelector:@selector(livenessDidCancel)]) {
        [self.mainQueue addOperationWithBlock:^{
            [self.delegate livenessDidCancel];
        }];
    }

    [STStartAndStopIndicatorView sharedIndicatorStopAnimate];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end

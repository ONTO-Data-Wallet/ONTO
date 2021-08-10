//
//  DDPhotoViewController.m
//  Loan
//
//  Created by yll on 2017/11/7.
//  Copyright © 2017年 Admin. All rights reserved.
//

#import "DDPhotoViewController.h"
#import <Photos/Photos.h>
#import "Config.h"
#import "UIView+Scale.h"

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

@interface DDPhotoViewController ()<AVCaptureMetadataOutputObjectsDelegate,UIAlertViewDelegate,CAAnimationDelegate>

//捕获设备，通常是前置摄像头，后置摄像头，麦克风（音频输入）
@property(nonatomic)AVCaptureDevice *device;
//AVCaptureDeviceInput 代表输入设备，他使用AVCaptureDevice 来初始化
@property(nonatomic)AVCaptureDeviceInput *input;
//当启动摄像头开始捕获输入
@property(nonatomic)AVCaptureMetadataOutput *output;
//输出
@property (nonatomic)AVCaptureStillImageOutput *ImageOutPut;
//session：由他把输入输出结合在一起，并开始启动捕获设备（摄像头）
@property(nonatomic)AVCaptureSession *session;
//图像预览层，实时显示捕获的图像
@property(nonatomic)AVCaptureVideoPreviewLayer *previewLayer;
//设备
@property (nonatomic, strong)AVCaptureDevice *deveice;
//拍照
@property (nonatomic, strong) UIButton *PhotoButton;

//返回
@property (nonatomic, strong) UIButton *backButton;
// title
@property (nonatomic, strong) UILabel  *titleLB;
// info
@property (nonatomic, strong) UILabel  *infoLB;

//取消
@property (nonatomic, strong) UIButton *cancleButton;
//相册
@property (nonatomic, strong) UIButton *albumButton;
//切换摄像头
@property (nonatomic, strong) UIButton *changeButton;
//确定选择当前照片
@property (nonatomic, strong) UIButton *selectButton;
//重新拍照
@property (nonatomic, strong) UIButton *reCamButton;
//照片加载视图
@property (nonatomic, strong) UIImageView *imageView;
//对焦区域
@property (nonatomic, strong) UIImageView *focusView;
//上方功能区
@property (nonatomic, strong) UIView *topView;
//下方功能区
@property (nonatomic, strong) UIView *bottomView;
//拍到的照片
@property (nonatomic, strong) UIImage *image;
//照片的信息
@property (nonatomic, strong) NSDictionary *imageDict;
//是否可以拍照
@property (nonatomic, assign) BOOL canCa;
//闪光灯模式
@property (nonatomic, assign) AVCaptureFlashMode flahMode;
//前后摄像头
@property (nonatomic, assign) AVCaptureDevicePosition cameraPosition;

@property (nonatomic, strong) UIImageView *kuangImgView;//橘色边框

@property (nonatomic, strong) UILabel *tishiLabel;//提示字

//左方功能区
@property (nonatomic, strong) UIView *leftView;
//右方功能区
@property (nonatomic, strong) UIView *rightView;

@end

@implementation DDPhotoViewController

#pragma mark - 上方功能区
-(UIView *)topView{
    if (!_topView ) {
        _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 64 + 80*SCALE_W)];
        _topView.alpha = 0.5;
        _topView.backgroundColor = [UIColor colorWithHexString:@"#5EA2FF"];//[UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
        //        [_topView addSubview:self.cancleButton];
        //        [_topView addSubview:self.changeButton];
        [_topView addSubview:self.titleLB];
        [_topView addSubview:self.infoLB];
        [_topView addSubview:self.backButton];
        
    }
    return _topView;
}

#pragma mark - 左方功能区
-(UIView*)leftView{
    if (!_leftView) {
        _leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 64+80*SCALE_W, (SYSWidth - 280*SCALE_W)/2, 372*SCALE_W)];
        _leftView.alpha = 0.5;
        _leftView.backgroundColor = [UIColor colorWithHexString:@"#5EA2FF"];
    }
    return _leftView;
}
#pragma mark - 右方功能区
-(UIView*)rightView{
    if (!_rightView) {
        _rightView = [[UIView alloc]initWithFrame:CGRectMake((SYSWidth - 280*SCALE_W)/2 + 280*SCALE_W, 64+80*SCALE_W, (SYSWidth - 280*SCALE_W)/2, 372*SCALE_W)];
        _rightView.alpha = 0.5;
        _rightView.backgroundColor = [UIColor colorWithHexString:@"#5EA2FF"];
    }
    return _rightView;
}
#pragma mark - 取消
-(UIButton *)cancleButton{
    if (_cancleButton == nil) {
        _cancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancleButton.frame = CGRectMake(0, SYSHeight -60*SCALE_W-SafeBottomHeight, SYSWidth/2, 60*SCALE_W);
        _cancleButton.backgroundColor =[UIColor colorWithHexString:@"#F3F3F3"];
        _cancleButton.alpha =1;
        [_cancleButton setTitle:Localized(@"newCANCEL") forState:UIControlStateNormal];
        [_cancleButton setTitleColor:[UIColor colorWithHexString:@"#9B9B9B"] forState:UIControlStateNormal];
        _cancleButton.titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightBold];
        [_cancleButton.titleLabel changeSpace:0 wordSpace:1];
        
        [_cancleButton addTarget:self action:@selector(cancle) forControlEvents:UIControlEventTouchUpInside];
    }
    return  _cancleButton ;
}
#pragma mark - 返回
-(UIButton*)backButton{
    if (!_backButton) {
        _backButton = [[UIButton alloc]initWithFrame:CGRectMake(12.5*SCALE_W, 34.5*SCALE_W, 28*SCALE_W, 28*SCALE_W)];
        [_backButton setImage:[UIImage imageNamed:@"cotback"] forState:UIControlStateNormal];
        [_backButton setEnlargeEdge:20];
        [_backButton addTarget:self action:@selector(cancle) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}
#pragma mark - title
-(UILabel*)titleLB{
    if (!_titleLB) {
        _titleLB = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, SYSWidth, 57*SCALE_W)];
        _titleLB.font = [UIFont systemFontOfSize:21 weight:UIFontWeightBold];
        _titleLB.text = Localized(@"takePhoto");
        [_titleLB changeSpace:0 wordSpace:2];
        _titleLB.textAlignment =NSTextAlignmentCenter;
    }
    return _titleLB;
}

#pragma mark - info
-(UILabel*)infoLB{
    if (!_infoLB) {
        NSMutableAttributedString * str = [Common attrString:Localized(@"takeInfo") width:280*SCALE_W font:[UIFont systemFontOfSize:12 weight:UIFontWeightMedium] lineSpace:2 wordSpace:2];
        CGSize strSize = [Common attrSizeString:Localized(@"takeInfo") width:280*SCALE_W font:[UIFont systemFontOfSize:12 weight:UIFontWeightMedium] lineSpace:2 wordSpace:2];
        _infoLB = [[UILabel alloc]initWithFrame:CGRectMake((SYSWidth -280*SCALE_W)/2, 64+27*SCALE_W, 280*SCALE_W, strSize.height)];
        _infoLB.font = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
        _infoLB.numberOfLines   =0;
        _infoLB.attributedText = str;
        _infoLB.textAlignment =NSTextAlignmentLeft;
    }
    return _infoLB;
}

#pragma mark - 相册
-(UIButton*)albumButton{
    if (!_albumButton) {
        _albumButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _albumButton.frame = CGRectMake(SYSWidth/2, SYSHeight  -60*SCALE_W-SafeBottomHeight, SYSWidth/2, 60*SCALE_W);
        _albumButton.backgroundColor =[UIColor colorWithHexString:@"#000000"];
        _albumButton.alpha =1;
        [_albumButton setTitle:Localized(@"newALBUM") forState:UIControlStateNormal];
        [_albumButton setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
        _albumButton.titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightBold];
        [_albumButton.titleLabel changeSpace:0 wordSpace:1];
        [_albumButton addTarget:self action:@selector(albumClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _albumButton;
}
-(void)albumClick{
    self.navigationController.navigationBar.hidden = NO;
    [self dismissViewControllerAnimated:NO completion:nil];
    self.albumBlock(@"");
}
#pragma mark - 下方功能区

-(UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 64+452*SCALE_W, ScreenWidth, SYSHeight - 64 - 452*SCALE_W-60*SCALE_W)];
        _bottomView.backgroundColor =  [UIColor colorWithHexString:@"#5EA2FF"];
        _bottomView.alpha = 0.5;
        //        [_bottomView addSubview:self.PhotoButton];
        //        [_bottomView addSubview:self.selectButton];
    }
    return _bottomView;
}

-(UIButton *)reCamButton{
    if (_reCamButton == nil) {
        _reCamButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _reCamButton.frame = CGRectMake(40, 25, 80, 30);
        [_reCamButton addTarget:self action:@selector(reCam) forControlEvents:UIControlEventTouchUpInside];
        [_reCamButton setTitle:Localized(@"IMRetakephoto") forState:UIControlStateNormal];
        _reCamButton.transform = CGAffineTransformMakeRotation(M_PI/2);
        [_reCamButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _reCamButton.alpha = 0;
    }
    return _reCamButton;
}

-(UIButton *)PhotoButton{
    if (_PhotoButton == nil) {
        _PhotoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _PhotoButton.frame = CGRectMake(ScreenWidth/2.0-25*SCALE_W, SYSHeight - 134*SCALE_W-SafeBottomHeight, 50*SCALE_W,50*SCALE_W );
        [_PhotoButton setImage:[UIImage imageNamed:@"newGroup 7"] forState: UIControlStateNormal];
        [_PhotoButton addTarget:self action:@selector(shutterCamera) forControlEvents:UIControlEventTouchUpInside];
    }
    return _PhotoButton;
}

-(UIButton *)selectButton{
    if (_selectButton == nil) {
        _selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _selectButton.frame = CGRectMake(ScreenWidth-120, 25, 80, 30);
        [_selectButton addTarget:self action:@selector(selectImage) forControlEvents:UIControlEventTouchUpInside];
        [_selectButton setTitle:Localized(@"IMChoosephoto") forState:UIControlStateNormal];
        _selectButton.transform=CGAffineTransformMakeRotation(M_PI/2);
        [_selectButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _selectButton.alpha = 0;
    }
    return _selectButton;
}

#pragma mark - 加载照片的视图
-(UIImageView *)imageView{
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc]initWithFrame:self.previewLayer.frame];
        
        //这里要注意，图片填充方式的选择让图片不要变形了
        
        [_imageView setContentMode:UIViewContentModeScaleAspectFill];
        
        _imageView.clipsToBounds = YES;
        
        _imageView.image = _image;
    }
    return _imageView;
}
#pragma mark - 对焦区域
-(UIImageView *)focusView{
    if (_focusView == nil) {
        _focusView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 80, 80)];
        _focusView.backgroundColor = [UIColor clearColor];
        _focusView.image = [UIImage imageNamed:@"foucs80pt"];
        _focusView.hidden = YES;
    }
    return _focusView;
}

- (UIImageView *)kuangImgView {
    if (_kuangImgView == nil) {
        _kuangImgView = [[UIImageView alloc]initWithFrame:CGRectMake((SYSWidth - 280*SCALE_W)/2, 64+80*SCALE_W,  280*SCALE_W, 372*SCALE_W)];
        _kuangImgView.image = [UIImage imageNamed:@"newRectangle 10"];
    }
    return _kuangImgView;
}

- (UILabel *)tishiLabel {
    
    if (_tishiLabel == nil) {
        _tishiLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth*0.5, 60)];
        _tishiLabel.center = self.view.center;
        _tishiLabel.text = Localized(@"IMIDcard");
        _tishiLabel.textColor = [UIColor whiteColor];
        _tishiLabel.numberOfLines = 0;
        _tishiLabel.textAlignment = NSTextAlignmentCenter;
        _tishiLabel.font = [UIFont systemFontOfSize:15];
        _tishiLabel.transform = CGAffineTransformMakeRotation(M_PI/2);
        
    }
    
    return _tishiLabel;
}

#pragma mark - 使用self.session，初始化预览层，self.session负责驱动input进行信息的采集，layer负责把图像渲染显示
- (AVCaptureVideoPreviewLayer *)previewLayer{
    if (_previewLayer == nil) {
        _previewLayer = [[AVCaptureVideoPreviewLayer alloc]initWithSession:self.session];
        _previewLayer.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - 60*SCALE_W);
        _previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    }
    return  _previewLayer;
}
-(AVCaptureStillImageOutput *)ImageOutPut{
    if (_ImageOutPut == nil) {
        _ImageOutPut = [[AVCaptureStillImageOutput alloc] init];
    }
    return _ImageOutPut;
}
#pragma mark - 初始化输入
-(AVCaptureDeviceInput *)input{
    if (_input == nil) {
        
        _input = [[AVCaptureDeviceInput alloc]initWithDevice:self.device error:nil];
    }
    return _input;
}
#pragma mark - 初始化输出
-(AVCaptureMetadataOutput *)output{
    if (_output == nil) {
        
        _output = [[AVCaptureMetadataOutput alloc]init];
        
    }
    return  _output;
}
#pragma mark - 使用AVMediaTypeVideo 指明self.device代表视频，默认使用后置摄像头进行初始化
-(AVCaptureDevice *)device{
    if (_device == nil) {
        
        _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    }
    return _device;
}

#pragma mark - 当前视图控制器的初始化
- (instancetype)init
{
    self = [super init];
    if (self) {
        _canCa = [self canUserCamear];
    }
    return self;
}

#pragma mark - 检查相机权限
- (BOOL)canUserCamear{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusDenied) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"请打开相机权限" message:@"设置-隐私-相机" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
        alertView.tag = 100;
        [alertView show];
        return NO;
    }
    else{
        return YES;
    }
    return YES;
}
#pragma mark - 视图加载
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    if (_canCa) {
        [self customCamera];
        [self customUI];
    }else{
        return;
    }
    
    
}
#pragma mark - 自定义视图
- (void)customUI {
    
    [self.view addSubview:self.topView];
    [self.view addSubview:self.bottomView];
    [self.view addSubview:self.focusView];
    [self.view addSubview:self.kuangImgView];
    [self.view addSubview:self.PhotoButton];
    [self.view addSubview:self.leftView];
    [self.view addSubview:self.rightView];
    [self.view addSubview:self.cancleButton];
    [self.view addSubview:self.albumButton];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(focusGesture:)];
    [self.view addGestureRecognizer:tapGesture];
    
}
#pragma mark - 自定义相机
- (void)customCamera{
    
    //生成会话，用来结合输入输出
    self.session = [[AVCaptureSession alloc]init];
    if ([self.session canSetSessionPreset:AVCaptureSessionPresetPhoto]) {
        self.session.sessionPreset = AVCaptureSessionPresetPhoto;
    }
    if ([self.session canAddInput:self.input]) {
        [self.session addInput:self.input];
    }
    
    if ([self.session canAddOutput:self.ImageOutPut]) {
        [self.session addOutput:self.ImageOutPut];
    }
    
    [self.view.layer addSublayer:self.previewLayer];
    
    //开始启动
    [self.session startRunning];
    if ([self.device lockForConfiguration:nil]) {
        if ([self.device isFlashModeSupported:AVCaptureFlashModeAuto]) {
            [self.device setFlashMode:AVCaptureFlashModeAuto];
        }
        //自动白平衡
        if ([self.device isWhiteBalanceModeSupported:AVCaptureWhiteBalanceModeAutoWhiteBalance]) {
            [self.device setWhiteBalanceMode:AVCaptureWhiteBalanceModeAutoWhiteBalance];
        }
        
        [self.device unlockForConfiguration];
    }
    
}

#pragma mark - 聚焦
- (void)focusGesture:(UITapGestureRecognizer*)gesture{
    CGPoint point = [gesture locationInView:gesture.view];
    [self focusAtPoint:point];
}
- (void)focusAtPoint:(CGPoint)point{
    CGSize size = self.view.bounds.size;
    CGPoint focusPoint = CGPointMake( point.y /size.height ,1-point.x/size.width );
    NSError *error;
    if ([self.device lockForConfiguration:&error]) {
        
        if ([self.device isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
            [self.device setFocusPointOfInterest:focusPoint];
            [self.device setFocusMode:AVCaptureFocusModeAutoFocus];
        }
        
        if ([self.device isExposureModeSupported:AVCaptureExposureModeAutoExpose ]) {
            [self.device setExposurePointOfInterest:focusPoint];
            [self.device setExposureMode:AVCaptureExposureModeAutoExpose];
        }
        
        [self.device unlockForConfiguration];
        self.focusView.center = point;
        _focusView.hidden = NO;
        
        //        self.focusView.alpha = 1;
        [UIView animateWithDuration:0.2 animations:^{
            self.focusView.transform = CGAffineTransformMakeScale(1.25f, 1.25f);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.3 animations:^{
                self.focusView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
            } completion:^(BOOL finished) {
                [self hiddenFocusAnimation];
            }];
        }];
    }
    
}
#pragma mark - 拍照
- (void)shutterCamera
{
    
    AVCaptureConnection * videoConnection = [self.ImageOutPut connectionWithMediaType:AVMediaTypeVideo];
    if (!videoConnection) {
        return;
    }
    
    [self.ImageOutPut captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        if (imageDataSampleBuffer == NULL) {
            return;
        }
        NSData * imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
        self.image = [UIImage imageWithData:imageData];
        
        UIImage *image1 = self.image;
        CGImageRef cgRef = image1.CGImage;
        CGFloat widthScale = image1.size.width / ScreenWidth;
        CGFloat heightScale = image1.size.height / (ScreenHeight-60*SCALE_W);
        //其实是横屏的
        CGFloat orignWidth = 280*SCALE_W-50*SCALE_W - SafeBottomHeight;//226
        CGFloat orginHeight = 372*SCALE_W;//360
        CGFloat x = (ScreenHeight - orginHeight - PhotoBottomHeight - PhotoTopHeight ) * 0.5 * heightScale;
        CGFloat y = (ScreenWidth - orignWidth) * 0.5 * widthScale;
        CGFloat width = orginHeight * heightScale;
        CGFloat height = orignWidth * widthScale;
        CGRect r = CGRectMake(x, y, width, height);
        CGImageRef imageRef = CGImageCreateWithImageInRect(cgRef, r);
        UIImage *thumbScale = [UIImage imageWithCGImage:imageRef];
        image1 = thumbScale;
        self.image = image1;
        
        self.imageDict = @{@"image":self.image,@"info":@{@"PHImageFileUTIKey":@".jpeg"}};
        [self.session stopRunning];
        [self.view insertSubview:self.imageView belowSubview:self.topView];
        self.imageblock(self.image);
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}
- (UIImage *)drawImage:(UIImage *)image{
    // 定义一个范围
    CGRect rect = CGRectMake(64+80*SCALE_W,(SYSWidth -280*SCALE_W)/2,372*SCALE_W,280*SCALE_W);
    // 开启上下文
    UIGraphicsBeginImageContext(rect.size);
    //会将当前图片的所有内容完整的画到上下文中
    [image drawInRect:rect];
    //新的image
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
//-
#pragma - 保存至相册
- (void)saveImageToPhotoAlbum:(UIImage*)savedImage
{
    
    UIImageWriteToSavedPhotosAlbum(savedImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    
}
// 指定回调方法

- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo{
    if(error != NULL){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"保存图片结果提示"
                                                        message:@"保存图片失败"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
    }
}
//-
#pragma mark - 取消 返回上级
-(void)cancle{
    [self.imageView removeFromSuperview];
    [self.session stopRunning];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0 && alertView.tag == 100) {
        
        NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        
        if([[UIApplication sharedApplication] canOpenURL:url]) {
            
            [[UIApplication sharedApplication] openURL:url];
            
        }
    }
}
#pragma mark - 重新拍照
- (void)reCam{
    self.imageView.image = nil;
    [self.imageView removeFromSuperview];
    [self.session startRunning];
    //    self.PhotoButton.alpha = 1;
    //    self.reCamButton.alpha = 0;
    //    self.selectButton.alpha = 0;
}

#warning 这里是重点

#pragma mark - 选择照片 返回上级
- (void)selectImage{
    
    UIImage *image1 = self.image;
    
    //    CGImageRef cgRef = image1.CGImage;
    //
    //    CGFloat widthScale = image1.size.width / ScreenWidth;
    //    CGFloat heightScale = image1.size.height / ScreenHeight;
    //
    //    //其实是横屏的
    //    //多减掉50是因为最后的效果图片的高度有偏差，不知道原因
    //    CGFloat orignWidth = 226-50;//226
    //    CGFloat orginHeight = 360;//360
    //
    //    //我们要裁剪出实际边框内的图片，但是实际的图片和我们看见的屏幕上的img，size是不一样，可以打印一下image的size看看起码好几千的像素，要不然手机拍的照片怎么都是好几兆的呢？
    //    CGFloat x = (ScreenHeight - orginHeight) * 0.5 * heightScale;
    //    CGFloat y = (ScreenWidth - orignWidth) * 0.5 * widthScale;
    //    CGFloat width = orginHeight * heightScale;
    //    CGFloat height = orignWidth * widthScale;
    //
    //    CGRect r = CGRectMake(x, y, width, height);
    //
    //    CGImageRef imageRef = CGImageCreateWithImageInRect(cgRef, r);
    //
    //    UIImage *thumbScale = [UIImage imageWithCGImage:imageRef];
    //    //
    //    image1 = thumbScale;
    //
    //    self.image = image1;
    
    //返回的时候把图片传回去
    self.imageblock(self.image);
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


- (void)focusDidFinsh{
    self.focusView.hidden = YES;
    self.focusView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
}

- (void)startFocusAnimation{
    self.focusView.hidden = NO;
    self.focusView.transform = CGAffineTransformMakeScale(1.25f, 1.25f);//将要显示的view按照正常比例显示出来
    [UIView beginAnimations:nil context:UIGraphicsGetCurrentContext()];
    
    [UIView setAnimationDidStopSelector:@selector(hiddenFocusAnimation)];
    [UIView setAnimationDuration:0.5f];//动画时间
    self.focusView.transform = CGAffineTransformIdentity;//先让要显示的view最小直至消失
    [UIView commitAnimations]; //启动动画
    //相反如果想要从小到大的显示效果，则将比例调换
    
}
- (void)hiddenFocusAnimation{
    [UIView beginAnimations:nil context:UIGraphicsGetCurrentContext()];
    
    [UIView setAnimationDelay:3];
    self.focusView.alpha = 0;
    [UIView setAnimationDuration:0.5f];//动画时间
    [UIView commitAnimations];
    
}
- (void)hiddenFoucsView{
    self.focusView.alpha = !self.focusView.alpha;
}




@end

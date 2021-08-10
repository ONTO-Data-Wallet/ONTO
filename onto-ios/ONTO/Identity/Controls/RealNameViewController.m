//
//  RealNameViewController.m
//  ONTO
//
//  Created by 张超 on 2018/4/11.
/*
 * **************************************************************************************
 *  Copyright © 2014-2018 Ontology Foundation Ltd.
 *  All rights reserved.
 *
 *  This software is supplied only under the terms of a license agreement,
 *  nondisclosure agreement or other written agreement with Ontology Foundation Ltd.
 *  Use, redistribution or other disclosure of any parts of this
 *  software is prohibited except in accordance with the terms of such written
 *  agreement with Ontology Foundation Ltd. This software is confidential
 *  and proprietary information of Ontology Foundation Ltd.
 *
 * **************************************************************************************
 *///

#import "RealNameViewController.h"
#import "SLControlModel.h"
#import "Common.h"
#import "WaitingViewController.h"
#import "ToastUtil.h"
#import "AppHelper.h"
#import "STLivenessController.h"
#import "STLivenessDetector.h"
#import "STLivenessCommon.h"
#import "LivingSettingGLobalData.h"
#import "IdentityModel.h"
#import "ChargeModel.h"
#import "ONTO-Swift.h"
typedef NS_ENUM(NSUInteger, liveStatus) {
    liveStatusIdle = 0,
    liveStatusSucceed,
    liveStatusFaild,
};
@interface RealNameViewController () <SLDelegate,UITextFieldDelegate,STLivenessDetectorDelegate, STLivenessControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *idcardTF;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (nonatomic, strong) SLControlModel *slModel;
@property (nonatomic,copy) NSDictionary *signatureDic;
@property (weak, nonatomic) IBOutlet UIImageView *shieldImage;
@property (weak, nonatomic) IBOutlet UILabel *authInfo;
@property (weak, nonatomic) IBOutlet UILabel *nameLB;
@property (weak, nonatomic) IBOutlet UILabel *IdLB;
@property (weak, nonatomic) STLivenessController *livenessVC;
@property (nonatomic, strong)NSMutableArray *walletArray;
@end

@implementation RealNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.slModel = [[SLControlModel alloc] init];
    [self.slModel setTypeWithDifficulty:1];
    self.slModel.delegate = self;
    [self configUI];
    
    // 显示SDK版本
    NSString *sdkVersionStr = [STLivenessDetector getVersion];
    
    // 设置默认的动作序列为 眨眼 张嘴 点头 摇头
    if (!([LivingSettingGLobalData sharedInstanceData].strSequence.length > 0)) {
        [LivingSettingGLobalData sharedInstanceData].strSequence = @"BLINK MOUTH NOD YAW";
        [LivingSettingGLobalData sharedInstanceData].liveComplexity = STIDLiveness_COMPLEXITY_NORMAL;
        [LivingSettingGLobalData sharedInstanceData].bVoicePrompt = YES;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(arrayActions:)
                                                 name:@"arrActions"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(liveComplexity:)
                                                 name:@"liveComplexity"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(voicePrompt:)
                                                 name:@"voicePrompt"
                                               object:nil];
    
}


#pragma mark === NSNotification Action
- (void)arrayActions:(NSNotification *)notification {
    NSDictionary *arryDictionary = [notification userInfo];
    [LivingSettingGLobalData sharedInstanceData].strSequence = [arryDictionary[@"array"] componentsJoinedByString:@" "];
}

- (void)liveComplexity:(NSNotification *)notification {
    NSDictionary *arryDictionary = [notification userInfo];
    if ([arryDictionary[@"liveComplexity"] isEqual:@0]) {
        [LivingSettingGLobalData sharedInstanceData].liveComplexity = STIDLiveness_COMPLEXITY_EASY;
    } else if ([arryDictionary[@"liveComplexity"] isEqual:@1]) {
        [LivingSettingGLobalData sharedInstanceData].liveComplexity = STIDLiveness_COMPLEXITY_NORMAL;
    } else if ([arryDictionary[@"liveComplexity"] isEqual:@2]) {
        [LivingSettingGLobalData sharedInstanceData].liveComplexity = STIDLiveness_COMPLEXITY_HARD;
    } else if ([arryDictionary[@"liveComplexity"] isEqual:@3]) {
        [LivingSettingGLobalData sharedInstanceData].liveComplexity = STIDLiveness_COMPLEXITY_HELL;
    }
}

- (void)voicePrompt:(NSNotification *)notification {
    NSDictionary *arryDictionary = [notification userInfo];
    
    [LivingSettingGLobalData sharedInstanceData].bVoicePrompt = [arryDictionary[@"voicePrompt"] boolValue];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //    if (self.navigationController.topViewController != self) {
    //        [self.navigationController setNavigationBarHidden:NO animated:animated];
    //    }
}


#pragma - mark -
#pragma - mark STLivenessDetectorDelegate

- (void)livenessDidSuccessfulGetProtobufId:(NSString *)protobufId //! OCLINT
                              protobufData:(NSData *)protobufData
                                 requestId:(NSString *)requestId //! OCLINT
                                    images:(NSArray *)imageArr {
    
        [self dismissViewControllerAnimated:YES completion:nil];
    NSString *base64String = [protobufData base64EncodedString]; //[protobufData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        
        
        NSDictionary *dic =@{@"ontId":[[NSUserDefaults standardUserDefaults]valueForKey:ONT_ID],@"id":self.idcardTF.text,@"name":self.nameTF.text,@"livePhoto":base64String,@"deviceCode":[[NSUserDefaults standardUserDefaults]valueForKey:DEVICE_CODE]};
    
    NSString * isNeedPay = self.chargeModel.ChargeInfo.Charge;
    if ([isNeedPay isEqualToString:@"1"]) {
        [self checkWallet:dic];
    }else{
        WaitingViewController *vc = [[WaitingViewController alloc]init];
        vc.dic = dic;
        vc.claimImage =self.claimImage;
        vc.isCFCA = NO;
        [self.navigationController pushViewController:vc animated:YES];
    }

}

- (void)livenessDidFailWithLivenessResult:(STIDLivenessResult)livenessResult
                                faceError:(STIDLivenessFaceError)faceError
                             protobufData:(NSData *)protobufData
                                requestId:(NSString *)requestId
                                   images:(NSArray *)imageArr {
    
    MGPopController *pop = [[MGPopController alloc] initWithTitle:Localized(@"CFCAVerFai") message:nil image:nil];
    MGPopAction *action =   [MGPopAction actionWithTitle:Localized(@"OK") action:^{
        
    }];
    action.titleColor =MainColor;
    [pop addAction:action];
    [pop show];
    pop.showCloseButton = NO;
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)livenessDidCancel {
    //    [self resetImageView];
    //    [self showViewsWithliveStatus:liveStatusFaild];
    //    self.messageLabel.text = @"活体检测已取消";
    
    MGPopController *pop = [[MGPopController alloc] initWithTitle:Localized(@"CFCAVerFai") message:nil image:nil];
    MGPopAction *action =   [MGPopAction actionWithTitle:Localized(@"OK") action:^{
        
    }];
    action.titleColor =MainColor;
    [pop addAction:action];
    [pop show];
    pop.showCloseButton = NO;
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)videoFrameRate:(NSInteger)rate {
    //    printf("%lu FPS\n", rate);
}
- (void)livenessControllerDeveiceError:(STIDLivenessDeveiceError)deveiceError {

    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)saveProtobufData:(NSData *)protobufData images:(NSArray *)imageArr {
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)configUI {
    
    
    if (_isCFCA) {
        [self setNavTitle:Localized(@"Authorization")];
        self.authInfo.text = Localized(@"authInfo");
    }else{
        [self setNavTitle:Localized(@"sensetime")];
        self.authInfo.text = Localized(@"sensetimeInfo");
    }
    [self setNavLeftImageIcon:[UIImage imageNamed:@"nav_back"] Title:Localized(@"Back")];
    
    
    self.nameLB.text =Localized(@"CFCArealName");
    self.IdLB.text = Localized(@"CFCAId");
    self.nameTF.placeholder = Localized(@"CFCAName");
    self.idcardTF.delegate =self;
    self.idcardTF.placeholder = Localized(@"CFCAIdAlert");
    [self.nextBtn setTitle:Localized(@"Next") forState:UIControlStateNormal];
    self.nextBtn.layer.cornerRadius = 1;
    self.nextBtn.layer.masksToBounds = YES;
    
}

//CorrectName

- (void)navLeftAction {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark SLDelegate
- (void)SLOnOK:(id)SLVC result:(BOOL)Result {
    
    if (Result==NO) {
        
        MGPopController *pop = [[MGPopController alloc] initWithTitle:Localized(@"CFCAVerFai") message:nil image:nil];
        MGPopAction *action =   [MGPopAction actionWithTitle:Localized(@"OK") action:^{
            
        }];
        action.titleColor =MainColor;
        [pop addAction:action];
        [pop show];
        pop.showCloseButton = NO;
        return;
    }
    
    
    NSData *data = [self.slModel getPackagedDat];
    NSString *base64String = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    [self.slModel destroy];
    
    
    
    
    NSDictionary *dic =@{@"OwnerOntId":[[NSUserDefaults standardUserDefaults]valueForKey:ONT_ID],@"Id":self.idcardTF.text,@"Name":self.nameTF.text,@"PicData":base64String,@"DeviceCode":[[NSUserDefaults standardUserDefaults]valueForKey:DEVICE_CODE]};
    
    NSString * isNeedPay = self.chargeModel.ChargeInfo.Charge;
    if ([isNeedPay isEqualToString:@"1"]) {
        [self checkWallet:dic];
    }else{
        WaitingViewController *vc = [[WaitingViewController alloc]init];
        vc.dic = dic;
        vc.claimImage =self.claimImage;
        vc.isCFCA = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}
-(void)checkWallet:(NSDictionary*)payDic{
//    walletArray?.removeAllObjects()
    
    [self.walletArray removeAllObjects];
    self.walletArray = [NSMutableArray array];
    NSArray * arr = [[NSUserDefaults standardUserDefaults] valueForKey:ALLASSET_ACCOUNT];
    if (arr.count == 0 || arr == nil) {
        [Common showToast:Localized(@"NOWALLET")];
        return;
    }else{
        for (NSDictionary *  subDic in arr) {
            if (subDic[@"label"] != nil) {
                [self.walletArray addObject:subDic];
            }
        }
        if (self.walletArray.count == 0) {
            [Common showToast:Localized(@"NOWALLET")];
        }else{
            IDMPaymentViewController * vc = [[IDMPaymentViewController alloc]init];
            vc.shuftiModel = self.chargeModel;
            vc.dataArray = self.walletArray;
            
            NSMutableDictionary * ceshiDic = [NSMutableDictionary dictionary];
            [ceshiDic addEntriesFromDictionary:payDic];
            if (self.isCFCA) {
                vc.comFrom = @"CFCA";
            }else{
                vc.comFrom = @"sensetime";
            }
            
            vc.payPreDic = ceshiDic;
            [self.navigationController pushViewController:vc animated:YES];
            
        }
    }
}
- (void)SLOnBack:(id)SLVC {
    [self.slModel destroy];
    [Common showToast:Localized(@"RealNameAuthError")];
//    [self showHint:Localized(@"RealNameAuthError") yOffset:200];
}


- (IBAction)nextAction:(id)sender {
    if (self.nameTF.text.length ==0) {
        [Common showToast:Localized(@"emptyName")];
//        [ToastUtil shortToast:self.view value:Localized(@"emptyName")];
        return;
    }
    if (self.idcardTF.text.length == 0) {
        [Common showToast:Localized(@"emptyID")];
//        [ToastUtil shortToast:self.view value:Localized(@"emptyID")];
    }else if (self.idcardTF.text.length>0 &&self.idcardTF.text.length<18){
        [Common showToast:Localized(@"IDNumber")];
//        [ToastUtil shortToast:self.view value:Localized(@"IDNumber")];
    }else{
        if ([AppHelper checkIDcardNum:self.idcardTF.text]) {
            
            if (self.isCFCA == YES){
                
                [self.slModel show:self];
                
            }else{
                
                [self showShangtang];
                
            }
            
        }else{
            [Common showToast:Localized(@"CorrectIDNumber")];
//            [ToastUtil shortToast:self.view value:Localized(@"CorrectIDNumber")];
        }
    }
    
    
    
}

- (void)showShangtang{
    if (![LivingSettingGLobalData sharedInstanceData].strSequence.length) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:@"动作序列未设置"
                                                       delegate:nil
                                              cancelButtonTitle:@"好的"
                                              otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    
    NSArray *arrStrSequence =
    [[LivingSettingGLobalData sharedInstanceData].strSequence componentsSeparatedByString:@" "];
    NSMutableArray *arrLivenessSequence = [NSMutableArray array];
    
    for (NSString *strAction in arrStrSequence) {
        if ([strAction isEqualToString:@"BLINK"]) {
            [arrLivenessSequence addObject:@(STIDLiveness_BLINK)];
        } else if ([strAction isEqualToString:@"MOUTH"]) {
            [arrLivenessSequence addObject:@(STIDLiveness_MOUTH)];
        } else if ([strAction isEqualToString:@"NOD"]) {
            [arrLivenessSequence addObject:@(STIDLiveness_NOD)];
        } else if ([strAction isEqualToString:@"YAW"]) {
            [arrLivenessSequence addObject:@(STIDLiveness_YAW)];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                            message:@"动作序列设置有误"
                                                           delegate:nil
                                                  cancelButtonTitle:@"ok"
                                                  otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
    }
    
    
    NSString *strApiKey = ACCOUNT_API_KEY;
    
    NSString *strApiSecret = ACCOUNT_API_SECRET;
    
    STLivenessController *livenessVC = [[STLivenessController alloc] initWithApiKey:strApiKey
                                                                          apiSecret:strApiSecret
                                                                        setDelegate:self
                                                                  detectionSequence:arrLivenessSequence];
    
    
    //设置每个模块的超时时间
    [livenessVC.detector setTimeOutDuration:kSenseIdLivenessDefaultTimeOutDuration];
    // 设置活体检测复杂度
    [livenessVC.detector setComplexity:[LivingSettingGLobalData sharedInstanceData].liveComplexity];
    // 设置活体检测的阈值
    [livenessVC.detector setHacknessThresholdScore:kSenseIdLivenessDefaultHacknessThresholdScore];
    
    // 设置是否进行眉毛遮挡的检测，如不设置默认为不检测
    livenessVC.detector.isBrowOcclusion = NO;
    
    // 设置默认语音提示状态,如不设置默认为开启
    livenessVC.isVoicePrompt = [LivingSettingGLobalData sharedInstanceData].bVoicePrompt;
    
    self.livenessVC = livenessVC;
    
    [self presentViewController:self.livenessVC animated:YES completion:nil];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([textField isEqual:self.idcardTF]) {
        if (range.location> 17){
            return NO;
        }
    }
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end

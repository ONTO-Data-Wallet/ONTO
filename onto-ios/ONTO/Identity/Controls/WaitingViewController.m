//
//  WaitingViewController.m
//  ONTO
//
//  Created by 赵伟 on 2018/4/27.
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

#import "WaitingViewController.h"
#import "ClaimViewController.h"
#import "RealNameViewController.h"
#import "ClaimModel.h"
#import "DataBase.h"
@interface WaitingViewController ()
@property (nonatomic, strong)NSTimer * timer;
@property (weak, nonatomic) IBOutlet UIImageView *waitImage;
@property (weak, nonatomic) IBOutlet UILabel *waitLabel;
@property (weak, nonatomic) IBOutlet UIImageView *failImage;
@property (weak, nonatomic) IBOutlet UILabel *failLabel;
@property (weak, nonatomic) IBOutlet UIButton *failBtn;

@property (nonatomic,assign)BOOL isSuccess;

@end

@implementation WaitingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
   // Do any additional setup after loading the view from its nib.
    
    [self configUI];

    if (_promtDic) {
        [self RequstpromtRequst];
    }else{
         [self RequstCFCRequst];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.isSuccess =NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //销毁定时器
    [_timer invalidate];
    _timer = nil;
}


- (void)configUI{
    
    [self setNavTitle:Localized(@"VerAuth")];
  
    
    [self setNavLeftImageIcon:[UIImage imageNamed:@"nav_back"] Title:Localized(@"Back")];
    if (_promtDic) {
        [self setNavTitle:Localized(@"Verifiedclaims")];
    }
    
    self.failBtn.layer.cornerRadius = 1;
    self.failBtn.layer.masksToBounds = YES;

    _failLabel.text = Localized(@"CreateFailed");
    _waitLabel.text = Localized(@"VerAuth");
    [self.failBtn setTitle:Localized(@"CFCATryAgain") forState:UIControlStateNormal];
    
}
- (IBAction)tryAgainAtion:(id)sender {

    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

- (void)RequstpromtRequst{
    
    
    [[CCRequest shareInstance] requestWithURLStringNoLoading:Claimissue MethodType:MethodTypePOST Params:_promtDic Success:^(id responseObject, id responseOriginal) {
        DebugLog(@"success:%@",responseOriginal);
        [self getDataisPromt:YES];
        _timer =  [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(function:) userInfo:nil repeats:YES];
        
    } Failure:^(NSError *error, NSString *errorDesc, id responseOriginal) {
        DebugLog(@"error:%@",responseOriginal);
        if (![responseOriginal isKindOfClass:[NSNull class]]) {
            _failLabel.hidden = NO;
            if ([responseOriginal isKindOfClass:[NSDictionary class]] && responseOriginal[@"Result"]) {
                _failLabel.text =[NSString stringWithFormat:@"%@",responseOriginal[@"Result"]];
            }else{
                _failLabel.text =Localized(@"CFCAVerFai");
            }
            
        }
        [self setFailUI];
    }];
}

- (void)RequstCFCRequst{
    NSString * urlString ;
    if (_isCFCA) {
        urlString = FaceAuth;
    }else{
        urlString = ShangTangAuth;
    }
    
    [[CCRequest shareInstance] requestWithURLStringNoLoading:urlString MethodType:MethodTypePOST Params:_dic Success:^(id responseObject, id responseOriginal) {
        DebugLog(@"success:%@",responseOriginal);
        [self getDataisPromt:NO];
        _timer =  [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(function:) userInfo:nil repeats:YES];
        
    } Failure:^(NSError *error, NSString *errorDesc, id responseOriginal) {
        DebugLog(@"error:%@",responseOriginal);
        if (![responseOriginal isKindOfClass:[NSNull class]]) {
            _failLabel.hidden = NO;
            if ([responseOriginal isKindOfClass:[NSDictionary class]] && responseOriginal[@"Result"]) {
                _failLabel.text =[NSString stringWithFormat:@"%@",responseOriginal[@"Result"]];
            }else{
                _failLabel.text =Localized(@"CreateFailed");
            }
        }
//
//        [self setFailUI];
        
    }];
}

- (void)setFailUI{
    _waitImage.hidden = YES;
    _waitLabel.hidden = YES;
    _failImage.hidden = NO;
    _failLabel.hidden = NO;
    _failBtn.hidden = NO;
    
}

- (void)navLeftAction {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    

        // 禁用返回手势
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.enabled = NO;
        }

    
}

-(void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    // 开启返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
    
}

- (void)function:(NSTimer*)timer{
    
    [self getDataisPromt:_promtDic?YES:NO];
    
    DebugLog(@"调用");
    
}

- (void)getDataisPromt:(BOOL)isPromt{

    
    
    NSString *claimContext;
    if (_isCFCA) {
        claimContext =  isPromt?[_promtDic valueForKey:@"ClaimContext"]:@"claim:cfca_authentication";
    }else{
       claimContext = isPromt?[_promtDic valueForKey:@"ClaimContext"]:@"claim:sensetime_authentication";
    }
    NSDictionary *params = @{@"OwnerOntId":[[NSUserDefaults standardUserDefaults]valueForKey:ONT_ID],
                             @"DeviceCode":[[NSUserDefaults standardUserDefaults]valueForKey:DEVICE_CODE],
                             @"ClaimId":@"",
                             @"ClaimContext":claimContext,
                             @"Status":@"9"
                             };
    DebugLog(@"!!!%@",params);
    [[CCRequest shareInstance] requestWithURLStringNoLoading:Claim_query MethodType:MethodTypePOST Params:params Success:^(id responseObject, id responseOriginal) {
        if (self.isSuccess == NO) {
            self.isSuccess =YES;
            [_timer invalidate];
            _timer = nil;
            
            ClaimViewController *vc = [[ClaimViewController alloc]init];
            vc.isPending = YES;
            vc.claimContext = claimContext;
            vc.stauts = 4;
            vc.claimImage =self.claimImage;
            vc.isFace = YES;
            
            [self.navigationController pushViewController:vc animated:YES];
        }
        
        
       
    } Failure:^(NSError *error, NSString *errorDesc, id responseOriginal) {

    }];
    
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

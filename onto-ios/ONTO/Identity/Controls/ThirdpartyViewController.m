//
//  ThirdpartyViewController.m
//  ONTO
//
//  Created by 赵伟 on 30/05/2018.
//  Copyright © 2018 Zeus. All rights reserved.
//

#import "ThirdpartyViewController.h"
#import "zySheetPickerView.h"
#import "DataBase.h"
#import "ClaimModel.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "LPActionSheet.h"
#import "IdentityModel.h"
#import <MJExtension/MJExtension.h>
#import "Config.h"
#import "WebIdentityViewController.h"
#import "ClaimViewController.h"
@interface ThirdpartyViewController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *confirmViewHeight;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (weak, nonatomic) IBOutlet UILabel *willProvide;
@property (weak, nonatomic) IBOutlet UILabel *Detai;
@property (nonatomic, copy) NSArray *modelArr;
@property (nonatomic, assign) NSInteger detailIndex;
@property (nonatomic, copy) NSString *detailContext;


@end

@implementation ThirdpartyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNavTitle:Localized(@"Authorization")];
    [self setNavLeftImageIcon:[UIImage imageNamed:@"nav_back"] Title:Localized(@"Back")];
    [_iconImage sd_setImageWithURL:[NSURL URLWithString:[_dic valueForKey:@"Logo"]]];
    _myTitleL.text = _dic[@"Name"];
    _subTitleL.text = _dic[@"Description"];
    [_confirmViewHeight setConstant:kScreenHeight];
    _modelArr = [IdentityModel mj_objectArrayWithKeyValuesArray:(NSArray*)[[NSUserDefaults standardUserDefaults]valueForKey:IDAUTHARR]];
    
}

- (void)navLeftAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)selectClick:(id)sender {
    
    [self sheetShow];
}

- (void)sheetShow{
    
    NSArray *claimedArr = [[DataBase sharedDataBase] getAllClaim];
    NSMutableArray *titleArr = [NSMutableArray array];
    NSMutableArray *heightLightTitleArr = [NSMutableArray array];

    for (IdentityModel *model in _modelArr) {
        [titleArr addObject:model.Name];
        
    ClaimModel*model1 = [[DataBase sharedDataBase]getCalimWithClaimContext:model.ClaimContext andOwnerOntId:[[NSUserDefaults standardUserDefaults]valueForKey:ONT_ID]];
        if ([model1.status isEqualToString:@"1"]) {
            [heightLightTitleArr addObject:model.Name];
        }
    }
    
    LPActionSheet *sheet =  [[LPActionSheet alloc]initWithTitle:@"" cancelButtonTitle:@"取消" destructiveButtonTitle:@"" otherButtonTitles:titleArr withHighlight:heightLightTitleArr handler:^(LPActionSheet *actionSheet, NSInteger index) {
        
        if (index==0) {
            return ;
        }
        
        NSInteger claimType=0;
        NSString *context = [(IdentityModel*)_modelArr[index-1] ClaimContext];
        
        
        for (ClaimModel *model in claimedArr) {
            if ([model.status isEqualToString:@"1"]) {
                
                if ([context isEqualToString:model.ClaimContext]) {
                    _detailIndex = index-1;
                    _detailContext = model.ClaimContext;
                    
                    [_selectBtn setTitle:[(IdentityModel*)_modelArr[index-1] Name] forState:UIControlStateNormal];
                    
                    [UIView animateWithDuration:0.5 animations:^{
                        
                        [_confirmViewHeight setConstant:30];
                        
                    } completion:^(BOOL finished) {
                        
                    }];
                    
                    return;
                }
                
            }
        }
        
        
        if ([context isEqualToString:@"claim:linkedin_authentication"]) {
            claimType = 1;
        }
        else  if ([context isEqualToString:@"claim:github_authentication"]) {
            claimType = 2;
        }
        else  if ([context isEqualToString:@"claim:facebook_authentication"]) {
            claimType = 3;
        }
        else   if ([context isEqualToString:@"claim:twitter_authentication"]) {
            claimType = 0;
        }
        
        WebIdentityViewController *webVC = [[WebIdentityViewController alloc]init];
        webVC.identityType = (IdentityType)claimType;
        webVC.claimurl = [(IdentityModel*)_modelArr[index] H5ReqParam];
        [self.navigationController pushViewController:webVC animated:YES];
        
        
    }];
    
    [sheet show];
    
}



- (IBAction)selectClick1:(id)sender {
    [UIView animateWithDuration:0.5 animations:^{
        
        [_confirmViewHeight setConstant:kScreenHeight];
        
    } completion:^(BOOL finished) {
        
    }];
    
    [self sheetShow];
    
}

- (IBAction)seeDetailClick:(id)sender {
    
    [self seeDetailAction];
    
}

- (void)seeDetailAction{
    
            ClaimViewController *claimVC = [[ClaimViewController alloc]init];
            claimVC.claimContext =  [(IdentityModel*)_modelArr[_detailIndex] ClaimContext];
            claimVC.stauts = 1;
            claimVC.isPending = NO;
            [self.navigationController pushViewController:claimVC animated:YES];
}

- (IBAction)noClick:(id)sender {
    
    [UIView animateWithDuration:0.5 animations:^{
        
        [_confirmViewHeight setConstant:kScreenHeight];
        
    } completion:^(BOOL finished) {
        
    }];
}

- (IBAction)allowAccess:(id)sender {
    
    [self allowAccessReq];
}

- (void)allowAccessReq{
    
    ClaimModel *claimmodel = [[DataBase sharedDataBase]getCalimWithClaimContext:_detailContext andOwnerOntId:[[NSUserDefaults standardUserDefaults]valueForKey:ONT_ID]];
    NSDictionary *claimDic = [[Common claimdencode:[[Common dictionaryWithJsonString:claimmodel.Content] valueForKey:@"EncryptedOrigData"]] valueForKey:@"claim"];
    
    
    NSDictionary *claimdic = @{@"Id":[claimDic valueForKey:@"jti"],@"Context":_detailContext,@"OrigData":[[Common dictionaryWithJsonString:claimmodel.Content] valueForKey:@"EncryptedOrigData"]};
    
    [[Common dictionaryWithJsonString:claimmodel.Content] valueForKey:@"EncryptedOrigData"];
    NSDictionary *params = @{@"OwnerOntId":[[NSUserDefaults standardUserDefaults]valueForKey:ONT_ID],@"DeviceCode":[[NSUserDefaults standardUserDefaults] valueForKey:DEVICE_CODE],@"ThirdpartyOntId":_thirdOntId,@"RequestId":_seesion,@"ClaimList":@[claimdic]};
    DebugLog(@"!!!%@",params);
    
    [[CCRequest shareInstance] requestWithURLStringNoLoading:ThirdpartyVerification MethodType:MethodTypePOST Params:params Success:^(id responseObject, id responseOriginal) {
        
        if ([[responseOriginal valueForKey:@"error"] integerValue] > 0) {
            [Common showToast:[NSString stringWithFormat:@"%@:%@",Localized(@"Systemerror"),[responseOriginal valueForKey:@"error"]]];
//            [ToastUtil shortToast:self.view value:[NSString stringWithFormat:@"%@:%@",Localized(@"Systemerror"),[responseOriginal valueForKey:@"error"]]];
            return;
        }
        [UIView animateWithDuration:0.5 animations:^{
            
            [_confirmViewHeight setConstant:kScreenHeight];
            
        } completion:^(BOOL finished) {
            
        }];
        [self.navigationController popToRootViewControllerAnimated:YES];

    } Failure:^(NSError *error, NSString *errorDesc, id responseOriginal) {
        
    }];
    
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

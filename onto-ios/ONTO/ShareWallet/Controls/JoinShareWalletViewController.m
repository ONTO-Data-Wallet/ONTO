//
//  JoinShareWalletViewController.m
//  ONTO
//
//  Created by Apple on 2018/7/11.
//  Copyright © 2018年 Zeus. All rights reserved.
//

#import "JoinShareWalletViewController.h"
#import "JoinShareWalletDetailViewController.h"
#import "ImportViewController.h"
@interface JoinShareWalletViewController ()
@property(nonatomic,strong)UITextField      *addressField;
@property(nonatomic,strong)UIButton         *createBtn;
@end

@implementation JoinShareWalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self createNav];
}
-(void)createUI{
    self.view.backgroundColor =[UIColor whiteColor];
    UILabel * addressLB =[[UILabel alloc]initWithFrame:CGRectMake(24*SCALE_W, 35*SCALE_W, SYSWidth-48*SCALE_W, 18*SCALE_W)];
    addressLB.text =Localized(@"shareWalletAddressShort");
    addressLB.font =[UIFont systemFontOfSize:14 weight:UIFontWeightSemibold];
    addressLB.textColor =BLACKLB;
    addressLB.textAlignment =NSTextAlignmentLeft;
    [self.view addSubview:addressLB];
    
    _addressField =[[UITextField alloc]initWithFrame:CGRectMake(24*SCALE_W, 59*SCALE_W, SYSWidth-68*SCALE_W, 18*SCALE_W)];
    _addressField.placeholder    =Localized(@"shareWalletAddressNew");
    _addressField.font =[UIFont systemFontOfSize:14];
    _addressField.textColor =BLACKLB;
    [self.view addSubview:_addressField];
    
    UIView * line =[[UIView alloc]initWithFrame:CGRectMake(24*SCALE_W, 83*SCALE_W, SYSWidth-48*SCALE_W, 1)];
    line.backgroundColor =LINEBG;
    [self.view addSubview:line];
    
    UIButton * scanBtn =[[UIButton alloc]initWithFrame:CGRectMake(SYSWidth -44*SCALE_W, 48*SCALE_W, 20*SCALE_W, 20*SCALE_W)];
    [scanBtn setEnlargeEdge:20];
    [scanBtn setImage:[UIImage imageNamed:@"newScan"] forState:UIControlStateNormal];
    [self.view addSubview:scanBtn];
    
    [scanBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        ImportViewController *vc =[[ImportViewController alloc]init];
        [vc setCallback:^(NSString *stringValue) {
            _addressField.text = stringValue;
        }];
        vc.isShareWalletAddress =YES;
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    [self.view addSubview:self.createBtn];
    
}
-(void)createNav{
    [self setNavTitle:Localized(@"leadShareWallet")];
    [self setNavLeftImageIcon:[UIImage imageNamed:@"nav_back"] Title:Localized(@"Back")];
    
}
- (void)navLeftAction {
    [self.navigationController popViewControllerAnimated:YES];
}
-(UIButton*)createBtn{
    if (!_createBtn) {
        _createBtn =[[UIButton alloc]initWithFrame:CGRectMake(0, SYSHeight-64-49, SYSWidth, 49)];
        if (KIsiPhoneX) {
            _createBtn.frame =CGRectMake(0, SYSHeight-64-49-34-24, SYSWidth, 49);
        }
        [_createBtn setTitle:Localized(@"Next") forState:UIControlStateNormal];
        [_createBtn setTitleColor:BLUELB forState:UIControlStateNormal];
        _createBtn.titleLabel.font =[UIFont systemFontOfSize:18 weight:UIFontWeightSemibold];
        [_createBtn setBackgroundColor:[UIColor colorWithHexString:@"#EDF2F5"]];
        [_createBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^{
            if (_addressField.text.length==0) {
                return ;
            }
            NSArray *array = [[NSUserDefaults standardUserDefaults] valueForKey:ALLASSET_ACCOUNT];
            if (array.count>0)
            {
                for (NSDictionary *dic in array)
                {
                    if ([dic isKindOfClass:[NSDictionary class]] && dic[@"sharedWalletAddress"])
                    {
                        if ([_addressField.text isEqualToString:dic[@"sharedWalletAddress"]])
                        {
                            [Common showToast:Localized(@"ExistShareWallet")];
//                            [ToastUtil shortToast:self.view value:Localized(@"ExistShareWallet")];
                            return;
                        }
                    }
                }
            }
            
            
            JoinShareWalletDetailViewController *vc =[[JoinShareWalletDetailViewController alloc]init];
            vc.shareWalletAddress =_addressField.text;
            [self.navigationController pushViewController:vc animated:YES];
        }];
        
    }
    return _createBtn;
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

//
//  ONTOWakePaySureViewController.m
//  ONTO
//
//  Created by Apple on 2019/5/16.
//  Copyright © 2019 Zeus. All rights reserved.
//

#import "ONTOWakePaySureViewController.h"

@interface ONTOWakePaySureViewController ()
@property(nonatomic, strong)UIView* bottomView;
@end

@implementation ONTOWakePaySureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

-(void)createUI {
    NSDictionary * result = _infoDic[@"result"];
    NSDictionary * Result = result[@"Result"];
    NSArray * Notify = Result[@"Notify"];
    NSDictionary * payInfo = Notify[0];
    NSArray * States = payInfo[@"States"];
    _bottomView = [[UIView alloc]init];
    _bottomView.layer.cornerRadius = 5;
    _bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_bottomView];
    
    UIButton* closeBtn = [[UIButton alloc]init];
    [closeBtn setEnlargeEdge:25];
    [closeBtn setImage:[UIImage imageNamed:@"Dapp_Close_gray"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:closeBtn];
    
    UILabel* typeLB = [[UILabel alloc]init];
    typeLB.text = Localized(@"paySure");
    typeLB.font = [UIFont systemFontOfSize:21 weight:UIFontWeightSemibold];
    [_bottomView addSubview:typeLB];
    
    UIImageView *payerImage = [[UIImageView alloc]init];
    payerImage.image = [UIImage imageNamed:@"Dapp_Payer"];
    [_bottomView addSubview:payerImage];
    
    UILabel * payerAddress = [[UILabel alloc]init];
    payerAddress.font = [UIFont systemFontOfSize:14];
    payerAddress.text = States[1];
    [_bottomView addSubview:payerAddress];
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor colorWithHexString:@"#F2F2F2"];
    [_bottomView addSubview:line];
    
    UILabel * payAmount = [[UILabel alloc] init];
    payAmount.font = [UIFont systemFontOfSize:14];
    payAmount.alpha = 0.6;
    payAmount.text = Localized(@"payAmount");
    [_bottomView addSubview:payAmount];
    
    UILabel * payFee = [[UILabel alloc] init];
    payFee.font = [UIFont systemFontOfSize:14];
    payFee.alpha = 0.6;
    payFee.text = Localized(@"payFee");
    [_bottomView addSubview:payFee];
    
    UILabel * toAddress = [[UILabel alloc] init];
    toAddress.font = [UIFont systemFontOfSize:14];
    toAddress.alpha = 0.6;
    toAddress.text = Localized(@"toAddress");
    [_bottomView addSubview:toAddress];
    
    UILabel * amount = [[UILabel alloc] init];
    amount.font = [UIFont systemFontOfSize:14];
    amount.alpha = 0.6;
    amount.text = Localized(@"AddressBalance");
    [_bottomView addSubview:amount];
    
    //
    
    UILabel * payAmountLB = [[UILabel alloc] init];
    payAmountLB.font = [UIFont systemFontOfSize:14];
    payAmountLB.text = @"100";
    [_bottomView addSubview:payAmountLB];
    BOOL isONT = NO;
    if ([payInfo[@"ContractAddress"] isEqualToString:@"0100000000000000000000000000000000000000"]) {
        isONT = YES;
        payAmountLB.text = [NSString stringWithFormat:@"%@ ONT",States[3]];
    }else if ([payInfo[@"ContractAddress"] isEqualToString:@"0200000000000000000000000000000000000000"]) {
        isONT = NO;
        NSString *payMoney = [Common getPayMoney:[NSString stringWithFormat:@"%@",States[3]]];
        payAmountLB.text = [NSString stringWithFormat:@"%@ ONG",payMoney];
    }
    
    UILabel * payFeeLB = [[UILabel alloc] init];
    payFeeLB.font = [UIFont systemFontOfSize:14];
    [_bottomView addSubview:payFeeLB];
    NSString *payFeeString = [Common getRealFee:@"500" GasLimit:[NSString stringWithFormat:@"%@",Result[@"Gas"]]];
    payFeeLB.text = [NSString stringWithFormat:@"%@ ONG",payFeeString];
    
    UILabel * toAddressLB = [[UILabel alloc] init];
    toAddressLB.font = [UIFont systemFontOfSize:14];
    toAddressLB.numberOfLines = 0;
    toAddressLB.text = States[2];
    [_bottomView addSubview:toAddressLB];
    
    UILabel * amountLB = [[UILabel alloc] init];
    amountLB.font = [UIFont systemFontOfSize:14];
    [_bottomView addSubview:amountLB];
    if (_responseOriginal[@"Result"]) {
        for (NSDictionary * dic in _responseOriginal[@"Result"]) {
            if ([dic[@"AssetName"] isEqualToString:@"ont"]) {
                if (isONT) {
                    amountLB.text = [NSString stringWithFormat:@"%@ ONT",dic[@"Balance"]];
                }
            }
            if ([dic[@"AssetName"] isEqualToString:@"ong"]) {
                if (!isONT) {
                    amountLB.text = [NSString stringWithFormat:@"%@ ONG",dic[@"Balance"]];
                }
            }
        }
    }
    
    UIButton * sureBtn = [[UIButton alloc]init];
    [sureBtn setTitle:Localized(@"surePay") forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sureBtn.backgroundColor = [UIColor blackColor];
    sureBtn.layer.cornerRadius = 5;
    [_bottomView addSubview:sureBtn];
    
    
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.bottom.equalTo(self.view).offset(-30 - LL_TabbarSafeBottomMargin);
    }];
    
    [typeLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bottomView).offset(20);
        make.top.equalTo(self.bottomView).offset(29);
    }];
    
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bottomView).offset(-20);
        make.top.equalTo(self.bottomView).offset(38);
        make.width.height.mas_offset(16);
    }];
    
    [payerImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bottomView).offset(20);
        make.top.equalTo(typeLB.mas_bottom).offset(25);
        make.width.height.mas_offset(12);
    }];
    
    [payerAddress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(payerImage.mas_right).offset(14);
        make.centerY.equalTo(payerImage);
    }];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bottomView).offset(20);
        make.right.equalTo(self.bottomView).offset(-20);
        make.height.mas_offset(1);
        make.top.equalTo(payerAddress.mas_bottom).offset(15);
    }];
    
    [payAmount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bottomView).offset(20);
        make.top.equalTo(line.mas_bottom).offset(20);
    }];
    
    [payFee mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bottomView).offset(20);
        make.top.equalTo(payAmount.mas_bottom).offset(15);
    }];
    
    [toAddress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bottomView).offset(20);
        make.top.equalTo(payFee.mas_bottom).offset(15);
    }];
    
    [payAmountLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bottomView).offset(141);
        make.right.equalTo(self.bottomView).offset(-20);
        make.top.equalTo(line.mas_bottom).offset(20);
    }];
    
    [payFeeLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bottomView).offset(141);
        make.right.equalTo(self.bottomView).offset(-20);
        make.top.equalTo(payAmount.mas_bottom).offset(15);
    }];
    
    [toAddressLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bottomView).offset(141);
        make.right.equalTo(self.bottomView).offset(-20);
        make.top.equalTo(payFee.mas_bottom).offset(15);
    }];
    
    [amountLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bottomView).offset(141);
        make.right.equalTo(self.bottomView).offset(-20);
        make.top.equalTo(toAddressLB.mas_bottom).offset(15);
    }];
    
    [amount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bottomView).offset(20);
        make.top.equalTo(toAddressLB.mas_bottom).offset(15);
    }];
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(amount.mas_bottom).offset(25);
        make.left.equalTo(self.bottomView).offset(20);
        make.right.equalTo(self.bottomView).offset(-20);
        make.height.mas_offset(42);
        make.bottom.equalTo(self.bottomView.mas_bottom).offset(-20);
    }];
    
    [sureBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        if (_sureBlock) {
            _sureBlock();
        }
    }];
    
}
-(void)closeView {
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    [appdelegate.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
}

@end

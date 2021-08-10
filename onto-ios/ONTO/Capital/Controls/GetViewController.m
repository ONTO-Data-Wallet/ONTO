//
//  GetViewController.m
//  ONTO
//
//  Created by 赵伟 on 2018/3/24.
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

#import "GetViewController.h"
#import "UIView+Scale.h"
@interface GetViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *titleImage;
@property (weak, nonatomic) IBOutlet UILabel *ontAdrr;
@property (weak, nonatomic) IBOutlet UILabel *ontAdrrdatail;
@property (weak, nonatomic) IBOutlet UIImageView *qrImage;
@property (weak, nonatomic) IBOutlet UIImageView *lineImage;
@property (weak, nonatomic) IBOutlet UIButton *ontoBtn;
@property (weak, nonatomic) IBOutlet UIView *mybackView;
@property (weak, nonatomic) IBOutlet UILabel *walletName;
@property (nonatomic, strong) UIImageView *shadowImage;
@property (weak, nonatomic) IBOutlet UIView *subBackView;
@property (weak, nonatomic) IBOutlet UILabel *addressLB;
@property (weak, nonatomic) IBOutlet UILabel *keyLB;
@property (weak, nonatomic) IBOutlet UILabel *keyContentLB;
@property (weak, nonatomic) IBOutlet UIButton *keyBtn;

@end

@implementation GetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setUI];

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

- (void)setUI{

    [self setNavTitle:Localized(@"ReceivingCode")];
    [self setNavLeftImageIcon:[UIImage imageNamed:@"nav_back"] Title:Localized(@"Back")];
    _ontAdrr.text = Localized(@"OntAddress");
    _addressLB.text =Localized(@"shareAddress");
    _keyLB.text =Localized(@"normalPublicKey");
//    [_ontoBtn setTitle:Localized(@"copy") forState:UIControlStateNormal];
    
    
    NSString *jsonStr = [Common getEncryptedContent:ASSET_ACCOUNT];
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:[jsonStr dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
    DebugLog(@"jsonDict=%@",jsonDict);
    NSMutableDictionary *qrDict = [[NSMutableDictionary alloc] initWithDictionary:jsonDict];
    [qrDict setValue:@"A" forKey:@"type"];
    NSString *qrStr = [jsonDict valueForKey:@"address"];
    self.qrImage.image = [SGQRCodeGenerateManager generateWithLogoQRCodeData:qrStr logoImageName:@"" logoScaleToSuperView:0.25 withWallet:NO];
    self.ontAdrrdatail.text = [jsonDict valueForKey:@"address"];
    self.walletName.text = [jsonDict valueForKey:@"label"];
    [self.keyBtn setEnlargeEdge:20];
    [self.ontoBtn setEnlargeEdge:20];
    self.keyContentLB.text =jsonDict[@"publicKey"];
//    self.view.backgroundColor = [UIColor redColor];
        [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

- (void)navLeftAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)ontoAction:(id)sender {
//    [self showHint:Localized(@"WalletCopySuccess")];
    [Common showToast:Localized(@"WalletCopySuccess")];
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.ontAdrrdatail.text;
}
- (IBAction)keyAction:(id)sender {
//    [self showHint:Localized(@"WalletKeySuccess")];
    [Common showToast:Localized(@"WalletKeySuccess")];
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.keyContentLB.text;
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

//
//  ContactDetailVC.m
//  ONTO
//
//  Created by 赵伟 on 07/06/2018.
//  Copyright © 2018 Zeus. All rights reserved.
//

#import "ContactDetailVC.h"
#import "AddContactViewController.h"
@interface ContactDetailVC ()
@property (weak, nonatomic) IBOutlet UILabel *nickNameL;
@property (weak, nonatomic) IBOutlet UILabel *addressL;

@end

@implementation ContactDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self configNav];

}
- (void)configNav {
    [self setNavTitle:Localized(@"Contacts")];
    [self setNavLeftImageIcon:[UIImage imageNamed:@"nav_back"] Title:Localized(@"Back")];
    //    [self setNavRightImageIcon:[UIImage imageNamed:@"ONTSend-SAO"] Title:nil];
    [self setNavRightImageIcon:nil Title:Localized(@"Edit")];
    
    if (_name) {
        self.nickNameL.text = _name;
    }
    if (_address) {
        self.addressL.text = _address;
    }
}

-(void)navRightAction{
    
    AddContactViewController *vc = [[AddContactViewController alloc]init];
    vc.name = self.nickNameL.text;
    vc.address =  self.addressL.text;
    [vc setCallback:^(NSString *stringValue,NSString *stringValue2 ) {
        self.nickNameL.text = stringValue;
        self.addressL.text = stringValue2;

    }];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)copyBtnClick:(id)sender {
//    [self showHint:Localized(@"WalletCopySuccess")];
    [Common showToast:Localized(@"WalletCopySuccess")];
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.address;
}

- (void)navLeftAction {
    
    [self.navigationController popViewControllerAnimated:YES];
    
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

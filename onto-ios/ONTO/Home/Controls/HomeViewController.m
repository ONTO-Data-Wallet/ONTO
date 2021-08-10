//
//  HomeViewController.m
//  ONTO
//
//  Created by Zeus.Zhang on 2018/2/7.
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

#import "HomeViewController.h"
#import "CreateViewController.h"
#import "KeystoreImportVC.h"
#import "CCRequest.h"
#import "ONTO-Swift.h"
@interface HomeViewController ()

@property(weak, nonatomic) IBOutlet UIButton *createBtn;
@property(weak, nonatomic) IBOutlet UIButton *importBtn;
@property(weak, nonatomic) IBOutlet UILabel *whatIDL;
@property(weak, nonatomic) IBOutlet UILabel *detailL;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configUI];
}

- (void)configUI {

    _whatIDL.text = Localized(@"ONTIDInfo");
    _detailL.text = Localized(@"ONTIDDec");

    [_importBtn addTarget:self action:@selector(importAction) forControlEvents:UIControlEventTouchUpInside];
    [_importBtn setTitle:Localized(@"LoginImport") forState:UIControlStateNormal];

    [_createBtn addTarget:self action:@selector(createAction) forControlEvents:UIControlEventTouchUpInside];
    [_createBtn setTitle:Localized(@"LoginCreate") forState:UIControlStateNormal];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}

- (void)importAction {

    {

        NSString *mediaType = AVMediaTypeVideo;//读取媒体类型
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];//读取设备授权状态
        if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) {
            UIAlertController *alert =
                [UIAlertController alertControllerWithTitle:Localized(@"CameraRights") message:@"" preferredStyle:UIAlertControllerStyleAlert];

            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *_Nonnull action) {

            }]];
            //弹出提示框；
            [self presentViewController:alert animated:true completion:nil];

            return;
        }
//        KeystoreImportVC *vc = [[KeystoreImportVC alloc] init];
//        vc.isIdentity = YES;
//        [self.navigationController pushViewController:vc animated:YES];
        NewOntImportViewController * vc = [[NewOntImportViewController alloc]init];
        [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"box"];
        [self.navigationController pushViewController:vc animated:YES];

    }
}

- (void)createAction {
    CreateViewController *control = [[CreateViewController alloc] init];
    [self.navigationController pushViewController:control animated:YES];
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


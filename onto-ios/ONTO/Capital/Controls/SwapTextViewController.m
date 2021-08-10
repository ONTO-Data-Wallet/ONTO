//
//  SwapTextViewController.m
//  ONTO
//
//  Created by 赵伟 on 2018/7/16.
//  Copyright © 2018年 Zeus. All rights reserved.
//

#import "SwapTextViewController.h"
#import "SwapExplainViewController.h"
@interface SwapTextViewController ()

@property (weak, nonatomic) IBOutlet UILabel *tipLabel1;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel2;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel3;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel4;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel5;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel6;
@property (weak, nonatomic) IBOutlet UIButton *confirmB;

@end

@implementation SwapTextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    [self setNavTitle:Localized(@"MainNetONT")];
    [self setNavLeftImageIcon:[UIImage imageNamed:@"nav_back"] Title:Localized(@"Back")];
    self.tipLabel1.text =  Localized(@"swap_tip1");
    self.tipLabel2.text =  Localized(@"swap_tip2");
    self.tipLabel3.text =  Localized(@"swap_tip3");
    self.tipLabel4.text =  Localized(@"swap_tip4");
    self.tipLabel5.text =  Localized(@"swap_tip5");
    self.tipLabel6.text =  Localized(@"swap_tip6");
    [self.confirmB setTitle:Localized(@"Swap") forState:UIControlStateNormal];

}

- (void)navLeftAction {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)confirmClick:(id)sender {
    SwapExplainViewController *vc = [[SwapExplainViewController alloc]init];
    vc.NET5 = _NET5;
    [self.navigationController pushViewController:vc animated:YES];
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

//
//  AddContactViewController.m
//  ONTO
//
//  Created by 赵伟 on 16/05/2018.
//  Copyright © 2018 Zeus. All rights reserved.
//

#import "AddContactViewController.h"
#import "ImportViewController.h"
#import "Config.h"
#import "ToastUtil.h"
#import "ContactsViewController.h"

@interface AddContactViewController ()

@property (weak, nonatomic) IBOutlet UITextField *nickNameL;
@property (weak, nonatomic) IBOutlet UITextField *addressL;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLB;
@property (weak, nonatomic) IBOutlet UILabel *addressLB;

@end

@implementation AddContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self configNav];
}

- (void)configNav {
    [self setNavTitle:Localized(@"Contacts")];
    [self setNavLeftImageIcon:[UIImage imageNamed:@"nav_back"] Title:Localized(@"Back")];
    [self setNavRightImageIcon:nil Title:Localized(@"Done")];
    self.nameLB.text = Localized(@"nameLB");
    self.addressLB.text =Localized(@"NewaddressLB");
    self.nickNameL.placeholder = Localized(@"Contactname");
    self.addressL.placeholder = Localized(@"ReceiverAddress");
    [self.deleteBtn setTitle:Localized(@"Delete") forState:UIControlStateNormal];

    
    if (!_name) {
        _deleteBtn.hidden = YES;
    }
    
    if (_name) {
        self.nickNameL.text = _name;
    }
    if (_address) {
        self.addressL.text = _address;
    }
    
    
}

- (IBAction)addAction:(id)sender {
    
    NSString *mediaType = AVMediaTypeVideo;//读取媒体类型
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];//读取设备授权状态
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:Localized(@"CameraRights") message:@"" preferredStyle: UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        //弹出提示框；
        [self presentViewController:alert animated:true completion:nil];
        
        return;
    }
    
    ImportViewController *vc = [[ImportViewController alloc] init];
    vc.isReceiverAddress = YES;
    
    [vc setCallback:^(NSString *stringValue) {
        if ([stringValue containsString:@"address"]&&[stringValue containsString:@"label"]) {
            NSDictionary *dic = [Common dictionaryWithJsonString:stringValue];
            self.addressL.text = [dic valueForKey:@"address"];
            self.nickNameL.text = [dic valueForKey:@"label"];

        }else{
            self.addressL.text = stringValue;
        }
        
    }];
    
    
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

//输入内容合法性验证
-(BOOL)p_isAddressSuitable:(NSString*)addStr
{
    //1.以大写A开头 && 2.字符长度为34位
    if (addStr.length == 34 && [[addStr substringToIndex:1] isEqualToString:@"A"])
    {
        return YES;
    }
    
    return NO;
}

-(void)navRightAction
{
    [self.nickNameL resignFirstResponder];
    [self.addressL resignFirstResponder];

    self.nickNameL.text = [self.nickNameL.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    self.addressL.text = [self.addressL.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if (![self.nickNameL.text isNotBlank])
    {
        [Common showToast:Localized(@"FillName")];
        return;
    }

    if (![self p_isAddressSuitable:self.addressL.text])
    {
        [Common showToast:@"请输入34位token，且首字母为大写A"];
        return;
    }
    
//    if (![self.addressL.text isNotBlank])
//    {
//        [Common showToast:Localized(@"FillAddress")];
//        return;
//    }
    
    NSMutableArray *contactsArr  = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults]valueForKey:ALLCONTACT_LIST]];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:self.nickNameL.text forKey:@"name"];
    [dic setValue:self.addressL.text forKey:@"address"];
    //编辑
    if (_name)
    {
        [contactsArr replaceObjectAtIndex:_index withObject:dic];
        
        _callback(self.nickNameL.text,self.addressL.text);
        
    }
    else
    {
        //增加
        [contactsArr insertObject:dic atIndex:0];
    }
    
    [[NSUserDefaults standardUserDefaults]setValue:contactsArr forKey:ALLCONTACT_LIST];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)deleteAction:(id)sender {
    
    NSMutableArray * contactsArr =   [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:ALLCONTACT_LIST]];
    [contactsArr removeObjectAtIndex:_index];
    [[NSUserDefaults standardUserDefaults] setObject:contactsArr forKey:ALLCONTACT_LIST];
    // 返回到指定界面
    for (UIViewController *temp in self.navigationController.viewControllers) {
        if ([temp isKindOfClass:[ContactsViewController class]]) {
            [self.navigationController popToViewController:temp animated:YES];
        }
    }
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

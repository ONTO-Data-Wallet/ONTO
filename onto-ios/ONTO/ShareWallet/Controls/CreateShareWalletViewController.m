//
//  CreateShareWalletViewController.m
//  ONTO
//
//  Created by Apple on 2018/7/9.
//  Copyright © 2018年 Zeus. All rights reserved.
//

#import "CreateShareWalletViewController.h"
#import "ShareWalletCell.h"
#import "AddShareWalletAddressViewController.h"
#import "blackView.h"
@interface CreateShareWalletViewController ()
<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
@property(nonatomic,strong)UITableView      *tableView;
@property(nonatomic,strong)NSMutableArray   *dataArray;
@property(nonatomic,strong)UIButton         *createBtn;

@property(nonatomic,copy)NSString           *nameStr;
@property(nonatomic,assign)NSInteger        totalNum;
@property(nonatomic,assign)NSInteger        requiredNum;
@property(nonatomic,strong)NSIndexPath      *selectAll;

@property(nonatomic,strong)UIView           *bottomView;
@property(nonatomic,strong)UIView           *animateV;
@property(nonatomic,strong)UIPickerView     *numPicker;
@property(nonatomic,assign)NSInteger        selectRow;
@property(nonatomic,assign)NSInteger        rSelectRow;
@property(nonatomic,assign)NSInteger        selectRow1;
@property(nonatomic,assign)NSInteger        rSelectRow1;
@property(nonatomic,strong)UITableView      *numTableView;
@end

@implementation CreateShareWalletViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.nameStr =@"";
    self.totalNum =-1;
    self.requiredNum =-1;
    [self createUI];
    [self createNav];
    // Do any additional setup after loading the view.
}
-(void)createUI{
    self.view.backgroundColor =[UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.createBtn];
    
}
-(void)createNav{
    [self setNavTitle:Localized(@"createShareWallet")];
    [self setNavLeftImageIcon:[UIImage imageNamed:@"nav_back"] Title:Localized(@"Back")];
    
}
- (void)navLeftAction {
    [self.navigationController popViewControllerAnimated:YES];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([tableView isEqual:_tableView]) {
        return 4;
    }
    return self.dataArray.count;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath   {
    if ([tableView isEqual:_tableView]) {
        return 82*SCALE_W;
    }
    return 51*SCALE_W;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isEqual:_tableView]) {
        
        static NSString * cellID = @"shareCell";
        ShareWalletCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell =[[ShareWalletCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            cell.selectionStyle =UITableViewCellSelectionStyleNone;
        }
        if (indexPath.row ==0) {
            cell.nameField.hidden =NO;
            cell.nameField.delegate =self;
            cell.nameField.tag =10000;
            [cell.nameField addTarget:self action:@selector(textFieldDidChange1:) forControlEvents:UIControlEventEditingChanged];
            cell.rightImage.hidden =YES;
            cell.titleLB.text =Localized(@"ShareWalletName");
            if (self.nameStr.length>0) {
                cell.nameField.placeholder  =@"";
                cell.totalNumField.placeholder  =@"";
                cell.requiredNumField.placeholder   =@"";
            }else{
                cell.totalNumField.placeholder  =@"";
                cell.requiredNumField.placeholder   =@"";
                cell.nameField.placeholder =Localized(@"NamePlaceHolder");
                //修改输入非法名称确认后的显示错误-bug
                cell.nameField.text = @"";
            }
        }else if (indexPath.row ==1){
            cell.totalNumField.hidden =NO;
            cell.requiredNumField.hidden =YES;
            cell.totalNumField.delegate =self;
            cell.totalNumField.tag =10001;
            cell.rightImage.hidden =NO;
            cell.titleLB.text =Localized(@"TotalCopayersNum");
            if (_totalNum!=-1) {
                cell.nameField.placeholder  =@"";
                cell.totalNumField.placeholder  =@"";
                cell.totalNumField.text =[NSString stringWithFormat:@"%ld",(long)_totalNum];
            }else{
                cell.totalNumField.placeholder =Localized(@"ShareSelect");
            }
        }else if (indexPath.row ==2){
            cell.requiredNumField.hidden =NO;
            cell.totalNumField.hidden=YES;
            cell.requiredNumField.delegate =self;
            cell.requiredNumField.tag =10002;
            cell.titleLB.text =Localized(@"RequiredCopayersNum");
            cell.rightImage.hidden =NO;
            if (_requiredNum!=-1) {
                cell.nameField.placeholder  =@"";
                cell.requiredNumField.placeholder=@"";
                cell.requiredNumField.text =[NSString stringWithFormat:@"%ld",(long)_requiredNum];
            }else{
                cell.requiredNumField.placeholder =Localized(@"ShareSelect");
            }
        }else if (indexPath.row ==3){
            cell.addressField.hidden =NO;
            //        cell.addressField.delegate =self;
            cell.rightImage.hidden =NO;
            cell.titleLB.text =Localized(@"AddressesCopayersAll");
        }
        return cell;
    }else{
        static NSString * numCellId =@"numCellId";
        UITableViewCell *cell =[_numTableView dequeueReusableCellWithIdentifier:numCellId];
        if (!cell) {
            cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:numCellId];
            cell.selectionStyle =UITableViewCellSelectionStyleNone;
            
            UIView* numLine =[[UIView alloc]initWithFrame:CGRectMake(0, 51*SCALE_W-1, SYSWidth-32*SCALE_W, 1)];
            numLine.backgroundColor =LINEBG;
            [cell.contentView addSubview:numLine];
        }
        
        cell.textLabel.text =[NSString stringWithFormat:@"%ld",[self.dataArray[indexPath.row] integerValue]];
        cell.textLabel.textAlignment =NSTextAlignmentCenter;
        cell.textLabel.font =[UIFont systemFontOfSize:18];
        cell.textLabel.textColor =[UIColor colorWithHexString:@"#6A797C"];
//        if (self.selectAll.row ==1) {
//            NSInteger nowI=-1;
//            for (NSInteger i=0; i<_dataArray.count; i++) {
//                if (_selectRow == [_dataArray[i] integerValue]) {
//                    nowI =i;
//                }
//            }
//            if (indexPath.row ==nowI) {
//                cell.textLabel.textColor = [UIColor colorWithHexString:@"#0AA5C9"];
//                cell.backgroundColor =LIGHTGRAYBG;
//            }else{
//                cell.backgroundColor =[UIColor whiteColor];
//            }
//        }else{
//            NSInteger nowI=-1;
//            for (NSInteger i=0; i<_dataArray.count; i++) {
//                if (_rSelectRow == [_dataArray[i] integerValue]) {
//                    nowI =i;
//                }
//            }
//            if (indexPath.row ==nowI) {
//                cell.textLabel.textColor = [UIColor colorWithHexString:@"#0AA5C9"];
//                cell.backgroundColor =LIGHTGRAYBG;
//            }else{
//                cell.backgroundColor =[UIColor whiteColor];
//            }
//        }
        return cell;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isEqual:_tableView]) {
        if (indexPath.row==1||indexPath.row ==2) {
            
            [self createSelectNumV:indexPath];
        }if (indexPath.row==3) {
            if (self.nameStr.length ==0) {
                [Common showToast:Localized(@"InputWalletName")];
                return;
            }
            if (_totalNum ==-1) {
                [Common showToast:Localized(@"FirstSelectAllPerple")];
                return;
            }
            if (_requiredNum ==-1) {
                [Common showToast:Localized(@"InputRequiredPerple")];
                return;
            }
            AddShareWalletAddressViewController *vc =[[AddShareWalletAddressViewController alloc]init];
            vc.nameStr      =_nameStr;
            vc.totalNum     =_totalNum;
            vc.requiredNum  =_requiredNum;
            [self.navigationController pushViewController:vc animated:YES];
            
        }
    }else{
        NSIndexPath*path;
        NSInteger selectedRow =[_dataArray[indexPath.row]integerValue];
        if (self.selectAll.row ==1) {
            _totalNum =selectedRow;
            //记录下滚动结束时的行数
            _selectRow = selectedRow;
            _selectRow1 =indexPath.row;
            path=[NSIndexPath indexPathForRow:_selectRow1 inSection:0];
        }else{
            _requiredNum =selectedRow;
            //记录下滚动结束时的行数
            _rSelectRow = selectedRow;
            _rSelectRow1 =indexPath.row;
            path=[NSIndexPath indexPathForRow:_rSelectRow1 inSection:0];
        }
        
        UITableViewCell * cell1 = (UITableViewCell *)[tableView cellForRowAtIndexPath:path];
        cell1.backgroundColor =[UIColor whiteColor];
        cell1.textLabel.textColor = [UIColor colorWithHexString:@"#6A797C"];
        
        UITableViewCell * cell = (UITableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        cell.backgroundColor =LIGHTGRAYBG;
        cell.textLabel.textColor = [UIColor colorWithHexString:@"#0AA5C9"];
        
        
        [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:self.selectAll,nil] withRowAnimation:UITableViewRowAnimationNone];
        [self performSelector:@selector(disAppear) withObject:nil afterDelay:0.5];
    }
}
-(void)disAppear{
    [self dismissScreenBgView];
}
-(UITableView*)tableView{
    if (!_tableView) {
        _tableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SYSWidth, SYSHeight-49-64) style:UITableViewStylePlain];
        if (KIsiPhoneX) {
            _tableView.frame =CGRectMake(0, 0, SYSWidth, SYSHeight-49-64-34-24);
        }
        _tableView.separatorStyle =UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator =NO;
        _tableView.delegate =self;
        _tableView.dataSource =self;
    }
    return _tableView;
}
-(UIButton*)createBtn{
    if (!_createBtn) {
        _createBtn =[[UIButton alloc]initWithFrame:CGRectMake(0, SYSHeight-64-49, SYSWidth, 49)];
        if (KIsiPhoneX) {
            _createBtn.frame =CGRectMake(0, SYSHeight-64-49-34-24, SYSWidth, 49);
        }
        [_createBtn setTitle:Localized(@"createONT") forState:UIControlStateNormal];
        [_createBtn setTitleColor:LIGHTGRAYLB forState:UIControlStateNormal];
        _createBtn.titleLabel.font =[UIFont systemFontOfSize:18 weight:UIFontWeightSemibold];
        [_createBtn setBackgroundColor:[UIColor colorWithHexString:@"#EDF2F5"]];
        
    }
    return _createBtn;
}
-(void)createSelectNumV:(NSIndexPath*)indexPath{
    self.selectAll =indexPath;
    _dataArray =[NSMutableArray array];
    if (indexPath.row==1) {
        [_dataArray removeAllObjects];
        if (_totalNum ==-1) {
            _selectRow =-1;
        }
        if (_requiredNum ==-1) {
            
            for (NSInteger i=2; i<=12; i++) {
                [_dataArray addObject:[NSNumber numberWithInteger:i]];
            }
        }else{
            for (NSInteger i=_requiredNum; i<=12; i++) {
                [_dataArray addObject:[NSNumber numberWithInteger:i]];
            }
        }
    }else{
        if (_totalNum ==-1) {
            _selectRow =-1;
            [Common showToast:Localized(@"FirstSelectAllPerple")];
//            [ToastUtil shortToast:self.view value:Localized(@"FirstSelectAllPerple")];
            return;
        }
        if (_requiredNum ==-1) {
            _selectRow =-1;
        }
        [_dataArray removeAllObjects];
        for (NSInteger i=2; i<=_totalNum; i++) {
            [_dataArray addObject:[NSNumber numberWithInteger:i]];
        }
    }
    AppDelegate* appdelegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    [self.bottomView removeFromSuperview];
    self.bottomView=[blackView initWithForView:appdelegate.window];
    self.bottomView.alpha =0;
    
//    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissScreenBgView)];
//    tapGesture.cancelsTouchesInView = YES;
//    [self.bottomView  addGestureRecognizer:tapGesture];
    
    self.animateV =[[UIView alloc]initWithFrame:CGRectMake(0, SYSHeight , SYSWidth, 168*SCALE_W+96*SCALE_W)];
    [self.bottomView addSubview:self.animateV];
    
    UIView *bgV =[[UIView alloc]initWithFrame:CGRectMake(16*SCALE_W, 0, SYSWidth-32*SCALE_W, 197*SCALE_W)];
    bgV.backgroundColor =[UIColor whiteColor];
    bgV.layer.cornerRadius =2.f;
    [self.animateV addSubview:bgV];
    
    UILabel *titleLB =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, SYSWidth-32*SCALE_W, 35*SCALE_W)];
    titleLB.font =[UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    titleLB.textColor =LIGHTGRAYLB;
    titleLB.textAlignment=NSTextAlignmentCenter;
    if (indexPath.row ==1) {
       titleLB.text =Localized(@"TotalCopayersNum");
    }else{
        titleLB.text =Localized(@"RequiredCopayersNum");
    }
    [bgV addSubview:titleLB];
    
    UIView * line =[[UIView alloc]initWithFrame:CGRectMake(0, 34*SCALE_W, SYSWidth-32*SCALE_W, 1*SCALE_W)];
    line.backgroundColor =LINEBG ;
    [bgV addSubview:line];
    
    UIButton * sureBtn =[[UIButton alloc]initWithFrame:CGRectMake(16*SCALE_W, 86*SCALE_W, SYSWidth-32*SCALE_W, 50*SCALE_W)];
    sureBtn.backgroundColor =[UIColor clearColor];
    [sureBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^{
    }];
    [bgV addSubview:sureBtn];
    
//    _numPicker= [[UIPickerView alloc] initWithFrame:CGRectMake(0, 35*SCALE_W, SYSWidth-32*SCALE_W, 153*SCALE_W)];
////    _selectRow =1;
//    _numPicker.userInteractionEnabled =YES;
//    _numPicker.dataSource = self;
//    _numPicker.delegate = self;
//    [bgV addSubview:_numPicker];
//    [_numPicker selectRow:1 inComponent:0 animated:NO];
    
    _numTableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 35*SCALE_W, SYSWidth-32*SCALE_W, 153*SCALE_W) style:UITableViewStylePlain];
    _numTableView.separatorStyle =UITableViewCellSeparatorStyleNone;
    _numTableView.showsVerticalScrollIndicator =NO;
    _numTableView.delegate =self;
    _numTableView.dataSource =self;
    [bgV addSubview:_numTableView];
    [_numTableView reloadData];
    
    UIView * line2 =[[UIView alloc]initWithFrame:CGRectMake(0, 187*SCALE_W, SYSWidth-32*SCALE_W, 1*SCALE_W)];
    line2.backgroundColor =LINEBG ;
    [bgV addSubview:line2];
    
    
    UIButton * cancleBtn =[[UIButton alloc]initWithFrame:CGRectMake(16*SCALE_W, 206*SCALE_W, SYSWidth-32*SCALE_W, 50*SCALE_W)];
    cancleBtn.layer.cornerRadius =2.f;
    cancleBtn.backgroundColor =[UIColor whiteColor];
    [cancleBtn setTitleColor:BLACKLB forState:UIControlStateNormal];
    [cancleBtn setTitle:Localized(@"Cancel") forState:UIControlStateNormal];
    cancleBtn.titleLabel.font =[UIFont systemFontOfSize:18 weight:UIFontWeightSemibold];
    [self.animateV addSubview:cancleBtn];
    
    
    
    [UIView animateWithDuration:.2 animations:^{
        self.animateV.frame = CGRectMake(0, SYSHeight - 168*SCALE_W-96*SCALE_W, SYSWidth, SYSHeight);
        self.bottomView.alpha =1;
    }];
    
    [cancleBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        [self dismissScreenBgView];
    }];
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return _dataArray.count;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return SYSWidth-32*SCALE_W;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 51*SCALE_W;
}
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSInteger noeRow =[_dataArray[row] integerValue];
    return [NSString stringWithFormat:@"%ld",noeRow];
}
-(UIView*)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    //设置分割线的颜色
    for(UIView *singleLine in pickerView.subviews){
        if (singleLine.frame.size.height < 1){
            singleLine.backgroundColor = LINEBG ;
        }
    }
    
    NSInteger noeRow =[_dataArray[row] integerValue];
    //设置文字的属性
    UILabel *genderLabel = [UILabel new];
    genderLabel.textAlignment = NSTextAlignmentCenter;
    genderLabel.text = [NSString stringWithFormat:@"%ld",noeRow];
    genderLabel.font =[UIFont systemFontOfSize:18];
    genderLabel.backgroundColor =[UIColor whiteColor];
    genderLabel.textColor = [UIColor colorWithHexString:@"#6A797C"];
    if (row ==_selectRow) {
        genderLabel.textColor = [UIColor colorWithHexString:@"#0AA5C9"];
        genderLabel.backgroundColor =LIGHTGRAYBG;
    }
    
    return genderLabel;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    //记录下滚动结束时的行数
    _selectRow = row;
    NSInteger selectedRow =[_dataArray[row]integerValue];
    //刷新picker，看上面的代理
    [pickerView reloadComponent:component];
    if (self.selectAll.row ==1) {
        _totalNum =selectedRow;
    }else{
        _requiredNum =selectedRow;
    }
    [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:self.selectAll,nil] withRowAnimation:UITableViewRowAnimationNone];
    [self dismissScreenBgView];
    
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    if (textField.tag ==10000) {
    }else if (textField.tag ==10001){
    }else if (textField.tag ==10002){
    }
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.tag ==10000)
    {
        if (textField.text.length <= 0 || textField.text.length > 12)
        {
            textField.text =@"";
//            NSIndexPath *path =[NSIndexPath indexPathForRow:0 inSection:0];
//             [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:path,nil] withRowAnimation:UITableViewRowAnimationNone];
            [Common showToast:Localized(@"SelectAlert")];
            return;
        }
        if (![AppHelper checkName:textField.text])
        {
            MGPopController *pop = [[MGPopController alloc] initWithTitle:Localized(@"CorrectName") message:nil image:nil];
            MGPopAction *action =   [MGPopAction actionWithTitle:Localized(@"OK") action:^{
                textField.text=@"";
                textField.placeholder = Localized(@"NamePlaceHolder");
                NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
                [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
            }];
            action.titleColor =MainColor;
            [pop addAction:action];
            [pop show];
            pop.showCloseButton = NO;
            return;
        }
        self.nameStr =textField.text;
    }else if (textField.tag ==10001){
    }else if (textField.tag ==10002){
    }
}

- (void)textFieldDidChange1:(UITextField *)textField{
    
    if (textField.tag ==10000) {
            if (textField.text.length > 12) {
                textField.text = [textField.text substringToIndex:12];
            }
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 消失视图
-(void)dismissScreenBgView{
    [UIView animateWithDuration:.2 animations:^{
        self.animateV.frame = CGRectMake(0, SYSHeight, SYSWidth, SYSHeight);
        self.bottomView.alpha =0;
    } completion:^(BOOL finished) {
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

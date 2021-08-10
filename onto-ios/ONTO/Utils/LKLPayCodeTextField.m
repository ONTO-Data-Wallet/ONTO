//
//  LKLPayCodeTextField.m
//  LakalaClient
//
//  Created by Apple on 2017/10/12.
//  Copyright © 2017年 LR. All rights reserved.
//

#import "LKLPayCodeTextField.h"
#import "LKLPayCodeCollectionViewCell.h"

@interface LKLPayCodeTextField ()<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITextFieldDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;

@property (nonatomic, strong) NSMutableArray *originArrayM;         // 最初始的空数组
@property (nonatomic, strong) NSMutableArray *dataArrayM;           // 要显示的数组（中间变量）
@property (nonatomic, strong) NSMutableArray *ciphertextArrayM;     // 密文 数组
@property (nonatomic, strong) NSMutableArray *plaintextArrayM;      // 明文 数组


@property (nonatomic, copy)   NSString *currentInputString; // 当前输入的字符
@property (nonatomic, assign) BOOL isFirst;
@end

@implementation LKLPayCodeTextField

static NSString *const reuseId = @"LKLPayCodeTextFieldCell";

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.isFirst =YES;
        [self createUI];
    }
    return self;
}
- (void)createUI {
    
    [self collectionView];
    NSString * mobileStr =[[NSUserDefaults standardUserDefaults] valueForKey:@"mobile"];
    [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:@"mobile"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    NSLog(@"mobileStr%@",mobileStr);
    if ([mobileStr isEqualToString:@"1"]) {
        [self performSelector:@selector(becomeFirst) withObject:nil afterDelay:1];
    }else{
        
        [self.textField becomeFirstResponder];
    }
    
}
-(void)becomeFirst{
    [self.textField becomeFirstResponder];
}
#pragma mark ---------------  Lazy Loading  ---------------

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        self.flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:self.flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.dataSource = self;
        _collectionView.delegate   = self;
        _collectionView.scrollEnabled = NO;
        _collectionView.userInteractionEnabled = YES;
        [self addSubview:_collectionView];
        
        [_collectionView registerClass:[LKLPayCodeCollectionViewCell class] forCellWithReuseIdentifier:reuseId];
    }
    return _collectionView;
}
- (NSMutableArray *)dataArrayM {
    if (!_dataArrayM) {
        
        if (self.textFieldNum == 0) {
            self.textFieldNum = 6;
        }
    
        _dataArrayM       = [NSMutableArray array];
        self.ciphertextArrayM = [NSMutableArray array];
        self.plaintextArrayM  = [NSMutableArray array];
        
        self.currentInputString = @"";
        
        NSString *string = @"";
        
        for (int i=0; i < self.textFieldNum; i++) {
            [_dataArrayM addObject:string];
            [self.ciphertextArrayM addObject:string];
            [self.plaintextArrayM addObject:string];
        }
        
        self.originArrayM = [NSMutableArray arrayWithArray:[_dataArrayM copy]];
    }
    return _dataArrayM;
}


- (UITextField *)textField {
    if (!_textField) {
        
        _textField = [[LKLForbidPasteTextField alloc] initWithFrame:self.bounds];
        _textField.backgroundColor = [UIColor clearColor];
        _textField.delegate = self;
        _textField.textColor = [UIColor clearColor];
        _textField.tintColor = [UIColor clearColor];
        _textField.borderStyle = UITextBorderStyleNone;
        _textField.keyboardType =UIKeyboardTypeNumberPad;
        _textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [self addSubview:_textField];
    }
    return _textField;
}


- (void)setIsChangeTextFieldNum:(BOOL)isChangeTextFieldNum {
    
    _isChangeTextFieldNum = isChangeTextFieldNum;
}


- (void)setTextFieldNum:(NSInteger)textFieldNum {
    
    _textFieldNum = textFieldNum;
    
    
    if (self.isChangeTextFieldNum) {
        if (textFieldNum > self.dataArrayM.count) {     // 增加长度
            for (int i=0; i < (textFieldNum-self.dataArrayM.count); i++) {
                [self.plaintextArrayM addObject:@""];
                [self.ciphertextArrayM addObject:@""];
                [self.originArrayM addObject:@""];
            }
        } else {    // 减小长度
            textFieldNum = textFieldNum < 0 ? 0:textFieldNum;   // 此判断用来防止无输入长度小于0的情况
            [self.plaintextArrayM replaceObjectsInRange:NSMakeRange(textFieldNum, self.dataArrayM.count-textFieldNum) withObjectsFromArray:@[]];
            [self.ciphertextArrayM replaceObjectsInRange:NSMakeRange(textFieldNum, self.dataArrayM.count-textFieldNum) withObjectsFromArray:@[]];
            [self.originArrayM replaceObjectsInRange:NSMakeRange(textFieldNum, self.dataArrayM.count-textFieldNum) withObjectsFromArray:@[]];
        }
    }
    
    self.isFirst =NO;
    [self updateData];
}


- (void)setIsShowTrueCode:(BOOL)isShowTrueCode {
    
    _isShowTrueCode = isShowTrueCode;
    
    [self updateData];
}


- (void)setBorderSpace:(CGFloat)borderSpace {
    
    _borderSpace = borderSpace < 0 ? 0:borderSpace;     // 防止输入间距小于0 的情况
    
    [self updateData];
}


- (void)setBorderColor:(UIColor *)borderColor {
    
    _borderColor = borderColor;
    
    [self updateData];
}
#pragma mark ---------------  UICollectionViewDataSource、UICollectionViewDelegateFlowLayout  ---------------

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.dataArrayM.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    LKLPayCodeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseId forIndexPath:indexPath];
    
    cell.indePath = indexPath;
    cell.isPWD = self.isPSW;
    cell.cellNum  = self.dataArrayM.count;
    cell.titleString = self.dataArrayM[indexPath.row];
    cell.cellBorderColor = self.borderColor;
    [cell setNewFrame];
    return cell;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPat{
        return CGSizeMake(self.frame.size.width/self.textFieldNum-0.005, self.frame.size.height);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
        return 0;
}


#pragma mark -----
#pragma mark ---------------  Method  ---------------

/** 清除已输入的支付密码 **/
- (void)clearKeyCode {
    
    self.dataArrayM       = [NSMutableArray arrayWithArray:[self.originArrayM copy]];
    self.plaintextArrayM  = [NSMutableArray arrayWithArray:[self.originArrayM copy]];
    self.ciphertextArrayM = [NSMutableArray arrayWithArray:[self.originArrayM copy]];
    
    
    self.currentInputString = @"";
    self.textField.text = @"";
    self.payCodeString = @"";
    [self.collectionView reloadData];
}


#pragma mark -----
#pragma mark ---------------  UITextFieldDelegate  ---------------

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    if (self.payCodeString.length != 0) {
        self.textField.text = self.payCodeString;
    }
    
    if (textField.text.length == self.textFieldNum-1) {
        self.textField.text = @"";
    }
}
-(void)changeField:(UITextField*)textField{
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    
    

    if (range.length == 0) {
        
        // 添加
        
        if (![self isInputRuleAndNumber:string]) {
            return NO;
        }
        
        if (string.length > 1) {
            return NO;
        }
        
        if (textField.text.length >= self.textFieldNum) {
            
            self.currentInputString = @"";
            
            [self updateData];
            return NO;
            
        }
        
        self.currentInputString = string;
        
        [self.plaintextArrayM replaceObjectAtIndex:range.location withObject:string];
        if (self.ciphertext && self.ciphertext.length == 1) {
            string = self.ciphertext;
        } else {
            string = @"●";
        }
        [self.ciphertextArrayM replaceObjectAtIndex:range.location withObject:string];
        
        [self updateData];
        return YES;
        
    }
    // 此处处理联想输入的时候，引起的可以一次性输入多个字符问题
    if (string.length > 0) {    // 联想输入处理
        return NO;
    }
    
    self.currentInputString = @"";
    
    [self.plaintextArrayM replaceObjectAtIndex:range.location withObject:string];
    string = @"";
    [self.ciphertextArrayM replaceObjectAtIndex:range.location withObject:string];
    
    [self updateData];
    return YES;
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    [textField resignFirstResponder];
}


- (void)updateData {
    
    [self dataArrayM];      // 防止未创建时就调用
    
    self.payCodeString = [self.plaintextArrayM componentsJoinedByString:@""];
    
    
    if (self.isShowTrueCode) {
        self.dataArrayM = [NSMutableArray arrayWithArray:[self.plaintextArrayM copy]];
    } else {
        self.dataArrayM = [NSMutableArray arrayWithArray:[self.ciphertextArrayM copy]];
    }
    
    [_collectionView reloadData];
    
    
    if (self.currentBlock) {
        self.currentBlock(self.payCodeString, self.currentInputString);
    }
    
    
    if (self.payCodeString.length == self.textFieldNum) {
        
        [self textFieldDidEndEditing:self.textField];
        
        if (self.finishedBlock) {
            self.finishedBlock(self.payCodeString);
        }
    }
}


/********************  限制字符样式  *******************/
/**
 pattern中,输入需要验证的通过的字符
 小写a-z
 大写A-Z
 汉字\u4E00-\u9FA5
 数字\u0030-\u0039
 @param string 要过滤的字符
 @return YES 只允许输入字母和数字
 */
- (BOOL)isInputRuleAndNumber:(NSString *)string {
    
    NSString *pattern = @"[0-9]";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    return [pred evaluateWithObject:string];
}

@end

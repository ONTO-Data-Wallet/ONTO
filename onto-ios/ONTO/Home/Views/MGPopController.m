//
//  MGPopController.m
//  MGPopControllerDemo
//
//  Created by 宋海梁 on 16/8/4.
//  Copyright © 2016年 宋海梁. All rights reserved.
//

#import "MGPopController.h"
#import <Masonry/Masonry.h>
#import "Config.h"
@implementation MGPopAction

- (instancetype)initWithImage:(UIImage *)image title:(NSString *)title action:(dispatch_block_t)action {

    self = [super init];
    if (self) {
        _image = image;
        _action = action;
        _title = title;
        
        _autoDismiss = YES;
        _titleColor = [UIColor colorWithRed:0 green:0.48 blue:1.0 alpha:1.0];
        _titleFont = [UIFont systemFontOfSize:17.0];
        _disabledTitleColor = [UIColor lightGrayColor];
        _enable = YES;
    }
    
    return self;
}

+ (instancetype)actionWithImage:(UIImage *)image action:(dispatch_block_t)action {

    return [[MGPopAction alloc] initWithImage:image title:nil action:action];
}

+ (instancetype)actionWithTitle:(NSString *)title action:(dispatch_block_t)action {

    return [[MGPopAction alloc] initWithImage:nil title:title action:action];
}

@end

@interface MGPopController () {

    NSString *_title;
    NSString *_message;
    UIImage *_image;
}

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIImageView *topImageView;
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UIView *actionContainerView;
@property (nonatomic, strong) UIView *textFieldContainerView;

@property (nonatomic, strong) NSMutableArray *actions;

@end

@implementation MGPopController

#pragma mark - Init

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message image:(UIImage *)image {
    
    self = [super init];
    if (self) {
        _title = title;
        _message = message;
        _image = image;
        
        [self setupDefault];
    }
    
    return self;
}

- (void)setupDefault {
    
    _actions = [NSMutableArray array];

    _backgroundColor = [UIColor whiteColor];
    _titleFont = [UIFont systemFontOfSize:18.0];
    _titleColor = [UIColor darkGrayColor];
    _messageFont = [UIFont systemFontOfSize:14.0];
    _messageColor = [UIColor lightGrayColor];
    _closeButtonTintColor = [UIColor lightGrayColor];
    _cornerRadius = 4.0;
    _horizontalOffset = 16;
    
    _showActionSeparator = NO;
    _actionPaddingLeftRight = 15;
    _actionSpacing = 10;
    _actionPaddingBottom = 15;
    _showCloseButton = NO;
}

#pragma mark - Life Circle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
}

#pragma mark - UI

- (void)setupUI {
    
    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    
    [self.view addSubview:self.containerView];
    [self.containerView addSubview:self.topImageView];
    [self.containerView addSubview:self.titleLabel];
    [self.containerView addSubview:self.messageLabel];
    [self.containerView addSubview:self.closeButton];
    [self.containerView addSubview:self.actionContainerView];
    [self.containerView addSubview:self.textFieldContainerView];
    [self.containerView addSubview:self.line];

    [self makeConstrains];
    self.titleLabel.text = _title;
    self.messageLabel.text = _message;
    if ([self.messageLabel.text isEqualToString:Localized(@"Creating")] || [self.messageLabel.text isEqualToString:@"Success!"]) {
        self.messageLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    self.topImageView.image = _image;
    self.closeButton.hidden = !self.showCloseButton;
}

- (void)setmytitle:(NSString*)mytitle{
    
    self.titleLabel.text = mytitle;
    
}

- (void)makeConstrains {
    
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.offset(_horizontalOffset);
        make.trailing.offset(-_horizontalOffset);
        make.centerY.equalTo(self.view).offset(self.verticalOffset);
//        make.height.equalTo(make.width);
    }];
    
    [self.topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(24);
        make.centerX.equalTo(self.containerView);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.topImageView.mas_bottom).offset(24);
        make.left.offset(24);
        make.right.offset(-24);
        make.centerX.equalTo(self.containerView);
    }];
    
    [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(24);
        make.right.offset(-24);
        make.leading.offset(15);
        make.trailing.offset(-24);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(16);
    }];
   
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.offset(0);
        make.trailing.offset(-0);
        make.top.mas_equalTo(self.messageLabel.mas_bottom).offset(32);
        make.height.equalTo(@1);

    }];
    
    [self.textFieldContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.offset(0);
        make.top.mas_equalTo(self.line .mas_bottom).offset(15);
    }];
    
    [self.actionContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.offset(self.actionPaddingLeftRight);
        make.trailing.offset(-self.actionPaddingLeftRight);
        make.top.mas_equalTo(self.line.mas_bottom).offset(0);
//        make.bottom.equalTo(self.containerView).offset(-self.actionPaddingBottom);
        make.bottom.offset(0);

    }];
   
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.trailing.offset(0);
        make.width.height.equalTo(@44);
    }];
    
    //Actions
    [self.actions enumerateObjectsUsingBlock:^(MGPopAction *action, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [btn setTitleColor:MainColor forState:UIControlStateNormal];
        btn.tag = idx;
        [btn addTarget:self action:@selector(actionButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
        if (action.image) {
            [btn setImage:action.image forState:UIControlStateNormal];
        }
        else if (action.title.length) {
            [btn setTitle:action.title forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor colorWithHexString:@"#35BFDF"] forState:UIControlStateNormal];
            
//           [self firstColor:[UIColor colorWithHexString:@"#35BFDF"] secondColor:_titleColor]

            [btn setTitleColor:action.disabledTitleColor forState:UIControlStateDisabled];
            btn.titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightSemibold];
            
        }
        if ([action.title isEqualToString:Localized(@"Later")]||[action.title isEqualToString:Localized(@"Cancel")]) {
            [btn setTitleColor:LIGHTGRAYLB forState:UIControlStateNormal];
        }
        if ([_message isEqualToString:@"Success!"]) {
            [btn setTitleColor:BLACKLB forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
        }
        btn.enabled = action.enable;
        
        
        
        
        [self.actionContainerView addSubview:btn];
    }];
    
    NSInteger count = self.actions.count;
    __block UIButton *preBtn;
    [self.actionContainerView.subviews enumerateObjectsUsingBlock:^(UIButton * _Nonnull btn, NSUInteger idx, BOOL * _Nonnull stop) {
       [btn mas_makeConstraints:^(MASConstraintMaker *make) {
           
           make.top.bottom.offset(0);
           make.height.equalTo(@48);
           if (preBtn) {
               make.left.equalTo(preBtn.mas_right).offset(self.actionSpacing);
               make.width.equalTo(preBtn.mas_width);
           }
           else {
               make.leading.offset(0);
           }
           if (idx == count-1) { //最后一个
               make.trailing.offset(0);
           }
       }];
        
        preBtn = btn;
    }];
    
    //分割线separator
    if (self.showActionSeparator) {
        //Top separator
        UIView *topSeparator = [[UIView alloc] init];
        topSeparator.backgroundColor = [UIColor colorWithRed:227/255.0 green:225/255.0 blue:228/255.0 alpha:1.0];
        [self.actionContainerView addSubview:topSeparator];
        [topSeparator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.trailing.offset(0);
            make.height.equalTo(@0.5);
        }];
        
        //vertical separator
        NSInteger separatorNum = self.actions.count-1;
        for (NSInteger i=0; i<separatorNum; i++) {
            UIView *separator = [[UIView alloc] init];
            separator.backgroundColor = [UIColor colorWithRed:227/255.0 green:225/255.0 blue:228/255.0 alpha:1.0];
            [self.actionContainerView addSubview:separator];
            [separator mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.offset(0);
                make.width.equalTo(@0.5);
                make.centerX.equalTo(self.actionContainerView).multipliedBy((i*2+2)/((CGFloat)self.actions.count));
            }];
        }
    }
    
    //TextFields
    [self.textFields enumerateObjectsUsingBlock:^(UITextField * _Nonnull textField, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.textFieldContainerView addSubview:textField];
    }];
    
    __block UITextField *preTextField;
    [self.textFieldContainerView.subviews enumerateObjectsUsingBlock:^(UITextField * textField, NSUInteger idx, BOOL * _Nonnull stop) {
        [textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.offset(16);
            make.trailing.offset(-16);
            if (preTextField) {
                make.top.equalTo(preTextField.mas_bottom).offset(8);
            }
            else {
                make.top.offset(0);
            }
            if (idx == self.textFields.count-1) { //最后一个
                make.bottom.offset(-8);
            }
        }];
        preTextField = textField;
    }];
    
}

-(BOOL)firstColor:(UIColor*)firstColor secondColor:(UIColor*)secondColor
{
    if (CGColorEqualToColor(firstColor.CGColor, secondColor.CGColor))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}


#pragma mark - Public Method

- (void)addAction:(MGPopAction *)action {

    [_actions addObject:action];
}

- (void)addTextFieldWithConfiguration:(void (^)(UITextField *textField))configuration {

    UITextField *textField = [[UITextField alloc] init];
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.font = [UIFont systemFontOfSize:13.0f];
    
    NSMutableArray *arr = [NSMutableArray arrayWithArray:_textFields];
    [arr addObject:textField];
    _textFields = arr;
    
    if (configuration) {
        configuration(textField);
    }
}

- (void)show {
    
    UIViewController *currentController = [self currentController];
    [currentController addChildViewController:self];
//    [currentController.view addSubview:self.view];
    
    UIWindow *window = [[[UIApplication sharedApplication]windows] objectAtIndex:0];
    [window addSubview:self.view];
    [window makeKeyAndVisible];

    
    
    
    [self.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsZero);
    }];
    
    CABasicAnimation *animation=[CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.fromValue = @(0.8);
    animation.toValue = @(1);
    animation.duration = 0.15;
    animation.autoreverses = NO;
    animation.repeatCount = 1;
    animation.removedOnCompletion = YES;
    animation.fillMode = kCAFillModeForwards;
    
    [self.containerView.layer addAnimation:animation forKey:@"animation"];
}

- (void)dismiss {
    
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.15 animations:^{
        
        self.containerView.layer.transform = CATransform3DMakeScale(0.5, 0.5, 1);
        self.containerView.alpha = 0;
        
    } completion:^(BOOL finished) {
        [weakSelf.view removeFromSuperview];
        [weakSelf removeFromParentViewController];
    }];
}

#pragma mark - getter、setter

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    _backgroundColor = backgroundColor;
    self.containerView.backgroundColor = backgroundColor;
}

- (void)setTitleFont:(UIFont *)titleFont {
    _titleFont = titleFont;
    self.titleLabel.font = _titleFont;
}

- (void)setTitleColor:(UIColor *)titleColor {
    _titleColor = titleColor;
    self.titleLabel.textColor = _titleColor;
}

- (void)setMessageFont:(UIFont *)messageFont {
    _messageFont = messageFont;
    self.messageLabel.font = _messageFont;
}

- (void)setMessageColor:(UIColor *)messageColor {
    _messageColor = messageColor;
    self.messageLabel.textColor = _messageColor;
}

- (void)setCloseButtonTintColor:(UIColor *)closeButtonTintColor {
    _closeButtonTintColor = closeButtonTintColor;
    self.closeButton.tintColor = _closeButtonTintColor;
}

- (void)setCornerRadius:(NSInteger)cornerRadius {
    _cornerRadius = cornerRadius;
    self.containerView.layer.cornerRadius = _cornerRadius;
}

#pragma mark - Private Method

- (void)closeButtonTouched:(UIButton *)sender {
    
    [self dismiss];
}

- (void)actionButtonTouched:(UIButton *)sender {

    
    
    if (self.actions.count > sender.tag) {
        MGPopAction *action = [self.actions objectAtIndex:sender.tag];
        if (action.action) {
            action.action();
        }
        if (action.autoDismiss) {
            [self dismiss];
        }
    }
}

- (UIViewController *)currentController {
    UIViewController *result = nil;
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        
        for (UIWindow *temWin in windows) {
            if (temWin.windowLevel == UIWindowLevelNormal) {
                window = temWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nestResponder = [frontView nextResponder];
    if ([nestResponder isKindOfClass:[UIViewController class]]) {
        result = nestResponder;
    } else {
        result = window.rootViewController;
    }
    return result;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

#pragma mark - Property

- (UIView *)containerView {
    
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
        _containerView.layer.cornerRadius = _cornerRadius;
        _containerView.backgroundColor = _backgroundColor;
    }
    
    return _containerView;
}

- (UIImageView *)topImageView {
    
    if (!_topImageView) {
        _topImageView = [[UIImageView alloc] init];
        _topImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    
    return _topImageView;
}

- (UILabel *)titleLabel {
    
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.numberOfLines = 0;
        _titleLabel.font = _titleFont;
        _titleLabel.textColor = _titleColor;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    return _titleLabel;
}

- (UILabel *)messageLabel {
    
    if (!_messageLabel) {
        _messageLabel = [[UILabel alloc] init];
        _messageLabel.numberOfLines = 0;
        _messageLabel.font = _messageFont;
        _messageLabel.textColor = _messageColor;
        _messageLabel.textAlignment = NSTextAlignmentLeft;
    }
    
    return _messageLabel;
}

- (UIButton *)closeButton {
    
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _closeButton.tintColor = _closeButtonTintColor;
        [_closeButton setImage:[UIImage imageNamed:@"icon_close"] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(closeButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _closeButton;
}

- (UIView *)actionContainerView {
    
    if (!_actionContainerView) {
        _actionContainerView = [[UIView alloc] init];
    }
    
    return _actionContainerView;
}

- (UIView *)line {
    
    if (!_line) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = [UIColor colorWithHexString:@"#E9EDEF"];
    }
    
    return _line;
}

- (UIView *)textFieldContainerView {

    if (!_textFieldContainerView) {
        _textFieldContainerView = [[UIView alloc] init];
    }
    
    return _textFieldContainerView;
}

@end

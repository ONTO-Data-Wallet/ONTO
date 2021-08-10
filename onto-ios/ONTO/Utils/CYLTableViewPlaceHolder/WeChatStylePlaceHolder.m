//
//  WeChatStylePlaceHolder.m
//  CYLTableViewPlaceHolder
//
//  Created by 陈宜龙 on 15/12/23.
//  Copyright © 2015年 http://weibo.com/luohanchenyilong/ ÂæÆÂçö@iOSÁ®ãÂ∫èÁä≠Ë¢Å. All rights reserved.
//

static float const kUIemptyOverlayLabelX         = 0;
static float const kUIemptyOverlayLabelY         = 0;
static float const kUIemptyOverlayLabelHeight    = 20;

#import "WeChatStylePlaceHolder.h"
#import "Config.h"
@interface WeChatStylePlaceHolder ()

@property (nonatomic, strong) UIImageView *emptyOverlayImageView;
@property (nonatomic, strong) UILabel *emptyOverlayLabel;

@end

@implementation WeChatStylePlaceHolder

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self = [self sharedInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self = [self sharedInit];
    }
    return self;
}

- (instancetype)sharedInit {
    self.backgroundColor = [UIColor whiteColor];
    self.backgroundColor = [UIColor whiteColor];
    self.contentMode =   UIViewContentModeTop;
    [self addUIemptyOverlayImageView];
    [self addUIemptyOverlayLabel];
//    [self setupUIemptyOverlay];
    return self;
}

- (void)addUIemptyOverlayImageView {
    self.emptyOverlayImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 260, 260)];
    self.emptyOverlayImageView.center = CGPointMake(CGRectGetWidth(self.frame) / 2, CGRectGetHeight(self.frame) / 2 - 100);
    self.emptyOverlayImageView.image = [UIImage imageNamed:@"nothing"];
    [self addSubview:self.emptyOverlayImageView];
    
}

- (void)setContacts{
    self.emptyOverlayImageView.image = [UIImage imageNamed:@"lianxihui"];
    _emptyOverlayLabel.text = @"";

}

- (void)addUIemptyOverlayLabel {
    CGRect emptyOverlayViewFrame = CGRectMake(kUIemptyOverlayLabelX, kUIemptyOverlayLabelY, CGRectGetWidth(self.frame), kUIemptyOverlayLabelHeight);
    _emptyOverlayLabel = [[UILabel alloc] initWithFrame:emptyOverlayViewFrame];
    _emptyOverlayLabel.textAlignment = NSTextAlignmentCenter;
    _emptyOverlayLabel.numberOfLines = 0;
    _emptyOverlayLabel.backgroundColor = [UIColor clearColor];
    _emptyOverlayLabel.text = Localized(@"NoClaims");
    _emptyOverlayLabel.font = [UIFont boldSystemFontOfSize:15];
    _emptyOverlayLabel.frame = ({
        CGRect frame = _emptyOverlayLabel.frame;
        frame.origin.y = CGRectGetMaxY(self.emptyOverlayImageView.frame) + 10;
        frame;
    });
    _emptyOverlayLabel.textColor = [UIColor grayColor];
    [self addSubview:_emptyOverlayLabel];
}

- (void)setupUIemptyOverlay {
    self.userInteractionEnabled = YES;
    UILongPressGestureRecognizer *longPressUIemptyOverlay = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressUIemptyOverlay:)];
    [longPressUIemptyOverlay setMinimumPressDuration:0.001];
    [self addGestureRecognizer:longPressUIemptyOverlay];
    self.userInteractionEnabled = YES;
}

- (void)longPressUIemptyOverlay:(UILongPressGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateBegan) {
        self.emptyOverlayImageView.alpha = 0.4;
    }
    if ( gesture.state == UIGestureRecognizerStateEnded ) {
        self.emptyOverlayImageView.alpha = 1;
        if ([self.delegate respondsToSelector:@selector(emptyOverlayClicked:)]) {
            [self.delegate emptyOverlayClicked:nil];
        }
    }
}

@end

#import <UIKit/UIKit.h>

// --- KHAI BÁO BIẾN TRẠNG THÁI ---
static UIView *mainMenu;
static BOOL isMenuVisible = YES;
static BOOL isAimNeck = NO;
static BOOL isAimHead = NO;
static BOOL isScopeHead = NO;
static BOOL isESPLine = NO;

// --- LỚP VẼ TIA ĐỊNH VỊ (OVERLAY) ---
@interface BinProESP : UIView
@end

@implementation BinProESP
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = NO;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    if (!isESPLine) return;
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1.2);
    CGContextSetStrokeColorWithColor(context, [UIColor cyanColor].CGColor);

    // Điểm bắt đầu từ giữa dưới màn hình (giống như từ nhân vật)
    CGPoint startPoint = CGPointMake(rect.size.width / 2, rect.size.height);
    
    // Giả lập tọa độ địch (Trong thực tế cần lấy từ Offset game)
    CGPoint targets[] = { CGPointMake(rect.size.width*0.2, rect.size.height*0.3), 
                          CGPointMake(rect.size.width*0.8, rect.size.height*0.4) };

    for (int i = 0; i < 2; i++) {
        CGContextMoveToPoint(context, startPoint.x, startPoint.y);
        CGContextAddLineToPoint(context, targets[i].x, targets[i].y);
        CGContextStrokePath(context);
    }
}
@end

static BinProESP *espView;

// --- LỚP GIAO DIỆN MENU VIP AIM BINPRO ---
@interface BinProMenu : UIView
@end

@implementation BinProMenu
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.9];
        self.layer.cornerRadius = 20;
        self.layer.borderWidth = 2;
        self.layer.borderColor = [UIColor orangeColor].CGColor;

        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, frame.size.width, 30)];
        title.text = @"VIP AIM BINPRO";
        title.textColor = [UIColor orangeColor];
        title.textAlignment = NSTextAlignmentCenter;
        title.font = [UIFont boldSystemFontOfSize:18];
        [self addSubview:title];

        [self addSwitch:@"Ghim Cổ (Vàng)" y:50 action:@selector(swNeck:)];
        [self addSwitch:@"Ghim Đầu (Đỏ)" y:90 action:@selector(swHead:)];
        [self addSwitch:@"Mở Ngắm > Đầu" y:130 action:@selector(swScope:)];
        [self addSwitch:@"Hiện Tia (ESP)" y:170 action:@selector(swESP:)];
    }
    return self;
}

- (void)addSwitch:(NSString *)title y:(float)y action:(SEL)sel {
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(15, y, 130, 30)];
    lbl.text = title; lbl.textColor = [UIColor whiteColor];
    lbl.font = [UIFont systemFontOfSize:14];
    [self addSubview:lbl];

    UISwitch *sw = [[UISwitch alloc] initWithFrame:CGRectMake(155, y, 0, 0)];
    sw.onTintColor = [UIColor orangeColor];
    [sw addTarget:self action:sel forControlEvents:UIControlEventValueChanged];
    [self addSubview:sw];
}

- (void)swNeck:(UISwitch *)s { isAimNeck = s.isOn; }
- (void)swHead:(UISwitch *)s { isAimHead = s.isOn; }
- (void)swScope:(UISwitch *)s { isScopeHead = s.isOn; }
- (void)swESP:(UISwitch *)s { isESPLine = s.isOn; [espView setNeedsDisplay]; }
@end

// --- HOOK VÀO GAME ---
%hook UIViewController
- (void)viewDidAppear:(BOOL)animated {
    %orig;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        UIWindow *win = [UIApplication sharedApplication].keyWindow;
        
        espView = [[BinProESP alloc] initWithFrame:win.bounds];
        [win addSubview:espView];

        mainMenu = [[BinProMenu alloc] initWithFrame:CGRectMake(60, 100, 220, 220)];
        mainMenu.hidden = !isMenuVisible;
        [win addSubview:mainMenu];

        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleBinPro:)];
        tap.numberOfTouchesRequired = 3;
        [win addGestureRecognizer:tap];
    });
}

%new
- (void)handleBinPro:(UITapGestureRecognizer *)s {
    if (s.state == UIGestureRecognizerStateEnded) {
        isMenuVisible = !isMenuVisible;
        mainMenu.hidden = !isMenuVisible;
    }
}
%end

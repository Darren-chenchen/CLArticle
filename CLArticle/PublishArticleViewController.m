//
//  PublishArticleViewController.m
//  ymw
//
//  Created by darren on 16/7/1.
//  Copyright © 2016年 yesmywine. All rights reserved.
//

#import "PublishArticleViewController.h"
#import "CLTextView.h"
#import "TZImagePickerController.h"
#import "YMWTextAttachment.h"
#import "PublishArticleTools.h"

@interface PublishArticleViewController ()<UITextFieldDelegate,UITextViewDelegate,UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet CLTextView *textView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIImageView *photoImgView;
@property (weak, nonatomic) IBOutlet UIImageView *rightImgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewYS;

/**textView的内容*/
@property (nonatomic,copy) NSString *textViewContent;
@property (nonatomic,copy) NSString *tempStr;

/**提示信息*/
@property (nonatomic,strong) UIButton *messageBtn;

@property (nonatomic,strong) PublishArticleTools *tools;
/**图片url数组*/
@property (nonatomic,strong) NSMutableArray *upLoadImgArr;
/**存放图片信息的字典*/
@property (nonatomic,strong) NSMutableDictionary *imageDic;
@end

@implementation PublishArticleViewController
/*懒加载**/
- (NSMutableArray *)upLoadImgArr
{
    if (_upLoadImgArr == nil) {
        _upLoadImgArr = [NSMutableArray array];
    }
    return _upLoadImgArr;
}

- (NSMutableDictionary *)imageDic
{
    if (_imageDic == nil) {
        _imageDic = [NSMutableDictionary dictionary];
    }
    return _imageDic;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNav];

    self.textView.placehoder = @"请输入内容...";
    self.textView.font = [UIFont systemFontOfSize:15];
    self.textView.delegate = self;
    self.titleField.delegate = self;
    
    self.photoImgView.userInteractionEnabled = YES;
    self.rightImgView.userInteractionEnabled = YES;

    [self.photoImgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickPhotoImg)]];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *myEncodedObject = [defaults objectForKey:@"myEncodedObjectKey_Article"];
    if (myEncodedObject) {
        self.tools  = (PublishArticleTools *)[NSKeyedUnarchiver unarchiveObjectWithData: myEncodedObject];
    } else {
        self.tools = [PublishArticleTools sharedPublishArticleTools];
    }
    
    // 对数据赋值
    [self assignmentContentData];
}

- (void)assignmentContentData
{
    
    self.imageDic = [NSMutableDictionary dictionaryWithDictionary:self.tools.imgDict];
    self.titleField.text = self.tools.articleTitle;
    self.textView.attributedText = self.tools.attributedText;
    if (self.tools.attributedText.length) {
        self.textView.placehoderLabel.hidden = YES;
    }
    
    NSLog(@"==%@",self.tools.attributedText);
}
- (void)setupNav
{
    UIButton *backButton=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    [backButton addTarget:self action:@selector(clickBackBtn) forControlEvents:UIControlEventTouchUpInside];
    backButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [backButton setTitle:@"返回" forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    UIBarButtonItem *btnItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = btnItem;
    
    self.navigationItem.title  =@"发布文章";
    
    UIButton *publishButton=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    [publishButton addTarget:self action:@selector(rightButtonClick) forControlEvents:UIControlEventTouchUpInside];
    publishButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [publishButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    UIBarButtonItem *btnItem2 = [[UIBarButtonItem alloc] initWithCustomView:publishButton];
    self.navigationItem.rightBarButtonItem = btnItem2;
    [publishButton setTitle:@"发布" forState:UIControlStateNormal];
}

- (void)clickBackBtn
{
    [self.view endEditing:YES];
    // 保存用户已经填写的信息
    [self saveUserInfo];
    
    [self leftBarButtonItemPress];
}

- (void)rightButtonClick
{
    [self.view endEditing:YES];
    NSLog(@"====%@",[self realText]);
    UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提交服务器的样式" message:[self realText] delegate:self cancelButtonTitle:@"好" otherButtonTitles:@"删除草稿",nil];
    alert.tag = 1;
    [alert show];
}
#pragma mark - 保存用户已经填写的信息
- (void)saveUserInfo
{
    self.tools.imgDict = self.imageDic;
    self.tools.articleContent = [self realText];
    self.tools.articleTitle = self.titleField.text;
    
    NSData *myEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:self.tools];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:myEncodedObject forKey:@"myEncodedObjectKey_Article"];
    [defaults synchronize];
}
- (void)leftBarButtonItemPress
{
    UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"文章未完成，是否放弃？" delegate:self cancelButtonTitle:@"是" otherButtonTitles:@"否",nil];
    alert.tag = 0;
    [alert show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0&&alertView.tag == 0) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else if(buttonIndex == 0&&alertView.tag == 1){
        
    } else if(buttonIndex == 1&&alertView.tag == 1){
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults removeObjectForKey:@"myEncodedObjectKey_Article"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self dismissViewControllerAnimated:YES completion:nil];
        });
        
    }else {
    
    }
}
#pragma mark -  调用相册
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
- (void)clickPhotoImg
{
    // 直接调用相册
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:nil];
    
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        [self.view endEditing:YES];
        
        if (self.textView.text.length == 0 && photos.count != 0) {
            self.textView.placehoderLabel.hidden = YES;
        }
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithAttributedString:self.textView.attributedText];

        [self showmessage];
        
        // 图文混排
        for (int i = 0;i < photos.count;i++) {
            UIImage *image = photos[i];
            NSData *data = UIImageJPEGRepresentation(image, 0.5);
            [self.upLoadImgArr addObject:image];
            NSString *imagUrl=[NSString stringWithFormat:@"#http://image%d%@#",i,[self getSaveKey]];
            [self.imageDic setValue:data forKey:imagUrl];
            YMWTextAttachment *att = [[YMWTextAttachment alloc] init];
            att.imgUrl = imagUrl;
            att.image = image;
            att.bounds = CGRectMake(0, 0, self.view.frame.size.width-40, 300);
            NSAttributedString *subtring2 = [NSAttributedString attributedStringWithAttachment:att];
            [string appendAttributedString:subtring2];
            [string appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@"\n"]];
            //修改行间距
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            [paragraphStyle setLineSpacing:5];
            
            [string addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [string length])];
            self.textView.font = [UIFont systemFontOfSize:15];
            
            if (i == photos.count-1) {
                // 全部上传成功了再赋值   模拟请求
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self removeAnimation];
                    [self.messageBtn setTitle:@"图片处理完成" forState:UIControlStateNormal];
                    self.textView.attributedText = string;
                    self.textView.font = [UIFont systemFontOfSize:15];
                });
                
            }
        }
        
    }];
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

#pragma mark - UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWilldismiss:) name:UIKeyboardWillHideNotification object:nil];
    
    return YES;
}
-(void)textViewDidChange:(UITextView *)textView{
    
    // 1.计算TextView的高度，
    CGFloat textViewH = 0;
    CGFloat minHeight = 33;//textView最小的高度
    CGFloat maxHeight = 68;//textView最大的高度
    
    // 获取contentSize的高度
    CGFloat contentHeight = textView.contentSize.height;
    if (contentHeight < minHeight) {
        textViewH = minHeight;
    }else if (contentHeight > maxHeight){
        textViewH = maxHeight;
    }else{
        textViewH = contentHeight;
    }
    
    // 加个动画
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    }];
    
    // 4.记光标回到原位
    [textView setContentOffset:CGPointZero animated:YES];
    [textView scrollRangeToVisible:textView.selectedRange];
}

- (void)keyboardWilldismiss:(NSNotification *)aNotification
{
    self.bottomViewYS.constant = 0;
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)keyboardWillShow:(NSNotification *)aNotification
{
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    self.bottomViewYS.constant = keyboardRect.size.height;
    
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    }];
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range

 replacementText:(NSString *)text {
    
    if ([text isEqualToString:@"\n"]) {
        
        [textView resignFirstResponder];
        
        return NO;
    }
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
#pragma 上传图片部分
-(NSString * )getSaveKey {
    static int a =0;
    NSDate *d = [NSDate date];
    a++;
    return [NSString stringWithFormat:@"/%ld/%ld/%ld/%d%.0f.jpg",(long)[self getYear:d],(long)[self getMonth:d],(long)[self getSecond:d],a,[[NSDate date] timeIntervalSince1970]];
    
}
- (NSInteger)getYear:(NSDate *) date{
    
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
    [formatter setTimeStyle:NSDateFormatterMediumStyle];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSInteger unitFlags = NSYearCalendarUnit;
    NSDateComponents *comps = [calendar components:unitFlags fromDate:date];
    NSInteger year=[comps year];
    return year;
}

- (NSInteger)getMonth:(NSDate *) date{
    
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
    [formatter setTimeStyle:NSDateFormatterMediumStyle];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSInteger unitFlags = NSMonthCalendarUnit;
    NSDateComponents *comps = [calendar components:unitFlags fromDate:date];
    NSInteger month = [comps month];
    return month;
}
- (NSInteger)getSecond:(NSDate *) date{
    
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
    [formatter setTimeStyle:NSDateFormatterMediumStyle];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSInteger unitFlags = NSSecondCalendarUnit;
    NSDateComponents *comps = [calendar components:unitFlags fromDate:date];
    NSInteger sec = [comps second];
    return sec;
}

- (NSString *)realText
{
    // 1.用来拼接所有文字
    NSMutableString *string = [NSMutableString string];
    // 2.遍历富文本里面的所有内容
    [self.textView.attributedText enumerateAttributesInRange:NSMakeRange(0, self.textView.attributedText.length) options:0 usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
        YMWTextAttachment *att = attrs[@"NSAttachment"];
        if (att) { // 如果是带有附件的富文本
            [string appendString:att.imgUrl];
        } else { // 普通的文本
            // 截取range范围的普通文本
            NSString *substr = [self.textView.attributedText attributedSubstringFromRange:range].string;
            [string appendString:substr];
        }
    }];
    return string;
}

- (void)showmessage
{
    // 1.创建按钮
    CGFloat width = 160;
    CGFloat height = 40;
    CGFloat x = (self.view.frame.size.width-width)*0.5;
    CGFloat y = CGRectGetMaxY(self.navigationController.navigationBar.frame)-height-1;
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.layer.cornerRadius = height*0.5;
    self.messageBtn = btn;
    btn.backgroundColor = [UIColor colorWithWhite:0.9 alpha:0.9];
    btn.frame = CGRectMake(x, y, width, height);
    [self.navigationController.view insertSubview:btn belowSubview:self.navigationController.navigationBar];
    // 2.设置按钮文字
    [btn setTitle:@"图片处理中" forState:UIControlStateNormal];
    btn.imageEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
    [btn setImage:[UIImage imageNamed:@"left rotation"] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    btn.userInteractionEnabled = NO;
    [btn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    // 3.执行动画
    [UIView animateWithDuration:1 animations:^{
        btn.transform = CGAffineTransformMakeTranslation(0, height + 20);
    } completion:^(BOOL finished) {
        [self addAnimation];
    }];
}

- (void)addAnimation
{
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0*-1 ];
    rotationAnimation.duration = 0.5;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = MAXFLOAT;
    [self.messageBtn.imageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}
- (void)removeAnimation
{
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.messageBtn.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        [self.messageBtn removeFromSuperview];
        [self.messageBtn.imageView.layer removeAllAnimations];
    }];
}


@end

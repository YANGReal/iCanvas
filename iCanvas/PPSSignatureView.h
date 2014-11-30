#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>


@class PPSSignatureView;
@protocol PPSSignatureViewDelagete <NSObject>

@optional
- (void)signView:(PPSSignatureView *)view signBeganWiithPoint:(CGPoint )point;
- (void)signView:(PPSSignatureView *)view signMovedWithPoint:(CGPoint )point;
- (void)signView:(PPSSignatureView *)view signEndedWithPoint:(CGPoint )point;


@end



@interface PPSSignatureView : GLKView

@property (assign , nonatomic) id<PPSSignatureViewDelagete>delegater;
@property (assign, nonatomic) UIColor *strokeColor;
@property (assign, nonatomic) BOOL hasSignature;
@property (strong, nonatomic) UIImage *signatureImage;
@property (assign , nonatomic) int fontWidth;
- (void)erase;

@end

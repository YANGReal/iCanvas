#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>



@class PPSSignatureView;
@protocol PPSSignatureViewDelageter <NSObject>

@optional
- (void)signView:(PPSSignatureView *)view signBeganWiithPoint:(CGPoint )point;
- (void)signView:(PPSSignatureView *)view signMovedWithPoint:(CGPoint )point;
- (void)signView:(PPSSignatureView *)view signEndedWithPoint:(CGPoint )point;


@end

@interface PPSSignatureView : GLKView

@property (assign, nonatomic) BOOL hasSignature;
@property (strong, nonatomic) UIImage *signatureImage;
@property (assign , nonatomic,readwrite) GLKVector3 color;
@property (assign , nonatomic) int fontWidth;
@property (assign , nonatomic) id<PPSSignatureViewDelageter>delegater;
- (void)erase;

@end

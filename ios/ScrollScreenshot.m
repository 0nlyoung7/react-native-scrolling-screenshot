#import "ScrollScreenshot.h"
#import "RCTConvert.h"
#import "RCTBridge.h"
#import "RCTView.h"
#import "RCTUIManager.h"

@implementation ScrollScreenshot

RCT_EXPORT_MODULE()

@synthesize bridge = _bridge;

- (dispatch_queue_t)methodQueue
{
  return dispatch_get_main_queue();
}


- (void) screenshot:(UIScrollView *)scrollView {
  UIImage* image = nil;
  
  CGFloat totalHeight = scrollView.contentSize.height;
  CGFloat screenHeight = scrollView.bounds.size.height;
  
  NSInteger until = (int)( ceil( totalHeight / screenHeight ) );
  
  CGPoint savedContentOffset = scrollView.contentOffset;
  CGRect savedFrame = scrollView.frame;
  
  UIGraphicsBeginImageContextWithOptions(scrollView.contentSize, YES, 0.0);
  CGContextRef context = UIGraphicsGetCurrentContext();
  {
    scrollView.contentOffset = CGPointZero;
    scrollView.frame = CGRectMake(0, 0, scrollView.contentSize.width, scrollView.contentSize.height);
    for (NSInteger index = 0; index < until; index++){
      
      CGFloat offsetVirtical = ((CGFloat)index ) * screenHeight;
      [scrollView setContentOffset:CGPointMake(0, offsetVirtical ) animated:YES];
      [NSThread sleepForTimeInterval:0.1];
    }
    
    [scrollView.layer renderInContext: context];
    image = UIGraphicsGetImageFromCurrentImageContext();
    
    [scrollView setContentOffset:savedContentOffset animated:YES];
    [NSThread sleepForTimeInterval:0.1];
    scrollView.frame = savedFrame;
  }
  UIGraphicsEndImageContext();
  
  if (image != nil) {
    //[UIImagePNGRepresentation(image) writeToFile: @"/tmp/test.png" atomically: YES];
    UIImageWriteToSavedPhotosAlbum(image,
                                   self, // send the message to 'self' when calling the callback
                                   @selector(thisImage:hasBeenSavedInPhotoAlbumWithError:usingContextInfo:), // the selector to tell the method to call on completion
                                   NULL); // you generally won't need a contextInfo here
  }
}

- (void)thisImage:(UIImage *)image hasBeenSavedInPhotoAlbumWithError:(NSError *)error usingContextInfo:(void*)ctxInfo
{
  if (error) {
    NSLog( @"error" );
  } else {
    NSLog( @"save success" );
    if (image !=NULL){
      image=nil;
    }
    if(ctxInfo !=NULL){
      ctxInfo=nil;
    }
  }
}

- (UIScrollView *) findUIScrollView:(UIView *) view{
  UIScrollView *result = nil;
  
  if ([view isKindOfClass:[UIScrollView class]]) {
    result = (UIScrollView *)view;
  } else if ([view isKindOfClass:[UIWebView class]]){
    result = ((UIWebView *)view).scrollView;
  }
  
  if( result != nil ){
    return result;
  }
  
  for (UIView *subview in view.subviews){
    result = [self findUIScrollView:subview];
    if( result != nil ){
      break;
    }
  }
  
  return result;
}

RCT_EXPORT_METHOD(takeScreenshot:(nonnull NSNumber *)reactTag
                  callback:(RCTResponseSenderBlock)callback)
{
  UIView *view = [self.bridge.uiManager viewForReactTag:reactTag];
  UIScrollView *scrollView = [self findUIScrollView:view];
  if( scrollView != nil ){
     [self screenshot:scrollView];
  }
}

@end
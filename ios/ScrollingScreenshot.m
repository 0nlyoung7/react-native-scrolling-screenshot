#import "ScrollingScreenshot.h"
#import "RCTConvert.h"
#import "RCTBridge.h"
#import "RCTView.h"
#import "RCTUIManager.h"
#import  <QuartzCore/QuartzCore.h>

@implementation ScrollingScreenshot

RCT_EXPORT_MODULE()

@synthesize bridge = _bridge;

- (dispatch_queue_t)methodQueue
{
  return dispatch_get_main_queue();
}

#define IS_RETINA ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] && ([UIScreen mainScreen].scale >= 2.0))


- (void) screenshotForIOS9:(UIScrollView *)scrollView {
  UIImage* image = nil;
  
  CGFloat totalHeight = scrollView.contentSize.height;
  CGFloat screenHeight = scrollView.bounds.size.height;
  
  NSInteger until = (int)( ceil( totalHeight / screenHeight ) );
  
  CGPoint savedContentOffset = scrollView.contentOffset;
  CGRect savedFrame = scrollView.frame;
  
  if( IS_RETINA ){
    UIGraphicsBeginImageContextWithOptions(scrollView.contentSize, scrollView.opaque, 0.0);
  } else {
    UIGraphicsBeginImageContext(scrollView.contentSize);
  }
  
  {
    scrollView.contentOffset = CGPointZero;
    scrollView.frame = CGRectMake(0, 0, scrollView.contentSize.width, scrollView.contentSize.height);
    for (NSInteger index = 0; index < until; index++){
      CGFloat offsetVirtical = ((CGFloat)index ) * screenHeight;
      [scrollView setContentOffset:CGPointMake(0, offsetVirtical ) animated:YES];
      [NSThread sleepForTimeInterval:0.2];
    }
    
    [scrollView.layer renderInContext: UIGraphicsGetCurrentContext()];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
  }
  
  [scrollView setContentOffset:savedContentOffset animated:YES];
  [NSThread sleepForTimeInterval:0.2];
  scrollView.frame = savedFrame;
  
  if (image != nil) {
    [UIImagePNGRepresentation(image) writeToFile: @"temp.jpg" atomically: YES];
    UIImageWriteToSavedPhotosAlbum(image,
                                   self, // send the message to 'self' when calling the callback
                                   @selector(thisImage:hasBeenSavedInPhotoAlbumWithError:usingContextInfo:), // the selector to tell the method to call on completion
                                   NULL); // you generally won't need a contextInfo here
  }
}

- (void) screenshot:(UIScrollView *)scrollView {
  
  CGFloat contentHeight = scrollView.contentSize.height;
  CGFloat screenHeight = scrollView.bounds.size.height;
  
  NSInteger until = (int)( ceil( contentHeight / screenHeight ) );
  
  CGPoint savedContentOffset = scrollView.contentOffset;
  CGRect savedFrame = scrollView.frame;
  
  @autoreleasepool {
    
    //NSMutableArray *imageList =[[NSMutableArray alloc] init];
    NSMutableArray *imageList = [NSMutableArray arrayWithCapacity:until];
    UIImage *firstImage;
    
    scrollView.contentOffset = CGPointZero;
    for (NSInteger index = 0; index < until; index++){
      
      CGFloat offsetVirtical = ((CGFloat)index ) * screenHeight;
      [scrollView setContentOffset:CGPointMake(0, offsetVirtical ) animated:NO];
      
      UIGraphicsBeginImageContextWithOptions(scrollView.contentSize, NO, 0.0);
      CGContextTranslateCTM(UIGraphicsGetCurrentContext(), 0, -offsetVirtical);
      [scrollView.layer renderInContext: UIGraphicsGetCurrentContext()];
      UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
      UIGraphicsEndImageContext();
      
      if (image != nil) {
        CGImageRef imageRef = [image CGImage];
        CGImageRef tempImage = CGImageCreateWithImageInRect(imageRef, CGRectMake(0,0,scrollView.frame.size.width*image.scale, scrollView.frame.size.height*image.scale));
        image = [UIImage imageWithCGImage:tempImage];
        CGImageRelease(tempImage);
        
        if( index == 0 ){
          firstImage = image;
        }
        
        [imageList addObject:image];
        [NSThread sleepForTimeInterval:0.2];
      }
    }
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(scrollView.contentSize.width*[UIScreen mainScreen].scale, scrollView.contentSize.height*[UIScreen mainScreen].scale) , NO, firstImage.scale);
    NSInteger index = 0;
    for (UIImage __weak *image in imageList)
    {
      [image drawInRect:CGRectMake(0, (image.size.height*index),image.size.width, image.size.height)];
      index++;
    }
    
    UIImage *finalImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath =  [paths objectAtIndex:0];
    
    NSString *filePath = [basePath stringByAppendingString:@"/temp.jpg"];
    NSError *error;
    
    NSData *data = UIImageJPEGRepresentation(finalImage, 0.5);
    
    BOOL writeSucceeded = [data writeToFile:filePath options:0 error:&error];
    if (!writeSucceeded) {
      NSLog( @"error occured to save in document" );
    } else {
      NSLog( @"saved in document %@", filePath  );
      finalImage = nil;
      imageList = nil;
      
      UIImage *image = [UIImage imageWithContentsOfFile:filePath];
      UIImageWriteToSavedPhotosAlbum(image,
                                     self, // send the message to 'self' when calling the callback
                                     @selector(thisImage:hasBeenSavedInPhotoAlbumWithError:usingContextInfo:), // the selector to tell the method to call on completion
                                     NULL); // you generally won't need a contextInfo here
    }
  }
  
  [scrollView setContentOffset:savedContentOffset animated:NO];
  scrollView.frame = savedFrame;
}

- (void)thisImage:(UIImage *)image hasBeenSavedInPhotoAlbumWithError:(NSError *)error usingContextInfo:(void*)ctxInfo
{
  if (error) {
    NSLog( @"error occured to save in album" );
  } else {
    NSLog( @"saved in album" );
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
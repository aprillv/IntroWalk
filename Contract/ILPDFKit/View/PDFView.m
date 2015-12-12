// PDFView.m
//
// Copyright (c) 2015 Iwe Labs
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import <QuartzCore/QuartzCore.h>
#import "PDFFormButtonField.h"
#import "PDFFormTextField.h"
#import "PDF.h"
#import "SignatureView.h"

@interface PDFView(Delegates) <UIScrollViewDelegate,UIGestureRecognizerDelegate,UIWebViewDelegate>
@end

@interface PDFView(Private)
- (void)fadeInWidgetAnnotations;
@end

@implementation PDFView {
    BOOL _canvasLoaded;
    UIActivityIndicatorView *spinner;
    NSArray *nwidgetAnnotationViews;
}

#pragma mark - PDFView

- (instancetype)initWithFrame:(CGRect)frame dataOrPath:(id)dataOrPath additionViews:(NSArray*)widgetAnnotationViews {
    self = [super initWithFrame:frame];
    if (self) {
        CGRect contentFrame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        _pdfView = [[UIWebView alloc] initWithFrame:contentFrame];
//        _pdfView.backgroundColor = [UIColor whiteColor];
         [self addSubview: _pdfView];
        
        
        _pdfView.scalesPageToFit = YES;
        _pdfView.scrollView.delegate = self;
        _pdfView.scrollView.bouncesZoom = NO;
        _pdfView.delegate = self;
        _pdfView.autoresizingMask =  UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin;
         self.autoresizingMask =  UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin;
//        self.backgroundColor = [UIColor greenColor];
//        [self addSubview: _pdfView];
//        _pdfView.backgroundColor = [UIColor redColor];
        [_pdfView.scrollView setZoomScale:1];
        [_pdfView.scrollView setContentOffset:CGPointZero];
        //This allows us to prevent the keyboard from obscuring text fields near the botton of the document.
        [_pdfView.scrollView setContentInset: UIEdgeInsetsMake(0, 0, 0, 0)];
        nwidgetAnnotationViews = widgetAnnotationViews;
        
        spinner = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
        spinner.hidesWhenStopped = YES;
        spinner.center = _pdfView.center;
        [_pdfView addSubview:spinner];
        
        if ([dataOrPath isKindOfClass:[NSString class]]) {
            [spinner startAnimating];
            [_pdfView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:dataOrPath]]];
        } else if([dataOrPath isKindOfClass:[NSData class]]) {
            [spinner startAnimating];
            [_pdfView loadData:dataOrPath MIMEType:@"application/pdf" textEncodingName:@"NSASCIIStringEncoding" baseURL:nil];
        }

        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:nil action:NULL];
        [self addGestureRecognizer:tapGestureRecognizer];
        tapGestureRecognizer.delegate = self;
    }
    return self;
}

- (void)addPDFWidgetAnnotationView:(PDFWidgetAnnotationView *)viewToAdd {
    [_pdfWidgetAnnotationViews addObject:viewToAdd];
    
    [_pdfView.scrollView addSubview:viewToAdd];
}

- (void)removePDFWidgetAnnotationView:(PDFWidgetAnnotationView *)viewToRemove {
    [viewToRemove removeFromSuperview];
    [_pdfWidgetAnnotationViews removeObject:viewToRemove];
}

- (void)setWidgetAnnotationViews:(NSArray *)additionViews {
    for (UIView *v in _pdfWidgetAnnotationViews) [v removeFromSuperview];
    _pdfWidgetAnnotationViews = nil;
    _pdfWidgetAnnotationViews = [[NSMutableArray alloc] initWithArray:additionViews];
    for (PDFWidgetAnnotationView *element in _pdfWidgetAnnotationViews) {
        element.alpha = 0;
        element.parentView = self;
        [_pdfView.scrollView addSubview:element];
        if ([element isKindOfClass:[PDFFormButtonField class]]) {
            [(PDFFormButtonField*)element setButtonSuperview];
        }
    }
    if (_canvasLoaded) [self fadeInWidgetAnnotations];
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [spinner stopAnimating];
    
    _pdfWidgetAnnotationViews = [[NSMutableArray alloc] initWithArray:nwidgetAnnotationViews];
    for (PDFWidgetAnnotationView *element in _pdfWidgetAnnotationViews) {
        element.alpha = 0;
        element.parentView = self;
        [_pdfView.scrollView addSubview:element];
        if ([element isKindOfClass:[PDFFormButtonField class]]) {
            [(PDFFormButtonField*)element setButtonSuperview];
        }
        if ([element isKindOfClass:[PDFFormTextField class]]) {
            [(PDFFormTextField*)element setValue:element.value];
        }
    }
    
    _canvasLoaded = YES;
    if (_pdfWidgetAnnotationViews) {
        [self fadeInWidgetAnnotations];
    }
}

//- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;
//- (void)webViewDidStartLoad:(UIWebView *)webView;
//- (void)webViewDidFinishLoad:(UIWebView *)webView;
//- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error;


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    CGFloat scale = scrollView.zoomScale;
//    if (scale < 1.0f) scale = 1.0f;
    for (PDFWidgetAnnotationView *element in _pdfWidgetAnnotationViews) {
        [element updateWithZoom:scale];
    }
}
//- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
//    for (UIView *im in scrollView.subviews) {
//        if ([im isKindOfClass:[PDFFormImageView class]]){
//            return im;
//        }
//    }
//    return NULL;
//}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (_activeWidgetAnnotationView == nil) return NO;
    if (!CGRectContainsPoint(_activeWidgetAnnotationView.frame, [touch locationInView:_pdfView.scrollView])) {
        if ([_activeWidgetAnnotationView isKindOfClass:[UITextView class]]) {
            [_activeWidgetAnnotationView resignFirstResponder];
        } else {
            [_activeWidgetAnnotationView resign];
        }
    }
    return NO;
}

#pragma mark - Private

- (void)fadeInWidgetAnnotations {
    [UIView animateWithDuration:0.5 delay:0.2 options:0 animations:^{
        for (UIView *v in _pdfWidgetAnnotationViews) v.alpha = 1;
    } completion:^(BOOL finished) {}];
}


@end





//
//  ViewController.m
//  W3D1-ScrollPager
//
//  Created by steve on 2017-05-14.
//  Copyright © 2017 steve. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic) NSArray <UIImageView *>*imageViews;
@property (nonatomic) UIPageControl *control;
@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [self createImageViews];
  [self addImageViews];
  [self createPageControl];
  
  self.scrollView.pagingEnabled = YES;
  self.scrollView.delegate = self;
  
  // Uncomment only 1 at a time
  [self setupScrollviewUsingAnchors];
  //  [self setupScrollviewUsingFrames];
  //  [self setupScrollviewUsingConstraints];
  //  [self setupScrollViewUsingVFL];
}

- (void)createImageViews {
  UIImageView *iv1 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"toronto.jpg"]];
  iv1.contentMode = UIViewContentModeScaleAspectFill;
  iv1.clipsToBounds = YES;
  UIImageView *iv2 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"montreal.jpg"]];
  iv2.contentMode = UIViewContentModeScaleAspectFill;
  iv2.clipsToBounds = YES;
  UIImageView *iv3 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"chicago.jpg"]];
  iv3.contentMode = UIViewContentModeScaleAspectFill;
  iv3.clipsToBounds = YES;
  self.imageViews = @[iv1, iv2, iv3];
}

- (void)addImageViews {
  for (UIImageView *iv in self.imageViews) {
    [self.scrollView addSubview:iv];
  }
}

#pragma mark - Page Control

- (void)createPageControl {
  self.control = [[UIPageControl alloc]init];
  self.control.numberOfPages = 3;
  self.control.currentPage = 0;
  self.control.backgroundColor = [UIColor blackColor];
  self.control.alpha = 0.5;
  [self.view addSubview:self.control];
  self.control.layer.zPosition = 10;
  [self.control sizeToFit];
  self.control.center = CGPointMake(CGRectGetMidX(self.view.frame) , CGRectGetHeight(self.view.frame) - self.control.bounds.size.height/2 );
}


#pragma mark - Anchors

- (void)setupScrollviewUsingAnchors {
  [self translatesAutoresizingMasksToConstraints];
  CGFloat width = self.view.bounds.size.width;
  for (UIImageView *iv in self.imageViews) {
    // add top constaint
    [iv.topAnchor constraintEqualToAnchor:self.view.topAnchor].active = YES;
    // add bottom constraint
    [iv.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = YES;
    // set width
    [iv.widthAnchor constraintEqualToConstant:width].active = YES;
  }
  // line them up
  [self.imageViews[0].leadingAnchor constraintEqualToAnchor:self.scrollView.leadingAnchor].active = YES;
  [self.imageViews[1].leadingAnchor constraintEqualToAnchor:self.imageViews[0].trailingAnchor].active = YES;
  [self.imageViews[2].leadingAnchor constraintEqualToAnchor:self.imageViews[1].trailingAnchor].active = YES;
  [self.imageViews[2].trailingAnchor constraintEqualToAnchor:self.scrollView.trailingAnchor].active = YES;
}


#pragma mark - Turn off Auto Resizing Masks

- (void)translatesAutoresizingMasksToConstraints {
  for (UIImageView *iv in self.imageViews) {
    iv.translatesAutoresizingMaskIntoConstraints = NO;
  }
}


#pragma mark - LayoutConstraints

- (void)setupScrollviewUsingConstraints {
  [self translatesAutoresizingMasksToConstraints];
  
  NSMutableArray<NSLayoutConstraint *>*constraints = [NSMutableArray array];
  
  // setup top constraint
  
  for (UIImageView *iv in self.imageViews) {
    // top
    [constraints addObject:[NSLayoutConstraint constraintWithItem:iv attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    // bottom
    [constraints addObject:[NSLayoutConstraint constraintWithItem:iv attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    // width
    [constraints addObject:[NSLayoutConstraint constraintWithItem:iv attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.view.frame.size.width]];
  }
  // line up
  [constraints addObject:[NSLayoutConstraint constraintWithItem:self.imageViews[0] attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0]];
  [constraints addObject:[NSLayoutConstraint constraintWithItem:self.imageViews[1] attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.imageViews[0] attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0]];
  [constraints addObject:[NSLayoutConstraint constraintWithItem:self.imageViews[2] attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.imageViews[1] attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0]];
  [constraints addObject:[NSLayoutConstraint constraintWithItem:self.imageViews[2] attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0]];
  
  [NSLayoutConstraint activateConstraints:constraints];
}


#pragma mark - Frames

- (void)setupScrollviewUsingFrames {
  CGFloat width = self.view.frame.size.width;
  CGFloat height = self.view.frame.size.height;
  for (NSInteger i = 0; i < self.imageViews.count; ++i) {
    UIImageView *iv = self.imageViews[i];
    iv.frame = CGRectMake(width * (CGFloat)i, 0, width, height);
  }
  self.scrollView.contentSize = CGSizeMake(width * 3, height);
}


#pragma mark - VFL

- (void)setupScrollViewUsingVFL {
  [self translatesAutoresizingMasksToConstraints];
  NSDictionary *views = @{@"view": self.view, @"iv1": self.imageViews[0], @"iv2": self.imageViews[1], @"iv3": self.imageViews[2], @"scrollview": self.scrollView};
  NSDictionary *metrics = @{@"width": @(self.view.frame.size.width), @"height": @(self.view.frame.size.height)};
  
  NSString *h1 = @"V:|[iv1(==height)]|";
  NSString *h2 = @"V:|[iv2(==height)]|";
  NSString *h3 = @"V:|[iv3(==height)]|";
  NSString *v1 = @"H:|[iv1(==width)][iv2(==width)][iv3(==width)]|";
  NSArray *c1 = [NSLayoutConstraint constraintsWithVisualFormat:h1 options:0 metrics:metrics views:views];
  NSArray *c2 = [NSLayoutConstraint constraintsWithVisualFormat:h2 options:0 metrics:metrics views:views];
  NSArray *c3 = [NSLayoutConstraint constraintsWithVisualFormat:h3 options:0 metrics:metrics views:views];
  NSArray *c4 = [NSLayoutConstraint constraintsWithVisualFormat:v1 options:0 metrics:metrics views:views];
  [NSLayoutConstraint activateConstraints:c1];
  [NSLayoutConstraint activateConstraints:c2];
  [NSLayoutConstraint activateConstraints:c3];
  [NSLayoutConstraint activateConstraints:c4];
}

#pragma mark - ScrollView Delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
  // Old hard coded solution
  /*
   CGPoint offset = scrollView.contentOffset;
   NSInteger maxX = (NSInteger)CGRectGetMaxX(self.view.frame);
   if (offset.x == 0) {
   self.control.currentPage = 0;
   return;
   }
   if (offset.x == maxX) {
   self.control.currentPage = 1;
   return;
   }
   self.control.currentPage = 2;
   */
  CGFloat maxX = CGRectGetMaxX(self.view.bounds);
  CGFloat offset = self.scrollView.contentOffset.x;
  NSInteger pageNumber = (NSInteger)(offset / maxX);
  self.control.currentPage = pageNumber;
  
}

@end









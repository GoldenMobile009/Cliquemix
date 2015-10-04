//
//  DraggableView.m
//  testing swiping
//
//  Created by Richard Kim on 5/21/14.
//  Copyright (c) 2014 Richard Kim. All rights reserved.
//
//  @cwRichardKim for updates and requests

#define ACTION_MARGIN 120 //%%% distance from center where the action applies. Higher = swipe further in order for the action to be called
#define SCALE_STRENGTH 4 //%%% how quickly the card shrinks. Higher = slower shrinking
#define SCALE_MAX .93 //%%% upper bar for how much the card shrinks. Higher = shrinks less
#define ROTATION_MAX 1 //%%% the maximum rotation allowed in radians.  Higher = card can keep rotating longer
#define ROTATION_STRENGTH 320 //%%% strength of rotation. Higher = weaker rotation
#define ROTATION_ANGLE M_PI/8 //%%% Higher = stronger rotation angle


#import "DraggableView.h"

@implementation DraggableView {
    CGFloat xFromCenter;
    CGFloat yFromCenter;
}

//delegate is instance of ViewController
@synthesize delegate;

@synthesize panGestureRecognizer;
@synthesize users;
@synthesize overlayView;

- (id)initWithFrame:(CGRect)frame users:(NSArray *)usrs groupName:(NSString *)grpNm fromChat:(BOOL)fromChat
{
    self = [super initWithFrame:frame];
    if (self) {
        self.users = usrs;
        self.groupName = grpNm;
        self.backgroundColor = [UIColor whiteColor];
        [self setupView];
        
        if (!fromChat) {
            panGestureRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(beingDragged:)];
            [self addGestureRecognizer:panGestureRecognizer];
        }
        
//        overlayView = [[OverlayView alloc]initWithFrame:CGRectMake(self.frame.size.width/2-100, 0, 100, 100)];
//        overlayView.alpha = 0;
//
//        [self addSubview:overlayView];
    }
    return self;
}

-(void)setupView
{
    for (int i = 0; i<[users count]; i++) {
        Profiles *profile = [[ParserEngine sharedInstance] getProfileWithID:[users objectAtIndex:i]];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:[self frameForButton:i]];
        button.layer.cornerRadius = 35;
        button.layer.masksToBounds = YES;
        button.tag = [profile.fbId integerValue];
        [button addTarget:self action:@selector(onUserButton:) forControlEvents:UIControlEventTouchUpInside];
        button.imageView.contentMode = UIViewContentModeScaleAspectFill;
        button.imageView.clipsToBounds = YES;
        [button sd_setImageWithURL:[NSURL URLWithString:profile.profilePic] forState:UIControlStateNormal];
        [self addSubview:button];
    }

    self.layer.cornerRadius = 4;
    self.layer.shadowRadius = 3;
    self.layer.shadowOpacity = 0.2;
    self.layer.shadowOffset = CGSizeMake(1, 1);
}
-(void)onUserButton:(id)sender{
    UIButton *button = (UIButton *)sender;
    Profiles *profile = [[ParserEngine sharedInstance] getProfileWithID:[NSString stringWithFormat:@"%ld",button.tag]];    
    if ([[self delegate] respondsToSelector:@selector(onUserButtonClick:)]) {
        [[self delegate] onUserButtonClick:profile];
    }
}
-(CGRect)frameForButton:(int)tag{
    switch (tag) {
        case 0:
            return CGRectMake(60, 40, 70, 70);
            break;
        case 1:
            return CGRectMake(self.frame.size.width - 130, 40, 70, 70);
            break;
        case 2:
            return CGRectMake(20, 120, 70, 70);
            break;
        case 3:
            return CGRectMake(self.frame.size.width - 90, 120, 70, 70);
            break;
        case 4:
            return CGRectMake(self.frame.size.width/2.75, 190, 70, 70);
            break;

        default:
            break;
    }
    return CGRectMake(self.frame.size.width/2.6, 30, 70, 70);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

//%%% called when you move your finger across the screen.
// called many times a second
-(void)beingDragged:(UIPanGestureRecognizer *)gestureRecognizer
{
    //%%% this extracts the coordinate data from your swipe movement. (i.e. How much did you move?)
    xFromCenter = [gestureRecognizer translationInView:self].x; //%%% positive for right swipe, negative for left
    yFromCenter = [gestureRecognizer translationInView:self].y; //%%% positive for up, negative for down
    
    //%%% checks what state the gesture is in. (are you just starting, letting go, or in the middle of a swipe?)
    switch (gestureRecognizer.state) {
            //%%% just started swiping
        case UIGestureRecognizerStateBegan:{
            self.originalPoint = self.center;
            break;
        };
            //%%% in the middle of a swipe
        case UIGestureRecognizerStateChanged:{
            //%%% dictates rotation (see ROTATION_MAX and ROTATION_STRENGTH for details)
            CGFloat rotationStrength = MIN(xFromCenter / ROTATION_STRENGTH, ROTATION_MAX);
            
            //%%% degree change in radians
            CGFloat rotationAngel = (CGFloat) (ROTATION_ANGLE * rotationStrength);
            
            //%%% amount the height changes when you move the card up to a certain point
            CGFloat scale = MAX(1 - fabsf(rotationStrength) / SCALE_STRENGTH, SCALE_MAX);
            
            //%%% move the object's center by center + gesture coordinate
            self.center = CGPointMake(self.originalPoint.x + xFromCenter, self.originalPoint.y + yFromCenter);
            
            //%%% rotate by certain amount
            CGAffineTransform transform = CGAffineTransformMakeRotation(rotationAngel);
            
            //%%% scale by certain amount
            CGAffineTransform scaleTransform = CGAffineTransformScale(transform, scale, scale);
            
            //%%% apply transformations
            self.transform = scaleTransform;
            [self updateOverlay:xFromCenter];
            
            break;
        };
            //%%% let go of the card
        case UIGestureRecognizerStateEnded: {
            [self afterSwipeAction];
            break;
        };
        case UIGestureRecognizerStatePossible:break;
        case UIGestureRecognizerStateCancelled:break;
        case UIGestureRecognizerStateFailed:break;
    }
}

//%%% checks to see if you are moving right or left and applies the correct overlay image
-(void)updateOverlay:(CGFloat)distance
{
    if (distance > 0) {
        overlayView.mode = GGOverlayViewModeRight;
    } else {
        overlayView.mode = GGOverlayViewModeLeft;
    }
    
    overlayView.alpha = MIN(fabsf(distance)/100, 0.4);
}

//%%% called when the card is let go
- (void)afterSwipeAction
{
    if (xFromCenter > ACTION_MARGIN) {
        [self rightAction];
    } else if (xFromCenter < -ACTION_MARGIN) {
        [self leftAction];
    } else { //%%% resets the card
        [UIView animateWithDuration:0.3
                         animations:^{
                             self.center = self.originalPoint;
                             self.transform = CGAffineTransformMakeRotation(0);
                             overlayView.alpha = 0;
                         }];
    }
}

//%%% called when a swipe exceeds the ACTION_MARGIN to the right
-(void)rightAction
{
    CGPoint finishPoint = CGPointMake(500, 2*yFromCenter +self.originalPoint.y);
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.center = finishPoint;
                     }completion:^(BOOL complete){
                         [self removeFromSuperview];
                     }];
    
    [delegate cardSwipedRight:self swiped:YES];
}

//%%% called when a swip exceeds the ACTION_MARGIN to the left
-(void)leftAction
{
    CGPoint finishPoint = CGPointMake(-500, 2*yFromCenter +self.originalPoint.y);
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.center = finishPoint;
                     }completion:^(BOOL complete){
                         [self removeFromSuperview];
                     }];
    
    [delegate cardSwipedLeft:self swiped:YES];
    
}

-(void)rightClickAction
{
    CGPoint finishPoint = CGPointMake(600, self.center.y);
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.center = finishPoint;
                         self.transform = CGAffineTransformMakeRotation(1);
                     }completion:^(BOOL complete){
                         [self removeFromSuperview];
                     }];
    
    [delegate cardSwipedRight:self swiped:NO];
}

-(void)leftClickAction
{
    CGPoint finishPoint = CGPointMake(-600, self.center.y);
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.center = finishPoint;
                         self.transform = CGAffineTransformMakeRotation(-1);
                     }completion:^(BOOL complete){
                         [self removeFromSuperview];
                     }];
    
    [delegate cardSwipedLeft:self swiped:NO];
}

@end

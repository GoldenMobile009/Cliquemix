//
//  DraggableViewBackground.m
//  testing swiping
//
//  Created by Richard Kim on 8/23/14.
//  Copyright (c) 2014 Richard Kim. All rights reserved.
//

#import "DraggableViewBackground.h"

@implementation DraggableViewBackground{
    NSInteger cardsLoadedIndex; //%%% the index of the card you have loaded into the loadedCards array last
    NSMutableArray *loadedCards; //%%% the array of card loaded (change max_buffer_size to increase or decrease the number of cards this holds)
    
    UIButton* menuButton;
    UIButton* messageButton;
    UIButton* checkButton;
    UIButton* xButton;
}
//this makes it so only two cards are loaded at a time to
//avoid performance and memory costs
static const int MAX_BUFFER_SIZE = 2; //%%% max number of cards loaded at any given time, must be greater than 1
static const float CARD_HEIGHT = 300; //%%% height of the draggable card
static const float CARD_WIDTH = 290; //%%% width of the draggable card

@synthesize allCards;//%%% all the cards

- (id)initWithFrame:(CGRect)frame groups:(NSArray *)groups currentGroup:(Groups *)group viewController:(UIViewController *)vc fromChat:(BOOL)fromChat
{
    self = [super initWithFrame:frame];
    if (self) {
        [super layoutSubviews];
        self.groups = groups;
        loadedCards = [[NSMutableArray alloc] init];
        allCards = [[NSMutableArray alloc] init];
        cardsLoadedIndex = 0;
        self.viewController = vc;
        self.currentGroup = group;
        self.myGroup = [GroupPost sharedInstance];
        self.fromChat = fromChat;
        [self setupView];
        [self loadCards];
    }
    return self;
}

//%%% sets up the extra buttons on the screen
-(void)setupView
{
    //#warning customize all of this.  These are just place holders to make it look pretty
    self.backgroundColor = [UIColor colorWithRed:.92 green:.93 blue:.95 alpha:1]; //the gray background colors
    if (!self.fromChat) {
        menuButton = [[UIButton alloc]initWithFrame:CGRectMake(17, 34, 22, 15)];
        [menuButton setImage:[UIImage imageNamed:@"menuButton"] forState:UIControlStateNormal];
        messageButton = [[UIButton alloc]initWithFrame:CGRectMake(284, 34, 18, 18)];
        [messageButton setImage:[UIImage imageNamed:@"messageButton"] forState:UIControlStateNormal];
        xButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [xButton setFrame:CGRectMake(40, CARD_HEIGHT + 50, 100, 108)];
        [xButton setImage:[UIImage imageNamed:@"xButton"] forState:UIControlStateNormal];
        [xButton addTarget:self action:@selector(swipeLeft) forControlEvents:UIControlEventTouchUpInside];
        checkButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [checkButton setFrame:CGRectMake(180, xButton.frame.origin.y, xButton.frame.size.width, xButton.frame.size.height)];
        [checkButton setImage:[UIImage imageNamed:@"checkButton"] forState:UIControlStateNormal];
        [checkButton addTarget:self action:@selector(swipeRight) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:menuButton];
        [self addSubview:messageButton];
        [self addSubview:xButton];
        [self addSubview:checkButton];
    }
}
-(void)onUserButtonClick:(Profiles *)user{
    if ([user.images count] != 0) {
        FVGalleryView *galleryView = [[FVGalleryView alloc]initWithFrame:self.viewController.view.bounds profile:user];
        [self.viewController.view addSubview:galleryView];
    }
    else{
        UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"" message:@"This user doesn't have photos." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [av show];
    }
}
//#warning include own card customization here!
//%%% creates a card and returns it.  This should be customized to fit your needs.
// use "index" to indicate where the information should be pulled.  If this doesn't apply to you, feel free
// to get rid of it (eg: if you are building cards from data from the internet)
-(DraggableView *)createDraggableViewWithDataAtIndex:(NSInteger)index
{
    Groups *group = [self.groups objectAtIndex:index];
    [self performSelectorOnMainThread:@selector(groupName) withObject:self waitUntilDone:NO];
    
    DraggableView *draggableView = [[DraggableView alloc]initWithFrame:CGRectMake((self.frame.size.width - CARD_WIDTH)/2, 40, CARD_WIDTH, CARD_HEIGHT) users:group.users groupName:group.groupName fromChat:self.fromChat];
    if (self.fromChat) {
        draggableView.backgroundColor = [UIColor clearColor];
    }
    draggableView.panGestureRecognizer = nil;
    draggableView.delegate = self;
    return draggableView;
}

//%%% loads all the cards and puts the first x in the "loaded cards" array
-(void)loadCards
{
    if([self.groups count] > 0) {
        NSInteger numLoadedCardsCap =(([self.groups count] > MAX_BUFFER_SIZE)?MAX_BUFFER_SIZE:[self.groups count]);
        //%%% if the buffer size is greater than the data size, there will be an array error, so this makes sure that doesn't happen
        
        //%%% loops through the exampleCardsLabels array to create a card for each label.  This should be customized by removing "exampleCardLabels" with your own array of data
        for (int i = 0; i<[self.groups count]; i++) {
            DraggableView* newCard = [self createDraggableViewWithDataAtIndex:i];
            [allCards addObject:newCard];
            
            if (i<numLoadedCardsCap) {
                //%%% adds a small number of cards to be loaded
                [loadedCards addObject:newCard];
            }
        }
        //%%% displays the small number of loaded cards dictated by MAX_BUFFER_SIZE so that not all the cards
        // are showing at once and clogging a ton of data
        for (int i = 0; i<[loadedCards count]; i++) {
            if (i>0) {
                [self insertSubview:[loadedCards objectAtIndex:i] belowSubview:[loadedCards objectAtIndex:i-1]];
            } else {
                [self addSubview:[loadedCards objectAtIndex:i]];
            }
            cardsLoadedIndex++; //%%% we loaded a card into loaded cards, so we have to increment
        }
    }
}

//#warning include own action here!
//%%% action called when the card goes to the left.
// This should be customized with your own action
-(void)cardSwipedLeft:(UIView *)card swiped:(BOOL)swiped;
{
    //do whatever you want with the card that was swiped
    //    DraggableView *c = (DraggableView *)card;
    Groups *group = [self.groups objectAtIndex:self.indexOfArray];
    self.indexOfArray++;
    if (!swiped) {
        [self.myGroup actionOnGroup:@"dislike.php" userGroupID:self.currentGroup.gid actionGroupID:group.gid callWithSuccess:nil errorCallback:nil];
    }
    [self groupName];
    
    [loadedCards removeObjectAtIndex:0]; //%%% card was swiped, so it's no longer a "loaded card"
    
    if (cardsLoadedIndex < [allCards count]) { //%%% if we haven't reached the end of all cards, put another into the loaded cards
        [loadedCards addObject:[allCards objectAtIndex:cardsLoadedIndex]];
        cardsLoadedIndex++;//%%% loaded a card, so have to increment count
        [self insertSubview:[loadedCards objectAtIndex:(MAX_BUFFER_SIZE-1)] belowSubview:[loadedCards objectAtIndex:(MAX_BUFFER_SIZE-2)]];
    }
    [self performSelector:@selector(backToDiscovery) withObject:self afterDelay:1.0];
}
//#warning include own action here!
//%%% action called when the card goes to the right.
// This should be customized with your own action
-(void)cardSwipedRight:(UIView *)card swiped:(BOOL)swiped;
{
    //do whatever you want with the card that was swiped
    //    DraggableView *c = (DraggableView *)card;
    
    Groups *group = [self.groups objectAtIndex:self.indexOfArray];
    self.indexOfArray++;
    if (!swiped) {
        [self.myGroup actionOnGroup:@"like.php" userGroupID:self.currentGroup.gid actionGroupID:group.gid callWithSuccess:nil errorCallback:nil];
    }
    [self groupName];
    
    [loadedCards removeObjectAtIndex:0]; //%%% card was swiped, so it's no longer a "loaded card"
    
    if (cardsLoadedIndex < [allCards count]) { //%%% if we haven't reached the end of all cards, put another into the loaded cards
        [loadedCards addObject:[allCards objectAtIndex:cardsLoadedIndex]];
        cardsLoadedIndex++;//%%% loaded a card, so have to increment count
        [self insertSubview:[loadedCards objectAtIndex:(MAX_BUFFER_SIZE-1)] belowSubview:[loadedCards objectAtIndex:(MAX_BUFFER_SIZE-2)]];
    }
    [self performSelector:@selector(backToDiscovery) withObject:self afterDelay:1.0];
}
-(void)backToDiscovery{
    if ([loadedCards count] == 0) {
        if ([[self delegate] respondsToSelector:@selector(backToDiscovery)]) {
            [[self delegate] backToDiscovery];
        }
    }
}
//%%% when you hit the right button, this is called and substitutes the swipe
-(void)swipeRight
{
    DraggableView *dragView = [loadedCards firstObject];
    dragView.overlayView.mode = GGOverlayViewModeRight;
    [UIView animateWithDuration:0.2 animations:^{
        dragView.overlayView.alpha = 1.0;
    }];
    [dragView rightClickAction];
}

//%%% when you hit the left button, this is called and substitutes the swipe
-(void)swipeLeft
{
    DraggableView *dragView = [loadedCards firstObject];
    dragView.overlayView.mode = GGOverlayViewModeLeft;
    [UIView animateWithDuration:0.2 animations:^{
        dragView.overlayView.alpha = 1.0;
    }];
    [dragView leftClickAction];
}
-(void)groupName{
    if ([[self delegate] respondsToSelector:@selector(currentGroupName:)]) {
        if ([self.groups count]-1 >= self.indexOfArray) {
            Groups *tmpGroup = [self.groups objectAtIndex:self.indexOfArray];
            [[self delegate] currentGroupName:tmpGroup.groupName];
        }
    }
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end

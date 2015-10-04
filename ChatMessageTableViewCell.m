//
//  ChatMessageTableViewCell.m
//  sample-chat
//
//  Created by Igor Khomenko on 10/19/13.
//  Copyright (c) 2013 Igor Khomenko. All rights reserved.
//

#import "ChatMessageTableViewCell.h"

#define padding 100

@implementation ChatMessageTableViewCell

static NSDateFormatter *messageDateFormatter;
static UIImage *orangeBubble;
static UIImage *aquaBubble;

+ (void)initialize{
    [super initialize];
    
    // init message datetime formatter
    messageDateFormatter = [[NSDateFormatter alloc] init];
    [messageDateFormatter setDateFormat: @"yyyy-mm-dd HH:mm"];
    [messageDateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"..."]];
    
    // init bubbles
    orangeBubble = [[UIImage imageNamed:@"orange"] stretchableImageWithLeftCapWidth:24  topCapHeight:15];
    aquaBubble = [[UIImage imageNamed:@"aqua"] stretchableImageWithLeftCapWidth:24  topCapHeight:15];
}

+ (CGFloat)heightForCellWithMessage:(QBChatAbstractMessage *)message
{
    NSString *text = message.text;

    
	CGSize  textSize = {180.0, 10000.0};
	CGSize size = [text sizeWithFont:[UIFont boldSystemFontOfSize:13]
                   constrainedToSize:textSize
                       lineBreakMode:NSLineBreakByWordWrapping];
    
	
	size.height += 45.0;
	return size.height;

}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.dateLabel = [[UILabel alloc] init];
        [self.dateLabel setFrame:CGRectMake(10, 5, 300, 20)];
        [self.dateLabel setFont:[UIFont systemFontOfSize:11.0]];
        [self.dateLabel setTextColor:[UIColor lightGrayColor]];
        [self.contentView addSubview:self.dateLabel];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.profilePic = [[UIImageView alloc] initWithFrame:CGRectMake(10,self.dateLabel.frame.origin.y + self.dateLabel.frame.size.height, 40, 40)];
        self.profilePic.backgroundColor = [UIColor clearColor];
        self.profilePic.layer.cornerRadius = self.profilePic.frame.size.width/2;
        self.profilePic.layer.masksToBounds = YES;
        self.profilePic.contentMode = UIViewContentModeScaleAspectFill;
        self.profilePic.clipsToBounds = YES;
        [self.contentView addSubview:self.profilePic];

        self.backgroundImageView = [[UIImageView alloc] init];
        [self.backgroundImageView setFrame:CGRectZero];
		[self.contentView addSubview:self.backgroundImageView];
        
		self.messageTextView = [[UITextView alloc] init];
        [self.messageTextView setBackgroundColor:[UIColor clearColor]];
        [self.messageTextView setEditable:NO];
        [self.messageTextView setScrollEnabled:NO];
		[self.messageTextView sizeToFit];
		[self.contentView addSubview:self.messageTextView];
    }
    return self;
}

- (void)configureCellWithMessage:(QBChatAbstractMessage *)message
{    
    self.messageTextView.text = message.text;
    
    
    CGSize textSize = { 180.0, 10000.0 };
    
	CGSize size = [self.messageTextView.text sizeWithFont:[UIFont boldSystemFontOfSize:13]
                                        constrainedToSize:textSize
                                            lineBreakMode:NSLineBreakByWordWrapping];

//    NSLog(@"message: %@", message);
    
	size.width += 10;
    
//    NSString *time = [messageDateFormatter stringFromDate:message.datetime];
    
    // Left/Right bubble
    
    if ([LocalStorageService shared].currentUser.ID == message.senderID) {
        [self.messageTextView setFrame:CGRectMake(padding/1.7, 25, size.width, size.height+padding)];
        [self.messageTextView sizeToFit];
        
        [self.profilePic setFrame:CGRectMake(10,self.dateLabel.frame.origin.y + self.dateLabel.frame.size.height, 40, 40)];

        [self.backgroundImageView setFrame:CGRectMake(padding/2, 25,self.messageTextView.frame.size.width+20, self.messageTextView.frame.size.height+5)];
        self.backgroundImageView.image = orangeBubble;
        
        self.dateLabel.textAlignment = NSTextAlignmentLeft;
        
        ParserEngine *myParser = [ParserEngine sharedInstance];
        
        Profiles *profile = [myParser currentUser];
        
        self.dateLabel.text = [NSString stringWithFormat:@"%@",profile.firstName];
        [self.profilePic sd_setImageWithURL:[NSURL URLWithString:profile.profilePic]];
        
    } else {
        [self.messageTextView setFrame:CGRectMake(320-size.width-padding/1.7, 25, size.width, size.height+padding)];
        [self.messageTextView sizeToFit];
        
        [self.profilePic setFrame:CGRectMake(310 - self.profilePic.frame.size.width, self.profilePic.frame.origin.y,self.profilePic.frame.size.width, self.profilePic.frame.size.height)];
        
        [self.backgroundImageView setFrame:CGRectMake(self.messageTextView.frame.origin.x-10, 25,self.messageTextView.frame.size.width+20, self.messageTextView.frame.size.height+5)];

        self.backgroundImageView.image = aquaBubble;
        
        Profiles *profile = [[ParserEngine sharedInstance] getProfileForChatID:[NSString stringWithFormat:@"%i",(int)message.senderID]];

        self.dateLabel.textAlignment = NSTextAlignmentRight;
        self.dateLabel.text = [NSString stringWithFormat:@"%@",profile.firstName];
        [self.profilePic sd_setImageWithURL:[NSURL URLWithString:profile.profilePic]];
    }
}

@end

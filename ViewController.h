//
//  ViewController.h
//  Cliquemix
//
//  Created by Dejan Atanasov on 2/4/15.
//  Copyright (c) 2015 Cliquemix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK.h>
#import "ProfileViewController.h"
#import "ParserEngine.h"

@interface ViewController : UIViewController
<FBLoginViewDelegate>{
    ParserEngine *myParser;
    IBOutlet UILabel *fbTextLabel;
    IBOutlet UIImageView *iconView;

}


@end


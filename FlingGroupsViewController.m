//
//  FlingGroupsViewController.m
//  Cliquemix
//
//  Created by Dejan Atanasov on 2/8/15.
//  Copyright (c) 2015 Cliquemix. All rights reserved.
//

#import "FlingGroupsViewController.h"

@interface FlingGroupsViewController ()

@end

@implementation FlingGroupsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    DraggableViewBackground *draggableBackground = [[DraggableViewBackground alloc]initWithFrame:flingView.bounds groups:self.groups currentGroup:self.currentGroup viewController:self fromChat:self.fromChat];
    draggableBackground.delegate = self;
    [flingView addSubview:draggableBackground];
}
-(id)initWithGroups:(NSArray *)groups currentGroup:(Groups *)group fromChat:(BOOL)fromChat{
    self = [super init];
    if (self) {
        self.groups = groups;
        self.currentGroup = group;
        self.fromChat = fromChat;
    }
    return self;
}
-(void)currentGroupName:(NSString *)grp_nm{
    groupNameLabel.text = grp_nm;
}
-(void)backToDiscovery{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)onBackButton:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

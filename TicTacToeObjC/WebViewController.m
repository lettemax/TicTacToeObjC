//
//  WebViewController.m
//  TicTacToeObjC
//
//  Created by Max Lettenberger on 5/14/15.
//  Copyright (c) 2015 Max. All rights reserved.
//

#import "WebViewController.h"
#import "ViewController.h"

@interface WebViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadRequestWithText:@"http://www.wikihow.com/Play-Tic-Tac-Toe"];

//    ViewController *vc = self.presentingViewController;
//
//    [vc.timer invalidate];

}

-(void)loadRequestWithText:(NSString *)text
{
    NSURL *url = [NSURL URLWithString:text];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}

- (IBAction)doneButtonPressed:(UIButton *)sender {

//    ViewController *vc = self.presentingViewController;
//
//    vc.timer = [NSTimer timerWithTimeInterval:1.0f target:self selector:@selector(onTick:) userInfo:nil repeats:YES];
//
//     [vc.runner addTimer:vc.timer forMode:NSDefaultRunLoopMode];


    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end

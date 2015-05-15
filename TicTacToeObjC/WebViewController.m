//
//  WebViewController.m
//  TicTacToeObjC
//
//  Created by Max Lettenberger on 5/14/15.
//  Copyright (c) 2015 Max. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadRequestWithText:@"http://www.wikihow.com/Play-Tic-Tac-Toe"];

}

-(void)loadRequestWithText:(NSString *)text
{
    NSURL *url = [NSURL URLWithString:text];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}

- (IBAction)doneButtonPressed:(UIButton *)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end

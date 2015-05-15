//
//  ViewController.m
//  TicTacToeObjC
//
//  Created by Max Lettenberger on 5/14/15.
//  Copyright (c) 2015 Max. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *labelOne;
@property (weak, nonatomic) IBOutlet UILabel *labelTwo;
@property (weak, nonatomic) IBOutlet UILabel *labelThree;
@property (weak, nonatomic) IBOutlet UILabel *labelFour;
@property (weak, nonatomic) IBOutlet UILabel *labelFive;
@property (weak, nonatomic) IBOutlet UILabel *labelSix;
@property (weak, nonatomic) IBOutlet UILabel *labelSeven;
@property (weak, nonatomic) IBOutlet UILabel *labelEight;
@property (weak, nonatomic) IBOutlet UILabel *labelNine;
@property (weak, nonatomic) IBOutlet UILabel *whichPlayerLabel;
@property NSArray *grid;
@property NSSet *freeSquares;
@property CGPoint center;
@property (weak, nonatomic) IBOutlet UILabel *timer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.grid = @[self.labelOne, self.labelTwo, self.labelThree, self.labelFour, self.labelFive, self.labelSix, self.labelSeven, self.labelEight, self.labelNine];
    self.whichPlayerLabel.text = @"X";
    self.whichPlayerLabel.textColor = [UIColor blueColor];
    self.freeSquares = [NSSet setWithArray:self.grid];
    self.center = self.whichPlayerLabel.center;

}

-(UILabel *)findLabelUsingPoint:(CGPoint)point
{
    for (int square = 0; square < self.grid.count; square++)
    {
        UILabel *label = self.grid[square];
        if (CGRectContainsPoint(label.frame, point))
        {
            return label;
        }
    }

    return nil;

}

- (IBAction)didPan:(UIPanGestureRecognizer *)sender {

    CGPoint point = [sender locationInView:self.view];
    if (CGRectContainsPoint(self.whichPlayerLabel.frame, point))
    {
        self.whichPlayerLabel.center = point;
    }

    if (sender.state == UIGestureRecognizerStateEnded)
    {
        UILabel *label = [self findLabelUsingPoint:point];
        if (label != nil && [label.text isEqualToString:@""])
        {
            label.text = self.whichPlayerLabel.text;
            label.textColor = self.whichPlayerLabel.textColor;
            self.whichPlayerLabel.center = self.center;

            [self togglePlayer];

            NSString *winner = [self checkForWinner];

            if (!([winner isEqualToString:@""]))
            {
                [self announceWinnerAndResetGame:winner];
            }

        } else {
            [UIView animateWithDuration:0.5f animations:^
             {
                 self.whichPlayerLabel.center = self.center;
             }];
        }
    }
}


- (IBAction)onLabelTapped:(UIGestureRecognizer *)sender {

    CGPoint point = [sender locationInView:(self.view)];

    UILabel *label = [self findLabelUsingPoint:point];

    if (label != nil && [label.text isEqualToString:@""])
    {

        if ([self.whichPlayerLabel.text isEqualToString:(@"X")])
        {
            label.text = @"X";
            label.textColor = [UIColor blueColor];
            self.whichPlayerLabel.text = @"O";
            self.whichPlayerLabel.textColor = [UIColor redColor];
        } else {
            label.text = @"O";
            label.textColor = [UIColor redColor];
            self.whichPlayerLabel.text = @"X";
            self.whichPlayerLabel.textColor = [UIColor blueColor];
        }

        NSString *winner = [self checkForWinner];

        if (!([winner isEqualToString:@""]))
        {
            [self announceWinnerAndResetGame:winner];
        }

    }
}

-(NSString *)checkForWinner
{
    for (int row = 0; row < 3; row+= 3)
    {
        UILabel *label1 = self.grid[row];
        UILabel *label2 = self.grid[row+1];
        UILabel *label3 = self.grid[row+2];
        if ([label1.text isEqualToString:label2.text] &&
            [label2.text isEqualToString:label3.text])
        {
            return label1.text;
        }
    }

    for (int col = 0; col < 3; col++)
    {
        UILabel *label1 = self.grid[col];
        UILabel *label2 = self.grid[col+3];
        UILabel *label3 = self.grid[col+6];
        if ([label1.text isEqualToString:label2.text] &&
            [label2.text isEqualToString:label3.text])
        {
            return label1.text;
        }
    }

    if ([self.labelOne.text isEqualToString:self.labelFive.text] && [self.labelFive.text isEqualToString:self.labelNine.text])
    {
        return self.labelOne.text;
    }

    if ([self.labelThree.text isEqualToString:self.labelFive.text] && [self.labelFive.text isEqualToString:self.labelSeven.text])
    {
        return self.labelThree.text;
    }

    return @"";
}

-(void)announceWinnerAndResetGame:(NSString *)winner
{
    UIAlertView *alertView = [[UIAlertView alloc]init];
    alertView.title = [NSString stringWithFormat:@"%@ has won!", winner];
    [alertView addButtonWithTitle:@"Play Again"];
    [alertView addButtonWithTitle:@"Done"];
    alertView.delegate = self;

    [alertView show];




}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        [self resetGame];
    }
}

-(void)resetGame
{
    for (UILabel *label in self.grid) {
        label.text = @"";
    }

    self.whichPlayerLabel.text = @"X";
    self.whichPlayerLabel.textColor = [UIColor blueColor];
}

-(void)togglePlayer
{
    if ([self.whichPlayerLabel.text isEqualToString:@"X"])
    {
        self.whichPlayerLabel.text = @"O";
        self.whichPlayerLabel.textColor = [UIColor redColor];
    } else {
        self.whichPlayerLabel.text = @"X";
        self.whichPlayerLabel.textColor = [UIColor blueColor];
    }

}

@end

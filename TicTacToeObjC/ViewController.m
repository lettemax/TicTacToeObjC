//
//  ViewController.m
//  TicTacToeObjC
//
//  Created by Max Lettenberger on 5/14/15.
//  Copyright (c) 2015 Max. All rights reserved.
//

#import "ViewController.h"
#include <stdlib.h>

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
@property NSMutableArray *freeSquares;
@property CGPoint center;
@property (weak, nonatomic) IBOutlet UILabel *timerLabel;
@property NSTimer *timer;
@property NSRunLoop *runner;
@property BOOL humanTurn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.grid = @[self.labelOne, self.labelTwo, self.labelThree, self.labelFour, self.labelFive, self.labelSix, self.labelSeven, self.labelEight, self.labelNine];
    self.freeSquares = [NSMutableArray new];
    [self.freeSquares addObjectsFromArray:self.grid];
    self.whichPlayerLabel.text = @"X";
    self.whichPlayerLabel.textColor = [UIColor blueColor];
    self.center = self.whichPlayerLabel.center;
    self.timer = [NSTimer timerWithTimeInterval:1.0f target:self selector:@selector(onTick:) userInfo:nil repeats:YES];
    self.runner = [NSRunLoop currentRunLoop];
    [self.runner addTimer:self.timer forMode:NSDefaultRunLoopMode];
    self.humanTurn = YES;

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

            [self.freeSquares removeObject:label];

            NSString *winner = [self checkForWinner];

            if (!([winner isEqualToString:@""]))
            {
                [self announceWinnerAndResetGame:winner];
            } else {
                [self togglePlayer];
            }

        } else {
            //animates 'drag back' to 'center' (original position of whichPlayerLabel
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
        label.text = @"X";
        label.textColor = [UIColor blueColor];
        [self.freeSquares removeObject:label];

        NSString *winner = [self checkForWinner];

        if (!([winner isEqualToString:@""]))
        {
            [self announceWinnerAndResetGame:winner];
        } else {
            [self togglePlayer];
        }
    }
}

-(NSString *)checkForWinner
{
    for (int row = 0; row < 9; row+=3)
    {
        UILabel *label1 = self.grid[row];
        UILabel *label2 = self.grid[row+1];
        UILabel *label3 = self.grid[row+2];
        if ([label1.text isEqualToString:label2.text] &&
            [label2.text isEqualToString:label3.text] && label1.text.length > 0)
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
            [label2.text isEqualToString:label3.text] && label1.text.length > 0)
        {
            return label1.text;
        }
    }

    if ([self.labelOne.text isEqualToString:self.labelFive.text] && [self.labelFive.text isEqualToString:self.labelNine.text] && self.labelOne.text.length > 0)
    {
        return self.labelOne.text;
    }

    if ([self.labelThree.text isEqualToString:self.labelFive.text] && [self.labelFive.text isEqualToString:self.labelSeven.text] && self.labelThree.text.length > 0)
    {
        return self.labelThree.text;
    }

    if (self.freeSquares.count == 0) {
        return @"T";
    }
    return @"";
}

-(void)announceWinnerAndResetGame:(NSString *)winner
{

    [self.timer invalidate];

    UIAlertView *alertView = [[UIAlertView alloc]init];

    if ([winner isEqualToString:@"T"])
    {
        alertView.title = [NSString stringWithFormat:@"TIE!"];
    } else {
        alertView.title = [NSString stringWithFormat:@"%@ has won!", winner];
    }

    [alertView addButtonWithTitle:@"Play Again"];
    [alertView addButtonWithTitle:@"Done"];
    alertView.delegate = self;

    alertView.tag = 0;

    [alertView show];

}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 0)
    {
        if (buttonIndex == 0)
        {
            [self resetGame];
        }
    } else if (alertView.tag == 1) {
        self.timer = [NSTimer timerWithTimeInterval:1.0f target:self selector:@selector(onTick:) userInfo:nil repeats:YES];
        [self togglePlayer];
    }
}

-(void)resetGame
{
    for (UILabel *label in self.grid) {
        label.text = @"";
    }

    self.whichPlayerLabel.text = @"X";
    self.whichPlayerLabel.textColor = [UIColor blueColor];

    self.freeSquares = [NSMutableArray new];
    [self.freeSquares addObjectsFromArray:self.grid];

    self.timer = [NSTimer timerWithTimeInterval:1.0f target:self selector:@selector(onTick:) userInfo:nil repeats:YES];

    [self resetTimer];

    }

-(void)togglePlayer
{
    if ([self.whichPlayerLabel.text isEqualToString:@"X"])
    {
        self.whichPlayerLabel.text = @"O";
        self.whichPlayerLabel.textColor = [UIColor redColor];
        [self computerTurn];
    } else {
        self.whichPlayerLabel.text = @"X";
        self.whichPlayerLabel.textColor = [UIColor blueColor];
    }

    [self resetTimer];

}


-(void)resetTimer
{
    self.timerLabel.text = @"10";
    [self.runner addTimer:self.timer forMode:NSDefaultRunLoopMode];
}

-(void)computerTurn
{
    //self.humanTurn = NO;

    int winningSpace = [self checkForAlmostWinner];

    NSLog(@"winning space = %d", winningSpace);
    if (winningSpace == 10)
    {
        int randomNum = arc4random_uniform(self.freeSquares.count);

        UILabel *label = self.freeSquares[randomNum];
        label.text = self.whichPlayerLabel.text;
        label.textColor = self.whichPlayerLabel.textColor;

        [self.freeSquares removeObject:label];

    } else {

        UILabel *label = self.grid[winningSpace];
        label.text = self.whichPlayerLabel.text;
        label.textColor = self.whichPlayerLabel.textColor;

        [self.freeSquares removeObject:label];
    }

    NSString *winner = [self checkForWinner];

    if (!([winner isEqualToString:@""]))
    {
        [self announceWinnerAndResetGame:winner];
    } else {
        [self togglePlayer];
    }

    //self.humanTurn = YES;
}

-(int)checkForAlmostWinner
{
    for (int row = 0; row < 9; row+=3)
    {
        UILabel *label1 = self.grid[row];
        UILabel *label2 = self.grid[row+1];
        UILabel *label3 = self.grid[row+2];
        //if one away from win, take that square

        if (([label1.text isEqualToString:label2.text] && [label3.text isEqualToString:@""] && label1.text.length > 0))
        {
//            UILabel *label = label3;
//            label.text = self.whichPlayerLabel.text;
//            label.textColor = self.whichPlayerLabel.textColor;
//
//            [self.freeSquares removeObject:label3];
            return row+2;
        }

        else if (([label1.text isEqualToString:label3.text] && [label2.text isEqualToString:@""] && label1.text.length > 0))
        {
//            UILabel *label = label2;
//            label.text = self.whichPlayerLabel.text;
//            label.textColor = self.whichPlayerLabel.textColor;
//
//            [self.freeSquares removeObject:label2];
            return row+1;
        }

        else if (([label2.text isEqualToString:label3.text] && [label1.text isEqualToString:@""] && label2.text.length > 0))
        {
//            UILabel *label = label1;
//            label.text = self.whichPlayerLabel.text;
//            label.textColor = self.whichPlayerLabel.textColor;
//
//            [self.freeSquares removeObject:label1];
            return row;
        }
    }

    for (int col = 0; col < 3; col++)
    {
        UILabel *label1 = self.grid[col];
        UILabel *label2 = self.grid[col+3];
        UILabel *label3 = self.grid[col+6];

        if (([label1.text isEqualToString:label2.text] && [label3.text isEqualToString:@""] && label1.text.length > 0))
        {
//            UILabel *label = label3;
//            label.text = self.whichPlayerLabel.text;
//            label.textColor = self.whichPlayerLabel.textColor;
//
//            [self.freeSquares removeObject:label3];
            return col+6;
        }

        else if (([label1.text isEqualToString:label3.text] && [label2.text isEqualToString:@""] && label1.text.length > 0))
        {
//            UILabel *label = label2;
//            label.text = self.whichPlayerLabel.text;
//            label.textColor = self.whichPlayerLabel.textColor;
//
//            [self.freeSquares removeObject:label2];
            return col+3;
        }

        else if (([label2.text isEqualToString:label3.text] && [label1.text isEqualToString:@""] && label2.text.length > 0))
        {
//            UILabel *label = label1;
//            label.text = self.whichPlayerLabel.text;
//            label.textColor = self.whichPlayerLabel.textColor;
//
//            [self.freeSquares removeObject:label1];
            return col;
        }
    }

    if ([self.labelOne.text isEqualToString:self.labelFive.text] && [self.labelNine.text isEqualToString:@""] && self.labelOne.text.length > 0)
    {
//        UILabel *label = self.labelNine;
//        label.text = self.whichPlayerLabel.text;
//        label.textColor = self.whichPlayerLabel.textColor;
//
//        [self.freeSquares removeObject:self.labelNine];
        return 8;
    }

    else if ([self.labelOne.text isEqualToString:self.labelNine.text] && [self.labelFive.text isEqualToString:@""] && self.labelOne.text.length > 0)
    {
//        UILabel *label = self.labelFive;
//        label.text = self.whichPlayerLabel.text;
//        label.textColor = self.whichPlayerLabel.textColor;
//
//        [self.freeSquares removeObject:self.labelFive];
        return 4;
    }

    else if ([self.labelFive.text isEqualToString:self.labelNine.text] && [self.labelOne.text isEqualToString:@""] && self.labelFive.text.length > 0)
    {
//        UILabel *label = self.labelOne;
//        label.text = self.whichPlayerLabel.text;
//        label.textColor = self.whichPlayerLabel.textColor;
//
//        [self.freeSquares removeObject:self.labelOne];
        return 0;
    }

    else if ([self.labelThree.text isEqualToString:self.labelFive.text] && [self.labelSeven.text isEqualToString:@""] && self.labelThree.text.length > 0)
    {
//        UILabel *label = self.labelSeven;
//        label.text = self.whichPlayerLabel.text;
//        label.textColor = self.whichPlayerLabel.textColor;
//
//        [self.freeSquares removeObject:self.labelSeven];
        return 6;
    }

    else if ([self.labelThree.text isEqualToString:self.labelSeven.text] && [self.labelFive.text isEqualToString:@""] && self.labelThree.text.length > 0)
    {
//        UILabel *label = self.labelFive;
//        label.text = self.whichPlayerLabel.text;
//        label.textColor = self.whichPlayerLabel.textColor;
//
//        [self.freeSquares removeObject:self.labelFive];
        return 4;
    }

    else if ([self.labelFive.text isEqualToString:self.labelSeven.text] && [self.labelThree.text isEqualToString:@""] && self.labelFive.text.length > 0)
    {
//        UILabel *label = self.labelThree;
//        label.text = self.whichPlayerLabel.text;
//        label.textColor = self.whichPlayerLabel.textColor;
//
//        [self.freeSquares removeObject:self.labelThree];
        return 2;

    } else {
        return 10;
    }

}

-(void)onTick:(NSTimer *)timer
{
    int time = [self.timerLabel.text intValue];

    if (time > 0) {
        self.timerLabel.text = [NSString stringWithFormat:@"%i", (time - 1)];
    } else {
        [self.timer invalidate];
        UIAlertView *timerAlert = [[UIAlertView alloc]init];
        timerAlert.title = @"Time's up!";
        [timerAlert addButtonWithTitle:@"Dismiss"];
        timerAlert.delegate = self;

        timerAlert.tag = 1;

        [timerAlert show];
    }
}

//stop timer when help button clicked
//reset timer when done button clicked

@end

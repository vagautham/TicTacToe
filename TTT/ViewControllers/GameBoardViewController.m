//
//  GameBoardViewController.m
//  TTT
//
//  Created by VA Gautham  on 8/28/14.
//  Copyright (c) 2014 Gautham. All rights reserved.
//

#import "GameBoardViewController.h"

@interface GameBoardViewController ()

@property AppDelegate *appDelegateInstance;

@property NSString *Player1Name;
@property UIImage *Player1Image;
@property NSString *Player2Name;
@property UIImage *Player2Image;
@property BOOL gameOver;

@end

@implementation GameBoardViewController
@synthesize gameBoardView;
@synthesize img_Player, lbl_Player, img_Peg;
@synthesize img_Slot0x0, img_Slot0x1, img_Slot0x2;
@synthesize img_Slot1x0, img_Slot1x1, img_Slot1x2;
@synthesize img_Slot2x0, img_Slot2x1, img_Slot2x2;
@synthesize gameBoardStatus, playerTurn;
@synthesize imageArray, boardArray;
@synthesize lbl_Player1, lbl_Player2, lbl_score, lbl_Totalmatches;
@synthesize Player1Wins, Player2Wins, totalMatches;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _appDelegateInstance = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    gameBoardStatus = [[NSMutableDictionary alloc] init];
    
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    _Player1Name = [userDefaults valueForKey:@"Player1Name"];
    if([userDefaults valueForKey:@"Player1Image"])
        _Player1Image = [userDefaults valueForKey:@"Player1Image"];
    else
        _Player1Image = [UIImage imageNamed:@"placeholder"];
    
    if (_appDelegateInstance.mGameType == GameType_SinglePlayer)
    {
        _Player2Name = @"Artificial Intelligence";
        _Player2Image = [UIImage imageNamed:@"AI.png"];
    }
    else
    {
        _Player2Name = [userDefaults valueForKey:@"Player2Name"];
        if([userDefaults valueForKey:@"Player2Image"])
            _Player2Image = [userDefaults valueForKey:@"Player2Image"];
        else
            _Player2Image = [UIImage imageNamed:@"placeholder"];
    }
    [img_Peg setAnimationDuration:1];
    
    imageArray = [[NSMutableArray alloc] initWithObjects:img_Slot0x0,img_Slot0x1,img_Slot0x2,img_Slot1x0,img_Slot1x1,img_Slot1x2,img_Slot2x0,img_Slot2x1,img_Slot2x2, nil];
    [self resetGameBoard];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"BG_Plain-568h.png"]]];
    Player1Wins = 0;
    Player2Wins = 0;
    totalMatches = 0;
    
    [lbl_Player1 setText:_Player1Name];
    [lbl_Player2 setText:_Player2Name];
    
    [lbl_score setText:[NSString stringWithFormat:@"%d (%d tie(s)) %d", Player1Wins,(totalMatches - (Player2Wins + Player1Wins)), Player2Wins]];
    [lbl_Totalmatches setText:[NSString stringWithFormat:@"(%d game(s))", totalMatches]];
}

-(void)resetGameBoard
{
    [self.view setUserInteractionEnabled:TRUE];
    [self.view setAlpha:1.0];
    
    [img_Peg stopAnimating];
    
    [lbl_Player setTextColor:[UIColor whiteColor]];
    
    for (UIImageView *imgView in imageArray)
        [imgView stopAnimating];
    
    playerTurn = Player_1_Turn;
    _gameOver = FALSE;
    
    [img_Player setImage:_Player1Image];
    [lbl_Player setText:[NSString stringWithFormat:@"%@'s turn", _Player1Name]];
    [img_Peg setImage:[UIImage imageNamed:@"X.png"]];
    
    [gameBoardStatus setValue:[NSNumber numberWithInt:Slot_Empty] forKey:BOARD_0x0];
    [gameBoardStatus setValue:[NSNumber numberWithInt:Slot_Empty] forKey:BOARD_0x1];
    [gameBoardStatus setValue:[NSNumber numberWithInt:Slot_Empty] forKey:BOARD_0x2];
    
    [gameBoardStatus setValue:[NSNumber numberWithInt:Slot_Empty] forKey:BOARD_1x0];
    [gameBoardStatus setValue:[NSNumber numberWithInt:Slot_Empty] forKey:BOARD_1x1];
    [gameBoardStatus setValue:[NSNumber numberWithInt:Slot_Empty] forKey:BOARD_1x2];
    
    [gameBoardStatus setValue:[NSNumber numberWithInt:Slot_Empty] forKey:BOARD_2x0];
    [gameBoardStatus setValue:[NSNumber numberWithInt:Slot_Empty] forKey:BOARD_2x1];
    [gameBoardStatus setValue:[NSNumber numberWithInt:Slot_Empty] forKey:BOARD_2x2];
    
    [img_Slot0x0 setImage:nil];
    [img_Slot0x1 setImage:nil];
    [img_Slot0x2 setImage:nil];
    
    [img_Slot1x0 setImage:nil];
    [img_Slot1x1 setImage:nil];
    [img_Slot1x2 setImage:nil];
    
    [img_Slot2x0 setImage:nil];
    [img_Slot2x1 setImage:nil];
    [img_Slot2x2 setImage:nil];
    
    boardArray = [[NSMutableArray alloc] initWithObjects:BOARD_0x0,BOARD_0x1,BOARD_0x2,BOARD_1x0,BOARD_1x1,BOARD_1x2,BOARD_2x0,BOARD_2x1,BOARD_2x2, nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *)touches
           withEvent:(UIEvent *)event
{
    if (_gameOver)
        return;
    
    UIImage *xImage = [UIImage imageNamed:@"X.png"];
    UIImage *oImage = [UIImage imageNamed:@"O.png"];
    UIImage *o1Image = [UIImage imageNamed:@"O1.png"];
    
    UITouch *touch = [[event allTouches] anyObject];
    BOOL validMove = FALSE;
    
    if(CGRectContainsPoint([img_Slot0x0 frame], [touch locationInView:self.gameBoardView]) && ([[gameBoardStatus valueForKey:BOARD_0x0] intValue] == Slot_Empty))
    {
        if(playerTurn == Player_1_Turn)
        {
            img_Slot0x0.image = xImage;
            [gameBoardStatus setValue:[NSNumber numberWithInt:Slot_X] forKey:BOARD_0x0];
        }
        else if(playerTurn == Player_2_Turn)
        {
            img_Slot0x0.image = oImage;
            [gameBoardStatus setValue:[NSNumber numberWithInt:Slot_O] forKey:BOARD_0x0];
        }
        [boardArray removeObject:BOARD_0x0];
        validMove = TRUE;
    }
    else if(CGRectContainsPoint([img_Slot0x1 frame], [touch locationInView:self.gameBoardView]) && ([[gameBoardStatus valueForKey:BOARD_0x1] intValue] == Slot_Empty))
    {
        if(playerTurn == Player_1_Turn)
        {
            img_Slot0x1.image = xImage;
            [gameBoardStatus setValue:[NSNumber numberWithInt:Slot_X] forKey:BOARD_0x1];
        }
        else if(playerTurn == Player_2_Turn)
        {
            img_Slot0x1.image = oImage;
            [gameBoardStatus setValue:[NSNumber numberWithInt:Slot_O] forKey:BOARD_0x1];
        }
        [boardArray removeObject:BOARD_0x0];
        validMove = TRUE;
    }
    else if(CGRectContainsPoint([img_Slot0x2 frame], [touch locationInView:self.gameBoardView]) && ([[gameBoardStatus valueForKey:BOARD_0x2] intValue] == Slot_Empty))
    {
        if(playerTurn == Player_1_Turn)
        {
            img_Slot0x2.image = xImage;
            [gameBoardStatus setValue:[NSNumber numberWithInt:Slot_X] forKey:BOARD_0x2];
        }
        else if(playerTurn == Player_2_Turn)
        {
            img_Slot0x2.image = oImage;
            [gameBoardStatus setValue:[NSNumber numberWithInt:Slot_O] forKey:BOARD_0x2];
        }
        [boardArray removeObject:BOARD_0x2];
        validMove = TRUE;
    }
    
    else if(CGRectContainsPoint([img_Slot1x0 frame], [touch locationInView:self.gameBoardView]) && ([[gameBoardStatus valueForKey:BOARD_1x0] intValue] == Slot_Empty))
    {
        if(playerTurn == Player_1_Turn)
        {
            img_Slot1x0.image = xImage;
            [gameBoardStatus setValue:[NSNumber numberWithInt:Slot_X] forKey:BOARD_1x0];
        }
        else if(playerTurn == Player_2_Turn)
        {
            img_Slot1x0.image = oImage;
            [gameBoardStatus setValue:[NSNumber numberWithInt:Slot_O] forKey:BOARD_1x0];
        }
        [boardArray removeObject:BOARD_1x0];
        validMove = TRUE;
    }
    else if(CGRectContainsPoint([img_Slot1x1 frame], [touch locationInView:self.gameBoardView]) && ([[gameBoardStatus valueForKey:BOARD_1x1] intValue] == Slot_Empty))
    {
        if(playerTurn == Player_1_Turn)
        {
            img_Slot1x1.image = xImage;
            [gameBoardStatus setValue:[NSNumber numberWithInt:Slot_X] forKey:BOARD_1x1];
        }
        else if(playerTurn == Player_2_Turn)
        {
            img_Slot1x1.image = oImage;
            [gameBoardStatus setValue:[NSNumber numberWithInt:Slot_O] forKey:BOARD_1x1];
        }
        [boardArray removeObject:BOARD_1x1];
        validMove = TRUE;
    }
    else if(CGRectContainsPoint([img_Slot1x2 frame], [touch locationInView:self.gameBoardView]) && ([[gameBoardStatus valueForKey:BOARD_1x2] intValue] == Slot_Empty))
    {
        if(playerTurn == Player_1_Turn)
        {
            img_Slot1x2.image = xImage;
            [gameBoardStatus setValue:[NSNumber numberWithInt:Slot_X] forKey:BOARD_1x2];
        }
        else if(playerTurn == Player_2_Turn)
        {
            img_Slot1x2.image = oImage;
            [gameBoardStatus setValue:[NSNumber numberWithInt:Slot_O] forKey:BOARD_1x2];
        }
        [boardArray removeObject:BOARD_1x2];
        validMove = TRUE;
    }
    
    else if(CGRectContainsPoint([img_Slot2x0 frame], [touch locationInView:self.gameBoardView]) && ([[gameBoardStatus valueForKey:BOARD_2x0] intValue] == Slot_Empty))
    {
        if(playerTurn == Player_1_Turn)
        {
            img_Slot2x0.image = xImage;
            [gameBoardStatus setValue:[NSNumber numberWithInt:Slot_X] forKey:BOARD_2x0];
        }
        else if(playerTurn == Player_2_Turn)
        {
            img_Slot2x0.image = oImage;
            [gameBoardStatus setValue:[NSNumber numberWithInt:Slot_O] forKey:BOARD_2x0];
        }
        [boardArray removeObject:BOARD_2x0];
        validMove = TRUE;
    }
    else if(CGRectContainsPoint([img_Slot2x1 frame], [touch locationInView:self.gameBoardView]) && ([[gameBoardStatus valueForKey:BOARD_2x1] intValue] == Slot_Empty))
    {
        if(playerTurn == Player_1_Turn)
        {
            img_Slot2x1.image = xImage;
            [gameBoardStatus setValue:[NSNumber numberWithInt:Slot_X] forKey:BOARD_2x1];
        }
        else if(playerTurn == Player_2_Turn)
        {
            img_Slot2x1.image = oImage;
            [gameBoardStatus setValue:[NSNumber numberWithInt:Slot_O] forKey:BOARD_2x1];
        }
        [boardArray removeObject:BOARD_2x1];
        validMove = TRUE;
    }
    else if(CGRectContainsPoint([img_Slot2x2 frame], [touch locationInView:self.gameBoardView]) && ([[gameBoardStatus valueForKey:BOARD_2x2] intValue] == Slot_Empty))
    {
        if(playerTurn == Player_1_Turn)
        {
            img_Slot2x2.image = xImage;
            [gameBoardStatus setValue:[NSNumber numberWithInt:Slot_X] forKey:BOARD_2x2];
        }
        else if(playerTurn == Player_2_Turn)
        {
            img_Slot2x2.image = oImage;
            [gameBoardStatus setValue:[NSNumber numberWithInt:Slot_O] forKey:BOARD_2x2];
        }
        [boardArray removeObject:BOARD_2x2];
        validMove = TRUE;
    }
    
    if (validMove)
    {
        BOOL win = [self checkForWin];
        if (!win && [[gameBoardStatus allKeysForObject:[NSNumber numberWithInt:Slot_Empty]] count] == 0)
        {
            [lbl_Player setText:[NSString stringWithFormat:@"Game Tie"]];
            [lbl_Player setTextColor:[UIColor greenColor]];
            
            gameResultAlert = [[UIAlertView alloc] initWithTitle:@"Its a Tie" message:@"Try again?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Retry", nil];
            [gameResultAlert show];
            ++totalMatches;
            [lbl_score setText:[NSString stringWithFormat:@"%d (%d tie(s)) %d", Player1Wins,(totalMatches - (Player2Wins + Player1Wins)), Player2Wins]];
            [lbl_Totalmatches setText:[NSString stringWithFormat:@"(%d game(s))", totalMatches]];
            _gameOver = TRUE;
            return;
        }
        if(playerTurn == Player_1_Turn)
        {
            if(win)
            {
                [lbl_Player setText:[NSString stringWithFormat:@"%@ won", _Player1Name]];
                
                gameResultAlert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%@ Won!", _Player1Name] message:@"Try again?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Retry", nil];
                //[gameResultAlert show];
                ++totalMatches;
                ++Player1Wins;
                [lbl_score setText:[NSString stringWithFormat:@"%d (%d tie(s)) %d", Player1Wins,(totalMatches - (Player2Wins + Player1Wins)), Player2Wins]];
                [lbl_Totalmatches setText:[NSString stringWithFormat:@"(%d game(s))", totalMatches]];
                [self animateWinner:Player_1_Turn];
                _gameOver = TRUE;
                return;
            }
            playerTurn = Player_2_Turn;
            [img_Player setImage:_Player2Image];
            [lbl_Player setText:[NSString stringWithFormat:@"%@'s turn", _Player2Name]];
            [img_Peg setImage:o1Image];
            
            if (_appDelegateInstance.mGameType == GameType_SinglePlayer)
            {
                [self AIsTurn];
            }
        }
        else if(playerTurn == Player_2_Turn)
        {
            if(win)
            {
                [lbl_Player setText:[NSString stringWithFormat:@"%@ won", _Player2Name]];
                
                gameResultAlert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%@ Won!", _Player2Name] message:@"Try again?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Retry", nil];
                //[gameResultAlert show];
                ++totalMatches;
                ++Player2Wins;
                [lbl_score setText:[NSString stringWithFormat:@"%d (%d tie(s)) %d", Player1Wins,(totalMatches - (Player2Wins + Player1Wins)), Player2Wins]];
                [lbl_Totalmatches setText:[NSString stringWithFormat:@"(%d game(s))", totalMatches]];
                [self animateWinner:Player_2_Turn];
                _gameOver = TRUE;
                return;
            }
            playerTurn = Player_1_Turn;
            [img_Player setImage:_Player1Image];
            [lbl_Player setText:[NSString stringWithFormat:@"%@'s turn", _Player1Name]];
            [img_Peg setImage:xImage];
        }
    }
}

-(void)animateWinner:(PlayerTurn)player
{
    if (player == Player_1_Turn)
    {
        UIImage *xImage = [UIImage imageNamed:@"X.png"];
        UIImage *xWinImage = [UIImage imageNamed:@"X-win.png"];
        
        NSArray *aniImages = [NSArray arrayWithObjects:xImage, xWinImage, nil];
        [img_Peg setAnimationImages:aniImages];
        [img_Peg startAnimating];
        for (UIImageView *imgView in imageArray)
        {
            if (imgView.image == xImage)
            {
                [imgView setAnimationImages:aniImages];
                [imgView setAnimationDuration:1];
                [imgView startAnimating];
            }
        }
    }
    else if (player == Player_2_Turn)
    {
        UIImage *oImage = [UIImage imageNamed:@"O.png"];
        UIImage *oWinImage = [UIImage imageNamed:@"O-win.png"];
        UIImage *o1Image = [UIImage imageNamed:@"O1.png"];
        
        
        NSArray *ani1Images = [NSArray arrayWithObjects:o1Image, oWinImage, nil];
        NSArray *aniImages = [NSArray arrayWithObjects:oImage, oWinImage, nil];
        
        [img_Peg setAnimationImages:ani1Images];
        [img_Peg startAnimating];
        for (UIImageView *imgView in imageArray)
        {
            if (imgView.image == oImage)
            {
                [imgView setAnimationImages:aniImages];
                [imgView setAnimationDuration:1];
                [imgView startAnimating];
            }
        }
    }
}

-(BOOL)checkForWin
{
    if(playerTurn == Player_1_Turn)
    {
        NSArray *xPostions = [gameBoardStatus allKeysForObject:[NSNumber numberWithInt:Slot_X]];
        if (xPostions.count < 3)
            return FALSE;
        if ([xPostions containsObject:BOARD_0x0])
        {
            if ([xPostions containsObject:BOARD_0x1] && [xPostions containsObject:BOARD_0x2])
                return TRUE;
            else if ([xPostions containsObject:BOARD_1x0] && [xPostions containsObject:BOARD_2x0])
                return TRUE;
            else if ([xPostions containsObject:BOARD_1x1] && [xPostions containsObject:BOARD_2x2])
                return TRUE;
        }
        if ([xPostions containsObject:BOARD_0x1])
        {
            if ([xPostions containsObject:BOARD_1x1] && [xPostions containsObject:BOARD_2x1])
                return TRUE;
        }
        if ([xPostions containsObject:BOARD_0x2])
        {
            if ([xPostions containsObject:BOARD_1x2] && [xPostions containsObject:BOARD_2x2])
                return TRUE;
            else if ([xPostions containsObject:BOARD_1x1] && [xPostions containsObject:BOARD_2x0])
                return TRUE;
        }
        if ([xPostions containsObject:BOARD_1x0])
        {
            if ([xPostions containsObject:BOARD_1x1] && [xPostions containsObject:BOARD_1x2])
                return TRUE;
        }
        if ([xPostions containsObject:BOARD_2x0])
        {
            if ([xPostions containsObject:BOARD_2x1] && [xPostions containsObject:BOARD_2x2])
                return TRUE;
        }
    }
    else if(playerTurn == Player_2_Turn)
    {
        NSArray *oPostions = [gameBoardStatus allKeysForObject:[NSNumber numberWithInt:Slot_O]];
        if (oPostions.count < 3)
            return FALSE;
        if ([oPostions containsObject:BOARD_0x0])
        {
            if ([oPostions containsObject:BOARD_0x1] && [oPostions containsObject:BOARD_0x2])
                return TRUE;
            else if ([oPostions containsObject:BOARD_1x0] && [oPostions containsObject:BOARD_2x0])
                return TRUE;
            else if ([oPostions containsObject:BOARD_1x1] && [oPostions containsObject:BOARD_2x2])
                return TRUE;
        }
        if ([oPostions containsObject:BOARD_0x1])
        {
            if ([oPostions containsObject:BOARD_1x1] && [oPostions containsObject:BOARD_2x1])
                return TRUE;
        }
        if ([oPostions containsObject:BOARD_0x2])
        {
            if ([oPostions containsObject:BOARD_1x2] && [oPostions containsObject:BOARD_2x2])
                return TRUE;
            else if ([oPostions containsObject:BOARD_1x1] && [oPostions containsObject:BOARD_2x0])
                return TRUE;
        }
        if ([oPostions containsObject:BOARD_1x0])
        {
            if ([oPostions containsObject:BOARD_1x1] && [oPostions containsObject:BOARD_1x2])
                return TRUE;
        }
        if ([oPostions containsObject:BOARD_2x0])
        {
            if ([oPostions containsObject:BOARD_2x1] && [oPostions containsObject:BOARD_2x2])
                return TRUE;
        }
    }
    return FALSE;
}

-(void)AIsTurn
{
    [self.view setUserInteractionEnabled:FALSE];
    [self.view setAlpha:0.5];
    NSString *AIMove;
    if (_appDelegateInstance.mHardMode == HardMode_Off)
    {
        NSUInteger randomIndex = arc4random() % [boardArray count];
        AIMove = [boardArray objectAtIndex:randomIndex];
    }
    else if(_appDelegateInstance.mHardMode == HardMode_On)
    {
        AIMove = [self getBestMove];
        
    }
    [self performSelector:@selector(makeAIMoveat:) withObject:AIMove afterDelay:1];
}

-(NSString *)getBestMove
{
    //If center is empty take center
    if ([self canUseCenter])
    {
        return BOARD_1x1;
    }
    else
    {
        //Check for no. of opponent pegs
        NSArray *xPostions = [gameBoardStatus allKeysForObject:[NSNumber numberWithInt:Slot_X]];
        if (xPostions.count < 2)
        {
            //Take any corner
            NSString *corner = [self getCorner];
            return corner;
            
        }
        else
        {
            //Check for blocks
            NSString *winningPosition = [self getWinningPosition];
            if (winningPosition)
                return winningPosition;
            else
            {
                NSString *unblockPosition = [self getUnblockingPosition];
                if (unblockPosition)
                    return unblockPosition;
                else
                {
                    NSString *corner = [self getCorner];
                    if (corner)
                        return corner;
                    else
                    {
                        NSString *emptyPostion = [self getEmptyPostion];
                        if (emptyPostion)
                            return emptyPostion;
                    }
                }
            }
        }
        NSString *emptyPostion = [self getEmptyPostion];
        if (emptyPostion)
            return emptyPostion;
    }
    //Should never happen
    return nil;
}

-(BOOL)canUseCenter
{
    if ([[gameBoardStatus valueForKey:BOARD_1x1] intValue] == Slot_Empty)
        return YES;
    return NO;
}

-(NSString *)getCorner
{
    NSString *blockingCorener = [self getBlockingCorners];
    if (blockingCorener)
        return blockingCorener;
    
    if ([[gameBoardStatus valueForKey:BOARD_0x0] intValue] == Slot_Empty)
        return BOARD_0x0;
    else if ([[gameBoardStatus valueForKey:BOARD_0x2] intValue] == Slot_Empty)
        return BOARD_0x2;
    else if ([[gameBoardStatus valueForKey:BOARD_2x0] intValue] == Slot_Empty)
        return BOARD_2x0;
    else if ([[gameBoardStatus valueForKey:BOARD_2x2] intValue] == Slot_Empty)
        return BOARD_2x2;
    return nil;
}

-(NSString *)getBlockingCorners
{
    NSArray *xPostions = [gameBoardStatus allKeysForObject:[NSNumber numberWithInt:Slot_X]];
    if ([xPostions containsObject:BOARD_0x1] || [xPostions containsObject:BOARD_1x0])
        if ([[gameBoardStatus valueForKey:BOARD_0x0] intValue] == Slot_Empty)
            return BOARD_0x0;
    
    if ([xPostions containsObject:BOARD_0x1] || [xPostions containsObject:BOARD_1x2])
        if ([[gameBoardStatus valueForKey:BOARD_0x2] intValue] == Slot_Empty)
            return BOARD_0x2;

    if ([xPostions containsObject:BOARD_1x0] || [xPostions containsObject:BOARD_2x1])
        if ([[gameBoardStatus valueForKey:BOARD_2x0] intValue] == Slot_Empty)
            return BOARD_2x0;
    
    if ([xPostions containsObject:BOARD_1x2] || [xPostions containsObject:BOARD_2x1])
        if ([[gameBoardStatus valueForKey:BOARD_2x2] intValue] == Slot_Empty)
            return BOARD_2x2;
    
    return nil;
}

-(NSString *)getUnblockingPosition
{
    NSArray *xPostions = [gameBoardStatus allKeysForObject:[NSNumber numberWithInt:Slot_X]];
    if ([xPostions containsObject:BOARD_0x0])
    {
        if ([xPostions containsObject:BOARD_0x1] && [[gameBoardStatus valueForKey:BOARD_0x2] intValue] == Slot_Empty)
            return BOARD_0x2;
        if ([xPostions containsObject:BOARD_0x2] && [[gameBoardStatus valueForKey:BOARD_0x1] intValue] == Slot_Empty)
            return BOARD_0x1;
        if ([xPostions containsObject:BOARD_1x0] && [[gameBoardStatus valueForKey:BOARD_2x0] intValue] == Slot_Empty)
            return BOARD_2x0;
        if ([xPostions containsObject:BOARD_2x0] && [[gameBoardStatus valueForKey:BOARD_1x0] intValue] == Slot_Empty)
            return BOARD_1x0;
        if ([xPostions containsObject:BOARD_1x1] && [[gameBoardStatus valueForKey:BOARD_2x2] intValue] == Slot_Empty)
            return BOARD_2x2;
        if ([xPostions containsObject:BOARD_2x2] && [[gameBoardStatus valueForKey:BOARD_1x1] intValue] == Slot_Empty)
            return BOARD_1x1;
    }
    if ([xPostions containsObject:BOARD_0x1])
    {
        if ([xPostions containsObject:BOARD_0x2] && [[gameBoardStatus valueForKey:BOARD_0x0] intValue] == Slot_Empty)
            return BOARD_0x0;
        if ([xPostions containsObject:BOARD_1x1] && [[gameBoardStatus valueForKey:BOARD_2x1] intValue] == Slot_Empty)
            return BOARD_2x1;
        if ([xPostions containsObject:BOARD_2x1] && [[gameBoardStatus valueForKey:BOARD_1x1] intValue] == Slot_Empty)
            return BOARD_1x1;
    }
    if ([xPostions containsObject:BOARD_0x2])
    {
        if ([xPostions containsObject:BOARD_1x2] && [[gameBoardStatus valueForKey:BOARD_2x2] intValue] == Slot_Empty)
            return BOARD_2x2;
        if ([xPostions containsObject:BOARD_2x2] && [[gameBoardStatus valueForKey:BOARD_1x2] intValue] == Slot_Empty)
            return BOARD_1x2;
        if ([xPostions containsObject:BOARD_1x1] && [[gameBoardStatus valueForKey:BOARD_2x0] intValue] == Slot_Empty)
            return BOARD_2x0;
        if ([xPostions containsObject:BOARD_2x0] && [[gameBoardStatus valueForKey:BOARD_1x1] intValue] == Slot_Empty)
            return BOARD_1x1;
    }
    if ([xPostions containsObject:BOARD_1x0])
    {
        if ([xPostions containsObject:BOARD_2x1] && [[gameBoardStatus valueForKey:BOARD_0x0] intValue] == Slot_Empty)
            return BOARD_0x0;
        if ([xPostions containsObject:BOARD_1x1] && [[gameBoardStatus valueForKey:BOARD_1x2] intValue] == Slot_Empty)
            return BOARD_1x2;
        if ([xPostions containsObject:BOARD_1x2] && [[gameBoardStatus valueForKey:BOARD_1x0] intValue] == Slot_Empty)
            return BOARD_1x0;
    }
    if ([xPostions containsObject:BOARD_1x1])
    {
        if ([xPostions containsObject:BOARD_1x2] && [[gameBoardStatus valueForKey:BOARD_1x0] intValue] == Slot_Empty)
            return BOARD_1x0;
        if ([xPostions containsObject:BOARD_2x2] && [[gameBoardStatus valueForKey:BOARD_0x0] intValue] == Slot_Empty)
            return BOARD_0x0;
        if ([xPostions containsObject:BOARD_2x0] && [[gameBoardStatus valueForKey:BOARD_0x2] intValue] == Slot_Empty)
            return BOARD_0x2;
    }
    if ([xPostions containsObject:BOARD_1x2])
    {
        if ([xPostions containsObject:BOARD_2x2] && [[gameBoardStatus valueForKey:BOARD_0x2] intValue] == Slot_Empty)
            return BOARD_0x2;
    }
    if ([xPostions containsObject:BOARD_2x0])
    {
        if ([xPostions containsObject:BOARD_2x1] && [[gameBoardStatus valueForKey:BOARD_2x2] intValue] == Slot_Empty)
            return BOARD_2x2;
        if ([xPostions containsObject:BOARD_2x2] && [[gameBoardStatus valueForKey:BOARD_2x1] intValue] == Slot_Empty)
            return BOARD_2x1;
    }
    if ([xPostions containsObject:BOARD_2x1])
    {
        if ([xPostions containsObject:BOARD_2x2] && [[gameBoardStatus valueForKey:BOARD_2x0] intValue] == Slot_Empty)
            return BOARD_2x0;
    }
    return nil;
}

-(NSString *)getWinningPosition
{
    NSArray *oPostions = [gameBoardStatus allKeysForObject:[NSNumber numberWithInt:Slot_O]];
    if ([oPostions containsObject:BOARD_0x0])
    {
        if ([oPostions containsObject:BOARD_0x1] && [[gameBoardStatus valueForKey:BOARD_0x2] intValue] == Slot_Empty)
            return BOARD_0x2;
        if ([oPostions containsObject:BOARD_0x2] && [[gameBoardStatus valueForKey:BOARD_0x1] intValue] == Slot_Empty)
            return BOARD_0x1;
        if ([oPostions containsObject:BOARD_1x0] && [[gameBoardStatus valueForKey:BOARD_2x0] intValue] == Slot_Empty)
            return BOARD_2x0;
        if ([oPostions containsObject:BOARD_2x0] && [[gameBoardStatus valueForKey:BOARD_1x0] intValue] == Slot_Empty)
            return BOARD_1x0;
        if ([oPostions containsObject:BOARD_1x1] && [[gameBoardStatus valueForKey:BOARD_2x2] intValue] == Slot_Empty)
            return BOARD_2x2;
        if ([oPostions containsObject:BOARD_2x2] && [[gameBoardStatus valueForKey:BOARD_1x1] intValue] == Slot_Empty)
            return BOARD_1x1;
    }
    if ([oPostions containsObject:BOARD_0x1])
    {
        if ([oPostions containsObject:BOARD_0x2] && [[gameBoardStatus valueForKey:BOARD_0x0] intValue] == Slot_Empty)
            return BOARD_0x0;
        if ([oPostions containsObject:BOARD_1x1] && [[gameBoardStatus valueForKey:BOARD_2x1] intValue] == Slot_Empty)
            return BOARD_2x1;
        if ([oPostions containsObject:BOARD_2x1] && [[gameBoardStatus valueForKey:BOARD_1x1] intValue] == Slot_Empty)
            return BOARD_1x1;
    }
    if ([oPostions containsObject:BOARD_0x2])
    {
        if ([oPostions containsObject:BOARD_1x2] && [[gameBoardStatus valueForKey:BOARD_2x2] intValue] == Slot_Empty)
            return BOARD_2x2;
        if ([oPostions containsObject:BOARD_2x2] && [[gameBoardStatus valueForKey:BOARD_1x2] intValue] == Slot_Empty)
            return BOARD_1x2;
        if ([oPostions containsObject:BOARD_1x1] && [[gameBoardStatus valueForKey:BOARD_2x0] intValue] == Slot_Empty)
            return BOARD_2x0;
        if ([oPostions containsObject:BOARD_2x0] && [[gameBoardStatus valueForKey:BOARD_1x1] intValue] == Slot_Empty)
            return BOARD_1x1;
    }
    if ([oPostions containsObject:BOARD_1x0])
    {
        if ([oPostions containsObject:BOARD_2x1] && [[gameBoardStatus valueForKey:BOARD_0x0] intValue] == Slot_Empty)
            return BOARD_0x0;
        if ([oPostions containsObject:BOARD_1x1] && [[gameBoardStatus valueForKey:BOARD_1x2] intValue] == Slot_Empty)
            return BOARD_1x2;
        if ([oPostions containsObject:BOARD_1x2] && [[gameBoardStatus valueForKey:BOARD_1x0] intValue] == Slot_Empty)
            return BOARD_1x0;
    }
    if ([oPostions containsObject:BOARD_1x1])
    {
        if ([oPostions containsObject:BOARD_1x2] && [[gameBoardStatus valueForKey:BOARD_1x0] intValue] == Slot_Empty)
            return BOARD_1x0;
        if ([oPostions containsObject:BOARD_2x2] && [[gameBoardStatus valueForKey:BOARD_0x0] intValue] == Slot_Empty)
            return BOARD_0x0;
        if ([oPostions containsObject:BOARD_2x0] && [[gameBoardStatus valueForKey:BOARD_0x2] intValue] == Slot_Empty)
            return BOARD_0x2;
    }
    if ([oPostions containsObject:BOARD_1x2])
    {
        if ([oPostions containsObject:BOARD_2x2] && [[gameBoardStatus valueForKey:BOARD_0x2] intValue] == Slot_Empty)
            return BOARD_0x2;
    }
    if ([oPostions containsObject:BOARD_2x0])
    {
        if ([oPostions containsObject:BOARD_2x1] && [[gameBoardStatus valueForKey:BOARD_2x2] intValue] == Slot_Empty)
            return BOARD_2x2;
        if ([oPostions containsObject:BOARD_2x2] && [[gameBoardStatus valueForKey:BOARD_2x1] intValue] == Slot_Empty)
            return BOARD_2x1;
    }
    if ([oPostions containsObject:BOARD_2x1])
    {
        if ([oPostions containsObject:BOARD_2x2] && [[gameBoardStatus valueForKey:BOARD_2x0] intValue] == Slot_Empty)
            return BOARD_2x0;
    }
    return nil;
}

-(NSString *)getEmptyPostion
{
    NSArray *emptyPostions = [gameBoardStatus allKeysForObject:[NSNumber numberWithInt:Slot_Empty]];
    if ([emptyPostions count] > 0)
        return [emptyPostions objectAtIndex:0];
    return nil;
}

-(void)makeAIMoveat:(NSString *)move
{
    [gameBoardStatus setValue:[NSNumber numberWithInt:Slot_O] forKey:move];
    [boardArray removeObject:move];
    UIImage *oImage = [UIImage imageNamed:@"O.png"];
    
    if ([move isEqualToString:BOARD_0x0])
        img_Slot0x0.image = oImage;
    if ([move isEqualToString:BOARD_0x1])
        img_Slot0x1.image = oImage;
    if ([move isEqualToString:BOARD_0x2])
        img_Slot0x2.image = oImage;
    if ([move isEqualToString:BOARD_1x0])
        img_Slot1x0.image = oImage;
    if ([move isEqualToString:BOARD_1x1])
        img_Slot1x1.image = oImage;
    if ([move isEqualToString:BOARD_1x2])
        img_Slot1x2.image = oImage;
    if ([move isEqualToString:BOARD_2x0])
        img_Slot2x0.image = oImage;
    if ([move isEqualToString:BOARD_2x1])
        img_Slot2x1.image = oImage;
    if ([move isEqualToString:BOARD_2x2])
        img_Slot2x2.image = oImage;
    
    [self.view setUserInteractionEnabled:TRUE];
    [self.view setAlpha:1.0];
    
    BOOL win = [self checkForWin];
    if (!win && [[gameBoardStatus allKeysForObject:[NSNumber numberWithInt:Slot_Empty]] count] == 0)
    {
        [lbl_Player setText:[NSString stringWithFormat:@"Game Tie"]];
        [lbl_Player setTextColor:[UIColor greenColor]];
        
        gameResultAlert = [[UIAlertView alloc] initWithTitle:@"Its a Tie" message:@"Try again?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Retry", nil];
        [gameResultAlert show];
        ++totalMatches;
        [lbl_score setText:[NSString stringWithFormat:@"%d (%d tie(s)) %d", Player1Wins,(totalMatches - (Player2Wins + Player1Wins)), Player2Wins]];
        [lbl_Totalmatches setText:[NSString stringWithFormat:@"(%d game(s))", totalMatches]];
        _gameOver = TRUE;
        return;
    }
    
    if(win)
    {
        [lbl_Player setText:[NSString stringWithFormat:@"%@ won", _Player2Name]];
        
        gameResultAlert = [[UIAlertView alloc] initWithTitle:@"You Loose!" message:@"Try again?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Retry", nil];
        //[gameResultAlert show];
        
        ++Player2Wins;
        ++totalMatches;
        [lbl_score setText:[NSString stringWithFormat:@"%d (%d tie(s)) %d", Player1Wins,(totalMatches - (Player2Wins + Player1Wins)), Player2Wins]];
        [lbl_Totalmatches setText:[NSString stringWithFormat:@"(%d game(s))", totalMatches]];
        [self animateWinner:Player_2_Turn];
        _gameOver = TRUE;
        return;
    }
    playerTurn = Player_1_Turn;
    [img_Player setImage:_Player1Image];
    [lbl_Player setText:[NSString stringWithFormat:@"%@'s turn", _Player1Name]];
    UIImage *xImage = [UIImage imageNamed:@"X.png"];
    [img_Peg setImage:xImage];
    
}

-(BOOL)prefersStatusBarHidden
{
    return TRUE;
}

-(IBAction)onReset:(id)sender
{
    [self resetGameBoard];
}

-(IBAction)onQuit:(id)sender
{
    [self.navigationController popViewControllerAnimated:FALSE];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
        [self resetGameBoard];
}

@end

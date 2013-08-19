//
//  ViewController.m
//  AirPrint
//
//  Created by Phuoc on 8/15/13.
//  Copyright (c) 2013 Phuoc. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

- (void)printDocument;
- (void)showAlertView:(NSString *)title withMessage:(NSString *)message;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)printDocument
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"CSL_Icon" ofType:@"jpg"];
    if (path == nil)
    {
        [self showAlertView:@"No Data" withMessage:nil];
        return;
    }
    NSData *myData = [NSData dataWithContentsOfFile: path];
    
    UIPrintInteractionController *pic = [UIPrintInteractionController sharedPrintController];
    
    if(pic && [UIPrintInteractionController canPrintData: myData] ) {
        
        pic.delegate = self;
        
        UIPrintInfo *printInfo = [UIPrintInfo printInfo];
        printInfo.outputType = UIPrintInfoOutputGeneral;
        printInfo.jobName = [path lastPathComponent];
        printInfo.duplex = UIPrintInfoDuplexLongEdge;
        pic.printInfo = printInfo;
        pic.showsPageRange = YES;
        pic.printingItem = myData;
        
        void (^completionHandler)(UIPrintInteractionController *, BOOL, NSError *) = ^(UIPrintInteractionController *pic, BOOL completed, NSError *error) {
            //self.content = nil;
            if (completed)
            {
                [self showAlertView:@"Success" withMessage:nil];
            }
            else if (!completed && error)
            {
                [self showAlertView:@"Faile" withMessage:@"Please, try agian!"];
//                NSLog(@"FAILED! due to error in domain %@ with error code %u", error.domain, error.code);
            }
        };
        
        [pic presentAnimated:YES completionHandler:completionHandler];
    }
}


- (void)showAlertView:(NSString *)title withMessage:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:title
                                                   message:message
                                                  delegate:self
                                         cancelButtonTitle:@"Okay"
                                         otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
}


- (IBAction)print:(id)sender
{
    [self printDocument];
}
@end

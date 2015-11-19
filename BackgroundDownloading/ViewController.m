//
//  ViewController.m
//  BackgroundDownloading
//
//  Created by Mangesh on 18/11/15.
//  Copyright © 2015 Mangesh  Tekale. All rights reserved.
//

#import "ViewController.h"
static NSString *sessionIdentifier = @"com.vatsa.backgroundtask";

@interface ViewController () <NSURLSessionDelegate, NSURLSessionDownloadDelegate>
@property (strong, nonatomic) IBOutlet UIButton *btnStart;
@property (strong, nonatomic) IBOutlet UILabel *lblMessage;
@property (strong, nonatomic) NSURLSessionConfiguration *sessionConfiguration;
@property (strong, nonatomic) IBOutlet UIProgressView *progressView;
@property (strong, nonatomic) IBOutlet UIImageView *imgView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)startButtonTapped:(UIButton*)sender {
    [sender setUserInteractionEnabled:NO];
    self.sessionConfiguration = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:sessionIdentifier];
    [self.sessionConfiguration setSessionSendsLaunchEvents:YES];
    [self.sessionConfiguration setDiscretionary:YES];
    self.sessionConfiguration.allowsCellularAccess = YES;
    NSURLSession *session = [NSURLSession sessionWithConfiguration:self.sessionConfiguration delegate:self delegateQueue:nil];

    NSURL *url = [NSURL URLWithString:@"https://upload.wikimedia.org/wikipedia/commons/3/3b/Colored-Pencils.jpg"];
    NSURLSessionDownloadTask *dataTask = [session downloadTaskWithURL:url];
    [dataTask resume];
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location {
    NSLog(@"%@",location);
    dispatch_sync(dispatch_get_main_queue(), ^{
        self.progressView.progress = 1.0;
        NSData *data = [NSData dataWithContentsOfURL:location];
        [self.imgView setImage:[UIImage imageWithData:data]];
        
    });

}
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    dispatch_sync(dispatch_get_main_queue(), ^{
        self.progressView.progress =   totalBytesWritten * 1.0/ totalBytesExpectedToWrite;

    });
    NSLog( @"%lld %lld %lld", bytesWritten, totalBytesWritten, totalBytesExpectedToWrite);
}

@end

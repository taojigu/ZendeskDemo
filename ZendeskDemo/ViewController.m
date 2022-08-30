//
//  ViewController.m
//  ZendeskDemo
//
//  Created by MacBoss on 2022/8/30.
//

#import "ViewController.h"
#import <ZendeskCoreSDK/ZendeskCoreSDK.h>
#import <SupportSDK/SupportSDK.h>
#import <SupportProvidersSDK/SupportProvidersSDK.h>
#import <ZendeskCoreSDK/ZendeskCoreSDK-Swift.h>
#import <MessagingAPI/MessagingAPI.h>
#import <MessagingSDK/MessagingSDK.h>
#import <ChatProvidersSDK/ChatProvidersSDK.h>
#import <AnswerBotProvidersSDK/AnswerBotProvidersSDK.h>
#import <AnswerBotSDK/AnswerBotSDK.h>
#import <ChatSDK/ChatSDK.h>
#import <CommonUISDK/CommonUISDK.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)initClicked:(id)sender{
    
    [ZDKZendesk initializeWithAppId: @"Your AppID"
        clientId: @"Your ClientID"
        zendeskUrl: @"Your url"];
    
    [ZDKMessaging initialize];
    [ZDKSupport initializeWithZendesk: [ZDKZendesk instance]];
    
    [ZDKAnswerBot initializeWithZendesk:[ZDKZendesk instance] support:[ZDKSupport instance]];
    [ZDKChat initializeWithAccountKey: @"Your Account Key" queue: dispatch_get_main_queue()];
    
}


- (IBAction)identityButtonClicked:(id)sender{
    
    
    NSString *email = @"taojigu@163.com";
    id<ZDKObjCIdentity> userIdentity = [[ZDKObjCAnonymous alloc] initWithName:email email:email];
    [[ZDKZendesk instance] setIdentity:userIdentity];
    

    
}

-(IBAction)pushMessageClicked:(id)sender{
    UIViewController *vc = [self conversationViewController];
    [self.navigationController pushViewController:vc animated:NO];
}


- (UIViewController *) conversationViewController {

    
    ZDKMessagingConfiguration *messagingConfiguration = [ZDKMessagingConfiguration new];
    NSError *error = nil;
    
    NSArray *engines = @[
        
        (id <ZDKEngine>) [ZDKAnswerBotEngine engineAndReturnError:&error],
        (id <ZDKEngine>) [ZDKSupportEngine engineAndReturnError:&error],
        (id <ZDKEngine>) [ZDKChatEngine engineAndReturnError:&error]
        
    ];

    return [[ZDKMessaging instance] buildUIWithEngines:engines
                                               configs:@[messagingConfiguration]
                                                 error:&error];
}


@end

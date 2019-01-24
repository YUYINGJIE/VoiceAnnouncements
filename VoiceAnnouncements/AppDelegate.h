//
//  AppDelegate.h
//  VoiceAnnouncements
//
//  Created by huahaniOSCode on 2019/1/14.
//  Copyright © 2019年 HuaHan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end


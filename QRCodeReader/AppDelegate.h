//
//  AppDelegate.h
//  QRCodeReader
//
//  Created by ZawYeNaing on 2/1/18.
//  Copyright © 2018 Zaw Ye Naing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end


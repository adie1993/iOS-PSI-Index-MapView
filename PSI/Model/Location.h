//
//  Location.h
//  PSI
//
//  Created by WGS-LAP189 on 04/05/18.
//  Copyright © 2018 Adie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Location : NSObject

@property (strong, nonatomic) NSString *nameLocation;
@property (strong, nonatomic) NSMutableDictionary *locationTag;
-(instancetype)initWithJson:(NSDictionary*)dict;

@end

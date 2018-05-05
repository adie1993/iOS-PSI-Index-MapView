//
//  PSIService.h
//  PSI
//
//  Created by WGS-LAP189 on 04/05/18.
//  Copyright © 2018 Adie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PSIService : NSObject

typedef void(^successWithDictionary)(NSDictionary*);

typedef void(^failureWithDictionary)(NSDictionary*);

- (void)getMapPSI:(successWithDictionary)success failure:(failureWithDictionary)failure;
@end

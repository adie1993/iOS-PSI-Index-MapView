//
//  Location.m
//  PSI
//
//  Created by WGS-LAP189 on 04/05/18.
//  Copyright © 2018 Adie. All rights reserved.
//

#import "Location.h"

@implementation Location

-(instancetype)initWithJson:(NSDictionary*)dict {
    self = [super init];
    
    @try {        
        self.nameLocation = dict[@"name"];
        NSMutableDictionary *dictLoc = [[NSMutableDictionary alloc] init];
        dictLoc = dict[@"label_location"];
        if (![dictLoc isKindOfClass:[NSNull class]]) {
            self.locationTag = dictLoc;
        }
    } @catch (NSException *exception) {
        NSLog(@"exception.name %@", exception.name);
        NSLog(@"exception.reason %@", exception.reason);
    } @finally {
        return self;
    }
    
}
@end

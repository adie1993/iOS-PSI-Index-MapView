//
//  PSITests.m
//  PSITests
//
//  Created by WGS-LAP189 on 05/05/18.
//  Copyright © 2018 Adie. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <Quick/Quick.h>
@import Nimble;
#import "PSIMapViewController.h"

QuickSpecBegin(PSIMapViewControllerSpec)

__block PSIMapViewController *viewController = nil;

describe(@"-viewDidLoad", ^{
    beforeEach(^{
        viewController = [[PSIMapViewController alloc] init];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        viewController = [storyboard instantiateViewControllerWithIdentifier:@"mapViewController"];
        [viewController viewDidLoad];
    });
   
    context(@"when view is loaded", ^{
        
        it(@"should have 0 locations loaded", ^{
            expect([[viewController locations] count]).to(equal(@0));
        });
        
        
    });
    
    
});



QuickSpecEnd

QuickSpecBegin(MapStyleSpec)

__block NSURL *filePath = nil;
describe(@"styleGmaps", ^{
    beforeEach(^{
        filePath = [[NSBundle mainBundle] URLForResource:@"styles" withExtension:@"json"];
    });
    
    context(@"when filepath is loaded", ^{
        
        it(@"should not be null", ^{
            expect(filePath).toNot(beNil());
        });
        
        
    });
    
    
});



QuickSpecEnd



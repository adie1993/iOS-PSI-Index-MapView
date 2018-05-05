//
//  PSIMapViewController.h
//  PSI
//
//  Created by WGS-LAP189 on 04/05/18.
//  Copyright © 2018 Adie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import "Location.h"
#import "BaseClassViewController.h"
@interface PSIMapViewController : BaseClassViewController<UICollectionViewDelegate,UICollectionViewDataSource,GMSMapViewDelegate>
@property (strong, nonatomic) IBOutlet GMSMapView *gmaps;

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UIButton *btnShow;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *heightInfoConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bottomInfoConstraint;
@property(nonatomic,retain) NSMutableArray <Location*>* locations;
@property (nonatomic,retain) NSArray *dataLocations;

@end

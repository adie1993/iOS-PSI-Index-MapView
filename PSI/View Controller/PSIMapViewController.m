//
//  PSIMapViewController.m
//  PSI
//
//  Created by WGS-LAP189 on 04/05/18.
//  Copyright © 2018 Adie. All rights reserved.
//

#import "PSIMapViewController.h"
#import "InfoCollectionViewCell.h"
@interface PSIMapViewController (){
    PSIService *service;
    BOOL isShow;
    NSMutableArray *allMarker;
}

@end

@implementation PSIMapViewController


- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"InformationCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"CollectionViewCell"];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    self.locations = [[NSMutableArray alloc] init];
    service  = [[PSIService alloc] init];
    
    self.bottomInfoConstraint.constant -= self.collectionView.frame.size.height;
    [self getPSIMap];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSURL *filePath = [[NSBundle mainBundle] URLForResource:@"styles" withExtension:@"json"];
    NSError *error;
    GMSMapStyle *style = [GMSMapStyle styleWithContentsOfFileURL:filePath error:&error];
    if (!style) {
        NSLog(@"The style definition could not be loaded: %@", error);
    }
    self.gmaps.mapStyle = style;
    [self.navigationController.navigationBar setHidden:YES];
}

-(void) getPSIMap{
    service  = [[PSIService alloc] init];
    [service getMapPSI:^(NSDictionary *result) {
        
        
        [self.locations removeAllObjects];
        self.dataLocations = [result objectForKey:@"region_metadata"];
        
        for (NSDictionary *dict in self.dataLocations) {
            if([dict[@"name"] isEqualToString:@"national"] && [dict[@"label_location"][@"latitude"] doubleValue]==0 && [dict[@"label_location"][@"longitude"] doubleValue]==0){
                continue;
            }else{
                [self.locations addObject:[[Location alloc] initWithJson:dict]];
            }
            
        }
        [self.collectionView reloadData];
        [self showMapmarker];
        
    } failure:^(NSDictionary *error) {
        @try {
            [self checkCodeError:error];
        } @catch (NSException *exception) {
            if ([exception.reason isEqualToString:@"service error"]) {
                [self showAlertRetryCancelWithTitle:@"Info" withMessage:@"Service Error" withRetryHandler:^(UIAlertAction * _Nonnull action) {
                    [self getPSIMap];
                } withCancelHandler:^(UIAlertAction * _Nonnull action) {
                    
                }];
            }
        }
    }];
}


-(void)showMapmarker{
    [self.gmaps clear];
    GMSCoordinateBounds *bounds = [[GMSCoordinateBounds alloc] init];
    allMarker = [[NSMutableArray alloc] init];
    for(Location *loc in self.locations){
        
        CLLocationCoordinate2D position = CLLocationCoordinate2DMake([loc.locationTag[@"latitude"] doubleValue], [loc.locationTag[@"longitude"] doubleValue]);
        GMSMarker *marker = [GMSMarker markerWithPosition:position];
        marker.title = [NSString stringWithFormat:@"%@", loc.nameLocation];
        marker.snippet = [NSString stringWithFormat:@"%@", loc.nameLocation];
        marker.map = self.gmaps;
        bounds = [bounds includingCoordinate:marker.position];
        marker.appearAnimation = kGMSMarkerAnimationPop;
        marker.tracksViewChanges = YES;
        marker.tracksInfoWindowChanges =YES;
        [allMarker addObject:marker];
    }
    [self.gmaps animateWithCameraUpdate:[GMSCameraUpdate fitBounds:bounds withPadding:30.0f]];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)btnShow:(id)sender {
    if(isShow){
        self.bottomInfoConstraint.constant -= self.collectionView.frame.size.height;
        
        [UIView animateWithDuration:0.2 delay:0 options:(UIViewAnimationCurveEaseOut << 16) animations:^{
            [self.btnShow setImage:[UIImage imageNamed:@"ic-show"] forState:UIControlStateNormal];
          
            
            [self.view layoutIfNeeded];
        } completion:^(BOOL completed){
            self->isShow =NO;
        }];
    }else{
        self.bottomInfoConstraint.constant += self.collectionView.frame.size.height;
        
        [UIView animateWithDuration:0.2 delay:0 options:(UIViewAnimationCurveEaseOut << 16) animations:^{
            
            [self.btnShow setImage:[UIImage imageNamed:@"ic-close"] forState:UIControlStateNormal];
            
            [self.view layoutIfNeeded];
        } completion:^(BOOL completed){
            self->isShow =YES;
        }];
    }
}

#pragma mark collection view
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(CGRectGetWidth(self.collectionView.frame)/2, (CGRectGetHeight(self.collectionView.frame)));
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.locations.count;
}

-(void)viewWillDisappear:(BOOL)animated{
    
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"CollectionViewCell";
    
    
    InfoCollectionViewCell *cell = (InfoCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    cell.labelText.text = self.locations[indexPath.row].nameLocation;
    [cell.labelText sizeToFit];
    ;
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    CLLocationCoordinate2D position = CLLocationCoordinate2DMake([self.locations[indexPath.row].locationTag[@"latitude"] doubleValue], [self.locations[indexPath.row].locationTag[@"longitude"] doubleValue]);
    [self.gmaps animateWithCameraUpdate:[GMSCameraUpdate setTarget:position zoom:15]];
    GMSMarker *mark = [allMarker objectAtIndex:indexPath.row];
    self.gmaps.selectedMarker = mark;
}
@end

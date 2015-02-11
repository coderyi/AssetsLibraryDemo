//
//  PhotoViewController.m
//  AssetsLibraryDemo
//
//  Created by coderyi on 14-10-16.
//  Copyright (c) 2014年 coderyi. All rights reserved.
//

#import "PhotoViewController.h"

@interface PhotoViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>{
    UICollectionView *cv;
    NSMutableArray *imageArray;
}

@end

@implementation PhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //    适配iOS7导航栏
    if (iOS7) {
        self.edgesForExtendedLayout = UIRectEdgeBottom | UIRectEdgeLeft | UIRectEdgeRight;
        
    }
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
    layout.itemSize=CGSizeMake(80.0f, 80.0f);
   
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical]; //控制滑动分页用
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    cv=[[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, WScreen, HScreen-64) collectionViewLayout:layout];
    [cv registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    cv.backgroundColor=[UIColor clearColor];

    [cv setUserInteractionEnabled:YES];
    cv.dataSource=self;
    cv.delegate=self;
    [self.view addSubview:cv];
    imageArray=[[NSMutableArray alloc] initWithCapacity:1];
    [_group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
        if (result) {
            [imageArray addObject:result];
            NSLog(@"%@",result);
            [cv reloadData];
        }
    }];
    
    
    
}
#pragma mark collectionView
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0f;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [imageArray count];
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    UIImageView *iv=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 70, 70)];
    [cell.contentView addSubview:iv];
    iv.image=[UIImage imageWithCGImage:((ALAsset *)[imageArray objectAtIndex:indexPath.row]).thumbnail];
    NSString *type=[((ALAsset *)[imageArray objectAtIndex:indexPath.row]) valueForProperty:ALAssetPropertyType];
    if ([type isEqualToString:@"ALAssetTypeVideo"]) {
        UIImageView *iv1=[[UIImageView alloc] initWithFrame:CGRectMake(0, 60, 15, 8)];
        [cell.contentView addSubview:iv1];
        iv1.image=[UIImage imageNamed:@"AssetsPickerVideo@2x"];
        UILabel *label1=[[UILabel alloc] initWithFrame:CGRectMake(10, 55, 55, 15)];
        label1.textAlignment=NSTextAlignmentRight;
        label1.textColor=[UIColor whiteColor];
        label1.font=[UIFont systemFontOfSize:10];
        
        int time=[[((ALAsset *)[imageArray objectAtIndex:indexPath.row]) valueForProperty:ALAssetPropertyDuration] intValue];
       
        if (time/60<1) {
            NSString *timeString=[NSString stringWithFormat:@"%d",time];
            label1.text=timeString;
        }else if (time/3600<1){
            NSString *timeString=[NSString stringWithFormat:@"%d:%d",time/60,time%60];
            label1.text=timeString;
        }else{
            NSString *timeString=[NSString stringWithFormat:@"%d:%d:%d",time/3600,((time%3600)/60),time%3600%60];
            label1.text=timeString;
        }
      
        [cell.contentView addSubview:label1];
        
    }
    
    return cell;
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
  
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

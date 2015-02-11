//
//  DemoListViewController.m
//  AssetsLibraryDemo
//
//  Created by coderyi on 14-10-16.
//  Copyright (c) 2014年 coderyi. All rights reserved.
//

#import "PhotoListViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "PhotoViewController.h"
@interface PhotoListViewController ()<UITableViewDataSource,UITableViewDelegate>{
    ALAssetsLibrary *assetsLibrary;
    NSMutableArray *groupArray;
    
    UITableView  *tableView;
    
}

@end

@implementation PhotoListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
    if (iOS7) {
       self.edgesForExtendedLayout = UIRectEdgeBottom | UIRectEdgeLeft | UIRectEdgeRight;
   
    }
    
    tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, WScreen, HScreen-64) style:UITableViewStyleGrouped];
    
    [self.view addSubview:tableView];

    tableView.dataSource=self;
    tableView.delegate=self;
    tableView.rowHeight=80;
    assetsLibrary = [[ALAssetsLibrary alloc] init];
    groupArray=[[NSMutableArray alloc] initWithCapacity:1];
    
    
    [self getGroups];

}
-(void)getGroups{
    [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        if (group) {
            [groupArray addObject:group];
            [tableView reloadData];
            //            通过这个可以知道相册的名字，从而也可以知道安装的部分应用
            //例如 Name:柚子相机, Type:Album, Assets count:1
            NSLog(@"%@",group);
          
        }
    } failureBlock:^(NSError *error) {
        NSLog(@"Group not found!\n");
    }];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return groupArray.count;
}




// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *CellId = @"CellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellId];
      
    }
    cell.textLabel.text=[((ALAssetsGroup *)[groupArray objectAtIndex:indexPath.section]) valueForProperty:ALAssetsGroupPropertyName];
    cell.imageView.image=[UIImage imageWithCGImage:((ALAssetsGroup *)[groupArray objectAtIndex:indexPath.section]).posterImage];
    cell.detailTextLabel.text=[NSString stringWithFormat:@"%d",[((ALAssetsGroup *)[groupArray objectAtIndex:indexPath.section]) numberOfAssets]] ;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PhotoViewController *vc=[[PhotoViewController alloc] init];
    vc.group=((ALAssetsGroup *)[groupArray objectAtIndex:indexPath.section]);
    
    [self.navigationController pushViewController:vc animated:YES];
    
    
    
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

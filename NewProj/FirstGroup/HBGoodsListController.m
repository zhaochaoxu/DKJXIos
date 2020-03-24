//
//  HBGoodsListController.m
//  NewProj
//
//  Created by 胡贝 on 2019/3/7.
//  Copyright © 2019年 胡贝. All rights reserved.
//

#import "HBGoodsListController.h"
#import "GoodsListCell.h"
#import "RYMacro.h"
#import "HBApiTool.h"
#import "MWPhoto.h"
#import "MWPhotoBrowser.h"

@interface HBGoodsListController ()<UITableViewDelegate,UITableViewDataSource,MWPhotoBrowserDelegate>

@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *imgsArray;
@property (nonatomic,strong) NSMutableArray *MwPhotos;


@end

@implementation HBGoodsListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.imgsArray = [NSMutableArray array];
    self.MwPhotos = [NSMutableArray array];
    [self setupUI];
    [self loadImgsData];

}

- (void)setupUI {
    
    self.title = @"商品列表";
//    [self.view addSubview:self.tableView];
    self.view.backgroundColor = [UIColor blackColor];
    

    

}

- (void)loadImgsData {
    kWEAK_SELF;
    [HBApiTool picBrowseGet:[[self.imgDict objectForKey:@"id"] intValue]
                    success:^(NSDictionary * dic) {
                        
                        [self pushPhoto:dic];
                        
                    } failure:^(NSError * error) {
        
    }];
}

- (void)pushPhoto:(NSDictionary *)data
{

    _MwPhotos = [NSMutableArray array];
    
    NSArray *array = [data objectForKey:@"picture"];
    [array enumerateObjectsUsingBlock:^(NSDictionary  *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *url = [obj objectForKey:@"url"];
        MWPhoto *photo = [MWPhoto photoWithURL:[NSURL URLWithString:url]];
        [self->_MwPhotos addObject:photo];
    }];
    
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.zoomPhotosToFill = YES;
    [browser setCurrentPhotoIndex:0];
    browser.displayNavArrows = NO;
    browser.alwaysShowControls = NO;
    
    browser.enableGrid = YES;
    browser.startOnGrid = YES;
    browser.autoPlayOnAppear = NO;
    browser.displayActionButton = NO;
    [browser.view setFrame:CGRectMake(0, -20, kWidth, KHeight)];
    [self.navigationController pushViewController:browser animated:YES];
    [browser.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:19.0]}];
    
    //    [self.navigationController pushViewController:browser animated:YES];
    
    [browser showNextPhotoAnimated:NO];
    [browser showPreviousPhotoAnimated:YES];
    
}

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return _MwPhotos.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < _MwPhotos.count) {
        return [_MwPhotos objectAtIndex:index];
    }
    return nil;
}
- (NSString *)photoBrowser:(MWPhotoBrowser *)photoBrowser titleForPhotoAtIndex:(NSUInteger)index{
    NSString *title = [NSString stringWithFormat:@"%@/%@",@(index),@(_MwPhotos.count)];
    return title;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.goodslist.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    static NSString *cellIdentifier = @"goodslist";
    GoodsListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[GoodsListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
    }
    
    cell.dict = self.goodslist[indexPath.row];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if ([self.delegate respondsToSelector:@selector(HBGoodsListControllerDeleagteWithValue:)]) {
        [self.delegate HBGoodsListControllerDeleagteWithValue:@"321"];
    }
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (UITableView *)tableView {
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kWidth, KHeightL) style:UITableViewStyleGrouped];
        tableView.backgroundColor = RYBackgroundColor;
        tableView.separatorStyle = UITableViewCellEditingStyleNone;
        tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
        tableView.delegate = self;
        tableView.dataSource = self;
        [self.view addSubview:tableView];
        _tableView = tableView;
        
    }
    return _tableView;
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

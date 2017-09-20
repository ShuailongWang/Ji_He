//
//  ViewController.m
//  ios_demo_001
//
//  Created by admin on 17/9/19.
//  Copyright © 2017年 wsl. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) NSArray *myData;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self setupUI];
}


- (void)setupUI{
    if (nil == _myTableView) {
        _myTableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        _myTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
        [self.view addSubview:_myTableView];
    }
}



#pragma mark - UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.myData.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellID"];
    if (nil == cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellID"];
    }
    
    NSDictionary *dict = self.myData[indexPath.row];
    cell.textLabel.text = dict[@"Title"];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dict = self.myData[indexPath.row];
    
    NSString *vcName = dict[@"VCName"];
    if (![vcName isEqualToString:@""]) {
        id vc =  [[NSClassFromString(vcName) alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}


#pragma mark - lan
-(NSArray *)myData{
    if (nil == _myData) {//
        _myData = @[@{@"Title": @"指纹识别", @"VCName" : @"TouchViewController"},
                    @{@"Title": @"运动传感器", @"VCName" : @"MotionViewController"},
                    @{@"Title": @"重力感应", @"VCName" : @"PictureMotionViewController"},
                    @{@"Title": @"加速计小球", @"VCName" : @"BallViewController"},
                    @{@"Title": @"光感感应", @"VCName" : @"ListenViewController"},
                    @{@"Title": @"距离感应", @"VCName" : @"DistanceViewController"},
                    @{@"Title": @"计步器", @"VCName" : @"GyroscopeViewController"},
                    @{@"Title": @"摇一摇", @"VCName" : @"YaoViewController"},
                    @{@"Title": @"二维码", @"VCName" : @"QRCodeViewController"},
                    ];
    }
    return _myData;
}

@end

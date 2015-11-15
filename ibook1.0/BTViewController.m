//
//  BTViewController.m
//  MYsearchdisplaycontroller
//
//  Created by 张欣琳 on 14-9-9.
//  Copyright (c) 2014年 张欣琳. All rights reserved.
//

#import "BTViewController.h"
#import "commonhead.h"
@interface BTViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UISearchDisplayDelegate, UIAlertViewDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_dataArray;//数据源
    NSMutableArray *_resultsData;//搜索结果数据
    UISearchBar *mySearchBar;
    
    UISearchDisplayController *mySearchDisplayController;
    
}
@property (copy, nonatomic) NSString *choosemessage;
@property (strong , nonatomic) UIAlertView *alertview;
@end

@implementation BTViewController

- (UIAlertView *)alertview
{
    if (_alertview == nil) {
        _alertview = [[UIAlertView alloc] initWithTitle:@"您已选择" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",@"取消", nil];
    }
    
    return  _alertview;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;
    
    _dataArray = [NSMutableArray array];
    _resultsData = [NSMutableArray array];
    
    [self initNav];
    [self initDataSource];
    [self initTableView];
    [self initMysearchBarAndMysearchDisPlay];
}

-(void)initDataSource
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"schooldatas.plist" ofType:nil];
    _dataArray = [NSMutableArray arrayWithContentsOfFile:path];
}

-(void)initNav{
    //状态栏的背景颜色
    
    UILabel *twoL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, is_IOS_7?64:44)];
    twoL.backgroundColor = RGBACOLOR(249,249,249,1);
    [self.view addSubview:twoL];
    
    UILabel *navLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,is_IOS_7?20:0, self.view.frame.size.width, 44)];
    navLabel.backgroundColor = [UIColor clearColor];
    navLabel.textColor = RGBACOLOR(11, 104, 210, 1);
    navLabel.text = @"搜素学校";
    navLabel.font = [UIFont systemFontOfSize:18];
    navLabel.textAlignment = NSTextAlignmentCenter;
    navLabel.userInteractionEnabled = YES;
    [self.view addSubview:navLabel];
}


- (void)initTableView
{
    _tableView = [[UITableView alloc] init];
    _tableView.frame = CGRectMake(0, is_IOS_7?64:44, self.view.frame.size.width, SCREEN_HEIGHT-64);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.tableHeaderView = [[UIView alloc] init];
    _tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_tableView];
    
    if (is_IOS_7)
        //分割线的位置不带偏移
        _tableView.separatorInset = UIEdgeInsetsZero;
}

-(void)initMysearchBarAndMysearchDisPlay
{
    mySearchBar = [[UISearchBar alloc] init];
    mySearchBar.delegate = self;
//    //设置选项
//    [mySearchBar setScopeButtonTitles:[NSArray arrayWithObjects:@"First",@"Last",nil]];
    [mySearchBar setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [mySearchBar sizeToFit];
    mySearchBar.backgroundColor = RGBACOLOR(249,249,249,1);
    mySearchBar.backgroundImage = [self imageWithColor:[UIColor clearColor] size:mySearchBar.bounds.size];
    //加入列表的header里面
    _tableView.tableHeaderView = mySearchBar;
    
    mySearchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:mySearchBar contentsController:self];
    mySearchDisplayController.delegate = self;
    mySearchDisplayController.searchResultsDataSource = self;
    mySearchDisplayController.searchResultsDelegate = self;
}

#pragma mark UISearchBar and UISearchDisplayController Delegate Methods

//searchBar开始编辑时改变取消按钮的文字
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    mySearchBar.showsCancelButton = YES;
    
    NSArray *subViews;

    if (is_IOS_7) {
        subViews = [(mySearchBar.subviews[0]) subviews];
    }
    else {
        subViews = mySearchBar.subviews;
    }
    
    for (id view in subViews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton* cancelbutton = (UIButton* )view;
            [cancelbutton setTitle:@"取消" forState:UIControlStateNormal];
            break;
        }
    }
}

-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    //準備搜尋前，把上面調整的TableView調整回全屏幕的狀態
    [UIView animateWithDuration:1.0 animations:^{
        _tableView.frame = CGRectMake(0, 20, self.view.frame.size.width, SCREEN_HEIGHT-20);
    }];
    
    return YES;
}

-(BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    //搜尋結束後，恢復原狀
    [UIView animateWithDuration:1.0 animations:^{
        _tableView.frame = CGRectMake(0, is_IOS_7?64:44, self.view.frame.size.width, SCREEN_HEIGHT-64);
    }];
    
    return YES;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller

shouldReloadTableForSearchString:(NSString *)searchString

{
    //一旦SearchBar輸入內容有變化，則執行這個方法，詢問要不要重裝searchResultTableView的數據
    
    // Return YES to cause the search result table view to be reloaded.
    
    [self filterContentForSearchText:searchString
                               scope:[mySearchBar scopeButtonTitles][mySearchBar.selectedScopeButtonIndex]];
    
    return YES;
}


- (BOOL)searchDisplayController:(UISearchDisplayController *)controller

shouldReloadTableForSearchScope:(NSInteger)searchOption

{
    //如果设置了选项，当Scope Button选项有變化的时候，則執行這個方法，詢問要不要重裝searchResultTableView的數據
    
    // Return YES to cause the search result table view to be reloaded.
    
    [self filterContentForSearchText:mySearchBar.text
                               scope:mySearchBar.scopeButtonTitles[searchOption]];
    
    return YES;
}

//源字符串内容是否包含或等于要搜索的字符串内容
-(void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSMutableArray *tempResults = [NSMutableArray array];
    NSUInteger searchOptions = NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch;
    
    for (int i = 0; i < _dataArray.count; i++) {
        NSString *storeString = _dataArray[i];
        NSRange storeRange = NSMakeRange(0, storeString.length);
        NSRange foundRange = [storeString rangeOfString:searchText options:searchOptions range:storeRange];
        if (foundRange.length) {
            [tempResults addObject:storeString];
        }
    }
    
    [_resultsData removeAllObjects];
    [_resultsData addObjectsFromArray:tempResults];
}

#pragma mark - tableView代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //searchDisplayController自身有一个searchResultsTableView，所以在执行操作的时候首先要判断是否是搜索结果的tableView，如果是显示的就是搜索结果的数据，如果不是，则显示原始数据。
    
    if(tableView == mySearchDisplayController.searchResultsTableView)
    {
        tableView.frame = CGRectMake(0, 20, self.view.frame.size.width, SCREEN_HEIGHT-20);
        //解决上面空出的20个像素
        self.edgesForExtendedLayout = UIRectEdgeNone;
       
        if (is_IOS_7)
            //分割线的位置不带偏移
            tableView.separatorInset = UIEdgeInsetsZero;

        return _resultsData.count;
    }
    else
    {
        return _dataArray.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *myCell = @"cell_identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:myCell];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myCell];
    }
    
    while ([cell.contentView.subviews lastObject] != nil) {
        [(UIView *)[cell.contentView.subviews lastObject] removeFromSuperview];
    }
    
    if (tableView == mySearchDisplayController.searchResultsTableView)
    {
        cell.textLabel.text = _resultsData[indexPath.row];
    }
    else
    {
        cell.textLabel.text = _dataArray[indexPath.row];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //取消选中
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (tableView == mySearchDisplayController.searchResultsTableView)
    {
        [self myAlertViewAccording:_resultsData[indexPath.row]];
    }
    else
    {
        [self myAlertViewAccording:_dataArray[indexPath.row]];
    }
}

-(void)myAlertViewAccording:(NSString *)content
{
//    UIActionSheet *sheet  = [[UIActionSheet alloc] initWithTitle:@"您已选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"确定", nil];
//    [sheet showInView:self.view];
    
    self.alertview.message = content;
    self.choosemessage = content;
    [self.alertview show];
    
    
}

//取消searchbar背景色
- (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self dismissViewControllerAnimated:YES completion:nil];
        if ([self.delegate respondsToSelector:@selector(BTViewControllerchooseschoolname:)]) {
            [self.delegate BTViewControllerchooseschoolname:self.choosemessage];
        }
    }
}

@end

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com

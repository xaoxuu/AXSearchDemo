//
//  ViewController.m
//  AXSearchDemo
//
//  Created by xaoxuu on 10/04/2017.
//  Copyright © 2017 Titan Studio. All rights reserved.
//

#import "ViewController.h"

#define kScreenW [UIScreen mainScreen].bounds.size.width

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

// @xaoxuu: search bar
@property (strong, nonatomic) UISearchBar *searchBar;
// @xaoxuu: result dc
@property (weak, nonatomic) IBOutlet UITableView *tableView;


// @xaoxuu: data
@property (strong, nonatomic) NSArray *sources;

// @xaoxuu: results
@property (strong, nonatomic) NSMutableArray *results;

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"LOL科普：地名大全";
    
    
    //    self.searchBar.scopeButtonTitles = [NSArray arrayWithObjects:@"BOY",@"GIRL",@"ALL",nil];
    
    
    self.tableView.tableHeaderView = self.searchBar;
}


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self _endEditing];
}

- (void)_endEditing{
    self.searchBar.showsCancelButton = NO;
    self.searchBar.text = nil;
    [self.searchBar resignFirstResponder];
}

- (UISearchBar *)searchBar{
    if (!_searchBar) {
        // create it
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 44)];
        _searchBar.delegate = self;
        // style
        _searchBar.searchBarStyle = UISearchBarStyleMinimal;
        _searchBar.tintColor = [UIColor blueColor];
        _searchBar.barTintColor = [UIColor blueColor];
        _searchBar.placeholder = @"请输入关键词";
        // do something...
        
    }
    return _searchBar;
}

- (NSArray *)sources{
    if (!_sources) {
        // create it
        _sources = @[@"国服第一臭豆腐 No.1 Stinky Tofu CN.",
                         @"瓦洛兰 Valoran",
                         @"德玛西亚 Demacia",
                         @"诺克萨斯 Noxus",
                         @"艾欧尼亚 Ionia",
                         @"皮尔特沃夫 Piltover",
                         @"弗雷尔卓德 Freijord",
                         @"班德尔城 Bandle City",
                         @"战争学院 The Institute of War",
                         @"祖安 Zaun",
                         @"卡拉曼达 Kalamanda",
                         @"蓝焰岛 Blue Flame Island",
                         @"哀嚎沼泽 Howling Marsh",
                         @"艾卡西亚 Icathia",
                         @"铁脊山脉 Ironspike Mountains",
                         @"库莽古丛林 Kumungu",
                         @"洛克法 Lokfar",
                         @"摩根小道 Morgon Pass",
                         @"塔尔贡山脉 Mountain Targon",
                         @"瘟疫丛林 Plague Jungles",
                         @"盘蛇河 Serpentine River",
                         @"恕瑞玛沙漠 Shurima Desert",
                         @"厄尔提斯坦 Urtistan",
                         @"巫毒之地 Voodoo Lands",
                         @"水晶之痕 Crystal Scar",
                         @"咆哮深渊 Howling Abyss",
                         @"熔岩洞窟 Magma Chambers",
                         @"试炼之地 Proving Grounds",
                         @"召唤师峡谷 Summoner's Rift",
                         @"扭曲丛林 Twisted Treeline"];
    }
    return _sources;
}
- (NSMutableArray *)results{
    if (!_results) {
        // create it
        _results = [NSMutableArray array];
        // do something...
        
    }
    return _results;
}



#pragma mark - search bar delegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    searchBar.showsCancelButton = YES;
    for(id cc in [searchBar subviews])
    {
        for (UIView *view in [cc subviews]) {
            if ([NSStringFromClass(view.class)                 isEqualToString:@"UINavigationButton"])
            {
                UIButton *btn = (UIButton *)view;
                [btn setTitle:@"取消" forState:UIControlStateNormal];
            }
        }
    }
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [self _endEditing];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self _endEditing];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    [self filterContentForSearchText:searchText];
}


- (void)filterContentForSearchText:(NSString *)searchText{
    [self.results removeAllObjects];
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"SELF contains[cd] %@", searchText];
    
    self.results = [[self.sources filteredArrayUsingPredicate:resultPredicate] mutableCopy];
//    for (CamerFrameModel *tmp in self.sources) {
//        NSString *content = tmp.model.camera.explain;
//        NSRange storeRange = NSMakeRange(0, content.length);
//        NSRange foundRange = [content rangeOfString:searchText options:NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch range:storeRange];
//        if (foundRange.length) {
//            [self.results addObject:tmp];
//        }
//    }
    [self.tableView reloadData];
}

#pragma mark - table view data source

// number of sections
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

// number of rows in section
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.searchBar.text.length || self.results.count) {
        return self.results.count;
    } else{
        return self.sources.count;
    }
//    return self.results.count?:self.sources.count;
}

// cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    // dequeue reusable cell with reuse identifier
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    // do something
    if (self.searchBar.text.length || self.results.count) {
        cell.textLabel.text = self.results[indexPath.row];
    } else{
        cell.textLabel.text = self.sources[indexPath.row];
    }
    // return cell
    return cell;
}

#pragma mark table view delegate

// did select row
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // deselect row
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    // do something
    
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self _endEditing];
}



@end

## Definition 项目定义 ##
StockCalculator is an iOS App that calculates the breakeven price of the purchase and the profit or loss of the trade for China stock market participators.

针对中国A股市场的股票交易，进行交易成本和税费计算。 提供计算买卖损益和成本价格两种计算方式。 可自由定制税费比率。支持计算结果的保存，方便以后进行查看。


## Goal 目标:1.1.0.1 ##
### Progress 进度 ###
  0%[                      ]
### Task 任务 ###
* [x] 修正保存时股票代码不正确的问题
* [x] 增加买入计算和卖出计算
 + [x] 修正切换市场时自动增加一行
 + [x] 修正切换计算方式时结果自动隐藏
 + [x] 保存记录名称
 + [x] 记录详情
 + [ ] 记录图标
 + [ ] 记录文字颜色
* [ ] 优化记录展示页面
 + [ ] 均线M5, M10, M20
 + [ ] 优化显示效果
 + [ ] 优化代码
* [ ] 朋友圈分享

## Goal 目标:1.0.1.1 ##
### Progress 进度 ###
100%[==========]
### Task 任务 ###
* [x] source code url address:改为StockCalculator
 + [x] 托管至stockcalculator
 + [x] 更改App链接
* [x] order source code
 + [x] 整理issue.txt -> stockcalculator-project.md
 + [x] 调整代码结构 - 此版本不做代码重构，放入需求栈中
* [x] 根据交易记录测试并完善brain计算准确性
 + [x] 整理交易记录文件
 + [x] 测试
* [x] 兼容iOS 8 - UIStackView before iOS 9.0
* [x] 当app启动第一次进入关于页面时，在加载过程中，切换tab，则回出现关于界面加载完成后indicator没有被隐藏的结果

## Goal 目标1.0.0.3 ##
### Progress 进度 ###
100%[===================]
### Task 任务 ###
* [x] appstore审核被reject
 + [x] Version 移植about中
 + [x] about中信息改版，去掉，捐赠和资源引用url，避免被再次reject
* [x] 搜索点击列表 导航栏按钮消失
* [x] visible effect in iPhone 4s
* [x] setting detail instruction


## Goal 目标1.0.0.2 ##
### Progress 进度 ###
100%[===================]
* [x] sell改为损益计算
* [x] buy改为保本价格
* [x] segment 切换 界面随之改变
* [x] 股票代码名称 改为 股票代码
* [x] placeholder为 名称/代码
* [x] 市场 改为 股票类型 
* [x] textfield 改为 readonly
* [x] 加入"计算"按钮
* [x] viewForFooterInSection
* [x] 点击两次计算 程序崩溃
* [x] 横屏 计算 重置 位置不正确
 + [x] 用模拟器测试SectionFooterView 在iPhone6下的表现 footer布局依然有问题
 + [x] xib中用collectionReusableView替换tableviewCell 解决问题


## Goal 目标1.0.0.0 ##
### Progress 进度 ###
100%[===================]
* [x] 点击结果列崩溃
* [x] 尝试修改标准样式达到效果
* [x] * 使用自定义模板
* [x] 股票代码输入框键盘类型.keyboardType = UIKeyboardTypeDefault
* [x] 股票类型默认值
* [x] * 点击股票类型呼出picker
 + [x] 增加ButtonCell模板
 + [x] 修改股票类型textfield为button
 + [x] 修改button样式 - interfacebuilder 修改
 + [x] addTarget:action:forControlEvents:
 + [x] 实现带"确定", "取消"的picker
* [x] 输入项 加入单位
 + [x] 买卖价格数量 加入单位 元 股
 + [x] 比率 加入单位 百分之
* [x] 计算
 + [x] 数据保存CalculateBrain
 + [x] 计算
 + [x] 结果展示
* [x] 计算类型选择失效
* [x] tableview datasource 和 delegate分开
* [x] 整理 pragrma mark
* [x] OutputCell模板加入单位
* [x] 股票类型 V
* [x] 根据计算类型更改计算结果
* [x] 显示detail
* [x] 保存rate
* [x] 初始化数据
* [x] 深圳A股 隐藏结果中的过户费
* [x] input数据不足则弹出消息框提示
* [x] 光标在佣金比率，不输入内容，光标换到税，佣金比率百分号嗷嗷增加
* [x] 重置时，佣金比率和税率不晴空
* [x] 测试instruction在真机上的表现
* [x] 设计记录数据库 表结构
* [x] implementation insert record function of Record class
* [x] 实现保存按钮
* [x] 实现record页中的tableview
* [x] 实现数据在record页中展示
* [x] test the sqlite in iPhone
* [x] implementation other methods of record
* [x] 调整instruction的位置和大小，便于操作
* [x] 美化record tabpage
* [x] 加入navigation controller 至 record tabpage
* [x] 增加点击显示record 详细信息页
* [x] new brain
* [x] database
* [x] 调整cell高度
* [x] record cell
* [x] record cell image
* [x] record删除
* [x] record查找
* [x] record detail layout
* [x] record detail line chart animation
* [x] setting image
* [x] setting value
* [x] setting detail save and cancel
* [x] about
* [x] launch image font style
* [x] 图标 保本 损益 app icon
* [x] settings 印花税率 佣金比率 过户费率 版本 关于
* [x] arrange material
* [x] after configing the rate in settings, the rate doesn't change in the calculator
* [x] stock mark is ShangHai, the app crashes when saving.
* [x] in record detail, the record to save breakeven price hidden the sell.
* [x] screen shot
* [x] icon 1024
* [x] setting image in iPhone 6plus
* [x] quantity textfield keyboard type
* [x] calculate the breakeven price is error
* [x] xib中使用collectionReusableView
* [x] Setting the background color on UITableViewHeaderFooterView has been deprecated. Please use contentView.backgroundColor instead.
* [x] * UISegment 移动至TableViewHeaderView
* [x]  + 试验table header view
* [x] 加入disclosure indicator 
* [x] 求证费用
* [x] 选中更新股票类型button文字
* [x] keyboard 完善相关


## Newsfeed 动态 ##


* 股票佣金，是投资者在委托买卖股票成交后按成交金额一定比例支付的费用，此项费用由证券公司经纪佣金、证券交易所手续费及证券交易监管费等组成。《关于调整证券交易佣金收取标准的通知》规定，从2002年5月1日开始，证券公司向客户收取的佣金不得高于证券交易金额的3‰，A股、证券投资基金每笔交易佣金不足5元的，按5元收取。
股票交易印花税，是从普通印花税发展而来的，是专门针对股票交易发生额征收的一种税。我国税法规定，对证券市场上买卖、继承、赠与所确立的股权转让依据，按确立时实际市场价格计算的金额征收印花税。目前我国股票交易印花税征收方式，对买卖、继承、赠与所书立的A股、B股股权转让书据的出让按千分之一的税率征收证券（股票）交易印花税，对受让方不再征税，即卖出股票才收取股票总额千分之一的印花税。
过户费是指委托买卖的股票、基金成交后买卖双为变更股权登记所支付的费用。这笔收入属于证券登记清算机构的收入，由证券经营机构在同投资者清算交割时代为扣收。为进一步降低投资者交易成本，经研究，中国证券登记结算有限责任公司于2015年8月1日起，调整沪深市场A股交易过户费的收费标准。A股交易过户费由沪市按照成交面值0.3‰、深市按照成交金额0.0255‰向买卖双方投资者分别收取，统一调整为按照成交金额0.02‰向买卖双方投资者分别收取。交易过户费为中国结算收费，证券经营机构不予留存。 


* you’re on the General tab.  Among the options available in the summary, you should see a section called Deployment Info and, within that, a section called Device Orientation (see Figure 5-2) with a list of checkboxes.


* tableView:willDisplayCell:forRowAtIndexPath:
textLabel, detailTextLabel
.font = [UIFont systemFontOfSize:50];
.textAlignment = UITextAlignmentRight;
.textColor = [UIColor blackColor];
.backgroudColor = [UIColor redColor]


* CGRect titleRect = CGRectMake(0, 0, 300, 40);
UILabel *tableTitle = [[UILabel alloc] initWithFrame:titleRect];
tableTitle.textColor = [UIColor blueColor];
tableTitle.backgroundColor = [self.tableView backgroundColor];
tableTitle.opaque = YES;
tableTitle.font = [UIFont boldSystemFontOfSize:18];
tableTitle.text = [curTrail objectForKey:@"Name"];
self.tableView.tableHeaderView = tableTitle;
[self.tableView reloadData];


* 举个例子说明，假设你买入2000股的股票，成交价格是1.5元。
成交金额为2000×1.5（元），即成交的股数×成交价
成交面额为2000×1（元），即成交的股数×该股股票面额，目前股票的面额大部分都是1元每股，但不排除个别情况，比如紫金矿业的股票面额就是0.1元，这时就用0.1元去替换1元就可以了。A股交易过户费由沪市按照成交面值0.3‰、深市按照成交金额0.0255‰向买卖双方投资者分别收取，统一调整为按照成交金额0.02‰向买卖双方投资者分别收取。交易过户费为中国结算收费，证券经营机构不予留存。


* 也就是说你每一笔交易的成绩金额与成交的股数以及成交价有关。而成交面额只看成交的股数，与你的成交价格无关。


* 印花税：成交金额的1‰ 。当前由向双边征收改为向卖方单边征收。投资者在买卖成交后支付给财税部门的税收。上海股票及深圳股票均按实际成交金额的千分之一支付，此税收由券商代扣后由交易所统一代缴。债券与基金交易均免交此项税收。
过户费（仅上海股票收取）：这是指股票成交后，更换户名所需支付的费用。由于我国两家交易所不同的运作方式，上海股票采取的是”中央登记、统一托管“，所以此费用只在投资者进行上海股票、基金交易中才支付此费用，深股交易时无此费用。此费用按成交面额（每股一元，等同于成交股数）的0.3‰收取。
券商交易佣金：最高为成交金额的3‰，最低5元起，单笔交易佣金不满5元按5元收取。
计息起点 储蓄存款利息计算时， 本金以“元”为起息点， 元以下的角、 分不计息， 利息的金额算至分位， 分位以下四舍五入。


## Jornal 日报 ##


* 2016-01-18 工程托管移至github.com/codepongo/stockcalculator


## Tip 贴士 ##

* 批量注释 command+/

* 代码缩进 control + i http://blog.csdn.net/mars2639/article/details/7587824

## Link 链接 ##
* http://m.blog.csdn.net/blog/LVXIANGAN/46340171

* http://stackoverflow.com/questions/1958920/how-to-add-uipickerview-in-uiactionsheet

* http://stackoverflow.com/questions/25545982/is-there-any-way-to-add-uipickerview-into-uialertcontroller-alert-or-actionshee

* http://finance.sina.com.cn/calc/stock_protected.html

* http://blog.csdn.net/weisubao/article/details/40663299


## Require 需求栈 ##
* [ ] 投资损益应该算你卖出多少股的损益
* [ ] 建议佣金买入和卖出分开，你买的不是一次就卖出了
* [ ] 输入代码显示名称 效果参考招商证券买入模块
* [ ] 重构代码
* [ ] 基金类型计算
* [ ] 国债逆回购
* [ ] 大数 准确以及显示
* [ ] record search by price and quantity
* [ ] 多语言:develop language 改为英文
* [ ] 帮助
* [ ] 增加捐赠













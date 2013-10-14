### 请小心更改配置文件 ###

# 模板、主题、版式
# _layout_alpha , _layout_beta , _layout_gamma , _layout_delta
layouts: _layout_gamma

# 网站 URL ，最后勿加入斜杠
url: http://www.hnsdqnn.com

# 网站名称
name: 湖南邵东办事处

# 默认标题
title: 全能保险柜湖南邵东办事处-邵东保险柜

# 默认描述
description: 广东安能保险柜制造有限公司旗下QNNsafe全能保险柜是国内保险柜十大品牌之一，专业制造保险柜、保险箱、家用保险柜、家用保险箱等安防产品。

# 默认关键词
keywords: 邵东保险柜

# 备案号
beian: 粤ICP备12015444号-25

# 自定首页公司简介段落
# homepage_about: |
#   全能保险柜是以从事保险柜（箱）等安防产品为主的现代化保险柜...

# 自定关于我们页面内容，默认是读取 _includes/about_company.md
# about: |
#   广东安能保险柜制造有限公司是...

#   公司控股工业集团创始于1935年...

#   经过多年的持续发展，公司已跻身...


# 首页轮播大图（ - 表示数组项目）
# _layout_alpha: 998 x 514px
# _layout_beta:  998 x 350px
# _layout_gamma: 998 x 350px
# _layout_delta: 720 x 288px
slider:
  - image: http://stores.qnnimg.com/billboards/alpha-billboard-05.jpg
    link:  /b-7348.html

  - image: http://stores.qnnimg.com/billboards/alpha-billboard-06.jpg
    link:  /f-2714cke.html

  - image: http://stores.qnnimg.com/billboards/alpha-billboard-07.jpg
    link:  /asafe.html

  - image: http://stores.qnnimg.com/billboards/alpha-billboard-04.jpg
    link:  /fg-5840br.html


# 侧栏服务，格式如下：
# 企业QQ：<a class="enterprise_qq" href="#">客户咨询</a>
# 个人QQ：<a class="individual_qq" data-qq="这里填写QQ号码" href="#">客户咨询</a>
service: |
  <p>客户咨询时间：早上8:00到下午17:30</p>
  <a class="enterprise_qq" href="#">客户咨询</a>
  <a class="enterprise_qq" href="#">客户咨询</a>
  <a class="enterprise_qq" href="#">客户咨询</a>


# 专卖店风采（ - 表示数组项目，content 用 markdown 格式）
photos:
  - thumb: http://stores.qnnimg.com/photos/150px/default.jpg
    photo: http://stores.qnnimg.com/photos/default.jpg
    content: |
      **销售网点**：

      **联系人**：

      **电话**：

      **地址**：


# 侧栏联系（每行代码前加入两个空格）
contact: |
  地址：
  
  联系人：
  
  联系电话：


# 联系页（每行代码前加入两个空格）
contacthtml: |
  ###地址：
  ###联系人：
  ###联系电话：

# 百度地图坐标，到这里获取： http://api.map.baidu.com/lbsapi/getpoint/
coord: 113.28,22.76

# 百度地图框内地址
addr: 地址：

# 右上角电话
telephone: 全能保险柜总部：400-830-4555

# 自定各产品的淘宝链接，default是默认链接（可以填上店铺主页），产品用名称（name字段，如BW-6960）对应网址
taobao:
  default: http://www.taobao.com/
  B-4538: 
  B-5440: 
  B-7348: 
  BGX-2535: 
  BGX-5840: 
  BMG-7545A/B: 
  BMG-8001A/B: 
  BMG-8002A/B: 
  BMG-8003A/B: 
  BMG-9055A/B: 
  BP-6747: 
  BP-9050: 
  BW-6960: 
  CKI-253525: 
  CM-2045: 
  CM-2045ZH: 
  CS-2018D: 
  CS-2221D: 
  CS-2520C: 
  CS-4021C: 
  CT-1211: 
  CT-1211H: 
  CT-4013: 
  CT-4013ME: 
  CT-4013ZH: 
  CT-4018ZH: 
  CW-7348: 
  C型不带枪锁枪弹柜: 
  C型枪弹柜系列: 
  DG-6442DS: 
  DG-7645D: 
  DG-7645S: 
  DG-9150D: 
  DG-9150S: 
  DM-2146: 
  DM-2146ZH: 
  D型零头弹药柜: 
  ES-2045ZH: 
  ES-2318W: 
  E型部队专用携行枪柜: 
  F-1614C: 
  F-2014C/K/E: 
  F-2714C/K/E: 
  F-2720ICK: 
  F-2720ILK: 
  F-3020C/E: 
  F-3020CC/EE: 
  F-3214CC/EE: 
  F-3214CCM/EEM: 
  F-4020ILK: 
  FG-100B/R: 
  FG-11860B/R: 
  FG-153: 
  FG-15870B/R: 
  FG-2940B/R: 
  FG-3001: 
  FG-3002: 
  FG-3542B/R: 
  FG-5840B/R: 
  FG-6001: 
  FG-6002: 
  FG-6006: 
  FG-6024F: 
  FG-6030F: 
  FG-6842B/R: 
  FG-8045B/R: 
  FG-9150B/R: 
  FG-9150D: 
  FRD-21: 
  FRD-31: 
  FRD-42: 
  GLF-3340: 
  GLF-4540: 
  GLF-5842: 
  GLF-7042: 
  GLF-7550: 
  GLF-8550: 
  GTX-11860: 
  GTX-15870: 
  GTX-3345: 
  GTX-4542: 
  GTX-5842: 
  GTX-6845: 
  GTX-9050: 
  H-06: 
  H-12: 
  H-15: 
  HG-11860: 
  HG-15870: 
  HG-2740: 
  HG-3342: 
  HG-4538: 
  HG-5840: 
  HG-6842: 
  HG-7645D: 
  HG-8045: 
  HG-9150: 
  IF-1212SC: 
  IF-1500C: 
  IF-2500C: 
  IF-3000C: 
  ITG-2040: 
  ITG-3342: 
  ITG-5840: 
  JKM(B)-1020-N: 
  JKM(CS)-1020-N: 
  JKM(M)-1020-N: 
  KL-4045: 
  MA-2045ZH: 
  MB-2045UZH: 
  MF-2043ZH: 
  MG-2043ZH: 
  MG-2045: 
  MH-2043ZH: 
  MI-2045: 
  MI-2045UZH: 
  MK-2043ZH: 
  MQ-2045ZH: 
  QN-2043: 
  QN-2043ZH: 
  RH-1612K/C: 
  RH-2014C/K/E: 
  RH-2410C/K: 
  RH-3020CC: 
  SJB-1630B/R: 
  SJB-2243B/R: 
  SJB-3236B/R: 
  SJB-40HⅢB/R: 
  SJB-40ⅢB/R: 
  SJB-43ⅢB/R: 
  SJB-48ⅢB/R: 
  SJB-52ⅢB/R: 
  SJB-53ⅢB/R: 
  SJB-58ⅢB/R: 
  SJB-72ⅢB/R: 
  SJB-88ⅢB/R: 
  SJB-88ⅢDB/R: 
  SK-2045: 
  SK-2045ZH: 
  TGG-2040B/R: 
  TGG-2045B/R: 
  TGG-2740B/R: 
  TGG-3342B/R: 
  TGG-4538B/R: 
  TGG-4938B/R: 
  TGG-5840B/R: 
  TGG-6642B/R: 
  TGG-7645B/R: 
  US-1206K: 
  US-1C/K: 
  US-2C/K: 
  US-3C/K: 
  WS-108: 
  ZA-18090: 
  ZF-4538B/R: 
  ZF-4938B/R: 

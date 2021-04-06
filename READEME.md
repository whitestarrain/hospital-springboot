
# 介绍

本系统为医院信息管理系统，主要功能为临床诊疗、药品管理、经济管理、综合管理与统计分析等。项目通过maven进行构建，整体使用SpringBoot框架，使用MVC设计模式，同时实现PO，VO分离，前端使用vue.js和axios以及后端使用springboot内部封装的jackson实现网页的局部刷新，完成了前端与后端，后端与数据库的对接，以及业务逻辑的处理。


软件设计方面。完成了数据库的设计，并通过对数据库的结构调成完善了与业务逻辑的对接；通过需求文档完成了功能模块的划分与业务流程的确定；完成了页面设计以及接口的定义。

功能实现方面。对挂号，退号，看诊，开药，缴费，发药六个必做和选做功能进行了实现，同时在此基础上进行了完善加强：完成了用户的登入登出，用户界面数据的自动局部刷新，如挂号后患者列表的自动更新，信息的自动填写与相关数据的生成，如通过病历号自动补全信息以及病历号和发票的自动生成；以及UI界面上对用户操作的约束，如无法给未就诊患者开药等等。

# 用例图

![hospital-1](./image/hospital-1.png)

# 模块

![hospital-2](./image/hospital-2.png)

# 程序流程图与演示

## 登录模块

![hospital-3](./image/hospital-3.png)

![hospital-24](./image/hospital-24.png)

![hospital-25](./image/hospital-25.png)

## 挂号模块

![hospital-4](./image/hospital-4.png)

![hospital-23](./image/hospital-23.png)

## 诊断模块

![hospital-5](./image/hospital-5.png)

![hospital-20](./image/hospital-20.png)

![hospital-21](./image/hospital-21.png)

![hospital-22](./image/hospital-22.png)

## 开药模块

![hospital-6](./image/hospital-6.png)

![hospital-19](./image/hospital-19.png)

![hospital-18](./image/hospital-18.png)

![hospital-15](./image/hospital-15.png)

![hospital-16](./image/hospital-16.png)

![hospital-17](./image/hospital-17.png)


## 收费模块

![hospital-7](./image/hospital-7.png)

![hospital-14](./image/hospital-14.png)

## 退号模块

![hospital-8](./image/hospital-8.png)

![hospital-12](./image/hospital-12.png)

![hospital-13](./image/hospital-13.png)

## 发药模块

![hospital-9](./image/hospital-9.png)

![hospital-10](./image/hospital-10.png)

![hospital-11](./image/hospital-11.png)



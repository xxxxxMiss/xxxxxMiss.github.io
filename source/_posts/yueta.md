---
title: yueta
date: 2017-11-29 11:37:17
tags:
categories:
---
# 登录

```
post /signin
name
pwd
captcha
```

# 退出

```
post /signout
```

# 意见反馈

```
get /feedbacks
// 分页参数
pagesize
page
// 筛选参数
company_email
start_time
end_time
```

# 顾问(consultants)相关

## 排行版

```
get /consultants/rank
```

## 添加顾问

```
post /consultants/add
// 组id
group_id // 0（第一组）1（第一组）...以此类推
name
email
is_leader: 0（不是）1（是） // 是否为组长
```

## 标记顾问为离职

```
post /consultants/leave
consultant_id
```

## 获取跟进人列表

```
get /consultants
```


## 今日业绩汇总

```
get /consultants/statistics
// 筛选参数
group_id // 分组
start_time // 起始时间
end_time // 结束时间
```

# 客户(companies)相关

## 客户列表（支持分页，筛选查询）

```
get /companies
// 分页参数
pagesize
page
// 筛选参数
company_email
// 管理员使用更多的参数
consultant_id // 当前更进人
category_id // 免费等
allocated: 0（未分配）1（已分配）
```

## 查看约Ta职位（查询该客户【公司，企业】下的所有职位列表,支持分页）

```
get /positions
// 分页参数
pagesize
page
// 公司id
company_id
```

## 简历列表(查看某一职位下的所有简历，支持分页)

```
get /resumes
// 分页参数
pagesize
page

company_id // 公司id
position_id // 职位id
```

## 更新邮箱

```
post /resumes/update_email
// 简历id
id 
email
position_id // 职位id
```

## 稍后联系

```
post /resumes/delay_contact
// 简历id
id 
// 备注
remark
```

## 手机号码无效

```
post /resumes/phone_invalid
// 简历id
id
// 手机号
phone
```

## 状态处理（获取已有状态数据）

```
get /resumes/get_status
// 简历id
id
```

## 状态处理（更新状态）

```
post /resumes/update_status
id // 简历id
name
current_status
phone
expect_salary_start
expect_salary_end
expect_work_place
in_place // 所在地
current_msalary_start // 当前月薪
current_msalary_end
current_ysalary_start // 当前年薪
current_ysalary_end

resume_time_start // 简历最新工作时间
resume_time_end
resume_company
resume_position
new_time_start // 最新工作时间
new_time_end
new_company // 最新公司
new_position

intention
    call_time
    working_date
    resume_remark
    common_tag
    yueta_remark
    msgtify
other
    reasonnintention
    remark
none
    reasonnintention
    remark
```

## 更换跟进人

```
post /companies/change_consultant
// 一些待确定参数
consultant_id // 更进人id
```

## 获取待分配公司列表(已废弃)

```
get /companies/will_allocate
// 支持筛选
email
category_id // 0（免费）1（体验）2（付费）
filter_one // true, false
```

## 分配公司

```
post /companies/allocate
company_ids: [] // 客户id
group_id // 组
consultant_id // 更进人id
```

## 公司分配之报表查询（待确定）

```
get /companies/reports
company_email
start_time
end_time
```

# 记录(record)相关
> 考虑划分到简历下

## 历史记录（支持分页，筛选查询）

```
get /record/history
// 分页参数
pagesize
page
// 筛选参数
company_email // 公司邮箱
resume_id // 简历id
// 愿意沟通（0） 手机号码无效（1） 结束联系（2） 不看机会（3） 看其他机会（4）
category_id
// 管理员使用更多的参数
operator_id // 操作者id
start_time
end_time
```

## 管理员更改历史状态

```
post /record/update_status
// 参数待确定
```


# 配置(config)相关

## 省市的查询（看具体实现，也可能是静态数据）

```
get /configs/city
```

---
name: express-tracking
description: 查询中国快递物流状态，支持顺丰、中通、圆通、韵达等主流快递公司。用于：(1) 查询运单号物流信息，(2) 追踪包裹状态，(3) 更新物流信息到飞书多维表格。触发词：查快递、查询物流、运单查询、快递追踪、物流状态。
---

# 快递查询 Skill

查询中国快递物流状态，支持主流快递公司。

## 📦 前置配置

### 1. 获取快递100 API 密钥

注册快递100开放平台：https://api.kuaidi100.com/，获取：
- `customer`（公司编号）
- `key`（API密钥）

### 2. 配置 OpenClaw

在 `settings.json` 中添加：

```json
{
  "skills": {
    "entries": {
      "express-tracking": {
        "env": {
          "KUAIDI100_CUSTOMER": "你的公司编号",
          "KUAIDI100_KEY": "你的API密钥"
        }
      }
    }
  }
}
```

## 🚀 使用方法

### 交互式模式
```
"查快递 SF123456789 顺丰"
```

我会提示你输入运单号（如已提供）或快递公司。

### 快速模式
```
"快递查询：运单号=SF123456789 快递公司=shunfeng"
"查物流：单号YT987654321 圆通"
```

### 命令行
```bash
bash scripts/query_express.sh <运单号> <快递公司代码> <customer> <key>
```

示例：
```bash
bash scripts/query_express.sh SF123456789 shunfeng 你的customer 你的key
```

## 🔍 签名方式

```
sign = MD5(param + key + customer) 转大写
```

- param: JSON格式的查询参数
- key: 授权key
- customer: 公司编号

## 📋 返回信息

API返回丰富信息：
- routeInfo: 路由信息（出发地、当前地、目的地）
- data[]: 物流轨迹
  - time/ftime: 时间
  - context: 物流内容
  - location: 当前位置
  - areaName: 省市名称
  - areaCenter: 经纬度坐标
  - status: 状态（已揽收/在途/干线/派件/代签）

## 📊 更新飞书表格

查询结果可更新到飞书多维表格，字段包括：
- 运单号
- 快递公司
- 状态
- 当前位置
- 出发地
- 目的地
- 快递员
- 最新动态
- 更新时间

## 📝 参考文档

- [快递公司代码](references/carrier_codes.md)
- [API参数说明](references/api_params.md)
- [配置说明](CONFIG.md)

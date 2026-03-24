# 快递100 API 参数说明

## 接口地址

```
https://poll.kuaidi100.com/poll/query.do
```

## 请求方式

POST

## 请求参数

| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| customer | string | 是 | 公司编号 |
| param | string | 是 | JSON格式的查询参数 |
| sign | string | 是 | 签名，32位大写 |

## param 参数

```json
{
  "com": "shunfeng",    // 快递公司代码
  "num": "SF123456789", // 运单号
  "phone": "1234",      // 手机号后4位（可选，顺丰有时需要）
  "from": "",           // 出发地（可选）
  "to": "",             // 目的地（可选）
  "resultv2": "4",      // 返回结果版本（可选）
  "show": "0",          // 返回格式（可选）
  "order": "desc"       // 排序方式（可选）
}
```

## 签名方式

```
sign = MD5(param + key + customer) 转大写
```

## 返回字段

| 字段 | 说明 |
|------|------|
| status | 状态码（200=成功）|
| message | 消息 |
| nu | 运单号 |
| com | 快递公司 |
| state | 物流状态码 |
| ischeck | 是否签收（1=已签收）|
| routeInfo.from | 出发地 |
| routeInfo.cur | 当前地点 |
| routeInfo.to | 目的地 |
| data[] | 物流轨迹数组 |

## data[] 字段

| 字段 | 说明 |
|------|------|
| time | 时间 |
| ftime | 格式化时间 |
| context | 物流内容 |
| location | 当前位置 |
| areaName | 省市名称 |
| areaCenter | 经纬度坐标 |
| status | 状态描述 |
| statusCode | 状态代码 |

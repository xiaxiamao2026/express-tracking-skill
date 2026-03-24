# 快递查询配置说明

## 1. 获取快递100 API

注册 https://api.kuaidi100.com/ 获取：
- `customer`（公司编号）
- `key`（API密钥）

## 2. 配置 OpenClaw

在 OpenClaw `settings.json` 中添加：

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

## 3. 使用方法

### 交互式
"查快递 SF123456789 shunfeng"

### 快速模式
"快递查询：运单号=SF123456789 快递公司=顺丰"

### 命令行
```bash
bash scripts/query_express.sh SF123456789 shunfeng $KUAIDI100_CUSTOMER $KUAIDI100_KEY
```

## 4. 返回示例

```json
{
  "status": "200",
  "message": "OK",
  "nu": "SF123456789",
  "com": "shunfeng",
  "state": "3",
  "ischeck": "0",
  "routeInfo": {
    "from": "北京",
    "cur": "上海中转",
    "to": "深圳"
  },
  "data": [
    {
      "ftime": "2026-03-23 14:30:00",
      "context": "已揽收",
      "location": "北京网点"
    }
  ]
}
```
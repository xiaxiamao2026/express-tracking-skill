# 快速使用

安装完成 ✅ 

## 测试查询

```bash
# 你需要配置环境变量
export KUAIDI100_CUSTOMER="你的customer"
export KUAIDI100_KEY="你的key"

# 测试查询顺丰快递
cd ~/.openclaw/skills/express-tracking
bash scripts/query_express.sh SF123456789 shunfeng $KUAIDI100_CUSTOMER $KUAIDI100_KEY
```

## 需要 API 密钥

1. 去 https://api.kuaidi100.com/ 注册
2. 申请测试密钥或正式密钥
3. 填写到 OpenClaw 配置

然后就可以查快递了！
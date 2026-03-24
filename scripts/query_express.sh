#!/bin/bash
# 快递100实时查询API脚本（自动识别版）
# 用法: ./query_express.sh <运单号> [快递公司代码]

TRACKING_NUM=$1
CARRIER=$2

# 从环境变量获取API密钥（优先），否则使用参数
CUSTOMER=${KUAIDI100_CUSTOMER:-$3}
KEY=${KUAIDI100_KEY:-$4}

# 检查必需参数
if [ -z "$TRACKING_NUM" ] || [ -z "$CUSTOMER" ] || [ -z "$KEY" ]; then
    echo "❌ 用法: $0 <运单号> [快递公司代码]"
    echo ""
    echo "📦 需要配置API密钥:"
    echo "  方式一: 环境变量"
    echo "    export KUAIDI100_CUSTOMER=\"你的customer\""
    echo "    export KUAIDI100_KEY=\"你的key\""
    echo ""
    echo "  方式二: OpenClaw settings.json"
    echo '    "express-tracking": {'
    echo '      "env": {'
    echo '        "KUAIDI100_CUSTOMER": "...",'
    echo '        "KUAIDI100_KEY": "..."'
    echo '      }'
    echo '    }'
    echo ""
    echo "  方式三: 直接传参"
    echo "    $0 运单号 快递公司 customer key"
    echo ""
    echo "🎯 如果省略快递公司代码，会自动识别"
    echo "  自动识别优先顺序: shunfeng, zhongtong, yuantong, yunda, shentong, jtexpress, ems, youzhengguonei"
    exit 1
fi

# 支持的快递公司列表及常见前缀映射
declare -A CARRIER_ALIASES=(
    ["sf"]="shunfeng" ["SF"]="shunfeng"
    ["zt"]="zhongtong" ["ZT"]="zhongtong" ["758"]="zhongtong"
    ["yt"]="yuantong" ["YT"]="yuantong"
    ["yd"]="yunda" ["YD"]="yunda"
    ["st"]="shentong" ["ST"]="shentong"
    ["jt"]="jtexpress" ["JT"]="jtexpress" ["800"]="jtexpress"
    ["ems"]="ems" ["EMS"]="ems"
    ["yz"]="youzhengguonei" ["YZ"]="youzhengguonei"
)

# 如果未指定快递公司，尝试自动识别
if [ -z "$CARRIER" ]; then
    # 1. 尝试从单号前缀识别
    for alias in "${!CARRIER_ALIASES[@]}"; do
        if [[ $TRACKING_NUM == $alias* ]]; then
            CARRIER="${CARRIER_ALIASES[$alias]}"
            echo "# 🚀 自动识别(前缀): $alias → $CARRIER"
            break
        fi
    done
fi

# 如果还是未识别，尝试查询多个常见快递
if [ -z "$CARRIER" ]; then
    echo "# 🔍 尝试自动识别快递公司..."
    CANDIDATES=("shunfeng" "zhongtong" "yuantong" "yunda" "shentong" "jtexpress" "ems" "youzhengguonei")
    for cand in "${CANDIDATES[@]}"; do
        PARAM="{\"com\":\"${cand}\",\"num\":\"${TRACKING_NUM}\"}"
        SIGN=$(echo -n "${PARAM}${KEY}${CUSTOMER}" | md5sum | awk '{print toupper($1)}')
        RESULT=$(curl -s "https://poll.kuaidi100.com/poll/query.do" \
            -X POST \
            -H "Content-Type: application/x-www-form-urlencoded" \
            -d "customer=${CUSTOMER}&param=${PARAM}&sign=${SIGN}")
        STATUS=$(echo "$RESULT" | grep -o '"status":"[^"]*"' | cut -d'"' -f4)
        if [ "$STATUS" = "200" ]; then
            CARRIER="$cand"
            echo "# ✅ 自动识别成功: $CARRIER"
            break
        fi
    done
    if [ -z "$CARRIER" ]; then
        echo "# ❌ 无法自动识别快递公司，请手动指定:"
        echo "#   shunfeng (顺丰) / zhongtong (中通) / yuantong (圆通)"
        echo "#   yunda (韵达) / shentong (申通) / jtexpress (极兔)"
        echo "#   ems (EMS) / youzhengguonei (邮政)"
        exit 1
    fi
fi

# 构建param
PARAM="{\"com\":\"${CARRIER}\",\"num\":\"${TRACKING_NUM}\"}"

# sign = MD5(param + key + customer) 转大写
SIGN=$(echo -n "${PARAM}${KEY}${CUSTOMER}" | md5sum | awk '{print toupper($1)}')

# 调用API
curl -s "https://poll.kuaidi100.com/poll/query.do" \
  -X POST \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "customer=${CUSTOMER}&param=${PARAM}&sign=${SIGN}"
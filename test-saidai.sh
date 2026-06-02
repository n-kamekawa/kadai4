#!/bin/bash
# 最大公約数シェルスクリプトのテスト用スクリプト
# saidai.sh のさまざまな入力に対する動作確認を行う

SCRIPT="./saidai.sh"
PASS=0
FAIL=0

# テスト関数: 正常系（期待する出力と一致するか確認）
test_success() {
    local input1="$1"
    local input2="$2"
    local expected="$3"
    local description="$4"

    result=$(bash "$SCRIPT" "$input1" "$input2" 2>/dev/null)
    if [ "$result" = "$expected" ]; then
        echo "PASS: $description"
        PASS=$((PASS + 1))
    else
        echo "FAIL: $description (期待値: $expected, 実際: $result)"
        FAIL=$((FAIL + 1))
    fi
}

# テスト関数: 異常系（エラー終了するか確認）
test_error() {
    local description="$1"
    shift

    bash "$SCRIPT" "$@" > /dev/null 2>&1
    if [ $? -ne 0 ]; then
        echo "PASS: $description"
        PASS=$((PASS + 1))
    else
        echo "FAIL: $description (エラー終了が期待されたが正常終了した)"
        FAIL=$((FAIL + 1))
    fi
}

echo "=== 最大公約数シェルスクリプト テスト開始 ==="
echo ""

# 正常系テスト
echo "--- 正常系テスト ---"
test_success 2 4 2 "gcd(2, 4) = 2"
test_success 12 8 4 "gcd(12, 8) = 4"
test_success 7 13 1 "gcd(7, 13) = 1 (互いに素)"
test_success 100 75 25 "gcd(100, 75) = 25"
test_success 5 5 5 "gcd(5, 5) = 5 (同じ数)"
test_success 1 1 1 "gcd(1, 1) = 1"
test_success 48 18 6 "gcd(48, 18) = 6"

echo ""

# 異常系テスト
echo "--- 異常系テスト ---"
test_error "引数が1つだけ → エラー終了" 3
test_error "引数なし → エラー終了"
test_error "文字列を入力 → エラー終了" abc def
test_error "文字と数字を入力 → エラー終了" abc 4
test_error "数字と文字を入力 → エラー終了" 4 abc
test_error "0を入力 → エラー終了" 0 5
test_error "負の数を入力 → エラー終了" -3 5
test_error "小数を入力 → エラー終了" 3.5 2

echo ""
echo "=== テスト結果 ==="
echo "成功: $PASS"
echo "失敗: $FAIL"
echo ""

if [ "$FAIL" -ne 0 ]; then
    echo "テスト失敗があります。"
    exit 1
fi

echo "全テスト成功!"
exit 0

#!/bin/bash
# 最大公約数を計算するシェルスクリプト
# 使い方: ./saidai.sh 自然数1 自然数2

# 引数の数チェック
if [ $# -ne 2 ]; then
    echo "エラー: 2つの自然数を引数として指定してください" >&2
    exit 1
fi

# 引数が自然数（正の整数）かチェック
for arg in "$1" "$2"; do
    if ! echo "$arg" | grep -qE '^[0-9]+$'; then
        echo "エラー: 自然数を入力してください: $arg" >&2
        exit 1
    fi
    if [ "$arg" -eq 0 ]; then
        echo "エラー: 0は自然数ではありません: $arg" >&2
        exit 1
    fi
done

a=$1
b=$2

# ユークリッドの互除法で最大公約数を計算
while [ "$b" -ne 0 ]; do
    temp=$b
    b=$((a % b))
    a=$temp
done

echo "$a"

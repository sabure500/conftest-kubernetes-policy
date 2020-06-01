package main

import data.kubernetes

name = input.metadata.name

deny[msg] {
    kubernetes.is_deployment
    exists_memory_limits
    msg = sprintf("%s - コンテナのメモリ使用率制限(spec.template.spec.containers[_].resources.limits.memory)を記述する必要があります", [name])
}

deny[msg] {
    kubernetes.is_deployment
    below_reguration_memory_size
    msg = sprintf("%s - コンテナのメモリ使用率('spec.template.spec.containers[_].resources.limits.memory' or 'spec.template.spec.containers[_].resources.requests.memory')は2000MiB以下にする必要があります", [name])
}

deny[msg] {
    kubernetes.is_deployment
    use_regulation_registry
    msg = sprintf("%s - 使用するコンテナイメージは指定のレジストリから取得する必要があります", [name])
}

# コンテナのメモリ使用制限が存在するか確認するルール
# spec.template.spec.containers[_].resources.limits.memoryが存在しない場合はtrue
# spec.template.spec.containers[_].resources.limits.memoryが存在する場合はfalse
default exists_memory_limits = true
exists_memory_limits = false {
    input.spec.template.spec.containers[_].resources.limits.memory
}

# コンテナのメモリリクエストが存在するか確認するルール
# spec.template.spec.containers[_].resources.requests.memoryが存在しない場合はtrue
# spec.template.spec.containers[_].resources.requests.memoryが存在する場合はfalse
default exists_memory_requests = true
exists_memory_requests = false {
    input.spec.template.spec.containers[_].resources.requests.memory
}

# コンテナのメモリ使用率のリミット・リクエストが規定値(2000Mi)よりも小さいか確認するルール
# どちらか値が2000Miを超えている場合はtrue
# どちら共の値が2000Mi以下の場合はfalse
# OPA_v0.20では末尾にB不要、それ以前は末尾にB必須
# conftest v0.18.2 はOPA v0.19 に依存している
below_reguration_memory_size {
    memory_size := input.spec.template.spec.containers[_].resources.limits.memory
    memory_size_byte := units.parse_bytes(memory_size)
    memory_size_byte > 2097152000
}
below_reguration_memory_size {
    memory_size := input.spec.template.spec.containers[_].resources.requests.memory
    memory_size_byte := units.parse_bytes(memory_size)
    memory_size_byte > 2097152000
}

# 規定のコンテナレジストリを使用しているかを確認するルール
# 規定のレジストリが利用されていない場合はtrue
# 規定のレジストリが利用されている場合はfalse
use_regulation_registry {
    use_image := input.spec.template.spec.containers[i].image
    not startswith(use_image, "us.gcr.io")
}

package main

# メモリの制限に関する記述がある場合は結果がfalseになること
test_exists_memory_limits {
    input := 
    {
    "kind": "Deployment",
    "spec": {
        "template": {
            "spec": {
                "containers": [
                    {
                        "resources": {
                            "limits": {
                                "memory": "100Mi"
                                }
                            }
                        }
                    ],
               }
            }
        }
    }
    not exists_memory_limits with input as input
}

# メモリの制限に関する記述がない場合は結果がtrueになること
test_not_exists_memory_limits {
    input := 
    {
    "kind": "Deployment",
    "spec": {
        "template": {
            "spec": {
                "containers": [
                    {
                        "name": "flask-sample",
                        }
                    ],
               }
            }
        }
    }
    exists_memory_limits with input as input
}

# コンテナのメモリ使用率のリミット・リクエストを指定する際の値が規定値(2000)より小さい場合はfalseになること
test_below_reguration_memory_size {
    input := 
    {
    "kind": "Deployment",
    "spec": {
        "template": {
            "spec": {
                "containers": [
                    {
                        "resources": {
                            "requests": {
                                "memory": "200Mi"
                                },
                            "limits": {
                                "memory": "200Mi"
                                }
                            }
                        }
                    ]
               }
            }
        }
    }
    not below_reguration_memory_size with input as input
}

# コンテナのメモリ使用率のリミット・リクエストを指定する際の値のどちらかが規定値(2000)より大きい場合はtrueになること
test_not_below_reguration_memory_size1 {
    input := 
    {
    "kind": "Deployment",
    "spec": {
        "template": {
            "spec": {
                "containers": [
                    {
                        "resources": {
                            "requests": {
                                "memory": "2001Mi"
                                },
                            "limits": {
                                "memory": "200Mi"
                                }
                            }
                        }
                    ]
               }
            }
        }
    }
    below_reguration_memory_size with input as input
}

# コンテナのメモリ使用率のリミット・リクエストを指定する際の値のどちらかが規定値(2000)より大きい場合はtrueになること
test_not_below_reguration_memory_size2 {
    input := 
    {
    "kind": "Deployment",
    "spec": {
        "template": {
            "spec": {
                "containers": [
                    {
                        "resources": {
                            "requests": {
                                "memory": "2000Mi"
                                },
                            "limits": {
                                "memory": "3Gi"
                                }
                            }
                        }
                    ]
               }
            }
        }
    }
    below_reguration_memory_size with input as input
}

# 規定のコンテナレジストリを利用している場合はfalse
test_use_regulation_registry {
    input := 
    {
    "kind": "Deployment",
    "spec": {
        "template": {
            "spec": {
                "containers": [
                    {
                        "image": "us.gcr.io/conftest-sample:latest"
                        }
                    ]
               }
            }
        }
    }
    not use_regulation_registry with input as input
}

# 規定外のコンテナレジストリを利用している場合はtrue
test_not_use_regulation_registry {
    input := 
    {
    "kind": "Deployment",
    "spec": {
        "template": {
            "spec": {
                "containers": [
                    {
                        "image": "docker.io/conftest-sample:latest"
                        }
                    ]
               }
            }
        }
    }
    use_regulation_registry with input as input
}
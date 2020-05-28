package main

import data.kubernetes
import data.openshift

name = input.metadata.name

violation[msg] {
    openshift.is_deployment
    msg = sprintf("%s - デプロイの設定はkind: Deploymentを利用してください", [name])
}

violation[msg] {
    openshift.is_build
    msg = sprintf("%s - Kind: Buildconfigの利用は禁止されています", [name])
}
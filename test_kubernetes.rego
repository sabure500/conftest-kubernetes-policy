package kubernetes

# kind: Deploymentの場合はtrueになること
test_is_deployment {
    input := 
    {
    "kind": "Deployment"
    }
    is_deployment with input as input
}

# kind: Deployment以外の場合はfalseになること
test_not_is_deployment {
    input := 
    {
    "kind": "deployment"
    }
    not is_deployment with input as input
}
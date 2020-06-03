package openshift

# kind: DeploymentConfigの場合はtrueになること
test_is_deployment {
    input := 
    {
    "kind": "DeploymentConfig"
    }
    is_deployment with input as input
}

# kind: DeploymentConfig以外の場合はfalseになること
test_not_is_deployment {
    input := 
    {
    "kind": "Deployment"
    }
    not is_deployment with input as input
}

# kind: BuildConfigの場合はtrueになること
test_is_build {
    input := 
    {
    "kind": "BuildConfig"
    }
    is_build with input as input
}

# kind: BuildConfig以外の場合はfalseになること
test_not_is_build {
    input := 
    {
    "kind": "Buildconfig"
    }
    not is_build with input as input
}
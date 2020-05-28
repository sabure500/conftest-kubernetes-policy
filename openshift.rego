package openshift

is_deployment {
    input.kind = "DeploymentConfig"
}

is_build {
    input.kind = "BuildConfig"
}
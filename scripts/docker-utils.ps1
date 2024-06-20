function Login-DockerRegistries {
    param(
        [string]$aliyunUsername,
        [string]$aliyunPassword,
        [string]$aliyunRegistry,
        [string]$dockerUsername,
        [string]$dockerPassword
    )

    # Login to Alibaba Cloud Container Registry
    Write-Output $aliyunPassword | docker login -u $aliyunUsername $aliyunRegistry --password-stdin

    # Login to Docker Hub
    Write-Output $dockerPassword | docker login -u $dockerUsername --password-stdin
}

function TagAndPushDockerImages {
    param(
        [string]$imageName,
        [string]$aliyunRegistry,
        [string]$aliyunNamespace,
        [string]$dockerUsername,
        [int]$runId
    )

    Write-Output "Registry: $aliyunRegistry, Namespace: $aliyunNamespace, Docker Username: $dockerUsername"

    $date = Get-Date -Format "yyyyMMdd"

    # Tagging for Alibaba Cloud
    docker tag $imageName "${aliyunRegistry}/${aliyunNamespace}/${imageName}"
    docker tag $imageName "${aliyunRegistry}/${aliyunNamespace}/${imageName}:$date"
    docker tag $imageName "${aliyunRegistry}/${aliyunNamespace}/${imageName}:r-$runId"

    # Tagging for Docker Hub
    docker tag $imageName "${dockerUsername}/${imageName}"
    docker tag $imageName "${dockerUsername}/${imageName}:$date"
    docker tag $imageName "${dockerUsername}/${imageName}:r-$runId"

    # Pushing to Alibaba Cloud
    docker push "${aliyunRegistry}/${aliyunNamespace}/${imageName}"
    docker push "${aliyunRegistry}/${aliyunNamespace}/${imageName}:$date"
    docker push "${aliyunRegistry}/${aliyunNamespace}/${imageName}:r-$runId"

    # Pushing to Docker Hub
    docker push "${dockerUsername}/${imageName}"
    docker push "${dockerUsername}/${imageName}:$date"
    docker push "${dockerUsername}/${imageName}:r-$runId"
}
#!/usr/bin/env bats

nothingRemoved() {
    run docker inspect alpine:2.6
    [ "$status" -eq 0 ]
    run docker inspect alpine:3.2
    [ "$status" -eq 0 ]
    run docker inspect cirros:0.3.0
    [ "$status" -eq 0 ]
    run docker inspect alpine.26.dockerclean
    [ "$status" -eq 0 ]
    run docker inspect alpine.32.dockerclean
    [ "$status" -eq 0 ]
    run docker inspect cirros.030.dockerclean
    [ "$status" -eq 0 ]
}

alpineImagesRemoved() {
    run docker inspect alpine:2.6
    [ "$status" -eq 1 ]
    run docker inspect alpine:3.2
    [ "$status" -eq 1 ]
    run docker inspect cirros:0.3.0
    [ "$status" -eq 0 ]
    run docker inspect alpine.26.dockerclean
    [ "$status" -eq 1 ]
    run docker inspect alpine.32.dockerclean
    [ "$status" -eq 1 ]
    run docker inspect cirros.030.dockerclean
    [ "$status" -eq 0 ]
}

alpineContainersRemoved() {
    run docker inspect alpine:2.6
    [ "$status" -eq 0 ]
    run docker inspect alpine:3.2
    [ "$status" -eq 0 ]
    run docker inspect cirros:0.3.0
    [ "$status" -eq 0 ]
    run docker inspect alpine.26.dockerclean
    [ "$status" -eq 1 ]
    run docker inspect alpine.32.dockerclean
    [ "$status" -eq 1 ]
    run docker inspect cirros.030.dockerclean
    [ "$status" -eq 0 ]
}

setup() {
    docker-compose -f tests/docker-compose.yml -p dockerclean-tests up -d
    sleep 5
    export alpine_26_image_id=$(docker inspect --format={{.Id}} alpine:2.6)
    export alpine_latest_image_id=$(docker inspect --format={{.Id}} alpine:3.2)
    export cirros_latest_image_id=$(docker inspect --format={{.Id}} cirros:0.3.0)
    export alpine_26_container_id=$(docker inspect --format={{.Id}} alpine.26.dockerclean)
    export alpine_latest_container_id=$(docker inspect --format={{.Id}} alpine.32.dockerclean)
    export cirros_latest_container_id=$(docker inspect --format={{.Id}} cirros.030.dockerclean)
    export cirros_exited_container_id=$(docker inspect --format={{.Id}} cirros.exited.dockerclean)
}

@test "matches containers without removing" {
    results=$(./dockerclean -c alpine)
    num_results=$(echo "$results" | grep alpine | wc -l)
    [ "$num_results" -eq 2 ]

    alpine_26_matched_container_id=$(docker inspect --format={{.Id}} $(echo "$results" | grep alpine | grep "2\.6" | awk '{print $1}'))
    alpine_latest_matched_container_id=$(docker inspect --format={{.Id}} $(echo "$results" | grep alpine | grep "3\.2" | awk '{print $1}'))
    [ "$alpine_26_matched_container_id" = "$alpine_26_container_id" ]
    [ "$alpine_latest_matched_container_id" = "$alpine_latest_container_id" ]

    nothingRemoved
}

@test "matches exited containers without removing" {
    results=$(./dockerclean -e)
    num_results=$(echo "$results" | grep cirros | grep Exited | wc -l)
    [ "$num_results" -eq 1 ]
    cirros_exited_matched_container_id=$(docker inspect --format={{.Id}} $(echo "$results" | grep cirros | grep Exited | awk '{print $1}'))
    [ "$alpine_exited_matched_container_id" = "$alpine_exited_container_id" ]

    nothingRemoved
}

@test "matches images without removing" {
    results=$(./dockerclean -i alpine)
    num_results=$(echo "$results" | grep alpine | wc -l)
    [ "$num_results" -eq 2 ]

    alpine_26_matched_image_id=$(docker inspect --format={{.Id}} $(echo "$results" | grep alpine | grep "2\.6" | awk '{print $3}'))
    alpine_latest_matched_image_id=$(docker inspect --format={{.Id}} $(echo "$results" | grep alpine | grep "3\.2" | awk '{print $3}'))
    [ "$alpine_26_matched_image_id" = "$alpine_26_image_id" ]
    [ "$alpine_latest_matched_image_id" = "$alpine_latest_image_id" ]

    nothingRemoved
}

@test "removes containers" {
    skip "CircleCI does not allow deletion of containers"

    results=$(./dockerclean -r -c alpine)
    alpineContainersRemoved
}

@test "removes images (after removing containers)" {
    skip "CircleCI does not allow deletion of containers"

    run ./dockerclean -r -c alpine
    [ "$status" -eq 0 ]

    results=$(./dockerclean -r -i alpine)
    sleep 1
    alpineImagesRemoved
}

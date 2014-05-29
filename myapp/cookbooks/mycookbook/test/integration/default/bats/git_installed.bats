#!/usr/bin/env bats

@test "git binary is found in PATH" {
  run which git
  [ "$status" -eq 0 ]
}

@test "mysql binary is found in PATH" {
  run which mysql
  [ "$status" -eq 0 ]
}

@test "nginx binary is found in PATH" {
  run which nginx
  [ "$status" -eq 0 ]
}

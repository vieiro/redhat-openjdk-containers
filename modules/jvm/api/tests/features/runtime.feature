@ubi8/openjdk-8
@openjdk-els/openjdk-11-rhel8
@ubi8/openjdk-17
@ubi8/openjdk-21
Feature: OpenJDK Runtime tests 

  @openjdk-els
  Scenario: Check JAVA_OPTS overrides defaults (OPENJDK-2009)
    Given container is started with env
    | variable  | value          |
    | JAVA_OPTS | --show-version |
    Then container log should not contain -XX:MaxRAMPercentage

  @openjdk-els
  Scenario: Check empty JAVA_OPTS overrides defaults (OPENJDK-2009)
    Given container is started with env
    | variable  | value          |
    | JAVA_OPTS |                |
    Then container log should not contain -XX:MaxRAMPercentage

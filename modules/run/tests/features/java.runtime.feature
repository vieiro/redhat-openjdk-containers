@ubi8/openjdk-8
@openjdk-els/openjdk-11-rhel8
@ubi8/openjdk-17
@ubi8/openjdk-21
Feature: Openshift OpenJDK Runtime tests
  @openjdk-els
  Scenario: Check JAVA_APP_NAME can contain spaces (OPENJDK-104)
    Given container is started with env
    | variable         | value   |
    | JAVA_APP_NAME    | foo bar |
  Then container log should not contain exec: bar': not found

  @openjdk-els
  Scenario: Check default JAVA_APP_DIR (OPENJDK-2033)
  When container is ready
  Then available container log should contain INFO running in /deployments

  @openjdk-els
  Scenario: Check custom JAVA_APP_DIR (OPENJDK-2033)
    Given container is started with env
    | variable     | value       |
    | JAVA_APP_DIR | /home/jboss |
  Then available container log should contain INFO running in /home/jboss

  @openjdk-els
  Scenario: Check relative path JAVA_APP_DIR (OPENJDK-2033)
    Given container is started with env
    | variable     | value  |
    | JAVA_APP_DIR | .      |
  Then available container log should contain INFO running in /home/jboss

  @openjdk-els
  Scenario: Check non-existent path JAVA_APP_DIR (OPENJDK-2033)
    Given container is started with env
    | variable     | value  |
    | JAVA_APP_DIR | /nope  |
  Then available container log should contain ERROR No directory /nope found for auto detection
  Scenario: Ensure JVM_ARGS is no longer present in the run script
    Given s2i build https://github.com/rh-openjdk/openjdk-container-test-applications.git from undertow-servlet
    Then file /usr/local/s2i/run should not contain JVM_ARGS

  Scenario: Ensure JAVA_ARGS are passed through to the running java application
    Given s2i build https://github.com/rh-openjdk/openjdk-container-test-applications.git from undertow-servlet
       | variable    | value               |
       | JAVA_ARGS   | Hello from CTF test |
    Then container log should contain /deployments/undertow-servlet.jar Hello from CTF test

  Scenario: Ensure diagnostic options work correctly
    Given s2i build https://github.com/rh-openjdk/openjdk-container-test-applications.git from undertow-servlet
       | variable         | value               |
       | JAVA_ARGS        | Hello from CTF test |
       | JAVA_DIAGNOSTICS | true                |
    Then container log should contain /deployments/undertow-servlet.jar Hello from CTF test
      And container log should contain -XX:NativeMemoryTracking=summary

  @openjdk-els
  Scenario: OPENJDK-474 to ensure JAVA_ARGS is not duplicated in the java command line
    Given container is started with env
    | variable  | value  |
    | JAVA_ARGS | unique |
  Then container log should not contain unique unique

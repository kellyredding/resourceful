Feature: Config Resource
  In order to consume rest based resources
  As an user
  I want to configure Resourceful for a particular resource format and host
  
  Scenario: JSON Format definition
    Given I want to use the json resource format
    Then the format should be .json
  
  Scenario: XML Format definition
    Given I want to use the xml resource format
    Then the format should be .xml
  
  Scenario: Host not configured
    Given I have no host server configured
    Then resourceful should complain about a configuration error

  Scenario: Host configured
    Given I have a configured resource host
    Then the host should be set

  Scenario: Resource logger
    Given I have a configured resource host set to log
    Then verify the log settings

  Scenario: Resource logging
    Given I have a configured resource host set to log
    When I get a json formatted resource
    Then the set log file should exist

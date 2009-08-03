Feature: Get Resource using mechanize agent
  In order to consume rest based resources
  As an object
  I want to get data from a web resource as a formatted object
  
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



  Scenario: Get JSON resource
    Given I have a configured resource host
    When I get a json formatted resource
    Then the result should be a hash object
    
  Scenario: Get XML resource
    Given I have a configured resource host
    When I get an xml formatted resource
    Then the result should be an xml object
    
  Scenario: Get an implicit format JSON resource
    Given I have a configured resource host
    When I get a json formatted implicitly resource
    Then the result should be a hash object
    
  Scenario: Get an implicit format XML resource
    Given I have a configured resource host
    When I get an xml formatted implicitly resource
    Then the result should be an xml object
    
  Scenario: Get resource with format not supported
    Given I have a configured resource host
    When I get an poop formatted resource
    Then resourceful should complain about a format error
    
  Scenario: Get non existent resource
    Given I have a configured resource host
    When I get a resource that does not exist
    Then resourceful should complain about the resource not being found
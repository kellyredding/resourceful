Feature: Get Resource
  In order to consume rest based resources
  As an object
  I want to get data from a web resource as a formatted object
  
  Scenario: Get JSON resource
    Given I have a configured resource host
    When I get a json resource
    Then the result should be a hash object
    
  Scenario: Get XML resource
    Given I have a configured resource host
    When I get an xml resource
    Then the result should be an xml object
    
  Scenario: Get resource with format not supported
    Given I have a configured resource host
    When I get an poop resource
    Then resourceful should complain about a format error
    
  Scenario: Get non existent resource
    Given I have a configured resource host
    When I get a resource that does not exist
    Then resourceful should complain about the resource not being found
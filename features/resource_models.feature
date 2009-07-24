Feature: Resource Models
  In order to consume rest based resources
  As an object
  I want to define and initialize a model class from xml resource data
  
  Scenario: Get JSON user
    Given I have a configured resource host
    And I am user with the screen_name "kelredd"
    When I load my "Json" user model
    Then the result should be a valid User model
    
  Scenario: Get XML user
    Given I have a configured resource host
    And I am user with the screen_name "kelredd"
    When I load my "Xml" user model
    Then the result should be a valid User model

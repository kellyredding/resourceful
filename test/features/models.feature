Feature:  Models
  In order to consume rest based resources
  As an object
  I want to define and initialize a model class from resource data
  
  Scenario: Get JSON user
    Given I am user with the screen_name "kelredd"
    When I load my "Json" user model
    Then the result should be a valid User model
    And the result should be a valid Json model
    
  Scenario: Get XML user
    Given I am user with the screen_name "kelredd"
    When I load my "Xml" user model
    Then the result should be a valid User model

  Scenario: Get JSON status collection
    When I load the "Json" status "public_timeline"
    Then the result should be a collection of valid Status models
    And the result should be a collection of valid Json models
    
  Scenario: Get XML status collection
    When I load the "Xml" status "public_timeline"
    Then the result should be a collection of valid Status models

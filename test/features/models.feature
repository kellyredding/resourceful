Feature:  Models
  In order to consume rest based resources
  As an object
  I want to define and initialize a model class from resource data
  
  Scenario: Get JSON widget
    When I load the "Json" widget model "1"
    Then the result should be a valid Widget model
    
  Scenario: Get XML user
    When I load the "Xml" widget model "1"
    Then the result should be a valid Widget model

  Scenario: Get JSON status collection
    When I load the "Json" widgets collection
    Then the result should be a collection of valid Widget models
    
  Scenario: Get XML status collection
    When I load the "Xml" widgets collection
    Then the result should be a collection of valid Widget models

  Scenario: Put JSON widget
    When I load the "Json" widget model "1"
    And I update "name" to be "foo"
    And I save the widget
    Then the result should be a valid Widget model

  Scenario: Post a new Xml widget
    When I create a new "Xml" widget model
    And I update "name" to be "foo"
    And I save the widget
    Then the result should be a valid Widget model

  Scenario: Delete Xml widget
    When I load the "Xml" widget model "1"
    And destroy the widget
    Then the result should be a valid Widget model

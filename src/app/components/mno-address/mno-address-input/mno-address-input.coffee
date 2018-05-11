@App.directive('mnoAddressInput', ->
  return {
    restrict: 'EA'
    templateUrl: 'app/components/mno-address/mno-address-input/mno-address-input.html',
    scope: {
      address: '='
    }

    controller: ($scope, AddressHelper) ->
      $scope.validCountries = AddressHelper.countries
      return
  }
)
function SearchCtrl($scope, $resource) {
    $scope.sidbase = $resource('/api/v1/:model.json',
        { model: 'tunes', 'name.like': 'Offence', limit: 20, total: 1 },
        { index: { method: 'GET', isArray: true }});

    $scope.doSearch = function () {
	$scope.searchResult = $scope.sidbase.index(
	    { model: 'tunes', 'name.like': $scope.searchTerm },
	    function (data, headers) {
		$scope.searchTotal = headers('X-Api-Total');
	    }
	);
    }
}

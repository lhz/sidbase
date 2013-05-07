
// http://hvsc.etv.cx/C64Music/

function SearchCtrl($scope, $resource) {

    $scope.sidbase = $resource('/api/v1/:model.json',
        { model: 'tunes', 'name.like': 'Offence', limit: 20, total: 1 },
        { index: { method: 'GET', isArray: true }});

    $scope.doSearch = function () {
	$scope.searchResult = $scope.sidbase.index(
	    { model: 'tunes', 'search.ts': $scope.searchTerm },
	    function (data, headers) {
		$scope.searchTotal = headers('X-Api-Total');
	    }
	);
    }
}

function GridSearchCtrl($scope, $resource) {

    $scope.sidbase = $resource('/api/v1/:model.json',
        { model: 'tunes', 'search.ts': '', order: 'author,year,name' },
        { index: { method: 'GET', isArray: true }});

    $scope.filterOptions = {
        filterText: "",
        useExternalFilter: true
    };

    $scope.pagingOptions = {
        pageSizes: [250, 500, 1000],
        pageSize: 250,
        totalServerItems: 0,
        currentPage: 1
    };

    $scope.getPagedDataAsync = function (pageSize, page, searchText) {
        // setTimeout(function () {

	$scope.myData = $scope.sidbase.index(
	    { model: 'tunes', 'search.ts': searchText, total: 1,
	      limit: pageSize, offset: (page - 1) * pageSize },
	    function (data, headers) {
		$scope.pagingOptions.totalServerItems = headers('X-Api-Total');
		// if (!$scope.$$phase) {
		//     $scope.$apply();
		// }
	    }
	);

        // }, 100);
    };
	
    $scope.getPagedDataAsync($scope.pagingOptions.pageSize,
			     $scope.pagingOptions.currentPage);

    $scope.$watch('pagingOptions', function () {
        $scope.getPagedDataAsync($scope.pagingOptions.pageSize,
				 $scope.pagingOptions.currentPage,
				 $scope.filterOptions.filterText);
    }, true);
    $scope.$watch('filterOptions', function () {
        $scope.getPagedDataAsync($scope.pagingOptions.pageSize,
				 $scope.pagingOptions.currentPage,
				 $scope.filterOptions.filterText);
    }, true);   

    $scope.gridOptions = {
        data: 'myData',
        enablePaging: true,
	showFooter: true,
        pagingOptions: $scope.pagingOptions,
        filterOptions: $scope.filterOptions,
	columnDefs: [
	    {field: 'name', displayName: 'Title'},
	    {field: 'author', displayName: 'Author'},
	    {field: 'released', displayName: 'Released'},
	],
	sortInfo: {field: 'author', direction: 'asc'},
	useExternalSorting: true,
	groups: ['author'],
	showGroupPanel: true,
	groupsCollapsedByDefault: false
    };
}

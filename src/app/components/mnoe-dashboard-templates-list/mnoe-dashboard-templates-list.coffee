#
# Mnoe Dashboard Templates list
#
@App.component('mnoeDashboardTemplatesList', {
  templateUrl: 'app/components/mnoe-dashboard-templates-list/mnoe-dashboard-templates-list.html',
  controller: ($uibModal, toastr, MnoeDashboardTemplates) ->
    vm = this

    vm.dashboardTemplates =
      search: {}
      sort: "name"
      nbItems: 10
      page: 1
      pageChangedCb: (nbItems, page) ->
        vm.dashboardTemplates.nbItems = nbItems
        vm.dashboardTemplates.page = page
        offset = (page  - 1) * nbItems
        fetchDashboardTemplates(nbItems, offset)

    vm.callServer = (tableState) ->
      sort = updateSort(tableState.sort)
      search = updateSearch(tableState.search)
      fetchDashboardTemplates(vm.dashboardTemplates.nbItems, vm.dashboardTemplates.offset, sort, search)

    # Update sorting parameters
    updateSort = (sortState = {}) ->
      sort = "name"
      if sortState.predicate
        sort = sortState.predicate
        if sortState.reverse
          sort += ".desc"
        else
          sort += ".asc"

      # Update dashboardTemplates sort
      vm.dashboardTemplates.sort = sort

    # Update searching parameters
    updateSearch = (searchingState = {}) ->
      search = {}
      if searchingState.predicateObject
        for attr, value of searchingState.predicateObject
          search[ 'where[' + attr + '.like]' ] = value + '%'

      # Update dashboardTemplates sort
      vm.dashboardTemplates.search = search

    #====================================
    # Dashboard Template deletion Modal
    #====================================
    vm.openDeleteModal = (dashboardTemplateId) ->
      modalInstance = $uibModal.open(
        templateUrl: 'app/views/dashboard-templates/modals/delete-dashboard-template-modal.html'
        controller: 'deleteDashboardTemplateCtrl'
        size: 'lg'
        resolve:
          dashboardTemplateId: dashboardTemplateId
      )
      modalInstance.result.then(
        (result) ->
          # If the user delete a dashboard template
          if result
            fetchDashboardTemplates()
      )

    #====================================
    # Retrieve Dashboard Templates
    #====================================
    fetchDashboardTemplates = (limit, offset, sort = vm.dashboardTemplates.sort, search = vm.dashboardTemplates.search) ->
      vm.dashboardTemplates.loading = true
      return MnoeDashboardTemplates.templates(limit, offset, sort, search).then(
        (response) ->
          vm.dashboardTemplates.totalItems = response.headers('x-total-count')
          vm.dashboardTemplates.list = response.data
      ).finally(-> vm.dashboardTemplates.loading = false)


    vm.toggleTemplatePublished = (id) ->
      MnoeDashboardTemplates.toggleTemplatePublished(id)

    return
})

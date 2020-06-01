package com.example.gitreposearcher.ui.repos_search

import androidx.lifecycle.LiveData
import androidx.lifecycle.MediatorLiveData
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.Transformations.switchMap
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import androidx.paging.PagedList
import com.bugdim88.arch_comp_mvi_lib.HandledData
import com.bugdim88.arch_comp_mvi_lib.ViewStateInteractor
import com.example.gitreposearcher.data.data_source.shared.NetworkState
import com.example.gitreposearcher.data.data_source.shared.PagedListContainer
import com.example.gitreposearcher.domain.SearchRepoUseCase
import com.example.gitreposearcher.model.RepoModel
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext

class RepoSearchListVM(private val searchRepoUseCase: SearchRepoUseCase) : ViewModel(),
    ViewStateInteractor<RepoSearchListVM.ViewState, RepoSearchListVM.ViewIntent> {

    private val _reposListContainer = MutableLiveData<PagedListContainer<RepoModel>>()
    private val _reposList = switchMap(_reposListContainer) { it.pagedList }
    private val _networkState = switchMap(_reposListContainer) { it.networkState }
    private val _initNetworkState = switchMap(_reposListContainer) { it.initNetworkState }

    private val _viewStateMediator = MediatorLiveData<ViewState>().apply {
        addSource(_reposList) { list ->
            _viewState = _viewState?.copy(reposList = HandledData(list))
        }
        addSource(_networkState) { state ->
            _viewState = _viewState?.copy(reposListNetworkState = HandledData(state))
        }
        addSource(_initNetworkState) { state ->
            _viewState = _viewState?.copy(reposListInitNetworkState = HandledData(state))
        }
    }

    private var _viewState: ViewState? =
        ViewState()
        set(value) {
            value ?: return
            field = value
            _viewStateMediator.value = value
        }

    override val viewState: LiveData<ViewState>
        get() = _viewStateMediator

    override fun onViewIntent(intent: ViewIntent) {
        when (intent) {
            is ViewIntent.OnStateChangeIntent -> onChangeState()
            is ViewIntent.InitIntent -> onSearchRepoIntent(null)
            is ViewIntent.SearchRepoIntent -> onSearchRepoIntent(intent.query)
            is ViewIntent.RetryIntent -> onRetryIntent()
            is ViewIntent.ChangeSearchModeStatusIntent -> onChangeSearchModeState(intent.searchModeOn)
        }
    }

    private fun onChangeSearchModeState(searchModeOn: Boolean) {
        _viewState = _viewState?.copy(searchModeOn = HandledData(searchModeOn))
    }

    private fun onRetryIntent() {
        viewModelScope.launch {
            withContext(Dispatchers.IO) {
                _reposListContainer.value?.retry?.invoke()
            }
        }
    }

    private fun onSearchRepoIntent(query: String?) {
        _reposListContainer.value = searchRepoUseCase(query)
    }

    private fun onChangeState() {
        _viewState = with(_viewState) {
            this?.copy(searchModeOn = HandledData(searchModeOn.data))
        }
    }

    sealed class ViewIntent {
        object OnStateChangeIntent : ViewIntent()
        object InitIntent : ViewIntent()
        object RetryIntent : ViewIntent()
        data class SearchRepoIntent(val query: String) : ViewIntent()
        data class ChangeSearchModeStatusIntent(val searchModeOn: Boolean) : ViewIntent()
    }

    data class ViewState(
        val reposList: HandledData<PagedList<RepoModel>> = HandledData(null),
        val reposListNetworkState: HandledData<NetworkState> = HandledData(null),
        val reposListInitNetworkState: HandledData<NetworkState> = HandledData(null),
        val searchModeOn: HandledData<Boolean> = HandledData(false),
        val errorEvent: HandledData<Throwable> = HandledData(null)
    )
}

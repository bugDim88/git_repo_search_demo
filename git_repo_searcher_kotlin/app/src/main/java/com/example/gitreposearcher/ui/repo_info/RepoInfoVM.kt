package com.example.gitreposearcher.ui.repo_info

import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.bugdim88.arch_comp_mvi_lib.HandledData
import com.bugdim88.arch_comp_mvi_lib.ViewStateInteractor
import com.example.gitreposearcher.domain.GetRepoDetailsUseCase
import com.example.gitreposearcher.model.RepoInfoModel
import kotlinx.coroutines.Job
import kotlinx.coroutines.launch

class RepoInfoVM(private val getRepoDetailsUseCase: GetRepoDetailsUseCase) : ViewModel(),
    ViewStateInteractor<RepoInfoVM.ViewState, RepoInfoVM.ViewIntent> {

    private var _repoName: String? = null
    private var _repoOwner: String? = null

    private val _viewStateMediator = MutableLiveData<ViewState>()
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
            is ViewIntent.InitIntent -> onInitIntent(intent.repoName, intent.repoOwner)
            is ViewIntent.ReloadIntent -> onReload()
        }
    }

    private fun onReload() {
        _repoName ?: return
        _repoOwner ?: return
        launchReloading {
            val repoInfo = getRepoDetailsUseCase(_repoName!!, _repoOwner!!)
            _viewState = _viewState?.copy(
                repoInfo = HandledData(repoInfo)
            )
        }
    }

    private fun onChangeState() {}

    private fun onInitIntent(repoName: String, repoOwner: String) {
        _repoName = repoName
        _repoOwner = repoOwner
        launchDataLoading {
            val repoInfo = getRepoDetailsUseCase(_repoName!!, _repoOwner!!)
            _viewState = _viewState?.copy(
                repoInfo = HandledData(repoInfo)
            )
        }
    }

    private fun launchReloading(loadOrReload: Boolean = true, block: suspend () -> Unit): Job =
        viewModelScope.launch {
            try {
                _viewState = _viewState?.copy(isReloading = HandledData(true))
                block()
            } catch (e: Throwable) {
                _viewState = _viewState?.copy(errorEvent = HandledData(e))
            } finally {
                _viewState = _viewState?.copy(isReloading = HandledData(false))
            }
        }

    private fun launchDataLoading(loadOrReload: Boolean = true, block: suspend () -> Unit): Job =
        viewModelScope.launch {
            try {
                _viewState = _viewState?.copy(isLoading = HandledData(true))
                block()
            } catch (e: Throwable) {
                _viewState = _viewState?.copy(errorEvent = HandledData(e))
            } finally {
                _viewState = _viewState?.copy(isLoading = HandledData(false))
            }
        }

    sealed class ViewIntent {
        object OnStateChangeIntent : ViewIntent()
        object ReloadIntent : ViewIntent()
        data class InitIntent(val repoName: String, val repoOwner: String) : ViewIntent()
    }

    data class ViewState(
        val errorEvent: HandledData<Throwable> = HandledData(null),
        val isLoading: HandledData<Boolean> = HandledData(false),
        val isReloading: HandledData<Boolean> = HandledData(false),
        val repoInfo: HandledData<RepoInfoModel> = HandledData(null)
    )
}

package com.example.gitreposearcher.ui.init_page

import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.bugdim88.arch_comp_mvi_lib.HandledData
import com.bugdim88.arch_comp_mvi_lib.ViewStateInteractor
import com.example.gitreposearcher.domain.CheckSignInStatusUseCase
import com.example.gitreposearcher.domain.SignInUseCase
import kotlinx.coroutines.Job
import kotlinx.coroutines.launch

class InitVM(
    private val signInUseCase: SignInUseCase,
    private val checkSignInStatusUseCase: CheckSignInStatusUseCase
) : ViewModel(),
    ViewStateInteractor<InitVM.ViewState, InitVM.ViewIntent> {

    private val _viewStateMediator = MutableLiveData<ViewState>()
    private var _viewState: ViewState? = ViewState()
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
            is ViewIntent.SignInIntent -> onSignInIntent(intent.code)
            is ViewIntent.InitIntent -> onInitIntent()
        }
    }

    private fun onInitIntent() {
        launchDataLoading {
            val authStatus = checkSignInStatusUseCase()
            _viewState = _viewState?.copy(
                authStatusEvent = HandledData(authStatus)
            )
        }
    }

    private fun onSignInIntent(code: String) {
        launchDataLoading {
            signInUseCase(code)
            _viewState = _viewState?.copy(authStatusEvent = HandledData(true))
        }
    }

    private fun onChangeState() {
        _viewState = with(_viewState) { this?.copy(isLoad = HandledData(isLoad.data)) }
    }

    private fun launchDataLoading(block: suspend () -> Unit): Job =
        viewModelScope.launch {
            try {
                _viewState =
                    _viewState?.copy(isLoad = HandledData(true))
                block()
            } catch (e: Throwable) {
                _viewState = _viewState?.copy(errorEvent = HandledData(e))
            } finally {
                _viewState = _viewState?.copy(isLoad = HandledData(false))
            }
        }

    sealed class ViewIntent {
        object OnStateChangeIntent : ViewIntent()
        object InitIntent : ViewIntent()
        data class SignInIntent(val code: String) : ViewIntent()
    }

    data class ViewState(
        val isLoad: HandledData<Boolean> = HandledData(false),
        val errorEvent: HandledData<Throwable> = HandledData(null),
        val authStatusEvent: HandledData<Boolean> = HandledData(null)
    )
}

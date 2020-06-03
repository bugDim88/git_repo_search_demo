package com.example.gitreposearcher.ui.init_page

import android.annotation.SuppressLint
import android.net.Uri
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.webkit.WebView
import android.webkit.WebViewClient
import androidx.core.view.isVisible
import androidx.fragment.app.Fragment
import androidx.lifecycle.Observer
import androidx.navigation.fragment.findNavController
import com.bugdim88.arch_comp_mvi_lib.ViewStateInteractor
import com.example.gitreposearcher.BuildConfig
import com.example.gitreposearcher.R
import com.example.gitreposearcher.ui.init_page.InitVM.ViewIntent
import com.example.gitreposearcher.ui.init_page.InitVM.ViewState
import com.google.android.material.snackbar.Snackbar
import kotlinx.android.synthetic.main.fragment_init.*
import org.koin.androidx.viewmodel.ext.android.viewModel
import timber.log.Timber

class InitFragment : Fragment() {

    val viewModel: InitVM by viewModel()
    val stateInteractor: ViewStateInteractor<ViewState, ViewIntent> by lazy { viewModel }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        if (savedInstanceState == null)
            stateInteractor.onViewIntent(ViewIntent.InitIntent)
    }

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? = // Inflate the layout for this fragment
        inflater.inflate(R.layout.fragment_init, container, false)

    @SuppressLint("SetJavaScriptEnabled")
    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        auth_web_view.settings.javaScriptEnabled = true
        stateInteractor.viewState.observe(viewLifecycleOwner, Observer(::handleState))
        authorization()
    }

    private fun handleState(viewState: ViewState?) {
        viewState ?: return
        viewState.errorEvent.handle(::handleError)
        viewState.isLoad.handle(::isLoad)
        viewState.authStatusEvent.handle(::handleAuthStatusEvent)
    }

    private fun handleError(error: Throwable?) {
        error ?: return
        Snackbar.make(requireView(), error.message ?: "error", Snackbar.LENGTH_SHORT).show()
    }

    private fun isLoad(isLoad: Boolean?) {
        isLoad ?: return
        pb_load.isVisible = isLoad
    }

    private fun handleAuthStatusEvent(authStatus: Boolean?) {
        authStatus ?: return
        auth_web_view.isVisible = !authStatus
        if (authStatus) {
            val action = InitFragmentDirections.actionInitFragmentToRepoSearchListFragment()
            findNavController().navigate(action)
        } else authorization()
    }

    private fun authorization() {
        val redirectUrl = resources.getString(R.string.redirect_url)
        val redirectRegex = Regex(redirectUrl)
        val authUrl = Uri.Builder()
            .scheme("https")
            .authority("github.com")
            .path("login/oauth/authorize")
            .appendQueryParameter("client_id", BuildConfig.client_id)
            .appendQueryParameter("scope", "user,repo,read:org")
            .appendQueryParameter("redirect_uri", redirectUrl)

        Timber.d(authUrl.toString())
        auth_web_view.webViewClient = object : WebViewClient() {

            override fun shouldOverrideUrlLoading(view: WebView?, url: String?): Boolean {
                if (url?.contains(redirectRegex) == true) {
                    val code = Uri.parse(url).getQueryParameter("code") ?: return false
                    stateInteractor.onViewIntent(ViewIntent.SignInIntent(code))
                    return true
                }
                return super.shouldOverrideUrlLoading(view, url)
            }
        }
        auth_web_view.loadUrl(authUrl.toString())
    }
}

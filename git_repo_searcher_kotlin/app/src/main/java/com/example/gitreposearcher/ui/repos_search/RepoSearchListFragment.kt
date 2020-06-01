package com.example.gitreposearcher.ui.repos_search

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.view.inputmethod.EditorInfo
import androidx.core.view.isVisible
import androidx.fragment.app.Fragment
import androidx.lifecycle.Observer
import androidx.navigation.fragment.findNavController
import androidx.paging.PagedList
import com.bugdim88.arch_comp_mvi_lib.ViewStateInteractor
import com.example.gitreposearcher.R
import com.example.gitreposearcher.data.data_source.shared.NetworkState
import com.example.gitreposearcher.data.data_source.shared.Status
import com.example.gitreposearcher.model.RepoModel
import com.example.gitreposearcher.ui.hideKeyboard
import com.example.gitreposearcher.ui.repos_search.RepoSearchListVM.ViewIntent
import com.example.gitreposearcher.ui.repos_search.RepoSearchListVM.ViewState
import com.google.android.material.snackbar.Snackbar
import kotlinx.android.synthetic.main.fragment_repo_search_list.*
import org.koin.androidx.viewmodel.ext.android.viewModel

class RepoSearchListFragment : Fragment() {

    val viewModel: RepoSearchListVM by viewModel()
    val stateInteractor: ViewStateInteractor<ViewState, ViewIntent> by lazy { viewModel }
    val repoAdapter: ReposAdapter by lazy {
        ReposAdapter({
            val action =
                RepoSearchListFragmentDirections.actionRepoSearchListFragmentToRepoInfoFragment(
                    it.owner,
                    it.title
                )
            findNavController().navigate(action)
        }, {
            stateInteractor.onViewIntent(ViewIntent.RetryIntent)
        })
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        if (savedInstanceState == null) stateInteractor.onViewIntent(ViewIntent.InitIntent)
    }

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? =
        inflater.inflate(R.layout.fragment_repo_search_list, container, false)

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        rv_repos.adapter = repoAdapter
        bt_search.setOnClickListener {
            stateInteractor.onViewIntent(ViewIntent.ChangeSearchModeStatusIntent(true))
        }
        bt_back.setOnClickListener {
            stateInteractor.onViewIntent(ViewIntent.ChangeSearchModeStatusIntent(false))
            it.hideKeyboard()
        }
        et_search.setOnEditorActionListener { v, actionId, _ ->
            when (actionId) {
                EditorInfo.IME_ACTION_SEARCH -> {
                    stateInteractor.onViewIntent(ViewIntent.SearchRepoIntent(v.text.toString()))
                    v.hideKeyboard()
                    true
                }
                else -> false
            }
        }
        stateInteractor.viewState.observe(viewLifecycleOwner, Observer(::handleViewState))
    }

    override fun onDestroyView() {
        super.onDestroyView()
        stateInteractor.onViewIntent(ViewIntent.OnStateChangeIntent)
    }

    private fun handleViewState(viewState: ViewState?) {
        viewState ?: return
        viewState.reposList.handle(::handleReposList)
        viewState.reposListNetworkState.handle(::handleListNetworkState)
        viewState.reposListInitNetworkState.handle(::handleInitNetworkState)
        viewState.searchModeOn.handle(::handleSearchModeStatus)
    }

    private fun handleSearchModeStatus(searchModeOn: Boolean?) {
        searchModeOn ?: return
        search_input.isVisible = searchModeOn
        toolbar_default.isVisible = !searchModeOn
    }

    private fun handleListNetworkState(networkState: NetworkState?) {
        networkState ?: return
        repoAdapter.setNetworkState(networkState)
    }

    private fun handleReposList(pagedList: PagedList<RepoModel>?) {
        pagedList ?: return
        repoAdapter.submitList(pagedList)
    }

    private fun handleInitNetworkState(networkState: NetworkState?) {
        networkState ?: return
        pb_load.isVisible = networkState.status == Status.RUNNING
        if (networkState.status == Status.FAILED)
            Snackbar.make(requireView(), networkState.msg ?: "error", Snackbar.LENGTH_SHORT).show()
    }
}

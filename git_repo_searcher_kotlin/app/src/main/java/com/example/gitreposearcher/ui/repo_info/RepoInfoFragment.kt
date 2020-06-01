package com.example.gitreposearcher.ui.repo_info

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.core.view.isVisible
import androidx.fragment.app.Fragment
import androidx.lifecycle.Observer
import androidx.navigation.fragment.navArgs
import com.bugdim88.arch_comp_mvi_lib.ViewStateInteractor
import com.example.gitreposearcher.R
import com.example.gitreposearcher.model.RepoInfoModel
import com.example.gitreposearcher.ui.repo_info.RepoInfoVM.ViewIntent
import com.example.gitreposearcher.ui.repo_info.RepoInfoVM.ViewState
import com.google.android.material.snackbar.Snackbar
import io.noties.markwon.Markwon
import kotlinx.android.synthetic.main.fragment_repo_info.*
import org.koin.androidx.viewmodel.ext.android.viewModel

class RepoInfoFragment : Fragment() {

    val viewModel: RepoInfoVM by viewModel()
    val stateInteractor: ViewStateInteractor<ViewState, ViewIntent> by lazy { viewModel }
    val args: RepoInfoFragmentArgs by navArgs()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        if (savedInstanceState == null)
            stateInteractor.onViewIntent(ViewIntent.InitIntent(args.repoName, args.repoOwner))
    }

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? =
        inflater.inflate(R.layout.fragment_repo_info, container, false)

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        with(tool_bar) {
            setNavigationIcon(R.drawable.ic_arrow_back)
            setNavigationOnClickListener { activity?.onBackPressed() }
            this.title = args.repoName
        }
        refresh_view.setOnRefreshListener {
            stateInteractor.onViewIntent(ViewIntent.ReloadIntent)
        }
        stateInteractor.viewState.observe(viewLifecycleOwner, Observer(::handleViewState))
    }

    private fun handleViewState(viewState: ViewState?) {
        viewState ?: return
        viewState.errorEvent.handle(::handleErrorEvent)
        viewState.isLoading.handle(::handleIsLoading)
        viewState.isReloading.handle(::isReloading)
        viewState.repoInfo.handle(::handleRepoInfo)
    }

    private fun handleErrorEvent(error: Throwable?) {
        error ?: return
        Snackbar.make(requireView(), error.message ?: "error", Snackbar.LENGTH_SHORT).show()
    }

    private fun handleIsLoading(isLoading: Boolean?) {
        pb_load.isVisible = isLoading == true
        repos_content.isVisible = isLoading == false
    }

    private fun isReloading(isReloading: Boolean?) {
        isReloading ?: return
        refresh_view.isRefreshing = isReloading
    }

    private fun handleRepoInfo(repoInfoModel: RepoInfoModel?) {
        repoInfoModel ?: return
        tv_login.text = repoInfoModel.ownerLogin
        tv_repo_name.text = repoInfoModel.name
        tv_description.text = repoInfoModel.description
        tv_stars_count.text =
            resources.getString(R.string.stars_counter, repoInfoModel.starsCount.toString())
        tv_fork_count.text =
            resources.getString(R.string.forks_counter, repoInfoModel.forksCount.toString())
        tv_issue_counter.text = repoInfoModel.issueCount.toString()
        tv_pull_request_count.text = repoInfoModel.pullRequestsCount.toString()
        if (repoInfoModel.readME.isNullOrEmpty()) {
            tv_readme.text = resources.getString(R.string.readme_empty)
        } else {
            Markwon.create(requireContext()).setMarkdown(tv_readme, repoInfoModel.readME)
        }
    }
}

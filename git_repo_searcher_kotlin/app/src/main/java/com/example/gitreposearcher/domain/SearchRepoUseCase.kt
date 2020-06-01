package com.example.gitreposearcher.domain

import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.switchMap
import androidx.paging.DataSource
import androidx.paging.LivePagedListBuilder
import androidx.paging.PagedList
import com.example.gitreposearcher.data.data_source.PublicReposDataSource
import com.example.gitreposearcher.data.data_source.SearchReposDataSource
import com.example.gitreposearcher.data.data_source.shared.PagedListContainer
import com.example.gitreposearcher.data.data_source.shared.ReposDataSource
import com.example.gitreposearcher.data.git_api.GitHubService
import com.example.gitreposearcher.model.RepoModel

class SearchRepoUseCase(private val service: GitHubService) {
    operator fun invoke(query: String?): PagedListContainer<RepoModel> {
        val sourceLiveData = MutableLiveData<ReposDataSource>()
        val dataSourceFactory = object : DataSource.Factory<String, RepoModel>() {
            override fun create(): DataSource<String, RepoModel> {
                val source =
                    if (query.isNullOrEmpty()) PublicReposDataSource(service) else SearchReposDataSource(
                        service,
                        query
                    )
                sourceLiveData.postValue(source)
                return source
            }
        }
        val list = LivePagedListBuilder(
            dataSourceFactory, PagedList.Config.Builder()
                .setEnablePlaceholders(false)
                .setPageSize(100)
                .build()
        ).build()
        return PagedListContainer(
            pagedList = list,
            networkState = sourceLiveData.switchMap { it.networkState },
            initNetworkState = sourceLiveData.switchMap { it.initNetworkState },
            retry = { sourceLiveData.value?.retryAllFailed() }
        )
    }
}

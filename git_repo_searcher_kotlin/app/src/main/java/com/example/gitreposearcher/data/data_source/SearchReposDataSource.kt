package com.example.gitreposearcher.data.data_source

import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import com.example.gitreposearcher.data.data_source.shared.NetworkState
import com.example.gitreposearcher.data.data_source.shared.ReposDataSource
import com.example.gitreposearcher.data.git_api.GitHubService
import com.example.gitreposearcher.model.RepoModel
import java.util.concurrent.atomic.AtomicBoolean

class SearchReposDataSource(private val service: GitHubService, private val query: String) :
    ReposDataSource() {

    private var retry: (() -> Any)? = null

    private val _initLoadFlag = AtomicBoolean(false)
    private val _networkState = MutableLiveData<NetworkState>()
    private val _initLoadState = MutableLiveData<NetworkState>()
    override val networkState: LiveData<NetworkState> = _networkState
    override val initNetworkState: LiveData<NetworkState> = _initLoadState

    override fun loadInitial(
        params: LoadInitialParams<String>,
        callback: LoadInitialCallback<String, RepoModel>
    ) {
        _initLoadState.postValue(NetworkState.LOADING)
        _initLoadFlag.set(true)
        try {
            val response = service.searchRepo(query).execute()
            if (!response.isSuccessful) throw Throwable(response.message())
            val repos = response.body()?.items
                ?.map {
                    RepoModel(
                        id = it.id,
                        title = it.name ?: "",
                        description = it.description ?: "",
                        owner = it.owner.login
                    )
                }
                ?: emptyList()
            val nextLink = response.headers()["link"]?.let(::getNextLink) ?: ""
            _initLoadFlag.set(false)
            _initLoadState.postValue(NetworkState.LOADED)
            callback.onResult(
                repos,
                "",
                nextLink
            )
        } catch (e: Throwable) {
            retry = { loadInitial(params, callback) }
            _initLoadState.postValue(NetworkState.error(e.message))
        }
    }

    override fun loadAfter(params: LoadParams<String>, callback: LoadCallback<String, RepoModel>) {
        if (!_initLoadFlag.get()) _networkState.postValue(NetworkState.LOADING)
        try {
            val response = service.getReposByUrl(params.key).execute()
            if (!response.isSuccessful) throw Throwable(response.message())
            val repos = response.body()?.items
                ?.map {
                    RepoModel(
                        id = it.id,
                        title = it.name ?: "",
                        description = it.description ?: "",
                        owner = it.owner.login
                    )
                }
                ?: emptyList()
            val nextLink = response.headers()["link"]?.let(::getNextLink) ?: ""
            if (!_initLoadFlag.get()) _networkState.postValue(NetworkState.LOADED)
            callback.onResult(repos, nextLink)
        } catch (e: Throwable) {
            retry = { loadAfter(params, callback) }
            _initLoadState.postValue(NetworkState.error(e.message))
        }
    }

    override fun loadBefore(params: LoadParams<String>, callback: LoadCallback<String, RepoModel>) {
        //
    }

    private fun getNextLink(header: String): String? {
        val links = header.split(",")
        return links.firstOrNull()?.split(";")?.firstOrNull()?.let { it.substring(1, it.lastIndex) }
    }

    override fun retryAllFailed() {
        val prevRetry = retry
        retry = null
        prevRetry?.invoke()
    }
}

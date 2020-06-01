package com.example.gitreposearcher.data.data_source.shared

import androidx.lifecycle.LiveData
import androidx.paging.PageKeyedDataSource
import com.example.gitreposearcher.model.RepoModel

abstract class ReposDataSource : PageKeyedDataSource<String, RepoModel>() {

    abstract val networkState: LiveData<NetworkState>
    abstract val initNetworkState: LiveData<NetworkState>

    abstract fun retryAllFailed()
}

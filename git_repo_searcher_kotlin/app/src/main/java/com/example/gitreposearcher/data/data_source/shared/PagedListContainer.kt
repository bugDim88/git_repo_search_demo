package com.example.gitreposearcher.data.data_source.shared

import androidx.lifecycle.LiveData
import androidx.paging.PageKeyedDataSource
import androidx.paging.PagedList

/**
 * Container for calling [PageKeyedDataSource]
 */
data class PagedListContainer<T>(
    val pagedList: LiveData<PagedList<T>>,
    val networkState: LiveData<NetworkState>,
    val initNetworkState: LiveData<NetworkState>,
    val retry: suspend () -> Unit
)

package com.example.gitreposearcher.ui.repos_search

import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.core.view.isVisible
import androidx.paging.PagedListAdapter
import androidx.recyclerview.widget.DiffUtil
import androidx.recyclerview.widget.RecyclerView
import com.example.gitreposearcher.R
import com.example.gitreposearcher.data.data_source.shared.NetworkState
import com.example.gitreposearcher.data.data_source.shared.Status
import com.example.gitreposearcher.model.RepoModel
import kotlinx.android.synthetic.main.item_network_state.view.*
import kotlinx.android.synthetic.main.item_repo.view.*

class ReposAdapter(
    private val onClickListener: (RepoModel) -> Unit,
    private val retryCallback: () -> Unit
) : PagedListAdapter<RepoModel, RecyclerView.ViewHolder>(RepoModelDiffCallback()) {

    private val kRepoType = 1
    private val kNetworkType = 2

    private var networkState: NetworkState? = null

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): RecyclerView.ViewHolder =
        when (viewType) {
            kRepoType -> RepoViewHolder(
                LayoutInflater.from(parent.context)
                    .inflate(R.layout.item_repo, parent, false),
                onClickListener
            )
            kNetworkType -> NetworkStateItemViewHolder(
                LayoutInflater.from(parent.context)
                    .inflate(R.layout.item_network_state, parent, false),
                retryCallback
            )
            else -> throw IllegalArgumentException("unknown view type $viewType")
        }

    override fun onBindViewHolder(holder: RecyclerView.ViewHolder, position: Int) {
        if (holder is RepoViewHolder) {
            holder.bind(getItem(position))
        }
        if (holder is NetworkStateItemViewHolder) {
            holder.bind(networkState)
        }
    }

    override fun getItemViewType(position: Int): Int {
        return if (hasExtraRow() && position == itemCount - 1) {
            kNetworkType
        } else {
            kRepoType
        }
    }

    override fun getItemCount(): Int {
        return super.getItemCount() + if (hasExtraRow()) 1 else 0
    }

    private fun hasExtraRow() = networkState != null && networkState != NetworkState.LOADED

    fun setNetworkState(newNetworkState: NetworkState?) {
        val previousState = this.networkState
        val hadExtraRow = hasExtraRow()
        this.networkState = newNetworkState
        val hasExtraRow = hasExtraRow()
        if (hadExtraRow != hasExtraRow) {
            if (hadExtraRow) {
                notifyItemRemoved(super.getItemCount())
            } else {
                notifyItemInserted(super.getItemCount())
            }
        } else if (hasExtraRow && previousState != newNetworkState) {
            notifyItemChanged(itemCount - 1)
        }
    }
}

private class RepoViewHolder(itemView: View, private val onClickListener: (RepoModel) -> Unit) :
    RecyclerView.ViewHolder(itemView) {
    fun bind(item: RepoModel?) {
        with(itemView) {
            setOnClickListener { item?.let { onClickListener(item) } }
            tv_title.text = item?.title ?: "_"
            tv_secondary.text = item?.description ?: "_"
        }
    }
}

private class NetworkStateItemViewHolder(itemView: View, private val retryCallback: () -> Unit) :
    RecyclerView.ViewHolder(itemView) {
    fun bind(state: NetworkState?) {
        with(itemView) {
            bt_retry.setOnClickListener { retryCallback() }
            pb_load.isVisible = state?.status == Status.RUNNING
            bt_retry.isVisible = state?.status == Status.FAILED
            tv_error_message.isVisible = state?.msg != null
            tv_error_message.text = state?.msg ?: ""
        }
    }
}

private class RepoModelDiffCallback : DiffUtil.ItemCallback<RepoModel>() {
    override fun areItemsTheSame(oldItem: RepoModel, newItem: RepoModel): Boolean =
        oldItem.id == newItem.id

    override fun areContentsTheSame(oldItem: RepoModel, newItem: RepoModel): Boolean =
        oldItem == newItem
}

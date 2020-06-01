package com.example.gitreposearcher.data.git_api.model

import com.google.gson.annotations.SerializedName

data class RepositoryApiModel(
    val id: Int,
    val name: String?,
    val description: String?,
    val owner: OwnerApiModel,
    val forks: Int,
    @SerializedName("stargazers_count")
    val stars: Int,
    @SerializedName("open_issues")
    val openIssues: Int
)

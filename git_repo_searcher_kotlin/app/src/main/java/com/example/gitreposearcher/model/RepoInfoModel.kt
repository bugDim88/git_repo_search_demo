package com.example.gitreposearcher.model

data class RepoInfoModel(
    val ownerLogin: String,
    val name: String,
    val description: String?,
    val starsCount: Int,
    val forksCount: Int,
    val issueCount: Int,
    val pullRequestsCount: Int,
    val readME: String?
)

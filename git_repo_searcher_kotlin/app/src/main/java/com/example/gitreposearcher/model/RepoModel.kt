package com.example.gitreposearcher.model

/**
 * Simple git_hub repo model
 */
data class RepoModel(
    val id: Int,
    val title: String,
    val description: String,
    val owner: String
)

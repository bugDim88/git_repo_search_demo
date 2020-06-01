package com.example.gitreposearcher.domain

import com.apollographql.apollo.ApolloClient
import com.apollographql.apollo.coroutines.toDeferred
import com.example.gitreposearcher.RepositoryInfoQuery
import com.example.gitreposearcher.model.RepoInfoModel
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext

class GetRepoDetailsUseCase(private val client: ApolloClient) {
    suspend operator fun invoke(repoName: String, repoOwner: String): RepoInfoModel =
        withContext(Dispatchers.IO) {
            val repo = client.query(RepositoryInfoQuery(repoName, repoOwner)).toDeferred().await()
                .data()?.repository ?: throw Throwable("response is null")
            RepoInfoModel(
                name = repo.name ?: "",
                description = repo.description,
                ownerLogin = repo.owner.login,
                starsCount = repo.stargazers.totalCount,
                forksCount = repo.forks.totalCount,
                pullRequestsCount = repo.pullRequests.totalCount,
                issueCount = repo.issues.totalCount,
                readME = repo.object_?.asBlob?.text
            )
        }
}

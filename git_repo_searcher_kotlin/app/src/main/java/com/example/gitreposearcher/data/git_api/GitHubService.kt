package com.example.gitreposearcher.data.git_api

import com.example.gitreposearcher.data.git_api.model.FileApiModel
import com.example.gitreposearcher.data.git_api.model.RepositoryApiModel
import com.example.gitreposearcher.data.git_api.model.ResponseTemplateModel
import retrofit2.Call
import retrofit2.http.GET
import retrofit2.http.Path
import retrofit2.http.Query
import retrofit2.http.Url

interface GitHubService {

    @GET("repositories")
    fun getPublicRepos(): Call<List<RepositoryApiModel>>

    @GET()
    fun getPublicRepos(@Url url: String): Call<List<RepositoryApiModel>>

    @GET("search/repositories")
    fun searchRepo(@Query("q") query: String): Call<ResponseTemplateModel<RepositoryApiModel>>

    @GET()
    fun getReposByUrl(@Url url: String): Call<ResponseTemplateModel<RepositoryApiModel>>

    @GET("repositories/{id}")
    fun getRepo(@Path("id") id: Int): Call<RepositoryApiModel>

    @GET("repositories/{id}/readme")
    fun getRepoReadMe(@Path("id") id: Int): Call<FileApiModel>
}

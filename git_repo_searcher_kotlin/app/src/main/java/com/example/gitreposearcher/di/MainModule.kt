package com.example.gitreposearcher.di

import com.apollographql.apollo.ApolloClient
import com.example.gitreposearcher.BuildConfig
import com.example.gitreposearcher.data.git_api.GitHubService
import com.example.gitreposearcher.data.git_api.TokenInterceptor
import com.example.gitreposearcher.data.shrared_prefs.LoginPrefs
import com.example.gitreposearcher.domain.CheckSignInStatusUseCase
import com.example.gitreposearcher.domain.GetRepoDetailsUseCase
import com.example.gitreposearcher.domain.SearchRepoUseCase
import com.example.gitreposearcher.domain.SignInUseCase
import com.example.gitreposearcher.ui.init_page.InitVM
import com.example.gitreposearcher.ui.repo_info.RepoInfoVM
import com.example.gitreposearcher.ui.repos_search.RepoSearchListVM
import okhttp3.OkHttpClient
import okhttp3.logging.HttpLoggingInterceptor
import org.koin.android.ext.koin.androidApplication
import org.koin.androidx.viewmodel.dsl.viewModel
import org.koin.dsl.module
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory

val mainModule = module {
    single { LoginPrefs(androidApplication()) }
    single { TokenInterceptor() }
    single<OkHttpClient> {
        val logInterceptor = HttpLoggingInterceptor().apply {
            level = HttpLoggingInterceptor.Level.BODY
        }
        val clientBuilder = OkHttpClient.Builder()
        if (BuildConfig.DEBUG) clientBuilder.addInterceptor(logInterceptor)
        clientBuilder.addInterceptor(get<TokenInterceptor>())
        clientBuilder.build()
    }
    single<GitHubService> {
        val retrofit = Retrofit.Builder()
            .baseUrl("https://api.github.com/")
            .client(get())
            .addConverterFactory(GsonConverterFactory.create())
            .build()
        retrofit.create(GitHubService::class.java)
    }
    single<ApolloClient> {
        ApolloClient.builder()
            .serverUrl("https://api.github.com/graphql")
            .okHttpClient(get())
            .build()
    }
    factory { SignInUseCase(androidApplication(), get(), get(), get()) }
    factory { CheckSignInStatusUseCase(get(), get()) }
    factory { GetRepoDetailsUseCase(get()) }
    factory { SearchRepoUseCase(get()) }
    viewModel { RepoInfoVM(get()) }
    viewModel { RepoSearchListVM(get()) }
    viewModel { InitVM(get(), get()) }
}

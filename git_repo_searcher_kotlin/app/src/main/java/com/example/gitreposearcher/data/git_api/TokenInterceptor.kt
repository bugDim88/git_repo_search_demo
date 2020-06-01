package com.example.gitreposearcher.data.git_api

import okhttp3.Interceptor
import okhttp3.Response

class TokenInterceptor() : Interceptor {
    @get:Synchronized
    @set:Synchronized
    var token: String? = null
    override fun intercept(chain: Interceptor.Chain): Response =
        chain.proceed(
            chain.request().newBuilder()
                .addHeader("Authorization", "token $token")
                .build()
        )
}

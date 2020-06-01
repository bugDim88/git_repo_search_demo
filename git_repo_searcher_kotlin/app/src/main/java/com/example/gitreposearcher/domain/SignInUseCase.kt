package com.example.gitreposearcher.domain

import android.content.Context
import com.example.gitreposearcher.R
import com.example.gitreposearcher.checkResponse
import com.example.gitreposearcher.data.git_api.TokenInterceptor
import com.example.gitreposearcher.data.shrared_prefs.LoginPrefs
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import okhttp3.FormBody
import okhttp3.HttpUrl.Companion.toHttpUrlOrNull
import okhttp3.OkHttpClient
import okhttp3.Request

class SignInUseCase(
    private val ctx: Context,
    private val client: OkHttpClient,
    private val loginPrefs: LoginPrefs,
    private val tokenInterceptor: TokenInterceptor
) {
    suspend operator fun invoke(code: String) {
        val url = "https://github.com/login/oauth/access_token".toHttpUrlOrNull() ?: return
        val requestBody = FormBody.Builder()
            .add("code", code)
            .add("client_id", ctx.resources.getString(R.string.client_id))
            .add("client_secret", ctx.resources.getString(R.string.client_secret))
            .build()
        val tokenObject = withContext(Dispatchers.IO) {
            val response =
                client.newCall(Request.Builder().url(url).post(requestBody).build()).execute()
            response.checkResponse()
            val tokenData = response.body?.string() ?: throw Throwable("null response")
            val tokenKeyRegex = Regex("access_token")
            val accessToken =
                tokenData.split("&").firstOrNull { it.contains(tokenKeyRegex) }?.split("=")?.last()
                    ?: throw Throwable("token not found")
            // val result = Gson().fromJson(tokenData, TokenApiModel::class.java)
            with(loginPrefs) {
                token = accessToken
            }
            accessToken
        }
        tokenInterceptor.token = tokenObject
    }
}

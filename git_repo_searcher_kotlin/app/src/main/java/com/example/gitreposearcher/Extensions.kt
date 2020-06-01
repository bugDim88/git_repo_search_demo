package com.example.gitreposearcher

import retrofit2.Response

fun <T> Response<T>.checkResponse(): T {
    if (!this.isSuccessful) throw Throwable(this.message())
    return this.body() ?: throw Throwable("null body response")
}

fun okhttp3.Response.checkResponse() {
    if (!this.isSuccessful) throw Throwable(this.message)
}

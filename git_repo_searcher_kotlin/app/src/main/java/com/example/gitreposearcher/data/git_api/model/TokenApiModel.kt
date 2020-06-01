package com.example.gitreposearcher.data.git_api.model

import com.google.gson.annotations.SerializedName

data class TokenApiModel(
    @SerializedName("access_token")
    val accessToken: String,
    @SerializedName("expires_in")
    val expiresIn: String,
    @SerializedName("refresh_token")
    val refreshToken: String,
    @SerializedName("refresh_token_expires_in")
    val refreshTokenExpiresIn: String,
    val scope: String,
    @SerializedName("token_type")
    val tokenType: String
)

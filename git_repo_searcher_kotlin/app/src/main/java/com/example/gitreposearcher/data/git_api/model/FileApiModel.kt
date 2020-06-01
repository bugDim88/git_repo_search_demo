package com.example.gitreposearcher.data.git_api.model

import com.google.gson.annotations.SerializedName

data class FileApiModel(
    val name: String,
    val size: Int,
    val url: String,
    @SerializedName("download_url")
    val downloadUrl: String,
    val content: String
)

package com.example.gitreposearcher.domain

import com.example.gitreposearcher.data.git_api.TokenInterceptor
import com.example.gitreposearcher.data.shrared_prefs.LoginPrefs
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext

class CheckSignInStatusUseCase(
    private val loginPrefs: LoginPrefs,
    private val tokenInterceptor: TokenInterceptor
) {
    /**
     * return
     *  true -> auth status valid
     *  false -> auth status invalid
     */
    suspend operator fun invoke(): Boolean {
        /*  val refreshTokenExpiredIn =
              withContext(Dispatchers.IO) { loginPrefs.refreshTokenExpiredIn }?.toInt() ?: 0
          val currentTime = Date().time / 1000*/
        val acessToken = withContext(Dispatchers.IO) { loginPrefs.token } ?: return false
        tokenInterceptor.token = acessToken
        return true
    }
}

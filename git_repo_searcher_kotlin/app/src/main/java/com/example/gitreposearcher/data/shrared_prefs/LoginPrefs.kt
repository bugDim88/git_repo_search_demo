package com.example.gitreposearcher.data.shrared_prefs

import android.content.Context
import android.content.SharedPreferences

class LoginPrefs(ctx: Context) {
    private val prefs: Lazy<SharedPreferences> = lazy { // Lazy to prevent IO access to main thread.
        ctx.applicationContext.getSharedPreferences(
            kPrefsName, Context.MODE_PRIVATE
        )
    }
    var token: String? by StringPreference(prefs, kToken, null)
    var expiredIn: String? by StringPreference(prefs, kExpiredIn, null)
    var refreshToken: String? by StringPreference(prefs, kRefreshToken, null)
    var refreshTokenExpiredIn: String? by StringPreference(prefs, kRefreshTokenExpiredIn, null)

    companion object {
        private const val kPrefsName = "login_prefs"
        private const val kToken = "token_pref"
        private const val kExpiredIn = "expired_in"
        private const val kRefreshToken = "refresh_token"
        private const val kRefreshTokenExpiredIn = "refresh_token_expired_in"
    }
}

package com.maskhazellc.maskhaze

import android.content.Context
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory
import io.flutter.plugin.common.StandardMessageCodec

class CameraPlatformViewFactory(private val messenger: BinaryMessenger): PlatformViewFactory(StandardMessageCodec.INSTANCE) {
    override fun create(context: Context, viewId: Int, args: Any?): PlatformView {
        return CameraPlatformView(context, viewId, messenger)
    }
}

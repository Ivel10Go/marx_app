package com.example.marx_app

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.widget.RemoteViews
import java.util.Locale

class QuoteWidgetProvider : AppWidgetProvider() {
  override fun onUpdate(
    context: Context,
    appWidgetManager: AppWidgetManager,
    appWidgetIds: IntArray,
  ) {
    appWidgetIds.forEach { widgetId ->
      updateWidget(context, appWidgetManager, widgetId)
    }
  }

  companion object {
    fun refreshAll(context: Context) {
      val manager = AppWidgetManager.getInstance(context)
      val componentName = ComponentName(context, QuoteWidgetProvider::class.java)
      val ids = manager.getAppWidgetIds(componentName)
      ids.forEach { id ->
        updateWidget(context, manager, id)
      }
    }

    private fun updateWidget(
      context: Context,
      appWidgetManager: AppWidgetManager,
      appWidgetId: Int,
    ) {
      val prefs = context.getSharedPreferences("HomeWidgetPreferences", Context.MODE_PRIVATE)
      val quoteText = prefs.getString("quote_text", "Tageszitat wird geladen...") ?: ""
      val source = prefs.getString("quote_source", "Das Kapital") ?: ""
      val explanation = prefs.getString("quote_explanation", "") ?: ""
      val categories = prefs.getString("quote_categories", "") ?: ""
      val streak = prefs.getString("streak", "0") ?: "0"

      val options = appWidgetManager.getAppWidgetOptions(appWidgetId)
      val minHeight = options.getInt(AppWidgetManager.OPTION_APPWIDGET_MIN_HEIGHT)

      val layout = when {
        minHeight >= 180 -> R.layout.quote_widget_large
        minHeight >= 110 -> R.layout.quote_widget_medium
        else -> R.layout.quote_widget_small
      }

      val views = RemoteViews(context.packageName, layout)
      views.setTextViewText(R.id.quote_text, quoteText)
      views.setTextViewText(R.id.quote_source, source.uppercase(Locale.GERMAN))

      if (layout != R.layout.quote_widget_small) {
        views.setTextViewText(R.id.quote_explanation, explanation)
      }
      if (layout == R.layout.quote_widget_large) {
        views.setTextViewText(R.id.quote_categories, categories)
        views.setTextViewText(R.id.quote_streak, "LEKTUERE · TAG $streak")
      }

      val openIntent = Intent(context, MainActivity::class.java)
      val pendingIntent = PendingIntent.getActivity(
        context,
        appWidgetId,
        openIntent,
        PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
      )
      views.setOnClickPendingIntent(R.id.quote_root, pendingIntent)

      appWidgetManager.updateAppWidget(appWidgetId, views)
    }
  }
}

package com.example.marx_app

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.view.View
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
      val quoteAuthor = prefs.getString("quote_author", "") ?: ""
      val source = prefs.getString("quote_source", null)
        ?: prefs.getString("source", "Zitatatlas") ?: ""
      val explanation = prefs.getString("quote_explanation", null)
        ?: prefs.getString("explanation", "") ?: ""
      val categories = prefs.getString("quote_categories", "") ?: ""
      val streak = prefs.getString("streak", "0") ?: "0"
      val contentType = prefs.getString("content_type", "quote") ?: "quote"
      val widgetMode = prefs.getString("widget_mode", "PUBLIC") ?: "PUBLIC"
      val header = prefs.getString(
        "widget_header",
        prefs.getString("kicker", null)
      ) ?: prefs.getString(
        "widget_header",
        if (contentType == "fact") "WELTGESCHICHTE" else "ZITATATLAS",
      ) ?: "ZITATATLAS"

      val options = appWidgetManager.getAppWidgetOptions(appWidgetId)
      val minHeight = options.getInt(AppWidgetManager.OPTION_APPWIDGET_MIN_HEIGHT)

      val layout = when {
        minHeight >= 110 -> R.layout.quote_widget_v2
        else -> R.layout.quote_widget_small
      }

      val views = RemoteViews(context.packageName, layout)
      views.setTextViewText(R.id.quote_header, header)
      if (layout != R.layout.quote_widget_small) {
        views.setTextViewText(R.id.widget_mode, widgetMode)
        views.setTextViewText(R.id.quote_author, quoteAuthor)
        views.setInt(R.id.quote_text_italic, "setMaxLines", 5)
        views.setInt(R.id.fact_text_normal, "setMaxLines", 4)
        views.setInt(R.id.quote_explanation, "setMaxLines", 2)
      }
      views.setTextViewText(R.id.quote_text_italic, quoteText)
      views.setTextViewText(R.id.fact_text_normal, quoteText)
      views.setTextViewText(R.id.quote_source, source.uppercase(Locale.GERMAN))

      val isFact = contentType == "fact"
      views.setViewVisibility(
        R.id.quote_text_italic,
        if (isFact) View.GONE else View.VISIBLE,
      )
      views.setViewVisibility(
        R.id.fact_text_normal,
        if (isFact) View.VISIBLE else View.GONE,
      )

      if (layout != R.layout.quote_widget_small) {
        views.setTextViewText(R.id.quote_explanation, explanation)
        views.setTextViewText(R.id.quote_categories, categories)
        views.setTextViewText(R.id.quote_streak, "LEKTUERE · TAG $streak")
        views.setViewVisibility(
          R.id.quote_explanation,
          if (explanation.isBlank()) View.GONE else View.VISIBLE,
        )
        views.setViewVisibility(
          R.id.quote_categories,
          if (categories.isBlank()) View.GONE else View.VISIBLE,
        )
        views.setViewVisibility(
          R.id.quote_author,
          if (quoteAuthor.isBlank()) View.GONE else View.VISIBLE,
        )
      }

      val openIntent = Intent(context, MainActivity::class.java)
      openIntent.putExtra(
        "launch_route",
        prefs.getString("launch_route", "/") ?: "/",
      )
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

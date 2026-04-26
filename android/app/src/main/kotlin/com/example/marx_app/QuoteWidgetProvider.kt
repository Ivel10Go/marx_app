package com.example.marx_app

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.util.Log
import android.view.View
import android.widget.RemoteViews
import java.util.Locale

class QuoteWidgetProvider : AppWidgetProvider() {
  override fun onReceive(context: Context, intent: Intent) {
    super.onReceive(context, intent)
    if (intent.action == AppWidgetManager.ACTION_APPWIDGET_UPDATE) {
      refreshAll(context)
    }
  }

  override fun onUpdate(
    context: Context,
    appWidgetManager: AppWidgetManager,
    appWidgetIds: IntArray,
  ) {
    appWidgetIds.forEach { widgetId ->
      updateWidget(context, appWidgetManager, widgetId)
    }
  }

  override fun onAppWidgetOptionsChanged(
    context: Context,
    appWidgetManager: AppWidgetManager,
    appWidgetId: Int,
    newOptions: android.os.Bundle,
  ) {
    super.onAppWidgetOptionsChanged(context, appWidgetManager, appWidgetId, newOptions)
    updateWidget(context, appWidgetManager, appWidgetId)
  }

  companion object {
    private const val LOG_TAG = "QuoteWidgetProvider"

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
      try {
        val prefs = context.getSharedPreferences("HomeWidgetPreferences", Context.MODE_PRIVATE)
        val quoteText = prefs.getString("quote_text", "Tageszitat wird geladen …") ?: ""
        val quoteAuthor = prefs.getString("quote_author", "") ?: ""
        val source = prefs.getString("quote_source", null)
          ?: prefs.getString("source", "Zitatatlas") ?: ""
        val explanation = prefs.getString("quote_explanation", null)
          ?: prefs.getString("explanation", "") ?: ""
        val categories = prefs.getString("quote_categories", "") ?: ""
        val streak = prefs.getString("streak", "0") ?: "0"
        val contentType = prefs.getString("content_type", "quote") ?: "quote"
        val widgetMode = prefs.getString("widget_mode", "PUBLIC") ?: "PUBLIC"
        val isFact = contentType == "fact"
        val isThinkerQuote = contentType == "thinker_quote"
        val header = prefs.getString("widget_header", null)
          ?: prefs.getString("kicker", null)
          ?: when {
            isFact -> "WELTGESCHICHTE"
            isThinkerQuote -> "DENKER"
            else -> "ZITATATLAS"
          }

        val options = appWidgetManager.getAppWidgetOptions(appWidgetId)
        val minHeight = options.getInt(AppWidgetManager.OPTION_APPWIDGET_MIN_HEIGHT)

        val layout = when {
          minHeight <= 0 -> R.layout.quote_widget_medium
          minHeight >= 150 -> R.layout.quote_widget_large
          minHeight >= 90 -> R.layout.quote_widget_medium
          else -> R.layout.quote_widget_small
        }

        val views = RemoteViews(context.packageName, layout)
        views.setTextViewText(R.id.quote_header, header)
        views.setTextViewText(R.id.widget_mode, widgetMode)
        if (layout != R.layout.quote_widget_small) {
          views.setTextViewText(R.id.quote_author, quoteAuthor)
          views.setInt(
            R.id.quote_text_italic,
            "setMaxLines",
            if (layout == R.layout.quote_widget_large) 6 else 5,
          )
          views.setInt(
            R.id.fact_text_normal,
            "setMaxLines",
            if (layout == R.layout.quote_widget_large) 6 else 5,
          )
          views.setInt(
            R.id.quote_explanation,
            "setMaxLines",
            if (layout == R.layout.quote_widget_large) 4 else 2,
          )
        }

        views.setTextViewText(R.id.quote_text_italic, quoteText)
        views.setTextViewText(R.id.fact_text_normal, quoteText)
        views.setTextViewText(R.id.quote_source, source.uppercase(Locale.GERMAN))
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
          views.setTextViewText(R.id.quote_streak, "LEKTÜRE · TAG $streak")
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
        } else {
          views.setTextViewText(R.id.quote_explanation, explanation)
          views.setTextViewText(R.id.quote_categories, categories)
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
      } catch (e: Exception) {
        Log.e(LOG_TAG, "Widget render failed for id=$appWidgetId, using fallback", e)
        val fallbackViews = RemoteViews(context.packageName, R.layout.quote_widget_v2)
        fallbackViews.setTextViewText(R.id.quote_header, "ZITATATLAS")
        fallbackViews.setTextViewText(R.id.widget_mode, "PUBLIC")
        fallbackViews.setTextViewText(R.id.quote_text_italic, "Widget wird vorbereitet …")
        fallbackViews.setViewVisibility(R.id.fact_text_normal, View.GONE)
        fallbackViews.setTextViewText(R.id.quote_source, "NEU LADEN")
        val fallbackIntent = Intent(context, MainActivity::class.java)
        fallbackIntent.putExtra("launch_route", "/")
        val fallbackPendingIntent = PendingIntent.getActivity(
          context,
          appWidgetId,
          fallbackIntent,
          PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
        )
        fallbackViews.setOnClickPendingIntent(R.id.quote_root, fallbackPendingIntent)
        appWidgetManager.updateAppWidget(appWidgetId, fallbackViews)
      }
    }
  }
}

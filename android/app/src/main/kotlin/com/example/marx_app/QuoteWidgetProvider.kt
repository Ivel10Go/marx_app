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
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale

class QuoteWidgetProvider : AppWidgetProvider() {
  override fun onReceive(context: Context, intent: Intent) {
    Log.d(LOG_TAG, "onReceive called with action: ${intent.action}")
    super.onReceive(context, intent)
    if (intent.action == AppWidgetManager.ACTION_APPWIDGET_UPDATE) {
      Log.d(LOG_TAG, "Refreshing all widgets")
      refreshAll(context)
    }
  }

  override fun onUpdate(
    context: Context,
    appWidgetManager: AppWidgetManager,
    appWidgetIds: IntArray,
  ) {
    Log.d(LOG_TAG, "onUpdate called for ${appWidgetIds.size} widgets")
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
    Log.d(LOG_TAG, "onAppWidgetOptionsChanged called for widget $appWidgetId")
    super.onAppWidgetOptionsChanged(context, appWidgetManager, appWidgetId, newOptions)
    updateWidget(context, appWidgetManager, appWidgetId)
  }

  companion object {
    private const val LOG_TAG = "QuoteWidgetProvider"

    fun refreshAll(context: Context) {
      Log.d(LOG_TAG, "refreshAll called")
      val manager = AppWidgetManager.getInstance(context)
      val componentName = ComponentName(context, QuoteWidgetProvider::class.java)
      val ids = manager.getAppWidgetIds(componentName)
      Log.d(LOG_TAG, "Found ${ids.size} widget instances to refresh")
      ids.forEach { id ->
        updateWidget(context, manager, id)
      }
    }

    private fun updateWidget(
      context: Context,
      appWidgetManager: AppWidgetManager,
      appWidgetId: Int,
    ) {
      Log.d(LOG_TAG, "updateWidget called for widget $appWidgetId")
      try {
        val prefs = context.getSharedPreferences("HomeWidgetPreferences", Context.MODE_PRIVATE)
        val quoteText = prefs.getString("quote_text", "Tageszitat wird geladen …") ?: ""
        Log.d(LOG_TAG, "Loaded quote_text from SharedPreferences")
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

        val layout = selectLayout(appWidgetManager, appWidgetId, widgetMode, contentType)
        Log.d(LOG_TAG, "Selected layout: ${layoutName(layout)} for widget $appWidgetId")

        val views = RemoteViews(context.packageName, layout)
        
        // Set universal views (present in all layouts)
        try {
          views.setTextViewText(R.id.quote_header, header)
          views.setTextViewText(R.id.widget_mode, widgetMode)
          views.setTextViewText(R.id.quote_author, quoteAuthor)
          Log.d(LOG_TAG, "✓ Set header, mode, author")
        } catch (e: Exception) {
          Log.w(LOG_TAG, "Failed to set header/mode/author: ${e.message}")
        }

        try {
          views.setTextViewText(R.id.quote_text_italic, quoteText)
          views.setTextViewText(R.id.fact_text_normal, quoteText)
          views.setTextViewText(R.id.quote_source, source.uppercase(Locale.GERMAN))
          Log.d(LOG_TAG, "✓ Set quote/fact text and source")
        } catch (e: Exception) {
          Log.w(LOG_TAG, "Failed to set text/source: ${e.message}")
        }

        try {
          views.setViewVisibility(
            R.id.quote_text_italic,
            if (isFact) View.GONE else View.VISIBLE,
          )
          views.setViewVisibility(
            R.id.fact_text_normal,
            if (isFact) View.VISIBLE else View.GONE,
          )
          Log.d(LOG_TAG, "✓ Set text visibility")
        } catch (e: Exception) {
          Log.w(LOG_TAG, "Failed to set text visibility: ${e.message}")
        }

        try {
          views.setTextViewText(R.id.quote_explanation, explanation)
          views.setTextViewText(R.id.quote_categories, categories)
          views.setTextViewText(R.id.quote_streak, "LEKTÜRE · TAG $streak")
          Log.d(LOG_TAG, "✓ Set explanation, categories, streak")
        } catch (e: Exception) {
          Log.w(LOG_TAG, "Failed to set explanation/categories/streak: ${e.message}")
        }

        try {
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
          Log.d(LOG_TAG, "✓ Set explanation/categories/author visibility")
        } catch (e: Exception) {
          Log.w(LOG_TAG, "Failed to set visibility: ${e.message}")
        }

        // Only set layout-specific views when the chosen layout includes them
        if (layout == R.layout.quote_widget_v2 || layout == R.layout.quote_widget_large) {
          try {
            val sdf = SimpleDateFormat("d. MMMM yyyy", Locale.GERMAN)
            val formatted = sdf.format(Date())
            views.setTextViewText(R.id.quote_date, formatted)
            views.setTextViewText(R.id.bottom_series_label, "SERIE")
            views.setTextViewText(R.id.bottom_tag_label, "TAG $streak")
            views.setTextViewText(R.id.widget_favorite, "♥")
            Log.d(LOG_TAG, "✓ Set layout-specific views (date, series, tag, favorite)")
          } catch (e: Exception) {
            Log.w(LOG_TAG, "Failed to set layout-specific views: ${e.message}")
          }
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
        
        try {
          views.setOnClickPendingIntent(R.id.quote_root, pendingIntent)
          Log.d(LOG_TAG, "✓ Set click intent")
        } catch (e: Exception) {
          Log.w(LOG_TAG, "Failed to set click intent: ${e.message}")
        }

        appWidgetManager.updateAppWidget(appWidgetId, views)
        Log.d(LOG_TAG, "✓ Widget $appWidgetId successfully updated with layout ${layoutName(layout)}")
      } catch (e: Exception) {
        Log.e(LOG_TAG, "Widget render failed for id=$appWidgetId, using fallback", e)
        val fallbackViews = RemoteViews(context.packageName, R.layout.quote_widget_compat)
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
        Log.d(LOG_TAG, "Widget $appWidgetId updated with fallback layout")
      }
    }

    private fun selectLayout(
      appWidgetManager: AppWidgetManager,
      appWidgetId: Int,
      widgetMode: String,
      contentType: String,
    ): Int {
      return try {
        val options = appWidgetManager.getAppWidgetOptions(appWidgetId)
        val minWidth = options.getInt(AppWidgetManager.OPTION_APPWIDGET_MIN_WIDTH)
        val minHeight = options.getInt(AppWidgetManager.OPTION_APPWIDGET_MIN_HEIGHT)

        Log.d(LOG_TAG, "Widget size: ${minWidth}x${minHeight}dp")

        when {
          widgetMode.equals("MARX", ignoreCase = true) ||
            contentType == "thinker_quote" ||
            minWidth >= 240 || minHeight >= 160 -> R.layout.quote_widget_v2
          minWidth >= 180 || minHeight >= 120 -> R.layout.quote_widget_medium
          else -> R.layout.quote_widget_small
        }
      } catch (e: Exception) {
        Log.w(LOG_TAG, "Failed to get widget options, using default layout: ${e.message}")
        R.layout.quote_widget_small
      }
    }

    private fun layoutName(layoutId: Int): String {
      return when (layoutId) {
        R.layout.quote_widget_v2 -> "quote_widget_v2"
        R.layout.quote_widget_medium -> "quote_widget_medium"
        R.layout.quote_widget_small -> "quote_widget_small"
        R.layout.quote_widget_large -> "quote_widget_large"
        R.layout.quote_widget_compat -> "quote_widget_compat"
        else -> "unknown_layout_$layoutId"
      }
    }
  }
}

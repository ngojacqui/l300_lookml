connection: "jacqui_lags_pbl"

include: "/views/*.view.lkml"

datagroup: disney_streaming_default_datagroup {
  max_cache_age: "1 hour"
}

explore: viewing_sessions {
  join: content_catalog {
    type: left_outer
    sql_on: ${viewing_sessions.content_id} = ${content_catalog.content_id} ;;
    relationship: many_to_one
  }

  join: subscribers {
    type: left_outer
    sql_on: ${viewing_sessions.subscriber_id} = ${subscribers.subscriber_id} ;;
    relationship: many_to_one
  }

  # L300: Aggregate Table example
  aggregate_table: rollup_monthly_viewing {
    query: {
      dimensions: [viewing_sessions.session_start_month, content_catalog.genre]
      measures: [viewing_sessions.total_duration, viewing_sessions.count]
    }
    materialization: {
      datagroup_trigger: disney_streaming_default_datagroup
    }
  }
}


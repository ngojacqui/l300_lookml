view: viewing_sessions {
  sql_table_name: `dynamic_union.viewing_sessions` ;;

  dimension: session_id {
    primary_key: yes
    type: string
    sql: ${TABLE}.session_id ;;
  }

  dimension: subscriber_id {
    type: string
    sql: ${TABLE}.subscriber_id ;;
  }

  dimension: content_id {
    type: string
    sql: ${TABLE}.content_id ;;
  }

  dimension_group: session_start {
    type: time
    timeframes: [raw, time, date, week, month, year]
    sql: ${TABLE}.session_start_at ;;
  }

  dimension: duration_minutes {
    type: number
    sql: ${TABLE}.duration_minutes ;;
  }

  dimension: device_type {
    type: string
    sql: ${TABLE}.device_type ;;
  }

  measure: count {
    type: count
    drill_fields: [session_id, subscribers.country, content_catalog.title, session_start_date]
  }

  measure: total_duration {
    type: sum
    sql: ${duration_minutes} ;;
  }
  
  measure: average_duration {
    type: average
    sql: ${duration_minutes} ;;
  }

  # L300: Parameters example
  parameter: metric_selector {
    type: unquoted
    allowed_value: {
      label: "Total Sessions"
      value: "count"
    }
    allowed_value: {
      label: "Total Duration (Minutes)"
      value: "total_duration"
    }
    allowed_value: {
      label: "Average Duration"
      value: "average_duration"
    }
  }

  measure: dynamic_metric {
    type: number
    label_from_parameter: metric_selector
    sql: 
      {% if metric_selector._parameter_value == 'count' %}
        ${count}
      {% elsif metric_selector._parameter_value == 'total_duration' %}
        ${total_duration}
      {% else %}
        ${average_duration}
      {% endif %} ;;
  }
}

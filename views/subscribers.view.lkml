view: subscribers {
  sql_table_name: `dynamic_union.subscribers` ;;

  dimension: subscriber_id {
    primary_key: yes
    type: string
    sql: ${TABLE}.subscriber_id ;;
  }

  dimension_group: signup {
    type: time
    timeframes: [raw, date, week, month, year]
    datatype: date
    sql: ${TABLE}.signup_date ;;
  }

  dimension: subscription_tier {
    type: string
    sql: ${TABLE}.subscription_tier ;;
  }

  dimension: country {
    type: string
    sql: ${TABLE}.country ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
  }
  
  measure: count {
    type: count
  }
}

view: content_catalog {
  sql_table_name: `dynamic_union.content_catalog` ;;

  dimension: content_id {
    primary_key: yes
    type: string
    sql: ${TABLE}.content_id ;;
  }

  dimension: title {
    type: string
    sql: ${TABLE}.title ;;
    # L300: Liquid example - rendering dynamic HTML or link
    html: <a href="https://www.google.com/search?q={{ value | url_encode }}">{{ value }}</a> ;;
  }

  dimension: type {
    type: string
    sql: ${TABLE}.type ;;
  }

  dimension: genre {
    type: string
    sql: ${TABLE}.genre ;;
  }

  dimension: release_year {
    type: number
    sql: ${TABLE}.release_year ;;
  }

  dimension: brand {
    type: string
    sql: ${TABLE}.brand ;;
  }

  # L300: Templated Filter example
  filter: genre_filter {
    type: string
    suggest_dimension: genre
  }

  dimension: is_selected_genre {
    type: yesno
    sql: {% condition genre_filter %} ${genre} {% endcondition %} ;;
  }
}


- dashboard: disney_executive_overview
  title: "🏰 Disney Streaming: Executive Overview"
  layout: newspaper
  preferred_viewer: dashboards-next
  description: "High-level overview of subscriber and viewing metrics."

  filters:
    - name: Date
      title: Date
      type: field_filter
      default_value: "last 30 days"
      allow_multiple_values: true
      required: false
      ui_config:
        type: advanced
        display: popover
      model: l300_disney_streaming
      explore: viewing_sessions
      listens_to_filters: []
      field: viewing_sessions.session_start_date

  elements:
    - name: "Header"
      type: text
      title_text: "Disney Streaming Executive Overview"
      subtitle_text: "A comprehensive look at our platform's health."
      body_text: >
        **Welcome to the Executive Overview.**

        This dashboard provides real-time insights into our global subscriber base and overall platform engagement. Use the Date filter above to adjust the timeframe.
      row: 0
      col: 0
      width: 24
      height: 3

    - name: "Active Subscribers KPI"
      title: "Active Subscribers"
      type: single_value
      model: l300_disney_streaming
      explore: viewing_sessions
      measures: [subscribers.count]
      filters:
        subscribers.status: "Active"
      listen:
        Date: viewing_sessions.session_start_date
      row: 3
      col: 0
      width: 8
      height: 4
      show_single_value_title: true
      single_value_title: "Active Subscribers"
      custom_color_enabled: true
      custom_color: "#113CCF"

    - name: "Total Watch Time KPI"
      title: "Total Watch Time (Min)"
      type: single_value
      model: l300_disney_streaming
      explore: viewing_sessions
      measures: [viewing_sessions.total_duration]
      listen:
        Date: viewing_sessions.session_start_date
      row: 3
      col: 8
      width: 8
      height: 4
      custom_color_enabled: true
      custom_color: "#ED1D24"

    - name: "Average Session Duration KPI"
      title: "Avg Session Duration"
      type: single_value
      model: l300_disney_streaming
      explore: viewing_sessions
      measures: [viewing_sessions.average_duration]
      listen:
        Date: viewing_sessions.session_start_date
      row: 3
      col: 16
      width: 8
      height: 4
      custom_color_enabled: true
      custom_color: "#F9D72F"

    - name: "Watch Time by Brand"
      title: "Watch Time Share by Franchise"
      type: looker_pie
      model: l300_disney_streaming
      explore: viewing_sessions
      dimensions: [content_catalog.brand]
      measures: [viewing_sessions.total_duration]
      listen:
        Date: viewing_sessions.session_start_date
      row: 7
      col: 0
      width: 12
      height: 8
      inner_radius: 50
      series_colors:
        "Disney": "#113CCF"
        "Pixar": "#F9D72F"
        "Marvel": "#ED1D24"
        "Star Wars": "#232323"
        "Nat Geo": "#FFCC00"
      value_labels: legend

    - name: "Viewing Trends"
      title: "Daily Viewing Trends"
      type: looker_line
      model: l300_disney_streaming
      explore: viewing_sessions
      dimensions: [viewing_sessions.session_start_date]
      measures: [viewing_sessions.total_duration]
      listen:
        Date: viewing_sessions.session_start_date
      row: 7
      col: 12
      width: 12
      height: 8
      x_axis_gridlines: false
      y_axis_gridlines: true
      show_y_axis_labels: true
      show_y_axis_ticks: true
      y_axis_tick_density: default
      y_axis_tick_density_custom: 5
      show_x_axis_label: false
      show_x_axis_ticks: true
      x_axis_scale: auto
      point_style: circle_outline
      series_colors:
        viewing_sessions.total_duration: "#113CCF"

    - name: "Global Subscriber Distribution"
      title: "Global Subscriber Distribution"
      type: looker_geo_choropleth
      model: l300_disney_streaming
      explore: viewing_sessions
      dimensions: [subscribers.country]
      measures: [subscribers.count]
      listen:
        Date: viewing_sessions.session_start_date
      row: 15
      col: 0
      width: 12
      height: 8
      map: auto
      map_projection: ""
      quantize_colors: false
      empty_color: "#F4F4F8"
      outer_border_color: "#BDBDBD"
      inner_border_color: "#E0E0E0"
      colors: ["#E8EAF6", "#113CCF"]
      
    - name: "Top Performance Data Table"
      title: "Detailed Performance Table"
      type: looker_grid
      model: l300_disney_streaming
      explore: viewing_sessions
      dimensions: [content_catalog.title, content_catalog.brand, content_catalog.type]
      measures: [viewing_sessions.count, viewing_sessions.total_duration]
      sorts: [viewing_sessions.total_duration desc]
      limit: 15
      listen:
        Date: viewing_sessions.session_start_date
      row: 15
      col: 12
      width: 12
      height: 8
      show_view_names: false
      show_row_numbers: true
      truncate_column_names: false
      hide_totals: false
      hide_row_totals: false
      table_theme: white
      limit_displayed_rows: false
      enable_conditional_formatting: true
      conditional_formatting: [{type: along a scale..., value: !!null '', background_color: "#113CCF", font_color: !!null '', color_application: {collection_id: disney_colors, palette_id: disney_colors_sequential, options: {steps: 5}}, bold: false, italic: false, strikethrough: false, fields: !!null ''}]

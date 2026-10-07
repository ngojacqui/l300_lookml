- dashboard: disney_executive_summary
  title: Disney Streaming Executive Summary
  layout: newspaper
  preferred_viewer: dashboards-next
  description: "Executive overview of streaming platform performance, subscriber growth, and content engagement."

  elements:
    # --- HEADER ---
    - name: welcome_text
      type: text
      title_text: "Welcome to the Disney Streaming Analytics Hub"
      subtitle_text: "Platform Performance & Audience Engagement"
      body_text: >
        <div style="display: flex; align-items: center; justify-content: center; border-bottom: 2px solid #114299; padding-bottom: 10px;">
          <!-- Mickey SVG -->
          <div style="margin-right: 20px;">
            <svg width="60" height="60" viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg">
              <circle cx="50" cy="60" r="30" fill="#114299" />
              <circle cx="20" cy="25" r="18" fill="#114299" />
              <circle cx="80" cy="25" r="18" fill="#114299" />
            </svg>
          </div>

          <div style="text-align: center;">
            <h1 style="color: #114299; margin-bottom: 0;">Disney Streaming</h1>
            <h3 style="color: #333; margin-top: 5px;">Executive Summary Dashboard</h3>
          </div>

          <!-- Minnie SVG -->
          <div style="margin-left: 20px;">
            <svg width="60" height="60" viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg">
              <circle cx="50" cy="60" r="30" fill="#114299" />
              <circle cx="20" cy="25" r="18" fill="#114299" />
              <circle cx="80" cy="25" r="18" fill="#114299" />
              <!-- Minnie's Bow -->
              <polygon points="50,30 25,10 25,45" fill="#E23636" />
              <polygon points="50,30 75,10 75,45" fill="#E23636" />
              <circle cx="50" cy="30" r="8" fill="#FFFFFF" />
            </svg>
          </div>
        </div>
        <p style="text-align: center; margin-top: 15px;">This dashboard provides real-time insights into our global subscriber base, content popularity, and overall audience engagement.</p>
      row: 0
      col: 0
      width: 24
      height: 6

    # --- KPIs ---
    - name: total_subscribers
      title: Total Subscribers
      type: single_value
      model: l300_disney_streaming
      explore: viewing_sessions
      measures: [subscribers.count]
      listen:
        Date Filter: viewing_sessions.session_start_date
        Country: subscribers.country
      row: 6
      col: 0
      width: 6
      height: 3

    - name: total_viewing_sessions
      title: Total Viewing Sessions
      type: single_value
      model: l300_disney_streaming
      explore: viewing_sessions
      measures: [viewing_sessions.count]
      listen:
        Date Filter: viewing_sessions.session_start_date
        Country: subscribers.country
      row: 6
      col: 6
      width: 6
      height: 3

    - name: total_watch_time
      title: Total Watch Time (Minutes)
      type: single_value
      model: l300_disney_streaming
      explore: viewing_sessions
      measures: [viewing_sessions.total_duration_minutes]
      listen:
        Date Filter: viewing_sessions.session_start_date
        Country: subscribers.country
      row: 6
      col: 12
      width: 6
      height: 3

    - name: average_watch_time
      title: Avg. Watch Time per Session
      type: single_value
      model: l300_disney_streaming
      explore: viewing_sessions
      measures: [viewing_sessions.average_duration_minutes]
      listen:
        Date Filter: viewing_sessions.session_start_date
        Country: subscribers.country
      row: 6
      col: 18
      width: 6
      height: 3

    # --- MAIN VISUALS ---
    - name: subscribers_by_tier
      title: Subscribers by Tier
      type: looker_pie
      model: l300_disney_streaming
      explore: viewing_sessions
      dimensions: [subscribers.subscription_tier]
      measures: [subscribers.count]
      inner_radius: 50
      colors: ["#114299", "#8E24AA", "#00ACC1"]
      listen:
        Date Filter: viewing_sessions.session_start_date
        Country: subscribers.country
      row: 9
      col: 0
      width: 8
      height: 6

    - name: viewers_by_device
      title: Viewing Sessions by Device
      type: looker_pie
      model: l300_disney_streaming
      explore: viewing_sessions
      dimensions: [viewing_sessions.device_type]
      measures: [viewing_sessions.count]
      inner_radius: 50
      colors: ["#E23636", "#F9A825", "#000000", "#114299"]
      listen:
        Date Filter: viewing_sessions.session_start_date
        Country: subscribers.country
      row: 9
      col: 8
      width: 8
      height: 6

    - name: top_content
      title: Top 5 Most Watched Content
      type: looker_bar
      model: l300_disney_streaming
      explore: viewing_sessions
      dimensions: [content_catalog.title, content_catalog.brand]
      measures: [viewing_sessions.total_duration_minutes]
      sorts: [viewing_sessions.total_duration_minutes desc]
      limit: 5
      x_axis_gridlines: false
      y_axis_gridlines: true
      show_y_axis_labels: true
      show_y_axis_ticks: true
      y_axis_tick_density: default
      y_axis_tick_density_custom: 5
      show_x_axis_label: false
      show_x_axis_ticks: true
      y_axis_scale_mode: linear
      x_axis_reversed: false
      y_axis_reversed: false
      plot_size_by_field: false
      trellis: ''
      stacking: ''
      limit_displayed_rows: false
      legend_position: center
      series_colors:
        Disney: '#114299'
        Marvel: '#E23636'
        Star Wars: '#000000'
        Pixar: '#F9A825'
        Nat Geo: '#FFCA28'
      point_style: none
      show_value_labels: true
      label_density: 25
      x_axis_scale: auto
      y_axis_combined: true
      ordering: none
      show_null_labels: false
      show_totals_labels: false
      show_silhouette: false
      totals_color: "#808080"
      listen:
        Date Filter: viewing_sessions.session_start_date
        Country: subscribers.country
      row: 9
      col: 16
      width: 8
      height: 6

    - name: engagement_over_time
      title: Viewing Engagement over Time
      type: looker_line
      model: l300_disney_streaming
      explore: viewing_sessions
      dimensions: [viewing_sessions.session_start_date]
      measures: [viewing_sessions.total_duration_minutes]
      sorts: [viewing_sessions.session_start_date]
      x_axis_gridlines: false
      y_axis_gridlines: true
      show_view_names: false
      show_y_axis_labels: true
      show_y_axis_ticks: true
      y_axis_tick_density: default
      show_x_axis_label: true
      show_x_axis_ticks: true
      y_axis_scale_mode: linear
      x_axis_reversed: false
      y_axis_reversed: false
      plot_size_by_field: false
      trellis: ''
      stacking: ''
      limit_displayed_rows: false
      legend_position: center
      point_style: circle
      show_value_labels: false
      label_density: 25
      x_axis_scale: auto
      y_axis_combined: true
      show_null_points: true
      interpolation: monotone
      series_colors:
        viewing_sessions.total_duration_minutes: "#114299"
      listen:
        Date Filter: viewing_sessions.session_start_date
        Country: subscribers.country
      row: 15
      col: 0
      width: 16
      height: 6

    - name: brand_performance
      title: Brand Performance Breakdown
      type: looker_column
      model: l300_disney_streaming
      explore: viewing_sessions
      dimensions: [content_catalog.brand]
      measures: [viewing_sessions.count, viewing_sessions.total_duration_minutes]
      sorts: [viewing_sessions.total_duration_minutes desc]
      x_axis_gridlines: false
      y_axis_gridlines: true
      show_view_names: false
      show_y_axis_labels: true
      show_y_axis_ticks: true
      y_axis_tick_density: default
      show_x_axis_label: false
      show_x_axis_ticks: true
      y_axis_scale_mode: linear
      x_axis_reversed: false
      y_axis_reversed: false
      plot_size_by_field: false
      trellis: ''
      stacking: ''
      limit_displayed_rows: false
      legend_position: center
      point_style: none
      show_value_labels: true
      label_density: 25
      x_axis_scale: auto
      y_axis_combined: true
      ordering: none
      show_null_labels: false
      show_totals_labels: false
      show_silhouette: false
      totals_color: "#808080"
      y_axes: [{label: '', orientation: left, series: [{axisId: viewing_sessions.count,
              id: viewing_sessions.count, name: Viewing Sessions}], showLabels: true,
          showValues: true, unpinAxis: false, tickDensity: default, tickDensityCustom: 5,
          type: linear}, {label: !!null '', orientation: right, series: [{axisId: viewing_sessions.total_duration_minutes,
              id: viewing_sessions.total_duration_minutes, name: Total Duration Minutes}],
          showLabels: true, showValues: true, unpinAxis: false, tickDensity: default,
          tickDensityCustom: 5, type: linear}]
      listen:
        Date Filter: viewing_sessions.session_start_date
        Country: subscribers.country
      row: 15
      col: 16
      width: 8
      height: 6

    # --- SECTION: DEMOGRAPHICS ---
    - name: section_demographics
      type: text
      title_text: "Subscriber Demographics & Status"
      body_text: "Breakdown of our user base across geographic regions and their current account standing."
      row: 21
      col: 0
      width: 24
      height: 2

    - name: subscribers_by_country
      title: Global Subscribers
      type: looker_geo_choropleth
      model: l300_disney_streaming
      explore: viewing_sessions
      dimensions: [subscribers.country]
      measures: [subscribers.count]
      map: world
      map_projection: ''
      show_view_names: false
      quantize_colors: false
      colors: ["#E1F5FE", "#114299"]
      empty_color: "#f5f5f5"
      listen:
        Date Filter: viewing_sessions.session_start_date
        Country: subscribers.country
      row: 23
      col: 0
      width: 12
      height: 8

    - name: subscriber_status
      title: Account Status Breakdown
      type: looker_column
      model: l300_disney_streaming
      explore: viewing_sessions
      dimensions: [subscribers.status]
      measures: [subscribers.count]
      sorts: [subscribers.count desc]
      x_axis_gridlines: false
      y_axis_gridlines: true
      show_y_axis_labels: true
      show_y_axis_ticks: true
      y_axis_tick_density: default
      show_x_axis_label: false
      show_x_axis_ticks: true
      y_axis_scale_mode: linear
      show_value_labels: true
      series_colors:
        Active: '#00ACC1'
        Paused: '#F9A825'
        Cancelled: '#E23636'
      listen:
        Date Filter: viewing_sessions.session_start_date
        Country: subscribers.country
      row: 23
      col: 12
      width: 12
      height: 8

    # --- SECTION: DEEP DIVE ---
    - name: section_content_performance
      type: text
      title_text: "Content Performance Deep Dive"
      body_text: "Detailed analysis of how individual titles are performing across genres."
      row: 31
      col: 0
      width: 24
      height: 2

    - name: content_performance_table
      title: Content Catalog Performance
      type: looker_grid
      model: l300_disney_streaming
      explore: viewing_sessions
      dimensions: [content_catalog.title, content_catalog.brand, content_catalog.genre, content_catalog.type]
      measures: [viewing_sessions.count, viewing_sessions.total_duration_minutes]
      sorts: [viewing_sessions.count desc]
      show_view_names: false
      show_row_numbers: true
      transpose: false
      truncate_text: true
      hide_totals: false
      hide_row_totals: false
      size_to_fit: true
      table_theme: white
      limit_displayed_rows: false
      enable_conditional_formatting: true
      header_text_alignment: left
      header_font_size: '12'
      rows_font_size: '12'
      conditional_formatting_include_totals: false
      conditional_formatting_include_nulls: false
      conditional_formatting: [{type: along a scale..., value: !!null '', background_color: !!null '',
          font_color: !!null '', color_application: {collection_id: b43731d5-dc87-4a8e-b807-635bef3948e7,
            palette_id: 85de97da-2ded-4dec-9ceb-36d14c8ca4ee, options: {steps: 5}},
          bold: false, italic: false, strikethrough: false, fields: [viewing_sessions.total_duration_minutes]}]
      listen:
        Date Filter: viewing_sessions.session_start_date
        Country: subscribers.country
      row: 33
      col: 0
      width: 24
      height: 8

  filters:
    - name: Date Filter
      title: Date Filter
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

    - name: Country
      title: Country
      type: field_filter
      default_value: ""
      allow_multiple_values: true
      required: false
      ui_config:
        type: tag_list
        display: popover
      model: l300_disney_streaming
      explore: viewing_sessions
      listens_to_filters: []
      field: subscribers.country

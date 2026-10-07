- dashboard: disney_content_performance
  title: "🎬 Disney Streaming: Content Performance"
  layout: newspaper
  preferred_viewer: dashboards-next
  description: "Deep dive into content engagement and genre performance."

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

    - name: Brand
      title: Brand
      type: field_filter
      default_value: ""
      allow_multiple_values: true
      required: false
      ui_config:
        type: checkboxes
        display: popover
      model: l300_disney_streaming
      explore: viewing_sessions
      listens_to_filters: []
      field: content_catalog.brand

  elements:
    # --- HEADER ---
    - name: welcome_text
      type: text
      title_text: "Welcome to the Disney Content Performance Hub"
      subtitle_text: "Content Engagement & Title Analytics"
      body_text: >
        <div style="display: flex; align-items: center; justify-content: center; border-bottom: 2px solid #ED1D24; padding-bottom: 10px;">
          <div style="margin-right: 20px;">
            <!-- Clapperboard SVG -->
            <svg width="60" height="60" viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg">
              <rect x="10" y="30" width="80" height="50" fill="#232323" />
              <polygon points="10,30 30,10 40,10 20,30" fill="#ED1D24" />
              <polygon points="35,30 55,10 65,10 45,30" fill="#ED1D24" />
              <polygon points="60,30 80,10 90,10 70,30" fill="#ED1D24" />
              <line x1="10" y1="30" x2="90" y2="30" stroke="#FFFFFF" stroke-width="2" />
            </svg>
          </div>

          <div style="text-align: center;">
            <h1 style="color: #ED1D24; margin-bottom: 0;">Disney Streaming</h1>
            <h3 style="color: #333; margin-top: 5px;">Content Performance Dashboard</h3>
          </div>

          <div style="margin-left: 20px;">
            <!-- Play Button SVG -->
            <svg width="60" height="60" viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg">
              <circle cx="50" cy="50" r="40" fill="#113CCF" />
              <polygon points="40,30 40,70 70,50" fill="#FFFFFF" />
            </svg>
          </div>
        </div>
        <p style="text-align: center; margin-top: 15px;">This dashboard provides a deep dive into content engagement, top performing titles, and audience viewing habits.</p>
      row: 0
      col: 0
      width: 24
      height: 6

    # --- KPIs ---
    - name: total_viewing_sessions
      title: Total Viewing Sessions
      type: single_value
      model: l300_disney_streaming
      explore: viewing_sessions
      measures: [viewing_sessions.count]
      listen:
        Date Filter: viewing_sessions.session_start_date
        Brand: content_catalog.brand
      row: 6
      col: 0
      width: 8
      height: 3

    - name: total_watch_time
      title: Total Watch Time
      type: single_value
      model: l300_disney_streaming
      explore: viewing_sessions
      measures: [viewing_sessions.total_duration]
      listen:
        Date Filter: viewing_sessions.session_start_date
        Brand: content_catalog.brand
      row: 6
      col: 8
      width: 8
      height: 3

    - name: average_watch_time
      title: Avg. Watch Time per Session
      type: single_value
      model: l300_disney_streaming
      explore: viewing_sessions
      measures: [viewing_sessions.average_duration]
      listen:
        Date Filter: viewing_sessions.session_start_date
        Brand: content_catalog.brand
      row: 6
      col: 16
      width: 8
      height: 3

    # --- SECTION: OVERVIEW ---
    - name: section_overview
      type: text
      title_text: "Content Performance Overview"
      body_text: "High-level view of how different titles and franchises are resonating with the audience."
      row: 9
      col: 0
      width: 24
      height: 2

    - name: "Top 10 Titles by Watch Time"
      title: "Top 10 Titles by Watch Time"
      type: looker_bar
      model: l300_disney_streaming
      explore: viewing_sessions
      dimensions: [content_catalog.title, content_catalog.brand]
      measures: [viewing_sessions.total_duration]
      sorts: [viewing_sessions.total_duration desc]
      limit: 10
      listen:
        Brand: content_catalog.brand
        Date Filter: viewing_sessions.session_start_date
      row: 11
      col: 0
      width: 12
      height: 8
      x_axis_gridlines: false
      y_axis_gridlines: true
      show_view_names: false
      show_y_axis_labels: true
      show_y_axis_ticks: true
      show_x_axis_label: false
      show_x_axis_ticks: true
      y_axis_reversed: false
      plot_size_by_field: false
      trellis: ''
      stacking: ''
      limit_displayed_rows: false
      legend_position: center
      series_colors:
        "Disney": "#113CCF"
        "Pixar": "#F9D72F"
        "Marvel": "#ED1D24"
        "Star Wars": "#232323"
        "Nat Geo": "#FFCC00"
      value_labels: legend
      label_type: labPer
      inner_radius: 50

    - name: "Engagement by Genre"
      title: "Engagement by Genre"
      type: looker_column
      model: l300_disney_streaming
      explore: viewing_sessions
      dimensions: [content_catalog.genre]
      measures: [viewing_sessions.total_duration, viewing_sessions.count]
      sorts: [viewing_sessions.total_duration desc]
      listen:
        Brand: content_catalog.brand
        Date Filter: viewing_sessions.session_start_date
      row: 11
      col: 12
      width: 12
      height: 8
      x_axis_gridlines: false
      y_axis_gridlines: true
      show_view_names: false
      show_y_axis_labels: true
      show_y_axis_ticks: true
      show_x_axis_label: false
      show_x_axis_ticks: true
      y_axis_combined: false
      y_axis_orientation: [left, right]
      series_colors:
        viewing_sessions.total_duration: "#F9D72F"
        viewing_sessions.count: "#113CCF"

    - name: engagement_over_time
      title: Watch Time over Time
      type: looker_line
      model: l300_disney_streaming
      explore: viewing_sessions
      dimensions: [viewing_sessions.session_start_date]
      measures: [viewing_sessions.total_duration]
      sorts: [viewing_sessions.session_start_date]
      x_axis_gridlines: false
      y_axis_gridlines: true
      show_view_names: false
      show_y_axis_labels: true
      show_y_axis_ticks: true
      show_x_axis_label: true
      show_x_axis_ticks: true
      y_axis_scale_mode: linear
      legend_position: center
      point_style: circle
      show_value_labels: false
      interpolation: monotone
      series_colors:
        viewing_sessions.total_duration: "#ED1D24"
      listen:
        Brand: content_catalog.brand
        Date Filter: viewing_sessions.session_start_date
      row: 19
      col: 0
      width: 24
      height: 6

    # --- SECTION: AUDIENCE BEHAVIOR ---
    - name: section_audience_behavior
      type: text
      title_text: "Audience Behavior & Hardware"
      body_text: "Understanding how and where our audience is engaging with content."
      row: 25
      col: 0
      width: 24
      height: 2

    - name: "Device Breakdown"
      title: "Sessions by Device Type"
      type: looker_pie
      model: l300_disney_streaming
      explore: viewing_sessions
      dimensions: [viewing_sessions.device_type]
      measures: [viewing_sessions.count]
      listen:
        Brand: content_catalog.brand
        Date Filter: viewing_sessions.session_start_date
      row: 27
      col: 0
      width: 8
      height: 6
      inner_radius: 40
      series_colors:
        "Smart TV": "#113CCF"
        "Mobile": "#F9D72F"
        "Tablet": "#ED1D24"
        "Web": "#232323"

    - name: "Duration vs Sessions Scatter"
      title: "Title Engagement Correlation"
      type: looker_scatter
      model: l300_disney_streaming
      explore: viewing_sessions
      dimensions: [content_catalog.title, content_catalog.brand]
      measures: [viewing_sessions.count, viewing_sessions.average_duration]
      listen:
        Brand: content_catalog.brand
        Date Filter: viewing_sessions.session_start_date
      row: 27
      col: 8
      width: 16
      height: 6
      x_axis_gridlines: true
      y_axis_gridlines: true
      show_view_names: false
      show_y_axis_labels: true
      show_x_axis_label: true
      series_colors:
        "Disney": "#113CCF"
        "Pixar": "#F9D72F"
        "Marvel": "#ED1D24"
        "Star Wars": "#232323"
        "Nat Geo": "#FFCC00"
      point_style: circle
      size_by_field: viewing_sessions.count

    # --- SECTION: DETAILED BREAKDOWN ---
    - name: section_detailed_breakdown
      type: text
      title_text: "Detailed Content Logs"
      body_text: "Granular data grid for content performance."
      row: 33
      col: 0
      width: 24
      height: 2

    - name: "Content Performance Grid"
      title: "Content Performance Data"
      type: looker_grid
      model: l300_disney_streaming
      explore: viewing_sessions
      dimensions: [content_catalog.title, content_catalog.genre, content_catalog.brand]
      measures: [viewing_sessions.count, viewing_sessions.total_duration, viewing_sessions.average_duration]
      sorts: [viewing_sessions.total_duration desc]
      listen:
        Brand: content_catalog.brand
        Date Filter: viewing_sessions.session_start_date
      row: 35
      col: 0
      width: 24
      height: 8
      show_view_names: false
      show_row_numbers: true
      truncate_text: true
      hide_totals: false
      hide_row_totals: false
      table_theme: white
      enable_conditional_formatting: true
      conditional_formatting: [{type: along a scale..., value: !!null '', background_color: !!null '',
          font_color: !!null '', color_application: {collection_id: b43731d5-dc87-4a8e-b807-635bef3948e7,
            palette_id: 85de97da-2ded-4dec-9ceb-36d14c8ca4ee, options: {steps: 5}},
          bold: false, italic: false, strikethrough: false, fields: [viewing_sessions.total_duration]}]

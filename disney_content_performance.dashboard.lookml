- dashboard: disney_content_performance
  title: "🎬 Disney Streaming: Content Performance"
  layout: newspaper
  preferred_viewer: dashboards-next
  description: "Deep dive into content engagement and genre performance."

  filters:
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
      row: 0
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
      series_colors:
        "Disney": "#113CCF"
        "Pixar": "#F9D72F"
        "Marvel": "#ED1D24"
        "Star Wars": "#232323"
        "Nat Geo": "#FFCC00"

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
      row: 0
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
      series_colors:
        viewing_sessions.total_duration: "#F9D72F"
        viewing_sessions.count: "#113CCF"

    - name: "Device Breakdown"
      title: "Sessions by Device Type"
      type: looker_pie
      model: l300_disney_streaming
      explore: viewing_sessions
      dimensions: [viewing_sessions.device_type]
      measures: [viewing_sessions.count]
      listen:
        Brand: content_catalog.brand
      row: 8
      col: 0
      width: 8
      height: 6
      inner_radius: 40
      series_colors:
        "Smart TV": "#113CCF"
        "Mobile": "#F9D72F"
        "Tablet": "#ED1D24"
        "Web": "#232323"
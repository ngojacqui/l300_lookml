# This view contains examples of advanced LookML concepts (Liquid, Parameters, and Templated Filters).
# Grounded in dataset: bigquery-public-data.thelook_ecommerce.order_items

view: ecommerce_concepts {
  sql_table_name: `bigquery-public-data.thelook_ecommerce.order_items` ;;

  dimension: order_id {
    primary_key: yes
    type: number
    value_format_name: id
    sql: ${TABLE}.id ;;
  }

  ############################################################################
  # CONCEPT 1: LIQUID
  ############################################################################

  # Example 1.1: Dynamic Label with Liquid
  # Dynamically shifts label depending on the logged-in user's first name
  dimension: dynamic_label_example {
    type: string
    sql: ${TABLE}.status ;;
    label: "
      {% if _user_attributes['first_name'] == 'Jacqui' %}
        Jacqui's Special Status Field
      {% else %}
        Order Status
      {% endif %}"
  }

  # Example 1.2: Dynamic Link with Liquid
  # Generates an external search link pointing to Google for product and brand verification
  dimension: product_google_search {
    label: "Google Search for Product"
    sql: ${TABLE}.product_id ;;
    link: {
      label: "Search for '{{ products.name._value | append: ' ' | append: products.brand._value }}' on Google"
      url: "https://www.google.com/search?q={{ products.name._value | url_encode }}%20{{ products.brand._value | url_encode }}"
      icon_url: "https://www.google.com/favicon.ico"
    }
  }

  ############################################################################
  # CONCEPT 2: PARAMETERS
  ############################################################################

  # Step 1: Define the user selector parameter
  parameter: product_level_selector {
    label: "Select Product Hierarchy Level"
    type: unquoted
    allowed_value: {
      label: "Category"
      value: "category"
    }
    allowed_value: {
      label: "Brand"
      value: "brand"
    }
    allowed_value: {
      label: "Department"
      value: "department"
    }
    default_value: "category"
  }

  # Step 2: Swap the underlying dimension dynamically based on the parameter choice
  dimension: dynamic_product_level {
    label_from_parameter: product_level_selector
    type: string
    sql:
      {% if product_level_selector._parameter_value == 'category' %}
        ${products.category}
      {% elsif product_level_selector._parameter_value == 'brand' %}
        ${products.brand}
      {% else %}
        ${products.department}
      {% endif %} ;;
  }

  ############################################################################
  # CONCEPT 3: TEMPLATED FILTERS
  ############################################################################

  # Step 1: Filter-only field offering category choices to comparisons
  filter: category_comparator {
    label: "Select a Category to Compare"
    type: string
    suggest_dimension: products.category
  }

  # Step 2: Establish comparison group logic using templated filters
  dimension: category_comparison_group {
    label: "Category Comparison"
    type: string
    sql:
      {% condition category_comparator %}
        CASE
          WHEN ${products.category} = {% parameter category_comparator %} THEN {% parameter category_comparator %}
          ELSE 'All Other Categories'
        END
      {% else %}
        'All Categories'
      {% endcondition %} ;;
  }

  measure: total_sale_price {
    type: sum
    sql: ${TABLE}.sale_price ;;
    value_format_name: usd
  }
}
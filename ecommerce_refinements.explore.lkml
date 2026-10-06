# explores/ecommerce_refinements.explore.lkml
# This file demonstrates Concept 4 (Aggregate Tables) and Concept 5 (Refinements).

include: "/views/*.view.lkml"

# Assume a base explore "order_items" exists in your project.
# We join the concepts view and set up the aggregate table.
explore: order_items {

  # Join our newly created dynamic concepts view
  join: ecommerce_concepts {
    type: left_outer
    relationship: one_to_one
    sql_on: ${order_items.id} = ${ecommerce_concepts.order_id} ;;
  }

  ############################################################################
  # CONCEPT 4: AGGREGATE TABLES
  # Speeds up queries running on a monthly scale by referencing a pre-aggregated dataset.
  ############################################################################
  # aggregate_table: order_items_monthly_sales {
  #   query: {
  #     dimensions: [order_items.created_month, users.country]
  #     measures: [ecommerce_concepts.total_sale_price]
  #   }
  #   materialization: {
  #     sql_trigger: SELECT CURRENT_DATE() ;;
  #   }
  # }
}

############################################################################
# CONCEPT 5: REFINEMENTS
# Refines the base "order_items" explore without overwriting or duplicating it.
############################################################################
explore: +order_items {
  label: "Order Analysis (with Advanced Concepts)"

  # Apply a default filter using the refinement
  always_filter: {
    filters: [ecommerce_concepts.product_level_selector: "category"]
  }
}

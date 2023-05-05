# Define the database connection to be used for this model.
connection: "@{CONNECTION_NAME}"

# include all the views
include: "/views/**/*.view"

# Datagroups define a caching policy for an Explore. To learn more,
# use the Quick Help panel on the right to see documentation.

datagroup: cortex_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

persist_with: cortex_default_datagroup

# Explores allow you to join together different views (database tables) based on the
# relationships between fields. By joining a view into an Explore, you make those
# fields available to users for data analysis.
# Explores should be purpose-built for specific use cases.

# To see the Explore you’re building, navigate to the Explore menu and select an Explore under "Cortex"

# To create more sophisticated Explores that involve multiple views, you can use the join parameter.
# Typically, join parameters require that you define the join type, join relationship, and a sql_on clause.
# Each joined view also needs to define a primary key.

include: "/LookML_Dashboard/*.dashboard.lookml"

explore: data_intelligence_ar {
sql_always_where: ${Client_ID} = "@{CLIENT}" ;;
}

explore:  data_intelligence_otc{
  sql_always_where: ${Client_ID} = "@{CLIENT}" ;;
}

explore: Navigation_Bar {}


explore: accounts_payable_v2 {

  sql_always_where: ${accounts_payable_v2.client_mandt} =  "@{CLIENT}";;
}

explore: days_payable_outstanding_v2 {
  sql_always_where: ${client_mandt} = "@{CLIENT}" ;;
}

explore: accounts_payable_turnover_v2 {

  sql_always_where: ${accounts_payable_turnover_v2.client_mandt} = "@{CLIENT}" ;;
}

explore: cash_discount_utilization {
  sql_always_where: ${client_mandt} = "@{CLIENT}";;
}

explore: materials_valuation_v2 {
  sql_always_where: ${client_mandt} =  "@{CLIENT}" ;;
}


explore: vendor_performance {
  sql_always_where: ${vendor_performance.client_mandt} = "@{CLIENT}"
    and ${language_map.looker_locale}='es_ES'
    ;;

  join: language_map {
    fields: []
    type: left_outer
    sql_on: ${vendor_performance.language_key} = ${language_map.language_key} ;;
    relationship: many_to_one
  }

  join: materials_valuation_v2 {
    type: left_outer
    relationship: many_to_one
    sql_on: ${vendor_performance.client_mandt} = ${materials_valuation_v2.client_mandt}
          and ${vendor_performance.material_number} = ${materials_valuation_v2.material_number_matnr}
          and ${vendor_performance.plant} = ${materials_valuation_v2.valuation_area_bwkey}
          and ${vendor_performance.month_year} = ${materials_valuation_v2.month_year}
          and ${materials_valuation_v2.valuation_type_bwtar} = ''
          ;;
  }
}

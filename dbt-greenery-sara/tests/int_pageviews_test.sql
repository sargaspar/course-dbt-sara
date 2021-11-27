
select
    user_guid
    , session_id
    , total_views
    , count_delete_from_cart
    , count_checkout
    , count_page_view
    , count_add_to_cart
    , count_package_shipped
    , count_account_created

from {{ ref('int_pageviews' )}}

where count_delete_from_cart + count_checkout + count_page_view + count_add_to_cart + count_package_shipped + count_account_created > total_views

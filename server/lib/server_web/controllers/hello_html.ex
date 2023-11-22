defmodule ServerWeb.HelloHTML do
  use ServerWeb, :html

  embed_templates "page_html/*"
end

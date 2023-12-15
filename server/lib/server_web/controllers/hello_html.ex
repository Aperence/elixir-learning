defmodule ServerWeb.HelloHTML do
  use ServerWeb, :html

  embed_templates "hello_html/*"

  attr :messenger, :string, default: nil

  def greet(assigns) do
    ~H"""
    <div>
    Hello world, <%= @messenger %>
    </div>
    """
  end
end

defmodule DonationAppWeb.PageController do
  use DonationAppWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end

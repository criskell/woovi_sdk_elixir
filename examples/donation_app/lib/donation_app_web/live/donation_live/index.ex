defmodule DonationAppWeb.DonationLive.Index do
  use DonationAppWeb, :live_view
  import DonationAppWeb.CoreComponents

  alias DonationApp.Donations
  alias DonationApp.Donations.Donation

  @impl true
  def mount(_params, _session, socket) do
    changeset = Donations.change_donation(%Donation{})

    {:ok,
     socket
     |> assign(:donations, Donations.list_donations())
     |> assign(:form, to_form(changeset))}
  end

  @impl true
  def handle_event("save", %{"donation" => params}, socket) do
    params =
      params
      |> normalize_amount()

    case Donations.create_donation(params) do
      {:ok, _donation} ->
        {:noreply,
         socket
         |> put_flash(:info, "Doação criada com sucesso")
         |> assign(:donations, Donations.list_donations())
         |> assign(:changeset, Donations.change_donation(%Donation{}))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    donation = Donations.get_donation!(id)

    case Donations.delete_donation(donation) do
      {:ok, _donation} ->
        {:noreply,
         socket
         |> put_flash(:info, "Doação excluída com sucesso")
         |> assign(:donations, Donations.list_donations())}

      {:error, _changeset} ->
        {:noreply, put_flash(socket, :error, "Erro ao excluir doação")}
    end
  end

  defp normalize_amount(params) do
    cents =
      params["amount"]
      |> String.replace(",", ".")
      |> Decimal.new()
      |> Decimal.mult(100)
      |> Decimal.round(0)
      |> Decimal.to_integer()

    params
    |> Map.delete("amount")
    |> Map.put("amount_cents", cents)
  end

  defp format_money(cents) do
    :erlang.float_to_binary(cents / 100, decimals: 2)
  end

  defp render_donations(assigns) when assigns.donations == [] do
    ~H"""
    <p class="text-gray-500 italic">Nenhuma doação foi encontrada.</p>
    """
  end

  defp render_donations(assigns) do
    ~H"""
    <ul class="space-y-2">
      <%= for donation <- @donations do %>
        <li class="flex justify-between border-b py-2">
          <div class="flex-1">
            <span>{donation.name}</span>
            <span>R$ {format_money(donation.amount_cents)}</span>
          </div>

          <button
            phx-click="delete"
            phx-value-id={donation.id}
            data-confirm="Tem certeza que deseja excluir esta doação?"
            class="text-red-600 hover:text-red-800 text-sm font-medium"
          >
            Excluir
          </button>
        </li>
      <% end %>
    </ul>
    """
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-2xl p-6 space-y-8">
      <h1 class="text-2xl font-bold">Doações</h1>

      <Layouts.flash_group flash={@flash} />

      <.form
        for={@form}
        phx-submit="save"
      >
        <.input
          field={@form[:name]}
          type="text"
          label="Nome do doador"
          required
        />

        <.input
          field={@form[:amount]}
          type="number"
          step="0.01"
          label="Valor da doação (R$)"
          required
        />

        <div class="mt-4">
          <.button>Salvar</.button>
        </div>
      </.form>

      <div>
        <h2 class="text-xl font-semibold mb-2">Lista de doações</h2>
        {render_donations(assigns)}
      </div>
    </div>
    """
  end
end

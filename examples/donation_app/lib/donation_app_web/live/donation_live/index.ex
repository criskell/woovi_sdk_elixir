defmodule DonationAppWeb.DonationLive.Index do
  use DonationAppWeb, :live_view
  import DonationAppWeb.CoreComponents

  alias DonationApp.Donations
  alias DonationApp.Donations.Donation
  require Logger

  @impl true
  @spec mount(any(), any(), map()) :: {:ok, map()}
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:donations, Donations.list_donations())
     |> assign(:form, to_form(Donations.change_donation(%Donation{})))
     |> assign(:show_payment_modal, false)
     |> assign(:qrcode_image_url, nil)
     |> assign(:brcode, nil)}
  end

  @impl true
  def handle_event("save", %{"donation" => params}, socket) do
    params =
      params
      |> normalize_amount()

    case Donations.create_donation(params) do
      {:ok, %{donation: donation, brcode: brcode, qrcode_image_url: qrcode_image_url}} ->
        if connected?(socket) do
          Phoenix.PubSub.subscribe(
            DonationApp.PubSub,
            "donation:#{donation.id}"
          )
        end

        {:noreply,
         socket
         |> put_flash(:info, "Doação criada com sucesso")
         |> assign(:donations, Donations.list_donations())
         |> assign(
           :form,
           to_form(Donations.change_donation(%Donation{}))
         )
         |> assign(:show_payment_modal, true)
         |> assign(:brcode, brcode)
         |> assign(:qrcode_image_url, qrcode_image_url)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :form, to_form(changeset))}

      {:error, {:payment_failed, error}} ->
        Logger.error("Request while creating PIX charge: #{inspect(error, pretty: true)}", error)

        {:noreply,
         socket
         |> put_flash(:error, "Erro ao criar cobrança PIX")}
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

  @impl true
  def handle_event("close_qrcode", _params, socket) do
    {:noreply, assign(socket, :show_payment_modal, false)}
  end

  @impl true
  def handle_event("clear_form", _, socket) do
    {:noreply, assign(socket, :form, to_form(Donations.change_donation(%Donation{})))}
  end

  @impl true
  def handle_event("validate", %{"donation" => params}, socket) do
    changeset =
      %Donation{}
      |> Donations.change_donation(params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :form, to_form(changeset))}
  end

  @impl true
  def handle_info(%{event: "payment_confirmed"}, socket) do
    {:noreply,
     socket
     |> put_flash(:info, "Doação confirmada com sucesso! Obrigado!")
     |> assign(:show_payment_modal, false)
     |> assign(:brcode, nil)
     |> assign(:qrcode_image_url, nil)
     |> assign(:donations, Donations.list_donations())}
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
    IO.inspect(
      ~H"""
      <.input
        field={@form[:name]}
        type="text"
        label="Nome do doador"
        required
      />
      """
      |> Phoenix.HTML.html_escape()
      |> Phoenix.HTML.safe_to_string()
    )

    ~H"""
    <div class="mx-auto max-w-2xl p-6 space-y-8">
      <h1 class="text-2xl font-bold">Doações</h1>

      <Layouts.flash_group flash={@flash} />

      <.form
        for={@form}
        phx-submit="save"
        phx-change="validate"
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

        <.input
          field={@form[:tax_id]}
          type="text"
          label="CPF/CNPJ"
          required
        />

        <div class="mt-4">
          <.button>Doar</.button>
        </div>
      </.form>

      <.button phx-click="clear_form">Limpar</.button>

      <div>
        <h2 class="text-xl font-semibold mb-2">Lista de doações</h2>

        {render_donations(assigns)}

        <%= if @show_payment_modal do %>
          <div class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
            <div class="bg-white rounded-lg p-6 max-w-md w-full mx-4">
              <div class="flex justify-between items-center mb-4">
                <h3 class="text-xl font-bold text-gray-900">Envie o pagamento via PIX</h3>
                <button phx-click="close_qrcode" class="text-gray-500 hover:text-gray-700">
                  ×
                </button>
              </div>

              <div class="text-center space-y-4">
                <p class="text-gray-600">Escaneie o QR Code abaixo para realizar o pagamento</p>

                <div class="flex justify-center p-4 bg-gray-50 rounded">
                  <img src={@qrcode_image_url} alt="QR Code Pix" class="w-64 h-64" />
                </div>

                <div class="space-y-2">
                  <p class="text-sm text-gray-600">Ou copie o código PIX:</p>

                  <div class="flex gap-2">
                    <input
                      type="text"
                      value={@brcode}
                      readonly
                      class="flex-1 px-3 py-2 border rounded text-sm bg-gray-50 text-gray-600"
                    />

                    <button
                      onclick={"navigator.clipboard.writeText('#{@brcode}')"}
                      class="px-4 py-2 bg-blue-600 text-white rounded hover:bg-blue-700"
                    >
                      Copiar
                    </button>
                  </div>
                </div>

                <button
                  phx-click="close_qrcode"
                  class="w-full mt-4 px-4 py-2 bg-gray-200 text-gray-800 rounded hover:bg-gray-300"
                >
                  Fechar
                </button>
              </div>
            </div>
          </div>
        <% end %>
      </div>
    </div>
    """
  end
end

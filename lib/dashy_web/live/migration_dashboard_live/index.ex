defmodule DashyWeb.MigrationDashboardLive.Index do
  use DashyWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    resp = fetch_data()

    {
      :ok,
      socket
      |> assign(:data, resp["data"])
      |> assign(:created_at, resp["createdAt"]),
      layout: false
    }
  end

  attr :label, :string, required: true
  slot :inner_block, required: true

  def card(assigns) do
    ~H"""
    <div>
      <div>
        <%= @label %>
      </div>
      <div>
        <%= render_slot(@inner_block) %>
      </div>
    </div>
    """
  end

  attr :label, :string, required: true
  attr :value, :string, required: true
  attr :max, :string, required: true

  def gauge(assigns) do
    ~H"""
    <.gauge_base label={@label} value={@value / @max}>
      <%= "#{@value} / #{@max}" %>
    </.gauge_base>
    """
  end

  attr :label, :string, required: true
  attr :value, :string, required: true
  slot :inner_block

  def gauge_base(assigns) do
    ~H"""
    <div class="flex py-3 px-4 flex-col justify-between rounded-lg bg-gray-100 min-w-[300px]">
      <div class="text-gray-500 text-base">
        <%= @label %>
      </div>
      <div class="relative rounded border-2 border-gray-400 flex my-2 overflow-hidden">
        <div
          class="absolute h-full"
          style={"background:#{color(@value)};width:#{floor(@value * 100)}%"}
        />
        <div class="relative px-2 py-1 text-gray-500 text-2xl"><%= fmt(@value) %></div>
      </div>

      <%= if @inner_block do %>
        <div class="text-gray-500 text-xs">
          <%= render_slot(@inner_block) %>
        </div>
      <% end %>
    </div>
    """
  end

  defp fmt(value) do
    "#{floor(value * 1000) / 10}%"
  end

  defp color(num) do
    buffer = 160
    "hsl(#{num * (120 + buffer) - buffer}deg 67% 58%)"
  end

  defp node_cov(data, key \\ "statements") do
    data
    |> Map.get("node_coverage")
    |> Enum.find(&(!&1["_isFooter"]))
    |> Map.get(key)
    |> then(&(&1 / 100))
  end

  defp fetch_data() do
    token = Application.get_env(:dashy, :build_token)

    {:ok, %Finch.Response{status: 200, body: body}} =
      Finch.build(
        :post,
        "https://team.kualibuild.com/app/api/v0/graphql",
        [
          {"content-type", "application/json"},
          {"authorization", "bearer #{token}"}
        ],
        Jason.encode!(%{
          "operationName" => "FetchMigrationData",
          "query" => """
          query FetchMigrationData($appId: ID!, $pageId: ID!) {
            app(id: $appId) {
              dataset(id: $pageId) {
                documentConnection(args: {limit: 100}) {
                  edges {
                    node {
                      createdAt
                      data
                    }
                  }
                }
              }
            }
          }
          """,
          "variables" => %{
            "appId" => "64342d0c34852b4431ba3585",
            "pageId" => "64342d0c34852b4431ba3585"
          }
        })
      )
      |> Finch.request(Dashy.Finch)

    body
    |> Jason.decode!()
    |> get_in(["data", "app", "dataset", "documentConnection", "edges"])
    |> Enum.map(& &1["node"])
    |> Enum.sort_by(&DateTime.from_iso8601(&1["createdAt"]))
    |> Enum.reverse()
    |> hd()
  end
end

defmodule Rockelivery.Orders.ReportRunner do
  use GenServer

  require Logger

  alias Rockelivery.Orders.Report

  # client

  def start_link(_initial_state) do
    GenServer.start_link(__MODULE__, %{})
  end

  # server

  @impl true
  def init(state) do
    Logger.info("ReportRunner started")
    schedule_report_generation()
    {:ok, state}
  end

  @impl true
  # accepts any message type (sync or async)
  def handle_info(:generate, state) do
    Logger.info("Generating report...")

    Report.create()
    schedule_report_generation()

    {:noreply, state}
  end

  def schedule_report_generation do
    # 1 minute
    Process.send_after(self(), :generate, 1000 * 10)
  end
end

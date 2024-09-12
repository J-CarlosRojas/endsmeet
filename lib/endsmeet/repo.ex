defmodule Endsmeet.Repo do
  use Ecto.Repo,
    otp_app: :endsmeet,
    adapter: Ecto.Adapters.Postgres
end

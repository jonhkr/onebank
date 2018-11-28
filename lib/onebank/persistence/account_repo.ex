defmodule OneBank.AccountRepo do
  import Ecto.Query, only: [from: 2]

  alias OneBank.{Repo, Aggregate.Account}

  defmodule EventSchema do
    use Ecto.Schema
    import Ecto.Changeset

    @primary_key false

    schema "event" do
      field :aggregate_id, Ecto.UUID
      field :aggregate_type
      field :version, :integer
      field :event_type
      field :event_data, :map

      timestamps(updated_at: false)
    end

    @required_fields [:aggregate_id, :aggregate_type, :version, :event_type]

    def changeset(params \\ :empty) do
      %__MODULE__{}
      |> cast(params, @required_fields ++ [:event_data])
      |> validate_required(@required_fields)
    end
  end

  def store(account) do
    account.uncommited_events
    |> Enum.map(fn (event) -> persist!(account, event) end)
  end

  def load(aggregate_type, aggregate_id) do
    type = to_string(aggregate_type)

    query = from e in EventSchema,
            where: e.aggregate_type == ^type and
                   e.aggregate_id == ^aggregate_id,
            order_by: e.version

    query
    |> Repo.all
    |> Enum.map(fn (e) -> reconstruct_event(e) end)
    |> Account.load
  end

  defp reconstruct_event(db_event) do
    db_event.event_data
    |> to_struct(String.to_atom(db_event.event_type))
  end

  defp to_struct(map, kind) do
    struct = struct(kind)
    Enum.reduce Map.to_list(struct), struct, fn({k, _}, acc) ->
      case Map.fetch(map, Atom.to_string(k)) do
        {:ok, v} -> %{acc | k => v}
        :error -> acc
      end
    end
  end

  defp persist!(aggregate, event) do
    EventSchema.changeset(%{
      aggregate_id: aggregate.id,
      aggregate_type: to_string(aggregate.__struct__),
      version: event.version,
      event_type: to_string(event.__struct__),
      event_data: Map.from_struct(event)
    })
    |> Repo.insert!
  end
end

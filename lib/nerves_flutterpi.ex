defmodule NervesFlutterpi do
  use Supervisor

  require WaitForIt

  @definition [
    name: [
      required: true,
      type: :atom
    ],
    flutter_app_dir: [
      required: true,
      type: :string
    ]
  ]
  @schema NimbleOptions.new!(@definition)

  def start_link(opts) do
    opts = NimbleOptions.validate!(opts, @schema)

    Supervisor.start_link(__MODULE__, opts, name: opts[:name])
  end

  @impl Supervisor
  def init(opts) do
    release = "--release"
    :os.cmd('udevd -d')
    :os.cmd('udevadm trigger --type=subsystems --action=add')
    :os.cmd('udevadm trigger --type=devices --action=add')
    :os.cmd('udevadm settle --timeout=30')
    children = [
      Supervisor.child_spec({MuonTrap.Daemon, ["flutter-pi", [release, opts[:flutter_app_dir]]]}, id: :flutterpi)
    ]
    Supervisor.init(children, strategy: :one_for_all)
  end
end

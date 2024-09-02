defmodule NervesFlutterpi do
  use Supervisor

  require Logger

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

    timeout = opts[:timeout] || 15000

    task = Task.async(fn -> wait_for_drm_device(timeout) end)
    :ok = Task.await(task, timeout)
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

  defp wait_for_drm_device(timeout) do
    NervesUEvent.subscribe(["devices", "platform", :_, :_, :_, "card1"])

    Logger.info("Waiting for DRM device to be ready...")
    receive do
      value ->
        Logger.info("DRM device is ready, launching infotainment application...")
        :ok
      ^timeout ->
        Logger.info("DRM device not detected, aborting...")
        :error
    end
  end
end
